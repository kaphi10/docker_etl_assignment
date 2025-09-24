import pandas as pd
import os
import sys
from dotenv import load_dotenv
from sqlalchemy import create_engine

sys.path.append('/app/database')
from  conn_setting import get_db_connection_string
load_dotenv()
DB_TABLE=os.getenv("DB_TABLE")
# def get_db_connection_string():
#     user=os.getenv("DB_USER")
#     password=os.getenv("DB_PASSWORD")
#     host=os.getenv("DB_HOST")
#     port=os.getenv("DB_PORT")
#     db_name=os.getenv("DB_NAME")
#     return f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{db_name}"


# load_dotenv()
# DB_TABLE=os.getenv("DB_TABLE")

def get_data(file_path):
    """Extract data from a CSV file."""
    df= pd.read_csv(file_path)
    return df
def transform_data(df):
    """Transform the data by converting all categorical values to lowercase."""
    for col in df.select_dtypes(include=['object']).columns:
        df[col] = df[col].str.lower()
    return df
def load_data(df, db_connection_string, table_name):
    """Load the data into a PostgreSQL database."""
    engine = create_engine(db_connection_string)
    with engine.connect() as connection:
        df.to_sql(table_name, con=connection, if_exists='append', index=False)
        print(f"Data loaded into table {table_name} successfully.")
        
def run_etl():
    """Run the ETL process."""
    file_path = "app/Popular_Baby_Names.csv"
    db_connection_string = get_db_connection_string()
    
    # ETL Process
    data = get_data(file_path)
    transformed_data = transform_data(data)
    load_data(transformed_data, db_connection_string, DB_TABLE)
    
        
if __name__ == "__main__":
    run_etl()