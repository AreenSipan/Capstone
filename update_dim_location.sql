MERGE DimLocation AS DST -- destination
USING (
    SELECT DISTINCT st.region, st.district, st.street
    FROM StagingRawTable st
	WHERE date_scraped >= ?
    ) AS SRC -- source
ON ( SRC.region = DST.region and SRC.district = DST.district and SRC.street = DST.street)
WHEN NOT MATCHED THEN -- there are IDs in the source table that are not in the destination table
  INSERT (region, district, street)
  VALUES (SRC.region, SRC.district, SRC.street);