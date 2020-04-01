CREATE DEFINER=`admin`@`%` PROCEDURE `createParkingGrid`(
    IN 	idParkingAreaIn INT(11), 
		parkrows INT(4),
		parkslots INT(4)
)
BEGIN
    DECLARE looperOuter INT DEFAULT 1;
	outerLoop: LOOP
		IF looperOuter = parkrows + 1 THEN
			LEAVE outerLoop;
		END IF;
		innerBlock: BEGIN
		DECLARE looperInner INT DEFAULT 1;
		innerLoop: LOOP
				IF looperInner = parkslots + 1 THEN
				  LEAVE innerLoop;
				END IF;
					INSERT INTO grid VALUES(idParkingAreaIn,null,looperOuter,looperInner,false);
				SET looperInner = looperInner + 1;
				ITERATE innerLoop;
		END LOOP innerLoop;
		END innerBlock;
		SET looperOuter = looperOuter + 1;
		
		ITERATE outerLoop;
	END LOOP;
    UPDATE parkingarea SET avaiblespace = parkrows*parkslots WHERE idparkingarea = idParkingAreaIn;    
END