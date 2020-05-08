CREATE DEFINER=`admin`@`%` PROCEDURE `createLog`(
IN 	idParkingLot INT(11),
	idParkingArea INT(11)
    )
BEGIN

	
    INSERT INTO log VALUES(
	idParkingLot,
	(SELECT name FROM parkinglot WHERE idparkinglot = idParkingLot),
	null,
	NOW(),
    (SELECT COUNT(*) FROM grid 
		WHERE idparkingarea = idParkingArea
		AND occupied = true),
    (SELECT COUNT(*) FROM grid 
		WHERE idparkingarea = idParkingArea 
		AND occupied = false),
    (SELECT avaiblespace FROM parkingarea WHERE idparkingarea = idParkingArea));
END