MERGE DimCondition AS DST -- destination
USING (
    SELECT DISTINCT st.condition, dp.platform_id_sk
    FROM StagingRawTable st
    LEFT JOIN DimPlatform dp
    ON st.platform_name = dp.platform_name
    WHERE st.date_scraped >= ?
    ) AS SRC -- source
ON ( SRC.condition = DST.condition_name AND SRC.platform_id_sk = DST.platform_id_sk_fk)
WHEN NOT MATCHED THEN -- there are IDs in the source table that are not in the destination table
  INSERT (condition_name,
          platform_id_sk_fk
          )
  VALUES (SRC.condition,
          SRC.platform_id_sk
          );