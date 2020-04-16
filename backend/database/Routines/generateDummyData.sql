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
    INSERT INTO path VALUES(parkingAreaID,null,65.060582, 25.462892),
							(parkingAreaID,null,65.060573, 25.464510),
                            (parkingAreaID,null,65.061669, 25.464576),
                            (parkingAreaID,null,65.061665, 25.462881);
	CALL createParkingGrid(parkingAreaID,45);
    CAll toggleStateWithoutReturn(parkingAreaID,2);
	CAll toggleStateWithoutReturn(parkingAreaID,4);
    CAll toggleStateWithoutReturn(parkingAreaID,5);
    CAll toggleStateWithoutReturn(parkingAreaID,8);
    CAll toggleStateWithoutReturn(parkingAreaID,9);
	CAll toggleStateWithoutReturn(parkingAreaID,19);
	CAll toggleStateWithoutReturn(parkingAreaID,20);
    CAll toggleStateWithoutReturn(parkingAreaID,22);
    CAll toggleStateWithoutReturn(parkingAreaID,23);
    CAll toggleStateWithoutReturn(parkingAreaID,35);
    SET parkingAreaID = null;
    
    INSERT INTO parkingarea VALUES(parkinglotID,null,2,20,90.0);
    SET parkingAreaID = LAST_INSERT_ID();
    INSERT INTO path VALUES(parkingAreaID,null,65.059511, 25.462798),
							(parkingAreaID,null,65.060321, 25.462787),
                            (parkingAreaID,null,65.060333, 25.461981),
                            (parkingAreaID,null,65.059516, 25.461992);
	CALL createParkingGrid(parkingAreaID,34);
    SET parkingAreaID = null;
    
    INSERT INTO parkingarea VALUES(parkinglotID,null,3,20,0.0);
    SET parkingAreaID = LAST_INSERT_ID();
    INSERT INTO path VALUES(parkingAreaID,null,65.057739, 25.462804),
							(parkingAreaID,null,65.058847, 25.462809),
                            (parkingAreaID,null,65.058841, 25.461611),
                            (parkingAreaID,null,65.057741, 25.461567);
	CALL createParkingGrid(parkingAreaID,44);
    SET parkingAreaID = null;
    
    
	SET parkinglotName:='test teknologiakyla';
    SET parkinglotID:=2;
    DELETE FROM parkinglot WHERE idparkinglot = parkinglotID;
    INSERT INTO parkinglot VALUES(parkinglotID,parkinglotName);
    
    INSERT INTO parkingarea VALUES(parkinglotID,null,1,20,0.0);
    SET parkingAreaID = LAST_INSERT_ID();
    INSERT INTO path VALUES(parkingAreaID,null,65.059129, 25.453084),
							(parkingAreaID,null,65.059630, 25.452490),
                            (parkingAreaID,null,65.059567, 25.452178),
                            (parkingAreaID,null,65.059070, 25.452777);
    CALL createParkingGrid(parkingAreaID,25);
    SET parkingAreaID = null;
    
    INSERT INTO parkingarea VALUES(parkinglotID,null,2,20,90.0);
    SET parkingAreaID = LAST_INSERT_ID();
    INSERT INTO path VALUES(parkingAreaID,null,65.061452, 25.447493),
							(parkingAreaID,null,65.062070, 25.446935),
                            (parkingAreaID,null,65.061695, 25.444566),
                            (parkingAreaID,null,65.061069, 25.445036);
	CALL createParkingGrid(parkingAreaID,40);
    SET parkingAreaID = null;
    
    INSERT INTO parkingarea VALUES(parkinglotID,null,3,20,0.0);
	SET parkingAreaID = LAST_INSERT_ID();
    INSERT INTO path VALUES(parkingAreaID,null,65.057354, 25.455739),
							(parkingAreaID,null,65.057359, 25.457524),
                            (parkingAreaID,null,65.057961, 25.457521),
                            (parkingAreaID,null,65.057975, 25.455755);
    CALL createParkingGrid(parkingAreaID,10);
    CAll toggleStateWithoutReturn(parkingAreaID,2);
	CAll toggleStateWithoutReturn(parkingAreaID,4);
    CAll toggleStateWithoutReturn(parkingAreaID,5);
    CAll toggleStateWithoutReturn(parkingAreaID,8);
    CAll toggleStateWithoutReturn(parkingAreaID,9);
	CAll toggleStateWithoutReturn(parkingAreaID,10);
	CAll toggleStateWithoutReturn(parkingAreaID,11);
    CAll toggleStateWithoutReturn(parkingAreaID,12);
    CAll toggleStateWithoutReturn(parkingAreaID,25);
    CAll toggleStateWithoutReturn(parkingAreaID,26);
    SET parkingAreaID = null;
    
    SELECT 
			'success' AS success;
END