CREATE DEFINER=`admin`@`%` PROCEDURE `deleteParkinglot`(
	IN 	parkinglotID int(11)
)
BEGIN
	DECLARE parkinglotName varchar(300) DEFAULT null;
	
    SET parkinglotName:=(SELECT name FROM parkinglot WHERE idparkinglot = parkinglotID);
	
    IF(parkinglotName IS NOT NULL) THEN
		DELETE from parkinglot WHERE idparkinglot = parkinglotID;
        SELECT 
			'success' AS success;
	END IF;
    
	IF(parkinglotName IS NULL) THEN
		SELECT 
			'error' AS error,
            'could not find parkinglot with that id' AS message;
	END IF;
END