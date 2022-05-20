# Import the necessary modules
import sys

# Set up logging
import logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s', datefmt='%d-%b-%y %H:%M:%S')

# Import the custom modules
import config
import tasks


def main():

	# Extract the system arguments
	platform = sys.argv[1]
	date = sys.argv[2]
	run_scraper = sys.argv[3] if len(sys.argv) > 3 else None

	# Initiate the logger
	logging.info("Initiating the flow for the platform {} on {}".format(platform, date))

	# Check whether scraping needs to be done
	if run_scraper:
		logging.info("Initiating the scraping of the platform {} on {}".format(platform, date))
		pass
	else:
		logging.info("Skipping the scraping of platform {} for {}".format(platform, date))

	# Establishing connection with the database
	logging.info("Establishing connection with the database {}".format(config.DIMENSIONAL_DB_NAME))
	cursor = tasks.connect_to_db(config.DIMENSIONAL_DB_CONFIG_FILE, config.DIMENSIONAL_DB_NAME,
		config.DB_CONNECTION_STRING_TEMPLATE)
	logging.info("Connection with the database {} successfully established!".format(config.DIMENSIONAL_DB_NAME))

	# Deleting data from staging raw table to avoid duplication
	logging.info("Deleting data from the staging raw table for platform {} on {}".format(platform, date))
	tasks.delete_from_staging_raw(cursor, config.SQL_QUERY_LOCATION_DIR,
								  platform=platform,
								  date=date)
	logging.info("FINISHED deleting data from the staging raw table for platform {} on {}".format(platform, date))

	# Ingesting data into the staging raw table
	logging.info("Beginning to load data from files into the staging raw table")
	filenames = [config.SCRAPED_FILENAME_TEMPLATE.format(category=i, date=date.replace("-",""))
				 for i in config.SCRAPED_DATA_CATEGORIES]
	for file in filenames:
		tasks.populate_staging_raw(cursor, config.SQL_QUERY_LOCATION_DIR, file, config.RAW_FILE_LOCATION_DIR, logging)
	logging.info("FINISHED ingesting data from files into the staging raw table")

	# Updating dim tables
	logging.info("Beginning the update of dimension tables")
	for table_name in config.DIM_TABLES:
		query_name = config.DIM_TABLE_UPDATE_QUERY_TEMPLATE.format(table_name=table_name)
		tasks.update_dim_table(cursor, config.SQL_QUERY_LOCATION_DIR, query_name, table_name, date, logging)
	logging.info("FINISHED the update of dimension tables")

	# Deleting data from the fact chart to avoid duplication
	logging.info("Deleting data from the fact chart for platform {} on {}".format(platform, date))
	tasks.delete_from_fact_chart(cursor, config.SQL_QUERY_LOCATION_DIR, date, platform)
	logging.info("FINISHED deleting data from the fact chart for platform {} on {}".format(platform, date))

	# Deleting data from the fact chart to avoid duplication
	logging.info("Beginning the ingestion into the fact chart for platform {} on {}".format(platform, date))
	tasks.load_fact_chart(cursor, config.SQL_QUERY_LOCATION_DIR, date, platform)
	logging.info("FINISHED ingesting data into the fact chart for platform {} on {}".format(platform, date))





if __name__ == "__main__":
    main()



