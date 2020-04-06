CREATE DEFINER=`admin`@`%` PROCEDURE `generateDummyData`()
BEGIN
	DECLARE parkinglotName varchar(300) DEFAULT null;
    DECLARE parkinglotID int(11) DEFAULT null;
    DECLARE parkingAreaID int(11) DEFAULT null;

    SET parkinglotName:='test oulunYliopisto';
    SET parkinglotID:=1;
    DELETE FROM parkinglot WHERE idparkinglot = parkinglotID;
    INSERT INTO parkinglot VALUES(parkinglotID,parkinglotName);
    
    INSERT INTO parkingarea VALUES(parkinglotID,null,1,20,90.0);
	SET parkingAreaID = LAST_INSERT_ID();
    INSERT INTO path VALUES(parkingAreaID,null,65.060569, 25.464495),
							(parkingAreaID,null,65.061023, 25.464515),
                            (parkingAreaID,null,65.061049, 25.463253),
                            (parkingAreaID,null,65.060574, 25.463218);
	CALL createParkingGrid(parkingAreaID,4,10);
    CAll toggleStateWithoutReturn(parkingAreaID,1,2);
	CAll toggleStateWithoutReturn(parkingAreaID,1,4);
    CAll toggleStateWithoutReturn(parkingAreaID,1,5);
    CAll toggleStateWithoutReturn(parkingAreaID,1,8);
    CAll toggleStateWithoutReturn(parkingAreaID,1,9);
	CAll toggleStateWithoutReturn(parkingAreaID,2,2);
	CAll toggleStateWithoutReturn(parkingAreaID,2,7);
    CAll toggleStateWithoutReturn(parkingAreaID,2,8);
    CAll toggleStateWithoutReturn(parkingAreaID,2,9);
    CAll toggleStateWithoutReturn(parkingAreaID,2,10);
    SET parkingAreaID = null;
    
    INSERT INTO parkingarea VALUES(parkinglotID,null,2,20,90.0);
    SET parkingAreaID = LAST_INSERT_ID();
    INSERT INTO path VALUES(parkingAreaID,null,65.059523, 25.462801),
							(parkingAreaID,null,65.060319, 25.462796),
                            (parkingAreaID,null,65.060327, 25.461990),
                            (parkingAreaID,null,65.059533, 25.461994);
	CALL createParkingGrid(parkingAreaID,8,4);
    SET parkingAreaID = null;
    
    INSERT INTO parkingarea VALUES(parkinglotID,null,3,20,0.0);
    SET parkingAreaID = LAST_INSERT_ID();
    INSERT INTO path VALUES(parkingAreaID,null,65.057658, 25.462826),
							(parkingAreaID,null,65.058856, 25.462799),
                            (parkingAreaID,null,65.058834, 25.461587),
                            (parkingAreaID,null,65.057743, 25.461570);
	CALL createParkingGrid(parkingAreaID,8,4);
    SET parkingAreaID = null;
    
    
	SET parkinglotName:='test teknologiakyla';
    SET parkinglotID:=2;
    DELETE FROM parkinglot WHERE idparkinglot = parkinglotID;
    INSERT INTO parkinglot VALUES(parkinglotID,parkinglotName);
    
    INSERT INTO parkingarea VALUES(parkinglotID,null,1,20,0.0);
    SET parkingAreaID = LAST_INSERT_ID();
    INSERT INTO path VALUES(parkingAreaID,null,65.058328, 25.443178),
							(parkingAreaID,null,65.059038, 25.442494),
                            (parkingAreaID,null,65.058936, 25.441915),
                            (parkingAreaID,null,65.058217, 25.442519);
    CALL createParkingGrid(parkingAreaID,8,4);
    SET parkingAreaID = null;
    
    INSERT INTO parkingarea VALUES(parkinglotID,null,2,20,90.0);
    SET parkingAreaID = LAST_INSERT_ID();
    INSERT INTO path VALUES(parkingAreaID,null,65.059117, 25.442610),
							(parkingAreaID,null,65.059766, 25.442015),
                            (parkingAreaID,null,65.059667, 25.441382),
                            (parkingAreaID,null,65.059021, 25.442008);
	CALL createParkingGrid(parkingAreaID,8,12);
    SET parkingAreaID = null;
    
    INSERT INTO parkingarea VALUES(parkinglotID,null,3,20,0.0);
	SET parkingAreaID = LAST_INSERT_ID();
    INSERT INTO path VALUES(parkingAreaID,null,65.057627, 25.438264),
							(parkingAreaID,null,65.058070, 25.437856),
                            (parkingAreaID,null,65.059514, 25.437390),
                            (parkingAreaID,null,65.057765, 25.439166);
    CALL createParkingGrid(parkingAreaID,9,12);
    CAll toggleStateWithoutReturn(parkingAreaID,1,2);
	CAll toggleStateWithoutReturn(parkingAreaID,1,4);
    CAll toggleStateWithoutReturn(parkingAreaID,1,5);
    CAll toggleStateWithoutReturn(parkingAreaID,1,8);
    CAll toggleStateWithoutReturn(parkingAreaID,1,9);
	CAll toggleStateWithoutReturn(parkingAreaID,2,2);
	CAll toggleStateWithoutReturn(parkingAreaID,2,7);
    CAll toggleStateWithoutReturn(parkingAreaID,2,8);
    CAll toggleStateWithoutReturn(parkingAreaID,2,9);
    CAll toggleStateWithoutReturn(parkingAreaID,2,9);
    SET parkingAreaID = null;
    
    SELECT 
			'success' AS success;
END