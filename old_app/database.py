from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy.orm import declarative_base

engine=create_engine("postgresql://postgres:Messi100@localhost/clients_db",
    echo=True
)

Base=declarative_base()

SessionLocal=sessionmaker(bind=engine)
