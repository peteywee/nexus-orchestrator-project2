# gpt-nexus/app/database.py
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker
import os

# Import the Base from models.py
from .models import Base

# Retrieve database URL from environment variables
DATABASE_URL = os.getenv("DATABASE_URL")

# Create the asynchronous SQLAlchemy engine
# echo=True will log all SQL statements to stdout (useful for debugging)
engine = create_async_engine(DATABASE_URL, echo=True)

# Create a sessionmaker for asynchronous sessions
# autocommit=False ensures transactions are explicitly committed
# autoflush=False means objects aren't flushed to DB until commit or explicit flush
# expire_on_commit=False prevents objects from expiring after commit, useful for async
AsyncSessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine,
    class_=AsyncSession,
    expire_on_commit=False
)

# Dependency for FastAPI to get an asynchronous database session
async def get_db():
    """
    Provides an asynchronous database session to FastAPI routes.
    The session is automatically closed after the request is processed.
    """
    async with AsyncSessionLocal() as session:
        try:
            yield session
            await session.commit() # Ensure commit after successful operations
        except:
            await session.rollback() # Rollback on errors
            raise
        finally:
            await session.close()

# Function to create all tables defined in Base.metadata
async def create_db_and_tables():
    """
    Asynchronously creates all database tables defined by SQLAlchemy models.
    This is typically run once during application startup or migration.
    """
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
