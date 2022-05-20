MERGE DimBuildingType AS DST -- destination
USING (
    SELECT DISTINCT st.building_type, dp.platform_id_sk
    FROM StagingRawTable st
    LEFT JOIN DimPlatform dp
    ON st.platform_name = dp.platform_name
    WHERE st.date_scraped >= ?
    ) AS SRC -- source
ON ( SRC.building_type = DST.building_type AND SRC.platform_id_sk = DST.platform_id_sk_fk)
WHEN NOT MATCHED THEN -- there are IDs in the source table that are not in the destination table
  INSERT (building_type,
          platform_id_sk_fk
          )
  VALUES (SRC.building_type,
          SRC.platform_id_sk
          );