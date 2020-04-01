CREATE PROCEDURE createLog(
	IN 	parkinglotName VARCHAR(255))
BEGIN

	SET @idParkingLot := (SELECT idparkinglot FROM parkinglot WHERE name = parkinglotName);
	
    INSERT INTO log VALUES(
	(@idParkingLot),
    parkinglotName,
	null,
	NOW(),
    (SELECT COUNT(*) FROM grid 
		WHERE idparkinglot = (@idParkingLot) 
		AND occupied = true),
    (SELECT COUNT(*) FROM grid 
		WHERE idparkinglot = (@idParkingLot) 
		AND occupied = false),
    (SELECT avaiblespace FROM parkinglot WHERE idparkinglot = @idParkingLot));
END