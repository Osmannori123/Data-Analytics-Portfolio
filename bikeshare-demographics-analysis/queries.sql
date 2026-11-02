/*
Data Management Fundamentals - Carnegie Mellon University
BikeShare & Pennsylvania Demographics Analysis

This file contains the SQL queries used for the two analyses
presented in this project.
*/

-- Analysis 1: pennsylvania population change by county density

WITH county_agg AS (
    SELECT
        location.county AS county,
        SUM(acs_estimates.pop2011) AS pop2011,
        SUM(acs_estimates.pop2021) AS pop2021,
        SUM(location.area_land_sq_miles) AS land_sq_miles
    FROM location
    JOIN acs_estimates
        ON acs_estimates.zip = location.zip
    WHERE state = 'PA'
        AND location.county IS NOT NULL
        AND location.area_land_sq_miles IS NOT NULL
        AND location.area_land_sq_miles > 0
    GROUP BY location.county
),

county_classified AS (
    SELECT
        county,
        (pop2021 * 1.0 / land_sq_miles) AS density_2021,

        CASE
            WHEN (pop2021 * 1.0 / land_sq_miles) >= 300
                THEN 'Dense'
            WHEN (pop2021 * 1.0 / land_sq_miles) >= 100
                THEN 'Moderate'
            ELSE 'Sparse'
        END AS density_category,

        (pop2021 - pop2011) * 1.0 / pop2011 AS percent_change
    FROM county_agg
)

SELECT
    density_category,
    COUNT(*) AS county_count,
    ROUND(AVG(percent_change), 4) AS avg_percent_change,
    ROUND(MIN(percent_change), 4) AS min_percent_change,
    ROUND(MAX(percent_change), 4) AS max_percent_change
FROM county_classified
GROUP BY density_category
ORDER BY
    CASE density_category
        WHEN 'Dense' THEN 1
        WHEN 'Moderate' THEN 2
        ELSE 3
    END;



-- Analysis 2: bikeshare commute vs leisure trips
-- Classifies trips using day of week, start time, duration, station information, and one way trip status.

SELECT
    CASE
        WHEN DaysOfTheWeek.DayID IN (1, 2, 3, 4, 5)
            AND (
                HOUR(Rentals.StartTime) BETWEEN 6 AND 9
                OR HOUR(Rentals.StartTime) BETWEEN 16 AND 18
            )
            AND Rentals.TripDuration_Minutes BETWEEN 3 AND 30
            AND Rentals.FromStationID <> Rentals.ToStationID
            AND Rentals.FromStationID <> -5000
            AND Rentals.ToStationID <> -5000
        THEN 'Commutes'
        ELSE 'Leisure'
    END AS TypeOfTrip,

    MetroArea.CoreCity AS MetroArea,
    HOUR(Rentals.StartTime) AS StartHour,
    COUNT(*) AS TripCount

FROM Rentals
JOIN DaysOfTheWeek
    ON Rentals.StartDayOfWeek = DaysOfTheWeek.DayID
JOIN MetroArea
    ON Rentals.MetroID = MetroArea.MetroID

GROUP BY TypeOfTrip, MetroArea, StartHour
ORDER BY MetroArea, StartHour, TypeOfTrip;


-- summary counts by metro area and trip classification

SELECT
    MetroArea.CoreCity AS MetroArea,

    CASE
        WHEN DaysOfTheWeek.DayID IN (1, 2, 3, 4, 5)
            AND (
                HOUR(Rentals.StartTime) BETWEEN 6 AND 9
                OR HOUR(Rentals.StartTime) BETWEEN 16 AND 18
            )
            AND Rentals.TripDuration_Minutes BETWEEN 3 AND 30
            AND Rentals.FromStationID <> Rentals.ToStationID
            AND Rentals.FromStationID <> -5000
            AND Rentals.ToStationID <> -5000
        THEN 'Commutes'
        ELSE 'Leisure'
    END AS TypeOfTrip,

    COUNT(*) AS TripCount

FROM Rentals
JOIN DaysOfTheWeek
    ON Rentals.StartDayOfWeek = DaysOfTheWeek.DayID
JOIN MetroArea
    ON Rentals.MetroID = MetroArea.MetroID

GROUP BY MetroArea, TypeOfTrip
ORDER BY MetroArea, TypeOfTrip;
