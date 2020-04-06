CREATE DEFINER=`admin`@`%` PROCEDURE `getFreeSlots`(
    IN 	parkingareaID int(11)
)
BEGIN
	DECLARE existss varchar(300) DEFAULT null;
    DECLARE freeSlots int(11) DEFAULT null;
	
    SET existss:=(SELECT avaiblespace FROM parkingarea WHERE idparkingarea = parkingareaID);
	
    IF(existss IS NOT NULL) THEN
		SELECT 
			parkingareaID AS idparkingarea, 
			(SELECT COUNT(*) FROM grid
				WHERE idparkingarea = parkingareaID 
				AND occupied = false) AS freeSlots;
	END IF;
    
	IF(existss IS NULL) THEN
		SELECT 
			'error' AS error,
            'could not find parkingarea with that id' AS message;
	END IF;

END