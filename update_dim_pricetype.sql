MERGE DimPriceType AS DST -- destination
USING (
    SELECT DISTINCT st.on_request
    FROM StagingRawTable st
	WHERE date_scraped >= ?
    ) AS SRC -- source
ON ( SRC.on_request = DST.on_request)
WHEN NOT MATCHED THEN -- there are IDs in the source table that are not in the destination table
  INSERT (on_request)
  VALUES (SRC.on_request);