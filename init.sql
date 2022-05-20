DROP TABLE StagingRawTable;
GO

CREATE TABLE StagingRawTable (
  staging_raw_id INT IDENTITY(1, 1) PRIMARY KEY,
  listing_id INT,
  location VARCHAR(621),
  region VARCHAR(50),
  district VARCHAR(50),
  street VARCHAR(100),
  price INT,
  views FLOAT,
  area FLOAT,
  room INT,
  floors INT NULL,
  bathrooms INT,
  building_type VARCHAR(50),
  ceiling_height FLOAT,
  condition VARCHAR(50),
  date_added DATETIME,
  date_edited DATETIME,
  date_scraped DATETIME, --dateScraped INT --date YYYYMMDD
  latitude DECIMAL(10,6),
  longitude DECIMAL(10,6),
  address VARCHAR(621),
  facilities VARCHAR(621),
  additional_info VARCHAR(621),
  url VARCHAR(255),
  on_request INT,
  price_sqm FLOAT,
  error INT,
  floor INT,
  storeys INT,
  listing_type VARCHAR(50),
  property_type VARCHAR(50),
  platform_name VARCHAR(50),
  air_conditioner INT,
  canalization INT,
  central_heating INT,
  electricity INT,
  gas INT,
  heating INT,
  hot_water INT,
  internet INT,
  irrigation INT,
  sewerage INT,
  water INT,
  water24_7 INT,
  attic INT,
  balcony INT,
  basement INT,
  bilateral INT,
  building_existence INT,
  close_to_the_bus_station INT,
  elevator INT,
  equipment INT,
  eurowindows INT,
  fence INT,
  fireplace INT,
  furniture INT,
  garage INT,
  gate INT,
  grating INT,
  gym INT,
  heated_floor INT,
  heater INT,
  high_first_floor INT,
  iron_door INT,
  laminate_flooring INT,
  loggia INT,
  open_balcony INT,
  park INT,
  parking INT,
  parquet INT,
  playground INT,
  roadside INT,
  sauna INT,
  security_system INT,
  storage_room INT,
  sunny INT,
  swimming_pool INT,
  tile INT,
  has_view INT
);

USE REAL_ESTATE_ANALYTICAL_DB;
GO
DROP TABLE IF EXISTS FactPricesViews;
GO
DROP TABLE IF EXISTS DimListing_SCD1;
GO
DROP TABLE IF EXISTS DimListingHistory_SCD2;
GO
DROP TABLE IF EXISTS DimBuildingType;
GO
DROP TABLE IF EXISTS DimLocation;
GO
DROP TABLE IF EXISTS DimCondition;
GO
DROP TABLE IF EXISTS DimPlatform;
GO
DROP TABLE IF EXISTS DimPropertyType;
GO
DROP TABLE IF EXISTS DimPriceType;
GO
DROP TABLE IF EXISTS DimListingType;
GO
DROP TABLE IF EXISTS DimLocation;
GO
DROP TABLE IF EXISTS DimDate;
GO

CREATE TABLE DimPlatform (
	platform_id_sk INT IDENTITY(1, 1) PRIMARY KEY,
	platform_name VARCHAR (255) NOT NULL
);
CREATE TABLE DimCondition (
    condition_id_sk INT IDENTITY(1, 1) PRIMARY KEY,
    condition_name VARCHAR(50),
    platform_id_sk_fk INT,
    FOREIGN KEY (platform_id_sk_fk) REFERENCES DimPlatform (platform_id_sk)
    );
CREATE TABLE DimBuildingType (
  building_type_id_sk INT IDENTITY(1, 1) PRIMARY KEY,
  building_type VARCHAR(50),
  platform_id_sk_fk INT,
  FOREIGN KEY (platform_id_sk_fk) REFERENCES DimPlatform (platform_id_sk)
);
CREATE TABLE DimPropertyType (
  property_type_id_sk INT IDENTITY(1, 1) PRIMARY KEY,
  property_type VARCHAR(50)
);
CREATE TABLE DimPriceType (
  price_type_id_sk INT IDENTITY(1, 1) PRIMARY KEY,
  on_request INT --on request vs money
);
CREATE TABLE DimListingType (
  listing_type_id_sk INT IDENTITY(1, 1) PRIMARY KEY,
  listing_type VARCHAR(50)
);

CREATE TABLE DimLocation (
  location_id_sk INT IDENTITY(1, 1) PRIMARY KEY,
  street VARCHAR(255),
  district VARCHAR(50),
  region VARCHAR(50)
);

CREATE TABLE DimListing_SCD1 (
 
  --Identification columns
  listing_id_sk INT IDENTITY(1, 1) PRIMARY KEY,
  listing_id_nk INT,
  --dim columns
  platform_id_sk_fk INT,
  property_type_id_sk_fk INT,
  building_type_id_sk_fk INT,
  condition_id_sk_fk INT,
  location_id_sk_fk INT,
  price_type_id_sk_fk INT, 
  listing_type_id_sk_fk INT, 
  --info columns
  area FLOAT,
  room INT,
  floor INT,
  storeys INT,
  floors INT,
  bathrooms INT,
  ceiling_height FLOAT,
  url VARCHAR(255),
  latitude FLOAT,
  longitude FLOAT,
  --date columns
  date_added date, --date YYYYMMDD
  date_scraped date, -- date YYYYMMDD
  valid_from DATE,
  FOREIGN KEY (platform_id_sk_fk) REFERENCES DimPlatform (platform_id_sk),
  FOREIGN KEY (listing_type_id_sk_fk) REFERENCES DimListingType (listing_type_id_sk),
  FOREIGN KEY (price_type_id_sk_fk) REFERENCES DimPriceType (price_type_id_sk),
  FOREIGN KEY (property_type_id_sk_fk) REFERENCES DimPropertyType (property_type_id_sk),
  FOREIGN KEY (building_type_id_sk_fk) REFERENCES DimBuildingType (building_type_id_sk),
  FOREIGN KEY (condition_id_sk_fk) REFERENCES DimCondition (condition_id_sk),
  FOREIGN KEY (location_id_sk_fk) REFERENCES DimLocation (location_id_sk));
​
CREATE TABLE DimListingHistory_SCD2 (
  --identification columns
  listing_history_id_sk INT IDENTITY(1, 1) PRIMARY KEY,
  listing_id_nk INT,
  --dim columns
  platform_id_sk_fk INT,
  property_type_id_sk_fk INT,
  building_type_id_sk_fk INT,
  condition_id_sk_fk INT,
  price_type_id_sk_fk INT, 
  location_id_sk_fk INT,
  listing_type_id_sk_fk INT,
  --info columns
  area FLOAT,
  room INT,
  floor INT,
  storeys INT,
  floors INT,
  bathrooms INT,
  ceiling_height FLOAT,
  url VARCHAR(255),
  latitude FLOAT,
  longitude FLOAT,
  --date columns
  date_added DATE,
  date_scraped INT, --date YYYYMMDD
  valid_from DATE,
  valid_to DATE,
  
  FOREIGN KEY (platform_id_sk_fk) REFERENCES DimPlatform (platform_id_sk),
  FOREIGN KEY (property_type_id_sk_fk) REFERENCES DimPropertyType (property_type_id_sk),
  FOREIGN KEY (building_type_id_sk_fk) REFERENCES DimBuildingType (building_type_id_sk),
  FOREIGN KEY (condition_id_sk_fk) REFERENCES DimCondition (condition_id_sk),
  FOREIGN KEY (location_id_sk_fk) REFERENCES DimLocation (location_id_sk),
  FOREIGN KEY (listing_type_id_sk_fk) REFERENCES DimListingType (listing_type_id_sk)
  );


  CREATE TABLE DimDate (
	[DateKey] INT PRIMARY KEY
	,[Date] DATETIME
	,[FullDateUK] CHAR(10)
	,-- Date in dd-MM-yyyy format
	[FullDateUSA] CHAR(10)
	,-- Date in MM-dd-yyyy format
	[DayOfMonth] VARCHAR(2)
	,-- Field will hold day number of Month
	[DaySuffix] VARCHAR(4)
	,-- Apply suffix as 1st, 2nd ,3rd etc
	[DayName] VARCHAR(9)
	,-- Contains name of the day, Sunday, Monday 
	[DayOfWeekUSA] CHAR(1)
	,-- First Day Sunday=1 and Saturday=7
	[DayOfWeekUK] CHAR(1)
	,-- First Day Monday=1 and Sunday=7
	[DayOfWeekInMonth] VARCHAR(2)
	,--1st Monday or 2nd Monday in Month
	[DayOfWeekInYear] VARCHAR(2)
	,[DayOfWeekInQuarter] VARCHAR(3)
	,[DayOfYear] VARCHAR(3)
	,[WeekOfMonth] VARCHAR(1)
	,-- Week Number of Month 
	[WeekOfQuarter] VARCHAR(2)
	,--Week Number of the Quarter
	[WeekOfYear] VARCHAR(2)
	,--Week Number of the Year
	[Month] VARCHAR(2)
	,--Number of the Month 1 to 12
	[MonthName] VARCHAR(9)
	,--January, February etc
	[MonthOfQuarter] VARCHAR(2)
	,-- Month Number belongs to Quarter
	[Quarter] CHAR(1)
	,[QuarterName] VARCHAR(9)
	,--First,Second..
	[Year] CHAR(4)
	,-- Year value of Date stored in Row
	[YearName] CHAR(7)
	,--CY 2012,CY 2013
	[MonthYear] CHAR(10)
	,--Jan-2013,Feb-2013
	[MMYYYY] CHAR(6)
	,[FirstDayOfMonth] DATE
	,[LastDayOfMonth] DATE
	,[FirstDayOfQuarter] DATE
	,[LastDayOfQuarter] DATE
	,[FirstDayOfYear] DATE
	,[LastDayOfYear] DATE
	,[IsWeekday] BIT -- 0=Week End ,1=Week Day
	);
GO

CREATE TABLE FactPricesViews (
  --identification columns
  row_id INT IDENTITY(1, 1) PRIMARY KEY,
  listing_id_sk_fk INT,
  listing_history_id_sk_fk INT,
  listing_id_nk INT,
  staging_raw_id_fk INT,
  price_type_id_sk_fk INT,
  platform_id_sk_fk INT,
  --measure columns
  price INT,
  views INT,
  on_request INT,
  error INT,
  air_conditioner INT,
  canalization INT,
  central_heating INT,
  electricity INT,
  gas INT,
  heating INT,
  hot_water INT,
  internet INT,
  irrigation INT,
  sewerage INT,
  water INT,
  water24_7 INT,
  attic INT,
  balcony INT,
  basement INT,
  bilateral INT,
  building_existence INT,
  close_to_the_bus_station INT,
  elevator INT,
  equipment INT,
  eurowindows INT,
  fence INT,
  fireplace INT,
  furniture INT,
  garage INT,
  gate INT,
  grating INT,
  gym INT,
  heated_floor INT,
  heater INT,
  high_first_floor INT,
  iron_door INT,
  laminate_flooring INT,
  loggia INT,
  open_balcony INT,
  park INT,
  parking INT,
  parquet INT,
  playground INT,
  roadside INT,
  sauna INT,
  security_system INT,
  storage_room INT,
  sunny INT,
  swimming_pool INT,
  tile INT,
  has_view INT,
  --date columns
  date_edited DATE,
  date_scraped_key INT, 
  date_scraped DATE

  FOREIGN KEY (date_scraped_key) REFERENCES DimDate(DateKey),
  FOREIGN KEY (listing_id_sk_fk) REFERENCES DimListing_SCD1(listing_id_sk),
  FOREIGN KEY (listing_history_id_sk_fk) REFERENCES DimListingHistory_SCD2(listing_history_id_sk),
  FOREIGN KEY (price_type_id_sk_fk) REFERENCES DimPriceType(price_type_id_sk),
  FOREIGN KEY (platform_id_sk_fk) REFERENCES DimPlatform(platform_id_sk)
);

