INSERT INTO FactPricesViews (
  listing_id_sk_fk,
  listing_history_id_sk_fk,
  listing_id_nk,
  staging_raw_id_fk,
  price_type_id_sk_fk,
  platform_id_sk_fk,
  price,
  views,
  on_request,
  error,
  air_conditioner,
  canalization,
  central_heating,
  electricity,
  gas,
  heating,
  hot_water,
  internet,
  irrigation,
  sewerage,
  water,
  water24_7,
  attic,
  balcony,
  basement,
  bilateral,
  building_existence,
  close_to_the_bus_station,
  elevator,
  equipment,
  eurowindows,
  fence,
  fireplace,
  furniture,
  garage,
  gate,
  grating,
  gym,
  heated_floor,
  heater,
  high_first_floor,
  iron_door,
  laminate_flooring,
  loggia,
  open_balcony,
  park,
  parking,
  parquet,
  playground,
  roadside,
  sauna,
  security_system,
  storage_room,
  sunny,
  swimming_pool,
  tile,
  has_view,
  date_edited,
  date_scraped_key,
  date_scraped
)
SELECT dl1.listing_id_sk, dl2.listing_history_id_sk, st.listing_id, st.staging_raw_id, dpt.price_type_id_sk, dp.platform_id_sk, st.price, st.views,
    st.on_request, st.error, st.air_conditioner, st.canalization, st.central_heating, st.electricity, st.gas, st.heating, st.hot_water,
    st.internet, st.irrigation, st.sewerage, st.water, st.water24_7, st.attic, st.balcony, st.basement, st.bilateral, st.building_existence,
    st.close_to_the_bus_station, st.elevator,st.equipment, st.eurowindows, st.fence, st.fireplace, st.furniture, st.garage, st.gate, st.grating,
    st.gym, st.heated_floor, st.heater, st.high_first_floor, st.iron_door, st.laminate_flooring, st.loggia, st.open_balcony, st.park, st.parking,
    st.parquet, st.playground, st.roadside, st.sauna, st.security_system, st.storage_room, st.sunny, st.swimming_pool, st.tile, st.has_view,
    st.date_edited, dd.DateKey, st.date_scraped
    FROM StagingRawTable st
    LEFT JOIN DimPlatform dp
    ON st.platform_name = dp.platform_name
    LEFT JOIN DimDate dd
    ON CONVERT(varchar, st.Date_scraped, 23) = dd.FullDateUK
    LEFT JOIN DimListing_SCD1 dl1
    ON st.listing_id = dl1.listing_id_nk
    LEFT JOIN DimListingHistory_SCD2 dl2
    ON st.listing_id = dl2.listing_id_nk
    LEFT JOIN DimPriceType dpt
    ON st.on_request = dpt.on_request
    WHERE st.date_scraped >= ? AND st.platform_name = ?;