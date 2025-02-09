import os
import json
import logging
from typing import List, Dict

from pydantic import SecretStr

# Schema
from schemas.schemas import Message

# LangChain imports
from langchain_openai import ChatOpenAI
from langchain_core.runnables import RunnablePassthrough
from langchain.prompts import ChatPromptTemplate

# Agents configuration
config_agents = {
    "openai": {"api_key": os.getenv("OPENAI_API_KEY", "")}
}
OPENAI_API_KEY: SecretStr = SecretStr(config_agents["openai"]["api_key"])
MODEL_NAME = "gpt-4o-mini"

# Global ChatOpenAI instance
chat_llm = ChatOpenAI(model=MODEL_NAME, temperature=0.7, api_key=OPENAI_API_KEY)


# Helpers

def process_response_content(response, default_key: str) -> Dict:
    result_text = response.content
    if isinstance(result_text, str):
        try:
            return json.loads(result_text)
        except Exception:
            return {default_key: result_text}
    else:
        return result_text if isinstance(result_text, dict) else {default_key: str(result_text)}

def create_chain(template: str, input_keys: List[str]):
    assignments = {key: (lambda x, key=key: x[key]) for key in input_keys}
    prompt_template = ChatPromptTemplate.from_template(template)
    json_llm_instance = chat_llm.bind(response_format={"type": "json_object"})
    return RunnablePassthrough.assign(**assignments) | prompt_template | json_llm_instance

async def execute_chain(chain, chain_input: Dict, default_key: str) -> Dict:
    response = await chain.ainvoke(chain_input)
    return process_response_content(response, default_key)

# Agents

async def coordinator_agent(messages: List[Message]) -> Dict:
    logging.info("Executing Coordinator Agent via LangChain")
    conversation_text = "\n".join([f"{msg.author}: {msg.message}" for msg in messages])

    template = (
        "You are a conversation coordinator. Your task is to identify boundaries between messages "
        "and group them by context for further analysis.\n"
        "The conversation history is:\n{conversation_text}\n"
        "Provide the resulting segments in JSON format with the key 'segments'."
    )

    chain = create_chain(template, ["conversation_text"])
    return await execute_chain(chain, {"conversation_text": conversation_text}, default_key="segments")

async def analyst_agent(block: Dict, history: List[Dict]) -> Dict:
    logging.info("Executing Analyst Agent via LangChain")
    block_json = json.dumps(block, ensure_ascii=False)
    history_json = json.dumps(history, ensure_ascii=False)

    template = (
        "You are a conversation analyst. Analyze the following block of messages: {block}\n"
        "and consider the accumulated history: {history}.\n"
        "For each of the following aspects, if applicable, provide an object with the fields 'text' and 'confidence' (a float between 0 and 1):\n"
        " - sentiment\n"
        " - behavior\n"
        " - red_flags\n"
        " - compliments\n"
        " - positive_points\n"
        " - language_consistency\n"
        "Indicate if the attendant switched languages inappropriately (or failed to follow a client language change).\n"
        "Optionally, include an array 'evaluation_history' with previous evaluations.\n"
        "Provide your response in JSON format."
    )

    chain = create_chain(template, ["block", "history"])
    return await execute_chain(chain, {"block": block_json, "history": history_json}, default_key="analysis")

async def reporter_agent(analyses: List[Dict]) -> Dict:
    logging.info("Executing Reporter Agent via LangChain")
    analyses_json = json.dumps(analyses, ensure_ascii=False)

    template = (
        "You are a reporter. Combine the following analyses and generate a final report that includes:\n"
        " - 'combined_result': a summary of all analyses,\n"
        " - 'pros_summary': a summary of the pros,\n"
        " - 'cons_summary': a summary of the cons,\n"
        " - 'improvements_summary' (optional): actionable suggestions for improving the conversation process,\n"
        " - 'risk_points' (optional): a list of risk factors for the company or client,\n"
        " - 'confidence': an object indicating the confidence level of the assertions.\n"
        "The analyses are: {analyses}\n"
        "Provide your response in JSON format."
    )

    chain = create_chain(template, ["analyses"])
    return await execute_chain(chain, {"analyses": analyses_json}, default_key="report")

async def finalizer_agent(report: Dict, prompt: str) -> Dict:
    logging.info("Executing Finalizer Agent via LangChain")
    report_json = json.dumps(report, ensure_ascii=False)

    template = (
        "You are a finalizer. Based on the provided report and the original question, craft a concise final answer.\n"
        "A good conversation is one in which the assistant responds adequately to the user's questions and finalizes the reservation.\n"
        "Question: {prompt}\n"
        "Report: {report}\n"
        "Answer clearly and directly in JSON format with the keys 'satisfaction', 'summary', and 'improvements'."
    )

    chain = create_chain(template, ["prompt", "report"])
    return await execute_chain(chain, {"prompt": prompt, "report": report_json}, default_key="final_answer")
