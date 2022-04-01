import os
from dotenv import load_dotenv
import sqlalchemy as _sql
import sqlalchemy.ext.declarative as _declarative
import sqlalchemy.orm as _orm

load_dotenv(dotenv_path=".env")


POSTGRES_USER: str = os.getenv("POSTGRES_USER")
POSTGRES_PASSWORD: str = os.getenv("POSTGRES_PASSWORD")
POSTGRES_SERVER: str = os.getenv("POSTGRES_SERVER", "localhost")
POSTGRES_PORT: str = os.getenv("POSTGRES_PORT", 5432)
POSTGRES_DB: str = os.getenv("POSTGRES_DB", "fastapi_database")
DATABASE_URL = f"postgresql://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{POSTGRES_SERVER}:{POSTGRES_PORT}/{POSTGRES_DB}"

#DATABASE_URL = "postgresql://myuser:password@localhost/fastapi_database"


engine = _sql.create_engine(DATABASE_URL)

SessionLocal = _orm.sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = _declarative.declarative_base()