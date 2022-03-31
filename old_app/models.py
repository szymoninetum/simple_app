from sqlalchemy import Boolean, Column, Integer, String, Numeric
from sqlalchemy.orm import relationship

from database import Base


class Clients(Base):
    __tablename__ = "clients"

    id = Column(Integer, primary_key=True, index=True)
    data = Column(String)
    #symbol = Column(String, unique=True, index=True)
    #price = Column(Numeric(10, 2))
    #average = Column(Numeric(10, 2))
    #email = Column(String, unique=True, index=True)
    #hashed_password = Column(String)
    #is_active = Column(Boolean, default=True)

  