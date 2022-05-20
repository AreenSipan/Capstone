MERGE DimListingType AS DST -- destination
USING (
    SELECT DISTINCT st.listing_type
    FROM StagingRawTable st
	WHERE date_scraped >= ?
    ) AS SRC -- source
ON ( SRC.listing_type = DST.listing_type)
WHEN NOT MATCHED THEN -- there are IDs in the source table that are not in the destination table
  INSERT (listing_type)
  VALUES (SRC.listing_type);