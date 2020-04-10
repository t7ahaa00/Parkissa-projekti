-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema parkissa
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `parkissa` ;

-- -----------------------------------------------------
-- Schema parkissa
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `parkissa` DEFAULT CHARACTER SET utf8 ;
USE `parkissa` ;

-- -----------------------------------------------------
-- Table `parkissa`.`parkinglot`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `parkissa`.`parkinglot` ;

CREATE TABLE IF NOT EXISTS `parkissa`.`parkinglot` (
  `idparkinglot` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`idparkinglot`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 44
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `parkissa`.`camera`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `parkissa`.`camera` ;

CREATE TABLE IF NOT EXISTS `parkissa`.`camera` (
  `idparkinglot` INT(11) NOT NULL,
  `idcamera` INT(11) NOT NULL AUTO_INCREMENT,
  `ip` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`idcamera`),
  INDEX `fk_kamera_parkkialue1_idx` (`idparkinglot` ASC),
  CONSTRAINT `fk_kamera_parkkialue1`
    FOREIGN KEY (`idparkinglot`)
    REFERENCES `parkissa`.`parkinglot` (`idparkinglot`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `parkissa`.`visitor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `parkissa`.`visitor` ;

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
DROP TABLE IF EXISTS `parkissa`.`car` ;

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
-- Table `parkissa`.`parkingarea`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `parkissa`.`parkingarea` ;

CREATE TABLE IF NOT EXISTS `parkissa`.`parkingarea` (
  `idparkinglot` INT(11) NOT NULL,
  `idparkingarea` INT(11) NOT NULL AUTO_INCREMENT,
  `id` INT(11) NOT NULL,
  `avaiblespace` INT(11) NOT NULL,
  `orientation` DECIMAL(15,6) NOT NULL,
  PRIMARY KEY (`idparkingarea`),
  INDEX `fk_parkingarea_parkinglot1_idx` (`idparkinglot` ASC),
  CONSTRAINT `fk_parkingarea_parkinglot1`
    FOREIGN KEY (`idparkinglot`)
    REFERENCES `parkissa`.`parkinglot` (`idparkinglot`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 29
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `parkissa`.`grid`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `parkissa`.`grid` ;

CREATE TABLE IF NOT EXISTS `parkissa`.`grid` (
  `idparkingarea` INT(11) NOT NULL,
  `idgrid` INT(11) NOT NULL AUTO_INCREMENT,
  `row` INT(11) NOT NULL,
  `slot` INT(11) NOT NULL,
  `occupied` TINYINT(4) NOT NULL,
  PRIMARY KEY (`idgrid`),
  INDEX `fk_grid_parkingarea1_idx` (`idparkingarea` ASC),
  CONSTRAINT `fk_grid_parkingarea1`
    FOREIGN KEY (`idparkingarea`)
    REFERENCES `parkissa`.`parkingarea` (`idparkingarea`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 838
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `parkissa`.`log`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `parkissa`.`log` ;

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
DROP TABLE IF EXISTS `parkissa`.`user` ;

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
DROP TABLE IF EXISTS `parkissa`.`parkinglot_has_user` ;

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
DROP TABLE IF EXISTS `parkissa`.`path` ;

CREATE TABLE IF NOT EXISTS `parkissa`.`path` (
  `idparkingarea` INT(11) NOT NULL,
  `idpath` INT(11) NOT NULL AUTO_INCREMENT,
  `lat` DECIMAL(15,6) NOT NULL,
  `lng` DECIMAL(15,6) NOT NULL,
  INDEX `fk_path_parkingarea1_idx` (`idparkingarea` ASC),
  PRIMARY KEY (`idpath`),
  CONSTRAINT `fk_path_parkingarea1`
    FOREIGN KEY (`idparkingarea`)
    REFERENCES `parkissa`.`parkingarea` (`idparkingarea`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `parkissa` ;

-- -----------------------------------------------------
-- procedure createLog
-- -----------------------------------------------------

USE `parkissa`;
DROP procedure IF EXISTS `parkissa`.`createLog`;

DELIMITER $$
USE `parkissa`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `createLog`(
IN 	parkinglotName VARCHAR(255),
	parkingareaName VARCHAR(255)
    )
BEGIN

	SET @idParkingLot := (SELECT idparkinglot FROM parkinglot WHERE name = parkinglotName);
    SET @idParkingArea := (SELECT idparkingarea FROM parkingarea WHERE name = parkingareaName);
	
    INSERT INTO log VALUES(
	(@idParkingLot),
    parkinglotName,
    parkingareaName,
	null,
	NOW(),
    (SELECT COUNT(*) FROM grid 
		WHERE idparkingarea = (@idParkingArea) 
		AND occupied = true),
    (SELECT COUNT(*) FROM grid 
		WHERE idparkingarea = (@idParkingArea) 
		AND occupied = false),
    (SELECT avaiblespace FROM parkingarea WHERE idparkingarea = @idParkingArea));
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure createParkingGrid
-- -----------------------------------------------------

USE `parkissa`;
DROP procedure IF EXISTS `parkissa`.`createParkingGrid`;

DELIMITER $$
USE `parkissa`$$
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
					INSERT INTO grid VALUES(idParkingAreaIn,null,looperOuter,looperInner,true);
				SET looperInner = looperInner + 1;
				ITERATE innerLoop;
		END LOOP innerLoop;
		END innerBlock;
		SET looperOuter = looperOuter + 1;
		
		ITERATE outerLoop;
	END LOOP;
    UPDATE parkingarea SET avaiblespace = parkrows*parkslots WHERE idparkingarea = idParkingAreaIn;    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure deleteParkinglot
-- -----------------------------------------------------

USE `parkissa`;
DROP procedure IF EXISTS `parkissa`.`deleteParkinglot`;

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

USE `parkissa`;
DROP procedure IF EXISTS `parkissa`.`generateDummyData`;

DELIMITER $$
USE `parkissa`$$
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure getFreeSlots
-- -----------------------------------------------------

USE `parkissa`;
DROP procedure IF EXISTS `parkissa`.`getFreeSlots`;

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

USE `parkissa`;
DROP procedure IF EXISTS `parkissa`.`toggleState`;

DELIMITER $$
USE `parkissa`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `toggleState`(
	IN 	parkingAreaIDin int(11),
    	rowIn int(11), 
		slotIn varchar(11)
)
BEGIN
    DECLARE gridID int(11) DEFAULT null;
    SET gridID:=(SELECT idgrid FROM grid WHERE row = rowIn AND slot = slotIn AND idparkingarea = parkingAreaIDin);
	
    IF(gridID IS NOT NULL) THEN
		UPDATE grid SET occupied = !occupied 
			WHERE idgrid = gridID;		
        SELECT 
			'success' AS success;
	END IF;
        
    IF(gridID IS NULL) THEN
		SELECT 
            'could not find grid with that row/slot' AS message;
	END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure toggleStateWithoutReturn
-- -----------------------------------------------------

USE `parkissa`;
DROP procedure IF EXISTS `parkissa`.`toggleStateWithoutReturn`;

DELIMITER $$
USE `parkissa`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `toggleStateWithoutReturn`(
	IN 	parkingAreaIDin int(11),
    	rowIn int(11), 
		slotIn varchar(11)
)
BEGIN
    DECLARE gridID int(11) DEFAULT null;
    SET gridID:=(SELECT idgrid FROM grid WHERE row = rowIn AND slot = slotIn AND idparkingarea = parkingAreaIDin);
	
    IF(gridID IS NOT NULL) THEN
		UPDATE grid SET occupied = !occupied 
			WHERE idgrid = gridID;		
	END IF;
        
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
