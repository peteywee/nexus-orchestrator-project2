# gpt-nexus/app/models.py
from sqlalchemy import Column, Integer, String, Boolean, DateTime, BigInteger, ForeignKey, func
from sqlalchemy.orm import declarative_base, relationship
from sqlalchemy.dialects.postgresql import JSONB
from datetime import datetime

# Base for declarative models
Base = declarative_base()

class User(Base):
    """SQLAlchemy model for the 'users' table."""
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String(50), unique=True, nullable=False, index=True)
    hashed_password = Column(String(255), nullable=False)
    email = Column(String(100), unique=True, nullable=True)
    is_active = Column(Boolean, default=True)
    is_admin = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), default=func.now())
    updated_at = Column(DateTime(timezone=True), default=func.now(), onupdate=func.now())

    # Define a relationship to the File model
    files = relationship("File", back_populates="owner", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<User(id={self.id}, username='{self.username}', is_active={self.is_active})>"

class File(Base):
    """SQLAlchemy model for the 'files' table."""
    __tablename__ = "files"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False) # Foreign key to users.id
    file_name = Column(String(255), nullable=False)
    file_path = Column(String(512), unique=True, nullable=False, index=True) # Assuming unique storage path
    file_size_bytes = Column(BigInteger, nullable=False)
    file_type = Column(String(100), nullable=True) # e.g., 'application/pdf', 'text/plain'
    upload_timestamp = Column(DateTime(timezone=True), default=func.now())
    processing_status = Column(String(50), default="uploaded", nullable=False) # e.g., 'uploaded', 'processing', 'completed', 'failed', 'deleted'
    last_processed_at = Column(DateTime(timezone=True), nullable=True) # Timestamp of last processing attempt
    metadata_json = Column(JSONB, nullable=True) # For additional, flexible metadata
    created_at = Column(DateTime(timezone=True), default=func.now())
    updated_at = Column(DateTime(timezone=True), default=func.now(), onupdate=func.now())

    # Define a relationship back to the User model
    owner = relationship("User", back_populates="files")

    def __repr__(self):
        return f"<File(id={self.id}, name='{self.file_name}', user_id={self.user_id}, status='{self.processing_status}')>"
