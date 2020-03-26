CREATE PROCEDURE toggleState (
	IN 	parkinglotName VARCHAR(255), 
		slotNameIn VARCHAR(5)
)
BEGIN
	UPDATE grid SET grid.occupied = NOT grid.occupied 
	WHERE idparkinglot in (SELECT idparkinglot FROM parkinglot WHERE name = parkinglotName)
	AND slotName=slotNameIn;
END