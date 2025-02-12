import os
import psycopg2  # This shows as not imported but is required when using SQLAlchemy with PostgreSQL
from db import Row
from sqlalchemy import create_engine, Engine, func
from sqlalchemy.orm import sessionmaker, Session

DATABASE_USER: str = os.environ['DATABASE_USER']
DATABASE_HOST: str = os.environ['DATABASE_HOST']
DATABASE_PORT: str = os.environ['DATABASE_PORT']
DATABASE_NAME: str = os.environ['DATABASE_NAME']
DATABASE_PASS: str = os.environ['DATABASE_PASS']
CONNECTION_STRING: str = f"postgresql+psycopg2://{DATABASE_USER}:{DATABASE_PASS}@{DATABASE_HOST}:{DATABASE_PORT}/{DATABASE_NAME}"


ENGINE: Engine = create_engine(CONNECTION_STRING)
SESSION_MAKER: sessionmaker = sessionmaker(bind=ENGINE)

Row.metadata.create_all(ENGINE)

def add_value_entry(value: float, ip_address: str) -> None:
    session: Session = SESSION_MAKER()
    session.add(Row(
        value=value,
        ip_address=ip_address
    ))
    session.commit()
    session.close()

def get_sum_of_all_values() -> float:
    session: Session = SESSION_MAKER()
    
    # Get the sum of all values for every row in the project_table, return 0 if there are no rows
    sum_of_all_values: float = session.query(func.sum(Row.value)).scalar()
    if sum_of_all_values is None:
        sum_of_all_values = 0
    else:
        # Round to the nearest 2 decimal places
        sum_of_all_values = round(sum_of_all_values, 2)

    session.close()
    return sum_of_all_values

def get_all_rows() -> list[Row]:
    session: Session = SESSION_MAKER()
    rows: list[Row] = session.query(Row).all()
    session.close()
    return rows

def reset_table() -> None:
    session: Session = SESSION_MAKER()
    # Delete all rows in the project_table
    session.query(Row).delete()
    session.commit()
    session.close()