DELETE FROM FactPricesViews WHERE date_scraped = ? and
platform_id_sk_fk IN
(SELECT platform_id_sk from DimPlatform
WHERE platform_name = ?
);