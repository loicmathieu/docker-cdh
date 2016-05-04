DROP TABLE cities;
CREATE EXTERNAL TABLE IF NOT EXISTS cities(
    name string,
    nameUpperCase string,
    postalCode string,
    id string,
    department string,
    latitude string,
    longitude string,
    elevation string
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\;'
STORED AS TEXTFILE
location '/cities';
