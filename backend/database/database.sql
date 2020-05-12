-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema parkissa
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema parkissa
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `parkissa` DEFAULT CHARACTER SET utf8 ;
USE `parkissa` ;

-- -----------------------------------------------------
-- Table `parkissa`.`api_keys`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parkissa`.`api_keys` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `api_key` VARCHAR(24) NOT NULL,
  `ip` VARCHAR(45) NOT NULL,
  `user_agent` VARCHAR(400) NOT NULL,
  `request_id` VARCHAR(200) NOT NULL,
  `uses` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `api_key_UNIQUE` (`api_key` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `parkissa`.`parkinglot`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parkissa`.`parkinglot` (
  `idparkinglot` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(60) NOT NULL,
  `city` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`idparkinglot`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `parkissa`.`parkingarea`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parkissa`.`parkingarea` (
  `idparkinglot` INT(11) NOT NULL,
  `idparkingarea` INT(11) NOT NULL AUTO_INCREMENT,
  `id` INT(11) NOT NULL,
  `avaiblespace` INT(11) NOT NULL,
  PRIMARY KEY (`idparkingarea`),
  INDEX `fk_parkingarea_parkinglot1_idx` (`idparkinglot` ASC),
  CONSTRAINT `fk_parkingarea_parkinglot1`
    FOREIGN KEY (`idparkinglot`)
    REFERENCES `parkissa`.`parkinglot` (`idparkinglot`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 26
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `parkissa`.`camera`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parkissa`.`camera` (
  `idparkingarea` INT(11) NOT NULL,
  `idcamera` INT(11) NOT NULL AUTO_INCREMENT,
  `ip` VARCHAR(45) NULL DEFAULT NULL,
  `cameraNumber` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`idcamera`),
  INDEX `fk_camera_parkingarea1_idx` (`idparkingarea` ASC),
  CONSTRAINT `fk_camera_parkingarea1`
    FOREIGN KEY (`idparkingarea`)
    REFERENCES `parkissa`.`parkingarea` (`idparkingarea`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `parkissa`.`visitor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parkissa`.`visitor` (
  `idvisitor` INT(11) NOT NULL AUTO_INCREMENT,
  `phonenumber` VARCHAR(45) NOT NULL,
  `firstname` VARCHAR(45) NULL DEFAULT NULL,
  `lastname` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`idvisitor`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `parkissa`.`car`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parkissa`.`car` (
  `idvisitor` INT(11) NOT NULL,
  `idcar` INT(11) NOT NULL AUTO_INCREMENT,
  `registernumber` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idcar`),
  INDEX `fk_car_visitor2_idx` (`idvisitor` ASC),
  CONSTRAINT `fk_car_visitor2`
    FOREIGN KEY (`idvisitor`)
    REFERENCES `parkissa`.`visitor` (`idvisitor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `parkissa`.`grid`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parkissa`.`grid` (
  `idparkingarea` INT(11) NOT NULL,
  `idgrid` INT(11) NOT NULL AUTO_INCREMENT,
  `slot` INT(11) NOT NULL,
  `occupied` TINYINT(4) NOT NULL,
  `lat` DECIMAL(15,6) NOT NULL,
  `lng` DECIMAL(15,6) NOT NULL,
  PRIMARY KEY (`idgrid`),
  INDEX `fk_grid_parkingarea1_idx` (`idparkingarea` ASC),
  CONSTRAINT `fk_grid_parkingarea1`
    FOREIGN KEY (`idparkingarea`)
    REFERENCES `parkissa`.`parkingarea` (`idparkingarea`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 931
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `parkissa`.`log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parkissa`.`log` (
  `idparkinglot` INT(11) NOT NULL,
  `parkinglotname` VARCHAR(300) NOT NULL,
  `parkingareaname` VARCHAR(300) NOT NULL,
  `idlog` INT(11) NOT NULL AUTO_INCREMENT,
  `time` DATETIME NOT NULL,
  `occupied` INT(11) NOT NULL,
  `free` INT(11) NOT NULL,
  `total` INT(11) NOT NULL,
  PRIMARY KEY (`idlog`),
  INDEX `fk_log_parkinglot1_idx` (`idparkinglot` ASC),
  CONSTRAINT `fk_log_parkinglot1`
    FOREIGN KEY (`idparkinglot`)
    REFERENCES `parkissa`.`parkinglot` (`idparkinglot`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `parkissa`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parkissa`.`user` (
  `iduser` INT(11) NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(100) NOT NULL,
  `userType` VARCHAR(45) NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(300) NOT NULL,
  PRIMARY KEY (`iduser`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `parkissa`.`parkinglot_has_user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parkissa`.`parkinglot_has_user` (
  `idparkinglot` INT(11) NOT NULL,
  `iduser` INT(11) NOT NULL,
  PRIMARY KEY (`idparkinglot`, `iduser`),
  INDEX `fk_parkingLot_has_user_user1_idx` (`iduser` ASC),
  INDEX `fk_parkingLot_has_user_parkingLot1_idx` (`idparkinglot` ASC),
  CONSTRAINT `fk_parkingLot_has_user_parkingLot1`
    FOREIGN KEY (`idparkinglot`)
    REFERENCES `parkissa`.`parkinglot` (`idparkinglot`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_parkingLot_has_user_user1`
    FOREIGN KEY (`iduser`)
    REFERENCES `parkissa`.`user` (`iduser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `parkissa`.`path`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parkissa`.`path` (
  `idparkingarea` INT(11) NOT NULL,
  `idpath` INT(11) NOT NULL AUTO_INCREMENT,
  `lat` DECIMAL(15,6) NOT NULL,
  `lng` DECIMAL(15,6) NOT NULL,
  PRIMARY KEY (`idpath`),
  INDEX `fk_path_parkingarea1_idx` (`idparkingarea` ASC),
  CONSTRAINT `fk_path_parkingarea1`
    FOREIGN KEY (`idparkingarea`)
    REFERENCES `parkissa`.`parkingarea` (`idparkingarea`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 85
DEFAULT CHARACTER SET = utf8;

USE `parkissa` ;

-- -----------------------------------------------------
-- procedure createLog
-- -----------------------------------------------------

DELIMITER $$
USE `parkissa`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `createLog`(
IN 	idParkingLot INT(11),
	idParkingArea INT(11)
    )
BEGIN

	
    INSERT INTO log VALUES(
	idParkingLot,
	(SELECT name FROM parkinglot WHERE idparkinglot = idParkingLot),
	null,
	NOW(),
    (SELECT COUNT(*) FROM grid 
		WHERE idparkingarea = idParkingArea
		AND occupied = true),
    (SELECT COUNT(*) FROM grid 
		WHERE idparkingarea = idParkingArea 
		AND occupied = false),
    (SELECT avaiblespace FROM parkingarea WHERE idparkingarea = idParkingArea));
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure createParkingGrid
-- -----------------------------------------------------

DELIMITER $$
USE `parkissa`$$
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure deleteParkinglot
-- -----------------------------------------------------

DELIMITER $$
USE `parkissa`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `deleteParkinglot`(
	IN 	parkinglotID int(11)
)
BEGIN
	DECLARE parkinglotName varchar(300) DEFAULT null;
	
    SET parkinglotName:=(SELECT name FROM parkinglot WHERE idparkinglot = parkinglotID);
	
    IF(parkinglotName IS NOT NULL) THEN
		DELETE from parkinglot WHERE idparkinglot = parkinglotID;
        SELECT 
			'success' AS success;
	END IF;
    
	IF(parkinglotName IS NULL) THEN
		SELECT 
			'error' AS error,
            'could not find parkinglot with that id' AS message;
	END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure generateDummyData
-- -----------------------------------------------------

DELIMITER $$
USE `parkissa`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `generateDummyData`()
BEGIN
	DECLARE parkinglotName varchar(300) DEFAULT null;
    DECLARE cityName varchar(300) DEFAULT null;
    DECLARE parkinglotID int(11) DEFAULT null;
    DECLARE parkingAreaID int(11) DEFAULT null;

    SET parkinglotName:='test oulunYliopisto';
    SET cityName:='Oulu';
    SET parkinglotID:=1;
    DELETE FROM parkinglot WHERE idparkinglot = parkinglotID;
    INSERT INTO parkinglot VALUES(parkinglotID,parkinglotName,cityName);
    
    INSERT INTO parkingarea VALUES(parkinglotID,null,1,20);
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
    
    INSERT INTO parkingarea VALUES(parkinglotID,null,2,20);
    SET parkingAreaID = LAST_INSERT_ID();
    INSERT INTO path VALUES(parkingAreaID,null,65.059511, 25.462798),
							(parkingAreaID,null,65.060321, 25.462787),
                            (parkingAreaID,null,65.060333, 25.461981),
                            (parkingAreaID,null,65.059516, 25.461992);
	CALL createParkingGrid(parkingAreaID,34);
    SET parkingAreaID = null;
    
    INSERT INTO parkingarea VALUES(parkinglotID,null,3,20);
    SET parkingAreaID = LAST_INSERT_ID();
    INSERT INTO path VALUES(parkingAreaID,null,65.057739, 25.462804),
							(parkingAreaID,null,65.058847, 25.462809),
                            (parkingAreaID,null,65.058841, 25.461611),
                            (parkingAreaID,null,65.057741, 25.461567);
	CALL createParkingGrid(parkingAreaID,44);
    SET parkingAreaID = null;
    
    
	SET parkinglotName:='test teknologiakyla';
    SET cityName:='Oulu';
    SET parkinglotID:=2;
    DELETE FROM parkinglot WHERE idparkinglot = parkinglotID;
    INSERT INTO parkinglot VALUES(parkinglotID,parkinglotName,cityName);
    
    INSERT INTO parkingarea VALUES(parkinglotID,null,1,20);
    SET parkingAreaID = LAST_INSERT_ID();
    INSERT INTO path VALUES(parkingAreaID,null,65.059129, 25.453084),
							(parkingAreaID,null,65.059630, 25.452490),
                            (parkingAreaID,null,65.059567, 25.452178),
                            (parkingAreaID,null,65.059070, 25.452777);
    CALL createParkingGrid(parkingAreaID,25);
    SET parkingAreaID = null;
    
    INSERT INTO parkingarea VALUES(parkinglotID,null,2,20);
    SET parkingAreaID = LAST_INSERT_ID();
    INSERT INTO path VALUES(parkingAreaID,null,65.061452, 25.447493),
							(parkingAreaID,null,65.062070, 25.446935),
                            (parkingAreaID,null,65.061695, 25.444566),
                            (parkingAreaID,null,65.061069, 25.445036);
	CALL createParkingGrid(parkingAreaID,40);
    SET parkingAreaID = null;
    
    INSERT INTO parkingarea VALUES(parkinglotID,null,3,20);
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getFreeSlots
-- -----------------------------------------------------

DELIMITER $$
USE `parkissa`$$
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

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure toggleState
-- -----------------------------------------------------

DELIMITER $$
USE `parkissa`$$
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure toggleStateWithoutReturn
-- -----------------------------------------------------

DELIMITER $$
USE `parkissa`$$
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
        
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
