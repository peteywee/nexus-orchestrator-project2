"""
PLACEHOLDER FILE: websocket_messages.py

This file is a placeholder for Pydantic schemas defining the structure of
messages exchanged over WebSockets between the frontend and the backend.

It should contain schemas for:
- Incoming user messages (e.g., QueryRequestWS, CommandMessageWS)
- Outgoing backend messages (e.g., TaskUpdateWS, AgentResponseWS, NotificationWS)

Purpose: To ensure strict validation and clear documentation of WebSocket
communication payloads.

For future reference: This file was generated as a placeholder on 2025-06-19.
"""
from pydantic import BaseModel
from typing import Optional, Any
from datetime import datetime

class WebSocketMessageBase(BaseModel):
    """Base schema for all WebSocket messages."""
    message_type: str # e.g., "query_request", "task_update", "agent_response"
    timestamp: datetime = datetime.now()
    payload: Any # Actual data, structure depends on message_type

class QueryRequestWS(WebSocketMessageBase):
    """Schema for a user's query request sent via WebSocket."""
    message_type: str = "query_request"
    query: str
    session_id: str

class TaskUpdateWS(WebSocketMessageBase):
    """Schema for a task progress update sent from backend to frontend via WebSocket."""
    message_type: str = "task_update"
    task_id: str
    status: str # e.g., "RECEIVED", "DISPATCHED", "COMPLETED", "FAILED"
    progress: Optional[float] = None # 0.0 to 1.0
    message: Optional[str] = None
    agent_status: Optional[str] = None # Which agent is currently active

class AgentResponseWS(WebSocketMessageBase):
    """Schema for a final agent response or intermediate result via WebSocket."""
    message_type: str = "agent_response"
    task_id: str
    sub_task_id: Optional[str] = None
    agent_id: str
    response_content: Any # Actual data from the agent
    is_final: bool = False # True if this is the final answer to the user query

# Example of an outgoing notification
class NotificationWS(WebSocketMessageBase):
    """Schema for a general notification message via WebSocket."""
    message_type: str = "notification"
    severity: str # e.g., "info", "warning", "error"
    content: str
