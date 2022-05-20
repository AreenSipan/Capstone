DECLARE  @Listing_SCD4 TABLE
( listing_id_nk INT NULL,
  platform_id_sk_fk INT NULL,
  property_type_id_sk_fk INT NULL,
  building_type_id_sk_fk INT NULL,
  condition_id_sk_fk INT NULL,
  location_id_sk_fk INT NULL,
  price_type_id_sk_fk INT NULL,
  listing_type_id_sk_fk INT NULL,
  --info columns
  area FLOAT NULL,
  room INT NULL,
  floor INT NULL,
  storeys INT NULL,
  floors INT NULL,
  bathrooms INT NULL,
  ceiling_height FLOAT NULL,
  url VARCHAR(255) NULL,
  latitude FLOAT NULL,
  longitude FLOAT NULL,
  --date columns
  date_added INT NULL, --date YYYYMMDD
  date_scraped INT NULL, -- date YYYYMMDD
  valid_from DATE NULL,
  MergeAction VARCHAR(10) NULL
)
MERGE DimListing_SCD1 AS DST
USING (
	SELECT DISTINCT st.listing_id, st.area, st.room, st.floor, st.storeys, st.floors, st.bathrooms,
	st.ceiling_height, st.url, st.latitude,st.longitude, dp.platform_id_sk, dpt.property_type_id_sk, db.building_type_id_sk,
	dc.condition_id_sk, dl.location_id_sk, st.date_scraped, dlt.listing_type_id_sk,dpr.price_type_id_sk
	FROM StagingRawTable st
    LEFT JOIN DimPlatform dp
    ON st.platform_name = dp.platform_name
	LEFT JOIN DimListingType dlt
	ON st.listing_type = dlt.listing_type
    LEFT JOIN DimPropertyType dpt
    ON st.property_type = dpt.property_type
    LEFT JOIN DimBuildingType db
    ON st.building_type = db.building_type and db.platform_id_sk_fk = dp.platform_id_sk
    LEFT JOIN DimCondition dc
    ON st.condition = dc.condition_name and dc.platform_id_sk_fk = dp.platform_id_sk
    LEFT JOIN DimLocation dl
    ON st.region = dl.region AND st.district = dl.district AND st.street = dl.street
    LEFT JOIN DimPriceType dpr
    ON st.on_request = dpr.on_request
    WHERE st.date_scraped >= ?
    ) AS SRC -- source
ON SRC.listing_id = DST.listing_id_nk
WHEN NOT MATCHED THEN
INSERT (listing_id_nk,
        platform_id_sk_fk,
        property_type_id_sk_fk,
        building_type_id_sk_fk,
        condition_id_sk_fk,
        location_id_sk_fk,
        price_type_id_sk_fk,
        listing_type_id_sk_fk,
        area,
        room,
        floor,
        storeys,
        floors,
        bathrooms,
        ceiling_height,
        url,
        latitude,
        longitude,
        valid_from)
		VALUES
		(SRC.listing_id,
        SRC.platform_id_sk,
        SRC.property_type_id_sk,
        SRC.building_type_id_sk,
        SRC.condition_id_sk,
        SRC.location_id_sk,
        SRC.price_type_id_sk,
        SRC.listing_type_id_sk,
        SRC.area,
        SRC.room,
        SRC.floor,
        SRC.storeys,
        SRC.floors,
        SRC.bathrooms,
        SRC.ceiling_height,
        SRC.url,
        SRC.latitude,
        SRC.longitude,
        SRC.date_scraped)
WHEN MATCHED
AND
	 ISNULL(DST.platform_id_sk_fk,'') <> ISNULL(SRC.platform_id_sk,'')
	 OR ISNULL(DST.property_type_id_sk_fk,'') <> ISNULL(SRC.property_type_id_sk,'')
	 OR ISNULL(DST.building_type_id_sk_fk,'') <> ISNULL(SRC.building_type_id_sk,'')
	 OR ISNULL(DST.condition_id_sk_fk,'') <> ISNULL(SRC.condition_id_sk,'')
	 OR ISNULL(DST.location_id_sk_fk,'') <> ISNULL(SRC.location_id_sk,'')
	 OR ISNULL(DST.listing_type_id_sk_fk,'') <> ISNULL(SRC.listing_type_id_sk,'')
	 OR ISNULL(DST.price_type_id_sk_fk,'') <> ISNULL(SRC.price_type_id_sk,'')
     OR ISNULL(DST.area,'') <> ISNULL(SRC.area,'')
     OR ISNULL(DST.room,'') <> ISNULL(SRC.room,'')
     OR ISNULL(DST.floor,'') <> ISNULL(SRC.floor,'')
     OR ISNULL(DST.storeys,'') <> ISNULL(SRC.storeys,'')
     OR ISNULL(DST.floors,'') <> ISNULL(SRC.floors,'')
     OR ISNULL(DST.bathrooms,'') <> ISNULL(SRC.bathrooms,'')
     OR ISNULL(DST.ceiling_height,'') <> ISNULL(SRC.ceiling_height,'')
     OR ISNULL(DST.url,'') <> ISNULL(SRC.url,'')
     OR ISNULL(DST.latitude,'') <> ISNULL(SRC.latitude,'')
     OR ISNULL(DST.longitude,'') <> ISNULL(SRC.longitude,'')
THEN UPDATE
SET
      DST.platform_id_sk_fk = SRC.platform_id_sk
	  ,DST.property_type_id_sk_fk = SRC.property_type_id_sk
	 ,DST.building_type_id_sk_fk = SRC.building_type_id_sk
	 ,DST.condition_id_sk_fk = SRC.condition_id_sk
	 ,DST.location_id_sk_fk = SRC.location_id_sk
	 ,DST.price_type_id_sk_fk = SRC.price_type_id_sk
     ,DST.listing_type_id_sk_fk = SRC.listing_type_id_sk
     ,DST.area = SRC.area
     ,DST.room = SRC.room
     ,DST.floor = SRC.floor
     ,DST.storeys = SRC.storeys
     ,DST.floors = SRC.floors
     ,DST.bathrooms = SRC.bathrooms
     ,DST.ceiling_height = SRC.ceiling_height
     ,DST.url = SRC.url
     ,DST.latitude = SRC.latitude
     ,DST.longitude = SRC.longitude
	 ,DST.valid_from = SRC.date_scraped
OUTPUT DELETED.listing_id_nk, DELETED.platform_id_sk_fk, DELETED.property_type_id_sk_fk, DELETED.building_type_id_sk_fk,
        DELETED.condition_id_sk_fk, DELETED.location_id_sk_fk, DELETED.price_type_id_sk_fk, DELETED.listing_type_id_sk_fk,
        DELETED.area, DELETED.room, DELETED.floor, DELETED.storeys, DELETED.floors,
        DELETED.bathrooms, DELETED.ceiling_height, DELETED.url, DELETED.latitude, DELETED.longitude,
        DELETED.valid_from, $Action AS MergeAction
INTO	@Listing_SCD4 (listing_id_nk, platform_id_sk_fk, property_type_id_sk_fk, building_type_id_sk_fk, condition_id_sk_fk,
        location_id_sk_fk, price_type_id_sk_fk, listing_type_id_sk_fk, area, room, floor, storeys, floors, bathrooms,
        ceiling_height, url, latitude, longitude, valid_from, MergeAction);
-- Update history table to set final date and current flag
UPDATE		TP4
SET			TP4.valid_to = CONVERT (DATE, GETDATE())
FROM		DimListingHistory_SCD2 TP4
			INNER JOIN @Listing_SCD4 TMP
			ON TP4.listing_id_nk = TMP.listing_id_nk
WHERE		TP4.valid_to IS NULL

-- Add latest history records to history table
INSERT INTO DimListingHistory_SCD2 (
        listing_id_nk,
        platform_id_sk_fk,
        property_type_id_sk_fk,
        building_type_id_sk_fk,
        condition_id_sk_fk,
        location_id_sk_fk,
        price_type_id_sk_fk,
        listing_type_id_sk_fk,
        area,
        room,
        floor,
        storeys,
        floors,
        bathrooms,
        ceiling_height,
        url,
        latitude,
        longitude,
        valid_from,
        valid_to)
SELECT listing_id_nk, platform_id_sk_fk, property_type_id_sk_fk, building_type_id_sk_fk, condition_id_sk_fk, location_id_sk_fk,
        price_type_id_sk_fk, listing_type_id_sk_fk, area, room, floor, storeys, floors, bathrooms, ceiling_height, url, latitude,
        longitude, valid_from, GETDATE()
FROM @Listing_SCD4
WHERE listing_id_nk IS NOT NULL