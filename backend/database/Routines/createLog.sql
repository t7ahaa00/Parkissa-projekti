CREATE DEFINER=`admin`@`%` PROCEDURE `createLog`(
IN 	parkinglotName VARCHAR(255),
	parkingareaName VARCHAR(255)
    )
BEGIN

	SET @idParkingLot := (SELECT idparkinglot FROM parkinglot WHERE name = parkinglotName);
    SET @idParkingArea := (SELECT idparkingarea FROM parkingarea WHERE name = parkingareaName);
	
    INSERT INTO log VALUES(
	(@idParkingLot),
    parkinglotName,
    parkingareaName,
	null,
	NOW(),
    (SELECT COUNT(*) FROM grid 
		WHERE idparkingarea = (@idParkingArea) 
		AND occupied = true),
    (SELECT COUNT(*) FROM grid 
		WHERE idparkingarea = (@idParkingArea) 
		AND occupied = false),
    (SELECT avaiblespace FROM parkingarea WHERE idparkingarea = @idParkingArea));
END