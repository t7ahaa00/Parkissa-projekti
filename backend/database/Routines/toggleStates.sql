CREATE DEFINER=`admin`@`%` PROCEDURE `toggleState`(
	IN 	parkingAreaIDin int(11),
		slotIn varchar(11)
)
BEGIN
    DECLARE gridID int(11) DEFAULT null;
    SET gridID:=(SELECT idgrid FROM grid WHERE slot = slotIn AND idparkingarea = parkingAreaIDin);
	
    IF(gridID IS NOT NULL) THEN
		UPDATE grid SET occupied = !occupied 
			WHERE idgrid = gridID;		
        SELECT 
			'success' AS success;
	END IF;
        
    IF(gridID IS NULL) THEN
		SELECT 
			'error' AS error,
            'could not find grid with that slot' AS message;
	END IF;
END