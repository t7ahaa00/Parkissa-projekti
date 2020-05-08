CREATE DEFINER=`admin`@`%` PROCEDURE `toggleStateWithoutReturn`(
	IN 	parkingAreaIDin int(11),
		slotIn varchar(11)
)
BEGIN
    DECLARE gridID int(11) DEFAULT null;
    SET gridID:=(SELECT idgrid FROM grid WHERE slot = slotIn AND idparkingarea = parkingAreaIDin);
	
    IF(gridID IS NOT NULL) THEN
		UPDATE grid SET occupied = !occupied 
			WHERE idgrid = gridID;		
	END IF;
        
END