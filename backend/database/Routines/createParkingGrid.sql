CREATE DEFINER=`admin`@`%` PROCEDURE `createParkingGrid`(
    IN 	idParkingAreaIn INT(11), 
		parkslots INT(4)
)
BEGIN
		DECLARE looperInner INT DEFAULT 1;
		innerLoop: LOOP
				IF looperInner = parkslots + 1 THEN
				  LEAVE innerLoop;
				END IF;
					INSERT INTO grid VALUES(idParkingAreaIn,null,looperInner,true,0.12345678,0.12345678);
				SET looperInner = looperInner + 1;
				ITERATE innerLoop;
		END LOOP innerLoop;
    UPDATE parkingarea SET avaiblespace = parkslots WHERE idparkingarea = idParkingAreaIn;    
END