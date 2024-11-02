# Import libraries
import pandas as pd
from sqlalchemy import create_engine
from dotenv import load_dotenv
import os

# Load environment variables from the .env file
load_dotenv()

# Retrieve database credentials from environment variables
host = os.getenv("DB_HOST")
port = os.getenv("DB_PORT")
username = os.getenv("DB_USER")
password = os.getenv("DB_PASSWORD")
database = os.getenv("DB_NAME")
table_name = os.getenv("TABLE_NAME")
csv_file_path = os.getenv("FILE_PATH")

# Read the CSV file into a pandas DataFrame
df = pd.read_csv(csv_file_path)

# Create a SQLAlchemy engine to connect to the MySQL database
engine = create_engine(f'mysql+pymysql://{username}:{password}@{host}:{port}/{database}')

# Import the DataFrame to a new table in MySQL
df.to_sql(table_name, con=engine, if_exists='fail', index=False)

print("Data imported successfully.")
