CREATE PROCEDURE createParkingGrid(
    IN 	parkinglotName VARCHAR(255), 
		rowCount INT(4),
		placesInRow INT(4)
)
BEGIN
    DECLARE looperOuter INT DEFAULT 0;
    DECLARE str varchar(30) DEFAULT '';
	DECLARE id int(11) DEFAULT (
		SELECT idparkinglot FROM parkinglot 
        WHERE name = parkinglotName);
	DECLARE letter varchar(3) DEFAULT 'A';
    DECLARE letter2 varchar(3) DEFAULT 'A';
	
    IF rowCount >= 26 THEN
		outerLoop: LOOP
			IF looperOuter = rowCount THEN
				LEAVE outerLoop;
			END IF;
			innerBlock: BEGIN
			DECLARE looperInner INT DEFAULT 0;
			innerLoop: LOOP
					IF looperInner = placesInRow THEN
					  LEAVE innerLoop;
					END IF;
					SET str = CONCAT(letter2,letter,looperInner+1);
						INSERT INTO grid VALUES(id,null,str,false);
					SET looperInner = looperInner + 1;
					ITERATE innerLoop;
			END LOOP innerLoop;
			END innerBlock;
			
			SET letter = CHAR(ASCII(letter)+1);
			SET looperOuter = looperOuter + 1;
			
			IF looperOuter % 26 = 0 THEN 
				SET letter = 'A';
				SET letter2 = CHAR(ASCII(letter2)+ 1);
			END IF;
			
			ITERATE outerLoop;
		END LOOP;
    END IF;
    
	IF rowCount <= 27 THEN
		outerLoop: LOOP
			IF looperOuter = rowCount THEN
				LEAVE outerLoop;
			END IF;
			innerBlock: BEGIN
			DECLARE looperInner INT DEFAULT 0;
			innerLoop: LOOP
					IF looperInner = placesInRow THEN
					  LEAVE innerLoop;
					END IF;
					SET str = CONCAT(letter,looperInner+1);
						INSERT INTO grid VALUES(id,null,str,false);
					SET looperInner = looperInner + 1;
					ITERATE innerLoop;
			END LOOP innerLoop;
			END innerBlock;
			
			SET letter = CHAR(ASCII(letter)+1);
			SET looperOuter = looperOuter + 1;
			
			ITERATE outerLoop;
		END LOOP;
    END IF;

    UPDATE parkinglot SET avaiblespace = rowCount*placesInRow WHERE name = parkinglotName;    
END