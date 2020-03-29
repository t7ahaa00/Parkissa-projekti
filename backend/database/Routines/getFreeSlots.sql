CREATE DEFINER=`admin`@`%` PROCEDURE `getFreeSlots`(
	IN 	parkinglotID int(11)
)
BEGIN
	DECLARE parkinglotName varchar(300) DEFAULT "Parkinglot with id doesn't exist";
    DECLARE freeSlots int(11) DEFAULT 0;
	
    SET parkinglotName:=(SELECT name FROM parkinglot WHERE idparkinglot = parkinglotID);
	
    IF(parkinglotName IS NOT NULL) THEN
		SELECT 
			parkinglotID AS idparkinglot, 
			parkinglotName AS name,
			(SELECT COUNT(*) FROM grid
				WHERE idparkinglot = idparkinglot 
				AND occupied = false) AS freeSlots;
	END IF;
    
	IF(parkinglotName IS NULL) THEN
		SELECT 
			'error' AS error,
            'could not find parkinglot with that id' AS message;
	END IF;

END