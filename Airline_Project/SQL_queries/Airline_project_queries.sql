-- using database
USE Airline_analysis;

-- retriving the entire table
SELECT * FROM Airline;

--calculating KPI's

--1. Finding total number of passengers
SELECT COUNT(Passenger_Id) as Total_no_of_passengers 
FROM Airline;

--2. Finding total number of flights on time
SELECT COUNT(DISTINCT CONCAT(Departure_Date, '-', Arrival_Airport)) AS OnTimeFlights
FROM Airline
WHERE Flight_Status = 'On Time';


--3. Finding total number of male passengers
 SELECT COUNT(Passenger_ID) AS Total_Male_Passengers
FROM Airline
WHERE Gender = 'Male';

--4. Finding total number of female passengers
 SELECT COUNT(Passenger_ID) AS Total_Female_Passengers
FROM Airline
WHERE Gender = 'Female';

--5. Finding how many number of passengers effected by delayed
SELECT COUNT(Passenger_ID) AS Passengers_effected_by_delay
FROM Airline
WHERE Flight_Status='delayed';

--6. Finding how many number of passengers effected by cancelled
SELECT COUNT(Passenger_ID) AS Passengers_effected_by_cancelled
FROM Airline
WHERE Flight_Status='cancelled';

-- Adding new column as Age_group into the airline table
ALTER TABLE Airline
ADD AgeGroup VARCHAR(15);

--Updating the column
UPDATE Airline
SET AgeGroup = CASE
    WHEN Age BETWEEN 0 AND 1 THEN 'Baby'
    WHEN Age BETWEEN 2 AND 3 THEN 'Toddler'
    WHEN Age BETWEEN 4 AND 5 THEN 'preschooler'
    WHEN Age BETWEEN 6 AND 12 THEN 'child'
    WHEN Age BETWEEN 13 AND 17 THEN 'adolescent'
    WHEN Age BETWEEN 18 AND 24 THEN 'young adult'
    WHEN Age BETWEEN 25 AND 34 THEN 'adult '
    WHEN Age BETWEEN 35 AND 49 THEN 'middle aged'
    WHEN Age BETWEEN 50 AND 60 THEN 'young senior'
    WHEN Age BETWEEN 61 AND 79 THEN 'senior '
    ELSE 'old'
END;

-- Finding Top5 number of passengers travelled month-wise
 SELECT TOP 5
    DATENAME(MONTH,Departure_Date) AS Month_NAME,
    COUNT(Passenger_ID) AS PassengersTraveled
FROM
    Airline
GROUP BY
    DATENAME(MONTH,Departure_Date),MONTH(Departure_Date)
ORDER BY
    PassengersTraveled DESC;


-- Finding Top3 months - flight wise status
WITH TopMonths AS (
    SELECT TOP 3 MONTH(Departure_Date) AS Month, COUNT(CONCAT(Departure_Date, '-', Arrival_Airport)) AS TotalFlights
    FROM Airline
    GROUP BY MONTH(Departure_Date)
    ORDER BY TotalFlights DESC
)
SELECT tm.Month, a.Flight_Status, COUNT(CONCAT(a.Departure_Date, '-', a.Arrival_Airport)) AS FlightsCount
FROM TopMonths tM
JOIN Airline a ON MONTH(a.Departure_Date) = tm.Month
GROUP BY tm.Month, a.Flight_Status
ORDER BY tm.Month, a.Flight_Status;


-- Finding continent-wise flight status 
SELECT Airport_Continent, Flight_Status, COUNT(CONCAT(Departure_Date, '-', Arrival_Airport)) AS FlightsCount
FROM Airline
GROUP BY Airport_Continent, Flight_Status
ORDER BY Airport_Continent, Flight_Status;


--Finding number of passengers nation-wise
SELECT Country_Name, COUNT(Passenger_ID) AS PassengersCount
FROM Airline
GROUP BY Country_Name
ORDER BY PassengersCount DESC;


-- Finding gender wise number of passengers according to age group
SELECT AgeGroup,Gender,COUNT(Passenger_ID) AS PassengersCount
FROM Airline
GROUP BY AgeGroup, Gender
ORDER BY AgeGroup, Gender;
