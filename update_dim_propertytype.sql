MERGE DimPropertyType AS DST -- destination
USING (
    SELECT DISTINCT st.property_type
    FROM StagingRawTable st
	WHERE date_scraped >= ?
    ) AS SRC -- source
ON ( SRC.property_type = DST.property_type )
WHEN NOT MATCHED THEN -- there are IDs in the source table that are not in the destination table
  INSERT (property_type)
  VALUES (SRC.property_type);