import datetime
from pydantic import BaseModel
from typing import List, Literal

class Message(BaseModel):
    author: Literal["cliente", "atendente"]
    message: str
    timestamp: datetime.datetime

class AnalysisRequest(BaseModel):
    session_id: int
    conversation_id: str
    prompt: str
    messages: List[Message]

class AnalysisResponse(BaseModel):
    analysis_id: int
