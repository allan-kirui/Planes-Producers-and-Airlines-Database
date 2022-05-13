--View consisiting of Model ID and Name, Airline Name, Alliance Name And Plane Tail Num
CREATE VIEW [ModAirAllJoined] 
	(TNo,ModID,ModName,AirName,AllName)
	AS SELECT PLANE.TailNo,MODEL.ModelID,MODEL.ModelName,
			  AIRLINE.AirlineName,AIRLINE.AllianceName
	FROM MODEL, AIRLINE,PLANE
	WHERE MODEL.ModelID = PLANE.ModelID AND PLANE.AirlineName = AIRLINE.AirlineName
	WITH CHECK OPTION
