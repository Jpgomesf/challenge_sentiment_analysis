import asyncio
import datetime
import logging
from typing import Any, Optional, List

from sqlalchemy.orm import Session

from core.database import SessionLocal
from models.models import Analysis, Stage
from services.llm_agents_service import (
    coordinator_agent,
    analyst_agent,
    reporter_agent,
    finalizer_agent,
)
from schemas.schemas import Message
from typing import cast

async def execute_agent(
    db: Session,
    analysis_id: int,
    stage_name: str,
    agent_fn,
    *args,
    max_retries: int = 3,
) -> Any:
    attempt = 0
    stage = create_or_update_stage(db, analysis_id, stage_name, status="executing")
    stage_id = cast(int, stage.id) if stage.id is not None else None

    while attempt < max_retries:
        try:
            result = await agent_fn(*args)
            create_or_update_stage(
                db, analysis_id, stage_name, status="completed", result=result, stage_id=stage_id
            )
            return result
        except Exception as e:
            attempt += 1
            logging.error(f"Error in agent {stage_name}, attempt {attempt}: {e}")
            if attempt >= max_retries:
                create_or_update_stage(
                    db,
                    analysis_id,
                    stage_name,
                    status="error",
                    error_details=str(e),
                    stage_id=stage_id,
                )
                raise Exception(f"Fatal error in agent {stage_name}: {e}")
            await asyncio.sleep(1)

def create_or_update_stage(
    db: Session,
    analysis_id: int,
    stage_name: str,
    status: str,
    result: Optional[Any] = None,
    error_details: Optional[str] = None,
    stage_id: Optional[int] = None,
) -> Stage:
    """
    Creates or updates a Stage record in the database.
    """
    if stage_id:
        stage = db.query(Stage).filter(Stage.id == stage_id).first()
        if stage:
            stage.status = status  # type: ignore
            stage.result = result  # type: ignore
            stage.error_details = error_details  # type: ignore
            stage.ended_at = datetime.datetime.now(datetime.timezone.utc)  # type: ignore
            db.commit()
            return stage

    stage = Stage(
        analysis_id=analysis_id,
        stage_name=stage_name,
        status=status,  # type: ignore
        result=result,  # type: ignore
        error_details=error_details,  # type: ignore
        started_at=datetime.datetime.now(datetime.timezone.utc),
        ended_at=datetime.datetime.now(datetime.timezone.utc)
        if status != "executing"
        else None,  # type: ignore
    )
    db.add(stage)
    db.commit()
    db.refresh(stage)
    return stage

async def process_conversation(
    analysis_id: int, conversation_id: str, prompt: str, messages: List[Message]
):
    """
    Processes a conversation by splitting it into blocks (if needed), then executing:
      1. The Coordinator Agent (in parallel) to segment the conversation,
      2. The Analyst Agent (sequentially) to analyze each block and accumulate a history,
      3. The Reporter Agent to generate a final report,
      4. The Finalizer Agent to produce the final answer based on the report and original prompt.
    Finally, it updates the Analysis record with the agent's output.
    """
    db = SessionLocal()
    try:
        logging.info(f"Starting analysis {analysis_id}")

        # Split conversation into blocks based on a simple token (word) count
        tokens = sum(len(msg.message.split()) for msg in messages)
        max_tokens = 128000
        blocks = []
        if tokens > max_tokens:
            chunk = []
            current_tokens = 0
            for msg in messages:
                msg_tokens = len(msg.message.split())
                if current_tokens + msg_tokens > max_tokens:
                    blocks.append(chunk)
                    chunk = [msg]
                    current_tokens = msg_tokens
                else:
                    chunk.append(msg)
                    current_tokens += msg_tokens
            if chunk:
                blocks.append(chunk)
        else:
            blocks.append(messages)

        logging.info(f"Split into {len(blocks)} block(s) for analysis")

        # Step 1: Coordinator Agent for each block (parallel execution)
        tasks = [
            execute_agent(db, analysis_id, f"Coordinator_block_{i+1}", coordinator_agent, block)
            for i, block in enumerate(blocks)
        ]
        coordinator_results = await asyncio.gather(*tasks)

        # Step 2: Analyst Agent (sequential execution, accumulating history)
        analyst_results = []
        history = []
        for i, coordinator_result in enumerate(coordinator_results):
            analyst_result = await execute_agent(
                db, analysis_id, f"Analyst_block_{i+1}", analyst_agent, coordinator_result, history
            )
            analyst_results.append(analyst_result)
            history.append(analyst_result)

        # Step 3: Reporter Agent to generate the final report
        report = await execute_agent(db, analysis_id, "Reporter", reporter_agent, analyst_results)

        # Step 4: Finalizer Agent to craft the final answer
        final_response = await execute_agent(db, analysis_id, "Finalizer", finalizer_agent, report, prompt)

        satisfaction = final_response.get("satisfaction")
        summary = final_response.get("summary")
        improvement = final_response.get("improvements")

        # Update the Analysis record
        analysis_record = db.query(Analysis).filter(Analysis.id == analysis_id).first()
        if analysis_record:
            analysis_record.satisfaction = satisfaction  # type: ignore
            analysis_record.summary = summary  # type: ignore
            analysis_record.improvement = improvement  # type: ignore
            analysis_record.status = "completed"  # type: ignore
            analysis_record.updated_at = datetime.datetime.now(datetime.timezone.utc)  # type: ignore
            db.commit()
            logging.info(f"Analysis {analysis_id} completed successfully")
    except Exception as e:
        analysis_record = db.query(Analysis).filter(Analysis.id == analysis_id).first()
        if analysis_record:
            analysis_record.status = "error"  # type: ignore
            analysis_record.updated_at = datetime.datetime.now(datetime.timezone.utc)  # type: ignore
            db.commit()
        logging.error(f"Analysis {analysis_id} failed: {e}")
    finally:
        db.close()
