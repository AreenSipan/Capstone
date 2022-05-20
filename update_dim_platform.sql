MERGE DimPlatform AS DST -- destination
USING (
    SELECT DISTINCT st.platform_name
    FROM StagingRawTable st
    WHERE st.date_scraped >= ?
    ) AS SRC -- source
ON ( SRC.platform_name = DST.platform_name )
WHEN NOT MATCHED THEN -- there are IDs in the source table that are not in the destination table
  INSERT (platform_name)
  VALUES (SRC.platform_name);