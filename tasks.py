import pyodbc
import pandas as pd
import numpy as np
import datetime
import utils

# Set up logging
import logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s', datefmt='%d-%b-%y %H:%M:%S')

def connect_to_db(config_file, db_name, connection_string_template):

     # Retrieve the connection parameters for the dimensional database
     db_connect_params = utils.get_sql_config(config_file, db_name)

     # Create a connection string for SQL Server
     conn_str = connection_string_template.format(*db_connect_params)

     # Connect to the database
     conn = pyodbc.connect(conn_str)

     # Create a Cursor class instance for executing T-SQL statements
     cursor = conn.cursor()

     return cursor


def delete_from_staging_raw(cursor, script_dir, **kwargs):

     script_file = script_dir + 'delete_from_staging_raw.sql'

     with open(script_file, 'r') as script:
          sqlScript = script.readlines()[0]

     cursor.execute(sqlScript, (kwargs['platform'], kwargs['date']))
     cursor.commit()


def populate_staging_raw(cursor, script_dir, filename, file_dir, logging):

     logging.info("Loading data from {} into the staging raw table".format(filename))

     # Read the csv file into a pandas dataframe
     df = pd.read_csv(file_dir + filename)
     df['date_added'] = df['date_added'].apply(lambda x: datetime.datetime.strptime(x, "%d.%m.%Y").date())
     df['date_edited'] = df['date_edited'].apply(lambda x: datetime.datetime.strptime(x, "%d.%m.%Y").date())
     df['date_scraped'] = df['date_scraped'].apply(lambda x: datetime.datetime.strptime(x, "%d.%m.%Y").date())
     df = df.fillna(np.nan).replace([np.nan], [None])

     script_file = script_dir + 'insert_into_staging_raw.sql'
     with open(script_file, 'r') as script:
          sqlScript = script.readlines()[0]

     cursor.fast_executemany = True
     cursor.executemany(sqlScript, df.values.tolist())
     cursor.commit()

     logging.info(f'{len(df)} rows inserted to the staging raw table')
     logging.info("FINISHED loading data from {} into the staging raw table".format(filename))


def update_dim_table(cursor, script_dir, script_name, table_name, date, logging):

     logging.info("Beginning the update of table {}".format(table_name))

     script_file = script_dir + script_name
     with open(script_file, 'r') as script:
          sqlScript = script.read()
     cursor.execute(sqlScript, date)
     cursor.commit()

     logging.info("FINISHED updating the table {}".format(table_name))

def delete_from_fact_chart(cursor, script_dir, date, platform):

     script_file = script_dir + 'delete_from_fact_chart.sql'

     with open(script_file, 'r') as script:
          sqlScript = script.read()

     cursor.execute(sqlScript, date, platform)
     cursor.commit()

def load_fact_chart(cursor, script_dir, date, platform):

     script_file = script_dir + 'insert_into_fact_chart.sql'

     with open(script_file, 'r') as script:
          sqlScript = script.read()

     cursor.execute(sqlScript, date, platform)
     cursor.commit()






