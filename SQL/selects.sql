USE PLANES_AND_AIRLINES

-- Displays 2 plane model ID's of planes that landed in Nairobi
SELECT TOP 2 ModelID, FLIGHT.FlightID,PLANE.TailNo,PLANE.AirlineName,
			 A1.AirportLocation AS 'From', A2.AirportLocation AS 'To'
FROM FLIGHT JOIN FLIGHT_AND_PLANES
ON FLIGHT.FlightID = FLIGHT_AND_PLANES.FlightID
JOIN PLANE
ON FLIGHT_AND_PLANES.TailNo = PLANE.TailNo
JOIN AIRPORT A1
ON A1.AirportCode = FLIGHT.DepartingApCode
JOIN AIRPORT A2
ON A2.AirportCode = FLIGHT.ReceivingApCode
WHERE A2.AirportLocation = 'Nairobi'
ORDER BY ModelID

-- Check for airlines in said alliances that have planes made by a specific producer
-- and list the number of planes
SELECT AIRLINE.AirlineName,ALLIANCE.AllianceName, PRODUCER.ProducerName,MODEL.ModelID, COUNT(MODEL.ModelID) AS 'Number'
FROM AIRLINE JOIN ALLIANCE
ON AIRLINE.AllianceName = ALLIANCE.AllianceName
JOIN PLANE
ON PLANE.AirlineName = AIRLINE.AirlineName
JOIN MODEL
ON MODEL.ModelID = PLANE.ModelID
JOIN PRODUCER
ON PRODUCER.ProducerID = MODEL.ProducerID
GROUP BY AIRLINE.AirlineName,ALLIANCE.AllianceName, PRODUCER.ProducerName,MODEL.ModelID
HAVING ProducerName = 'Boeing' AND ALLIANCE.AllianceName IN('SkyTeam','OneWorld')

--3 Check address of a producer of a plane with a specific tail number
SELECT PLANE.AirlineName,PLANE.TailNo,MODEL.ModelID,PRODUCER.AddressID,ADDRESSES.Street,ADDRESSES.City,ADDRESSES.Country,ADDRESSES.PostalCode
FROM PLANE
JOIN MODEL
ON PLANE.ModelID = MODEL.ModelID
JOIN PRODUCER
ON PRODUCER.ProducerID = MODEL.ProducerID
JOIN ADDRESSES
ON ADDRESSES.AddressID = PRODUCER.AddressID
WHERE PLANE.TailNo='7B-BAW' 


--1 ordered list of plane models owned by airlines in an alliance
SELECT AIRLINE.AirlineName,AIRLINE.AllianceName, PLANE.ModelID, COUNT(PLANE.ModelID) AS 'Number'
FROM AIRLINE, PLANE
WHERE PLANE.AirlineName = AIRLINE.AirlineName AND AIRLINE.AllianceName='OneWorld'
GROUP BY AIRLINE.AirlineName,AIRLINE.AllianceName, PLANE.ModelID
ORDER BY  Number DESC


--3 Give the name and count of the owner whose airlines collectively have the highest number of planes.
SELECT TOP 1 OWNERS.OwnerName, COUNT(PLANE.ModelID) AS 'Number of planes'
FROM OWNERS, OWNERS_AND_AIRLINES, AIRLINE, PLANE
WHERE OWNERS_AND_AIRLINES.OwnerID=OWNERS.OwnerID
AND OWNERS_AND_AIRLINES.AirlineName = AIRLINE.AirlineName
AND PLANE.AirlineName = AIRLINE.AirlineName
GROUP BY OWNERS.OwnerName
ORDER BY 'Number of planes' DESC

--Subqueries 
--Shows details of owner who has a stake in all Airlines
SELECT *
FROM OWNERS
WHERE NOT EXISTS
	(SELECT * 
		FROM AIRLINE
		WHERE NOT EXISTS
		(SELECT * 
			FROM OWNERS_AND_AIRLINES
			WHERE OWNERS.OwnerID = OWNERS_AND_AIRLINES.OwnerID
			AND AIRLINE.AirlineName = OWNERS_AND_AIRLINES.AirlineName))

--Show Owner ID who have stakes in more than one airline and said Airlines
SELECT DISTINCT OWN.OwnerID,OWN.AirlineName
FROM OWNERS_AND_AIRLINES OWN
WHERE EXISTS
	(SELECT * 
	FROM OWNERS_AND_AIRLINES OWN2
	WHERE OWN.OwnerID = OWN2.OwnerID AND OWN.AirlineName <> OWN2.AirlineName)

--Show data of Producers with models whose value is greater than 1000000
SELECT PRODUCER.ProducerID,PRODUCER.ProducerName,PRODUCER.DateFormed
FROM PRODUCER
WHERE PRODUCER.ProducerID IN
(SELECT ProducerID
FROM MODEL
GROUP BY ProducerID
HAVING SUM(Price)>1000000)
ORDER BY ProducerName


--User wants to see all flights departing between a set time frame from a specific airport
SELECT A1.AirportName AS 'Departing Airport',A2.AirportName AS 'Receiving Airport',FLIGHT_AND_PLANES.FlightID,
		FLIGHT.DepartureTime,Tno AS 'Tail Num',ModID,ModName AS 'Model Name',AirName AS 'AIRLINE',AllName AS 'ALLIANCE'
FROM ModAirAllJoined --VIEW
JOIN FLIGHT_AND_PLANES
ON FLIGHT_AND_PLANES.TailNo = TNo
JOIN FLIGHT
ON FLIGHT.FlightID = FLIGHT_AND_PLANES.FlightID
JOIN AIRPORT A1
ON A1.AirportCode = FLIGHT.DepartingApCode
JOIN AIRPORT A2
ON A2.AirportCode = FLIGHT.ReceivingApCode
WHERE A1.AirportCode='OMDB' AND FLIGHT.DepartureTime BETWEEN '12:00:00' AND '16:00:00'


