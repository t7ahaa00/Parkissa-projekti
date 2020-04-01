CREATE DEFINER=`admin`@`%` PROCEDURE `toggleState`(
	IN 	parkinglotIDIn int(11), 
		slotnameIn varchar(11)
)
BEGIN
	DECLARE parkinglotName varchar(300) DEFAULT null;
    DECLARE gridID int(11) DEFAULT null;
    SET parkinglotName:=(SELECT name FROM parkinglot WHERE idparkinglot = parkinglotIDIn);
    SET gridID:=(SELECT idgrid FROM grid WHERE slotname = slotnameIn AND idparkinglot = parkinglotIDIn);
	
    IF(parkinglotName IS NOT NULL AND gridID IS NOT NULL) THEN
		UPDATE grid SET occupied = !occupied 
			WHERE idparkinglot = parkinglotIDIn
			AND idgrid=gridID;
		
        SELECT 
			'success' AS success;
	END IF;
        
	IF(parkinglotName IS NULL) THEN
		SELECT 
			'error' AS error,
            'could not find parkinglot with that id' AS message;
	END IF;
	
    IF(gridID IS NULL) THEN
		SELECT 
			'error' AS error,
            'could not find grid with that name' AS message;
	END IF;
END