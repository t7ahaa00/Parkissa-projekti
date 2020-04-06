CREATE PROCEDURE generateDummyData ()
BEGIN
	DECLARE parkinglotName varchar(300) DEFAULT null;
    DECLARE parkinglotID int(11) DEFAULT null;
    DECLARE parkingAreaID int(11) DEFAULT null;

    SET parkinglotName:='test oulunYliopisto';
    SET parkinglotID:=1;
    DELETE FROM parkinglot WHERE idparkinglot = parkinglotID;
    INSERT INTO parkinglot VALUES(parkinglotID,parkinglotName);
    
    INSERT INTO parkingarea VALUES(parkinglotID,null,1,65.060014,25.470085,65.058479,25.471944,20);
	SET parkingAreaID = LAST_INSERT_ID();
	CALL createParkingGrid(parkingAreaID,9,12);
    SET parkingAreaID = null;
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
    INSERT INTO parkingarea VALUES(parkinglotID,null,2,65.060014,25.470085,65.058479,25.471944,20);
	CALL createParkingGrid(LAST_INSERT_ID(),8,4);
    SET parkingAreaID = null;
    INSERT INTO parkingarea VALUES(parkinglotID,null,3,65.060014,25.470085,65.058479,25.471944,20);
	CALL createParkingGrid(LAST_INSERT_ID(),8,4);
    SET parkingAreaID = null;
    
    
	SET parkinglotName:='test teknologiakyla';
    SET parkinglotID:=2;
    DELETE FROM parkinglot WHERE idparkinglot = parkinglotID;
    INSERT INTO parkinglot VALUES(parkinglotID,parkinglotName);
    
    INSERT INTO parkingarea VALUES(parkinglotID,null,1,65.060014,25.470085,65.058479,25.471944,20);
    CALL createParkingGrid(LAST_INSERT_ID(),8,4);
    SET parkingAreaID = null;
    
    INSERT INTO parkingarea VALUES(parkinglotID,null,2,65.060014,25.470085,65.058479,25.471944,20);
	CALL createParkingGrid(LAST_INSERT_ID(),8,12);
    SET parkingAreaID = null;
    
    INSERT INTO parkingarea VALUES(parkinglotID,null,3,65.060014,25.470085,65.058479,25.471944,20);
	SET parkingAreaID = LAST_INSERT_ID();
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