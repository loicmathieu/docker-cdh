--load the cities CSV file in Pig
raw = load '/cities/cities.csv' using PigStorage(';') AS (
    name:chararray,
    nameUpperCase:chararray,
    postalCode:chararray,
    id:chararray,
    department:chararray,
    latitude:chararray,
    longitude:chararray,
    elevation:chararray
);

--compute number of cities by departement
data_by_department = group raw by department;
data_by_department = foreach data_by_department generate
    group as department,
    COUNT(raw) as nb;
data_by_department = ORDER data_by_department BY nb DESC;

--store the result in HDFS
store data_by_department into '/data_by_department' using PigStorage(',');
