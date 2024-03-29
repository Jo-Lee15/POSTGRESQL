-- Chapter 11 Code Examples
-----------------------------------------------------------------

-- Listing 11-1: Extracting components of a timestamp value using date_part()

SELECT
    date_part('year', '2019-12-01 18:37:12 EST'::timestamptz) AS "year",
    date_part('month', '2019-12-01 18:37:12 EST'::timestamptz) AS "month",
    date_part('day', '2019-12-01 18:37:12 EST'::timestamptz) AS "day",
    date_part('hour', '2019-12-01 18:37:12 EST'::timestamptz) AS "hour",
    date_part('minute', '2019-12-01 18:37:12 EST'::timestamptz) AS "minute",
    date_part('seconds', '2019-12-01 18:37:12 EST'::timestamptz) AS "seconds",
    date_part('timezone_hour', '2019-12-01 18:37:12 EST'::timestamptz) AS "tz",
    date_part('week', '2019-12-01 18:37:12 EST'::timestamptz) AS "week",
    date_part('quarter', '2019-12-01 18:37:12 EST'::timestamptz) AS "quarter",
    date_part('epoch', '2019-12-01 18:37:12 EST'::timestamptz) AS "epoch";

-- Bonus: Using the SQL-standard extract() for similar datetime parsing:

SELECT extract('year' from '2019-12-01 18:37:12 EST'::timestamptz) AS "year";

-- Listing 11-2: Three functions for making datetimes from components

-- make a date
SELECT make_date(2018, 2, 22);
-- make a time
SELECT make_time(18, 4, 30.3);
-- make a timestamp with time zone
SELECT make_timestamptz(2018, 2, 22, 18, 4, 30.3, 'Europe/Lisbon');

-- Bonus: Retrieving the current date and time

SELECT
    current_date,
    current_time,
    current_timestamp,
    localtime,
    localtimestamp,
    now();

-- Listing 11-3: Comparing current_timestamp and clock_timestamp() during row insert

CREATE TABLE current_time_example (
    time_id bigserial,
    current_timestamp_col timestamp with time zone,
    clock_timestamp_col timestamp with time zone
);

INSERT INTO current_time_example (current_timestamp_col, clock_timestamp_col)
    (SELECT current_timestamp,
            clock_timestamp()
     FROM generate_series(1,1000));

SELECT * FROM current_time_example;

-- Time Zones

-- Listing 11-4: Showing your PostgreSQL server's default time zone

SHOW timezone; -- Note: You can see all run-time defaults with SHOW ALL;
SHOW ALL;
-- Listing 11-5: Showing time zone abbreviations and names

SELECT * FROM pg_timezone_abbrevs;
SELECT * FROM pg_timezone_names;

-- Filter to find one
SELECT * FROM pg_timezone_names
WHERE name LIKE 'Europe%';

-- Listing 11-6: Setting the time zone for a client session

SET timezone TO 'US/Pacific';

CREATE TABLE time_zone_test (
    test_date timestamp with time zone
);
INSERT INTO time_zone_test VALUES ('2020-01-01 4:00');

SELECT test_date
FROM time_zone_test;

SET timezone TO 'US/Eastern';

SELECT test_date
FROM time_zone_test;

SELECT test_date AT TIME ZONE 'Asia/Seoul'
FROM time_zone_test;


-- Math with dates!

SELECT '1929-9-30'::date - '1929-9-27'::date;
SELECT '1929-9-30'::date + '5 years'::interval;


-- Taxi Rides

-- Listing 11-7: Creating a table and importing NYC yellow taxi data

CREATE TABLE nyc_yellow_taxi_trips_2016_06_01 (
    trip_id bigserial PRIMARY KEY,
    vendor_id varchar(1) NOT NULL,
    tpep_pickup_datetime timestamp with time zone NOT NULL,
    tpep_dropoff_datetime timestamp with time zone NOT NULL,
    passenger_count integer NOT NULL,
    trip_distance numeric(8,2) NOT NULL,
    pickup_longitude numeric(18,15) NOT NULL,
    pickup_latitude numeric(18,15) NOT NULL,
    rate_code_id varchar(2) NOT NULL,
    store_and_fwd_flag varchar(1) NOT NULL,
    dropoff_longitude numeric(18,15) NOT NULL,
    dropoff_latitude numeric(18,15) NOT NULL,
    payment_type varchar(1) NOT NULL,
    fare_amount numeric(9,2) NOT NULL,
    extra numeric(9,2) NOT NULL,
    mta_tax numeric(5,2) NOT NULL,
    tip_amount numeric(9,2) NOT NULL,
    tolls_amount numeric(9,2) NOT NULL,
    improvement_surcharge numeric(9,2) NOT NULL,
    total_amount numeric(9,2) NOT NULL
);

COPY nyc_yellow_taxi_trips_2016_06_01 (
    vendor_id,
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    passenger_count,
    trip_distance,
    pickup_longitude,
    pickup_latitude,
    rate_code_id,
    store_and_fwd_flag,
    dropoff_longitude,
    dropoff_latitude,
    payment_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount
   )
FROM 'C:\Users\Jo\practical-sql-main\practical-sql-main\Chapter_11\yellow_tripdata_2016_06_01.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

CREATE INDEX tpep_pickup_idx
ON nyc_yellow_taxi_trips_2016_06_01 (tpep_pickup_datetime);

SELECT count(*) FROM nyc_yellow_taxi_trips_2016_06_01;
SELECT * FROM nyc_yellow_taxi_trips_2016_06_01;

-- Listing 11-8: Counting taxi trips by hour

SELECT
    date_part('hour', tpep_pickup_datetime) AS trip_hour,
    count(*)
FROM nyc_yellow_taxi_trips_2016_06_01
GROUP BY trip_hour
ORDER BY trip_hour;

-- Listing 11-9: Exporting taxi pickups per hour to a CSV file

COPY
    (SELECT
        date_part('hour', tpep_pickup_datetime) AS trip_hour,
        count(*)
    FROM nyc_yellow_taxi_trips_2016_06_01
    GROUP BY trip_hour
    ORDER BY trip_hour
    )
TO 'C:\Users\Jo\hourly_pickups_2016_06_01.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

-- Listing 11-10: Calculating median trip time by hour

SELECT
    date_part('hour', tpep_pickup_datetime) AS trip_hour,
    percentile_cont(.5)
        WITHIN GROUP (ORDER BY
            tpep_dropoff_datetime - tpep_pickup_datetime) AS median_trip
FROM nyc_yellow_taxi_trips_2016_06_01
GROUP BY trip_hour
ORDER BY trip_hour;

-- Listing 11-11: Creating a table to hold train trip data

SET timezone TO 'US/Central';

CREATE TABLE train_rides (
    trip_id bigserial PRIMARY KEY,
    segment varchar(50) NOT NULL,
    departure timestamp with time zone NOT NULL,
    arrival timestamp with time zone NOT NULL
);

INSERT INTO train_rides (segment, departure, arrival)
VALUES
    ('Chicago to New York', '2017-11-13 21:30 CST', '2017-11-14 18:23 EST'),
    ('New York to New Orleans', '2017-11-15 14:15 EST', '2017-11-16 19:32 CST'),
    ('New Orleans to Los Angeles', '2017-11-17 13:45 CST', '2017-11-18 9:00 PST'),
    ('Los Angeles to San Francisco', '2017-11-19 10:10 PST', '2017-11-19 21:24 PST'),
    ('San Francisco to Denver', '2017-11-20 9:10 PST', '2017-11-21 18:38 MST'),
    ('Denver to Chicago', '2017-11-22 19:10 MST', '2017-11-23 14:50 CST');

SELECT * FROM train_rides;

-- Listing 11-12: Calculating the length of each trip segment

SELECT segment,
       to_char(departure, 'YYYY-MM-DD HH12:MI a.m. TZ') AS departure,
       arrival - departure AS segment_time
FROM train_rides;

-- Listing 11-13: Calculating cumulative intervals using OVER

SELECT segment,
       arrival - departure AS segment_time,
       sum(arrival - departure) OVER (ORDER BY trip_id) AS cume_time
FROM train_rides;

-- Listing 11-14: Better formatting for cumulative trip time

SELECT segment,
       arrival - departure AS segment_time,
       sum(date_part('epoch', (arrival - departure)))
           OVER (ORDER BY trip_id) * interval '1 second' AS cume_time
FROM train_rides;

--Try it yourself questions and answers

--------------------------------------------------------------
-- Chapter 11: Working with Dates and Times
--------------------------------------------------------------

-- 1. Using the New York City taxi data, calculate the length of each ride using
-- the pickup and drop-off timestamps. Sort the query results from the longest
-- ride to the shortest. Do you notice anything about the longest or shortest
-- trips that you might want to ask city officials about?

-- Answer: More than 480 of the trips last more than 10 hours, which seems
-- excessive. Moreover, two records have drop-off times before the pickup time,
-- and several have pickup and drop-off times that are the same. It's worth
-- asking whether these records have timestamp errors.

SELECT
    trip_id,
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    tpep_dropoff_datetime - tpep_pickup_datetime AS length_of_ride
FROM nyc_yellow_taxi_trips_2016_06_01
ORDER BY length_of_ride DESC;

-- 2. Using the AT TIME ZONE keywords, write a query that displays the date and
-- time for London, Johannesburg, Moscow, and Melbourne the moment January 1,
-- 2100, arrives in New York City.

-- Answer:

SELECT '2100-01-01 00:00:00-05' AT TIME ZONE 'US/Eastern' AS new_york,
       '2100-01-01 00:00:00-05' AT TIME ZONE 'Europe/London' AS london,
       '2100-01-01 00:00:00-05' AT TIME ZONE 'Africa/Johannesburg' AS johannesburg,
       '2100-01-01 00:00:00-05' AT TIME ZONE 'Europe/Moscow' AS moscow,
       '2100-01-01 00:00:00-05' AT TIME ZONE 'Australia/Melbourne' AS melbourne;

-- 3. As a bonus challenge, use the statistics functions in Chapter 10 to
-- calculate the correlation coefficient and r-squared values using trip time
-- and the total_amount column in the New York City taxi data, which represents
-- total amount charged to passengers. Do the same with trip_distance and
-- total_amount. Limit the query to rides that last three hours or less.

-- Answer:

SELECT
    round(
          corr(total_amount, (
              date_part('epoch', tpep_dropoff_datetime) -
              date_part('epoch', tpep_pickup_datetime)
                ))::numeric, 2
          ) AS amount_time_corr,
    round(
        regr_r2(total_amount, (
              date_part('epoch', tpep_dropoff_datetime) -
              date_part('epoch', tpep_pickup_datetime)
        ))::numeric, 2
    ) AS amount_time_r2,
    round(
          corr(total_amount, trip_distance)::numeric, 2
          ) AS amount_distance_corr,
    round(
        regr_r2(total_amount, trip_distance)::numeric, 2
    ) AS amount_distance_r2
FROM nyc_yellow_taxi_trips_2016_06_01
WHERE tpep_dropoff_datetime - tpep_pickup_datetime <= '3 hours'::interval;

-- Note: Both correlations are strong, with r values of 0.80 or higher. We'd
-- expect this given that cost of a taxi ride is based on both time and distance.
