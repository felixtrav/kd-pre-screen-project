from sqlalchemy.orm import declarative_base
from sqlalchemy import Column, Integer, Float
from sqlalchemy.dialects.postgresql import INET as IPAddress

Base = declarative_base()

class Row(Base):
    __tablename__ = 'project_table'

    id = Column(Integer, primary_key=True, autoincrement=True)
    value = Column(Float, nullable=False)
    ip_address = Column(IPAddress, nullable=False)
