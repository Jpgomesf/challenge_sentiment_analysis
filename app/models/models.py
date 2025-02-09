import datetime
from sqlalchemy import Column, String, Integer, Text, DateTime, ForeignKey, Boolean, JSON
from sqlalchemy.orm import relationship
from core.database import Base

class Motel(Base):
    __tablename__ = "motel"
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(Text, nullable=False)
    sessions = relationship("Session", back_populates="motel", cascade="all, delete-orphan")
    messages = relationship("Message", back_populates="motel", cascade="all, delete-orphan")

class Session(Base):
    __tablename__ = "session"
    id = Column(Integer, primary_key=True, autoincrement=True)
    motel_id = Column(Integer, ForeignKey("motel.id", ondelete="CASCADE"), nullable=False)
    created_at = Column(DateTime, nullable=False, default=datetime.datetime.utcnow)
    motel = relationship("Motel", back_populates="sessions")
    messages = relationship("Message", back_populates="session", cascade="all, delete-orphan")
    analyses = relationship("Analysis", back_populates="session", cascade="all, delete-orphan")

class Message(Base):
    __tablename__ = "message"
    id = Column(Integer, primary_key=True, autoincrement=True)
    motel_id = Column(Integer, ForeignKey("motel.id", ondelete="CASCADE"), nullable=False)
    session_id = Column(Integer, ForeignKey("session.id", ondelete="CASCADE"), nullable=False)
    content = Column(Text, nullable=False)
    remote = Column(Boolean, nullable=False)
    created_at = Column(DateTime, nullable=False, default=datetime.datetime.utcnow)
    motel = relationship("Motel", back_populates="messages")
    session = relationship("Session", back_populates="messages")

class Analysis(Base):
    __tablename__ = "analysis"
    id = Column(Integer, primary_key=True, autoincrement=True)
    session_id = Column(Integer, ForeignKey("session.id", ondelete="CASCADE"), nullable=False)
    satisfaction = Column(Integer, nullable=False)
    summary = Column(Text, nullable=False)
    improvement = Column(Text, nullable=False)
    created_at = Column(DateTime, nullable=False, default=datetime.datetime.utcnow)
    conversation_id = Column(String, index=True, nullable=True)
    status = Column(String, index=True, nullable=True)
    updated_at = Column(DateTime, default=datetime.datetime.utcnow, onupdate=datetime.datetime.utcnow)
    session = relationship("Session", back_populates="analyses")
    stages = relationship("Stage", back_populates="analysis", cascade="all, delete-orphan")

class Stage(Base):
    __tablename__ = "stages"
    id = Column(Integer, primary_key=True, autoincrement=True)
    analysis_id = Column(Integer, ForeignKey("analysis.id", ondelete="CASCADE"), nullable=False, index=True)
    stage_name = Column(String, nullable=True)
    status = Column(String, nullable=True)
    result = Column(JSON, nullable=True)
    error_details = Column(Text, nullable=True)
    started_at = Column(DateTime, default=datetime.datetime.utcnow)
    ended_at = Column(DateTime, nullable=True)
    analysis = relationship("Analysis", back_populates="stages")
