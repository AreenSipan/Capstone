DIMENSIONAL_DB_NAME = 'REAL_ESTATE_ANALYTICAL_DB'

DIMENSIONAL_DB_CONFIG_FILE = 'dimensional_db_config.cfg'

DB_CONNECTION_STRING_TEMPLATE = 'Driver={};Server={};Database={};Trusted_Connection={};'

SQL_QUERY_LOCATION_DIR = 'C:/Users/aasryan/Desktop/capstone/submission/queries/'

RAW_FILE_LOCATION_DIR = 'C:/Users/aasryan/Desktop/capstone/submission/drop/'

STAGING_RAW_TABLE_NAME = 'StagingRawTable'

SCRAPED_DATA_CATEGORIES = ['apt_sale', 'apt_rent', 'house_sale', 'house_rent']

SCRAPED_FILENAME_TEMPLATE = '{category}_{date}.csv'

DIM_TABLES = ['dim_platform','dim_condition','dim_buildingtype','dim_propertytype','dim_pricetype','dim_listingtype',
              'dim_location', 'dim_listing', 'dim_date']

DIM_TABLE_UPDATE_QUERY_TEMPLATE = 'update_{table_name}.sql'