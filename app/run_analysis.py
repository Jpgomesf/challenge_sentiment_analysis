import asyncio
import datetime
import logging
from typing import List, cast

from core.database import SessionLocal
from models.models import Analysis, Session as DBSession, Message as DBMessage
from services.process_service import process_conversation
from schemas.schemas import Message

logging.basicConfig(level=logging.INFO)

def query_session(db) -> DBSession:
    session_instance = db.query(DBSession).order_by(DBSession.id.asc()).first()
    return session_instance

def query_session_messages(db, session_id: int) -> List[Message]:
    db_messages = (
        db.query(DBMessage)
        .filter(DBMessage.session_id == session_id)
        .order_by(DBMessage.created_at.asc())
        .all()
    )
    messages: List[Message] = []
    for m in db_messages:
        author = "cliente" if m.remote else "atendente"
        messages.append(
            Message(
                author=author,
                message=m.content,
                timestamp=m.created_at
            )
        )
    return messages

async def main():
    db = SessionLocal()
    try:
        session_instance = query_session(db)
        if not session_instance:
            logging.error("Nenhuma sessão encontrada no banco de dados.")
            return

        conversation_id = "7"
        prompt = "Give me the Satisfaction a number between 0 and 10 (0 = very unsatisfactory, 10 = excellent)"

        new_analysis = Analysis(
            session_id=session_instance.id,
            conversation_id=conversation_id,
            status="started",
            satisfaction=0,
            summary="",
            improvement="",
            created_at=datetime.datetime.now(datetime.timezone.utc),
            updated_at=datetime.datetime.now(datetime.timezone.utc)
        )
        db.add(new_analysis)
        db.commit()
        db.refresh(new_analysis)
        analysis_id: int = cast(int, new_analysis.id)
        logging.info(f"Analysis {analysis_id} criado para a sessão {session_instance.id}.")

        messages = query_session_messages(db, cast(int, session_instance.id))
        logging.info(f"Foram encontradas {len(messages)} mensagem(ns) para a sessão {session_instance.id}.")

        await process_conversation(analysis_id, conversation_id, prompt, messages)
        logging.info("Processamento da conversa concluído.")
    except Exception as e:
        logging.error(f"Erro ao processar a conversa: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    asyncio.run(main())
