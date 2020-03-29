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
-- Table `parkissa`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `parkissa`.`user` ;

CREATE TABLE IF NOT EXISTS `parkissa`.`user` (
  `iduser` INT(11) NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`iduser`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `parkissa`.`admin`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `parkissa`.`admin` ;

CREATE TABLE IF NOT EXISTS `parkissa`.`admin` (
  `iduser` INT(11) NOT NULL,
  `idadmin` INT(11) NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(300) NOT NULL,
  `password` VARCHAR(300) NOT NULL,
  PRIMARY KEY (`idadmin`),
  INDEX `fk_admin_user1_idx` (`iduser` ASC),
  CONSTRAINT `fk_admin_user1`
    FOREIGN KEY (`iduser`)
    REFERENCES `parkissa`.`user` (`iduser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `parkissa`.`parkinglot`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `parkissa`.`parkinglot` ;

CREATE TABLE IF NOT EXISTS `parkissa`.`parkinglot` (
  `idparkinglot` INT(11) NOT NULL AUTO_INCREMENT,
  `lng` FLOAT NOT NULL,
  `lat` FLOAT NOT NULL,
  `name` VARCHAR(60) NOT NULL,
  `avaiblespace` INT(11) NOT NULL,
  PRIMARY KEY (`idparkinglot`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 2
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
  `iduser` INT(11) NOT NULL,
  `idvisitor` INT(11) NOT NULL AUTO_INCREMENT,
  `phonenumber` VARCHAR(45) NOT NULL,
  `firstname` VARCHAR(45) NULL DEFAULT NULL,
  `lastname` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`idvisitor`),
  INDEX `fk_visitor_user_idx` (`iduser` ASC),
  CONSTRAINT `fk_visitor_user`
    FOREIGN KEY (`iduser`)
    REFERENCES `parkissa`.`user` (`iduser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
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
-- Table `parkissa`.`grid`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `parkissa`.`grid` ;

CREATE TABLE IF NOT EXISTS `parkissa`.`grid` (
  `idparkinglot` INT(11) NOT NULL,
  `idgrid` INT(11) NOT NULL AUTO_INCREMENT,
  `slotname` VARCHAR(45) NOT NULL,
  `occupied` TINYINT(4) NOT NULL,
  PRIMARY KEY (`idgrid`),
  INDEX `fk_parkkiruutu_parkkialue_idx` (`idparkinglot` ASC),
  CONSTRAINT `fk_parkkiruutu_parkkialue`
    FOREIGN KEY (`idparkinglot`)
    REFERENCES `parkissa`.`parkinglot` (`idparkinglot`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 91
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `parkissa`.`log`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `parkissa`.`log` ;

CREATE TABLE IF NOT EXISTS `parkissa`.`log` (
  `idparkinglot` INT(11) NOT NULL,
  `parkinglotname` VARCHAR(300) NOT NULL,
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
-- Table `parkissa`.`staff`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `parkissa`.`staff` ;

CREATE TABLE IF NOT EXISTS `parkissa`.`staff` (
  `iduser` INT(11) NOT NULL,
  `idstaff` INT(11) NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idstaff`),
  INDEX `fk_staff_user1_idx` (`iduser` ASC),
  CONSTRAINT `fk_staff_user1`
    FOREIGN KEY (`iduser`)
    REFERENCES `parkissa`.`user` (`iduser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

USE `parkissa` ;

-- -----------------------------------------------------
-- procedure createLog
-- -----------------------------------------------------

USE `parkissa`;
DROP procedure IF EXISTS `parkissa`.`createLog`;

DELIMITER $$
USE `parkissa`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `createLog`(
IN 	parkinglotName VARCHAR(255))
BEGIN

	SET @idParkingLot := (SELECT idparkinglot FROM parkinglot WHERE name = parkinglotName);
	
    INSERT INTO log VALUES(
	(@idParkingLot),
    parkinglotName,
	null,
	NOW(),
    (SELECT COUNT(*) FROM grid 
		WHERE idparkinglot = (@idParkingLot) 
		AND occupied = true),
    (SELECT COUNT(*) FROM grid 
		WHERE idparkinglot = (@idParkingLot) 
		AND occupied = false),
    (SELECT avaiblespace FROM parkinglot WHERE idparkinglot = @idParkingLot));
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
	IN 	parkinglotID int(11)
)
BEGIN
	DECLARE parkinglotName varchar(300) DEFAULT null;
    DECLARE freeSlots int(11) DEFAULT null;
	
    SET parkinglotName:=(SELECT name FROM parkinglot WHERE idparkinglot = parkinglotID);
	
    IF(parkinglotName IS NOT NULL) THEN
		SELECT 
			parkinglotID AS idparkinglot, 
			parkinglotName AS name,
			(SELECT COUNT(*) FROM grid
				WHERE idparkinglot = idparkinglot 
				AND occupied = false) AS freeSlots;
	END IF;
    
	IF(parkinglotName IS NULL) THEN
		SELECT 
			'error' AS error,
            'could not find parkinglot with that id' AS message;
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
	IN 	parkinglotIDIn int(11), 
		slotnameIn varchar(11)
)
BEGIN
	DECLARE parkinglotName varchar(300) DEFAULT null;
    DECLARE gridID int(11) DEFAULT null;
    SET parkinglotName:=(SELECT name FROM parkinglot WHERE idparkinglot = parkinglotIDIn);
    SET gridID:=(SELECT idgrid FROM grid WHERE slotname = slotnameIn AND idparkinglot = parkinglotIDIn);
	
    IF(parkinglotName IS NOT NULL AND gridID IS NOT NULL) THEN
		UPDATE grid SET grid.occupied = NOT grid.occupied 
			WHERE idparkinglot = parkinglotIDIn
			AND slotName=slotNameIn;
            
		SELECT 'success' AS success;
	END IF;
        
	IF(parkinglotName IS NULL) THEN
		SELECT 
			'error' AS error,
            'could not find parkinglot with that id' AS message;
	END IF;
	
    IF(gridID IS NULL) THEN
		SELECT 
			'error' AS error,
            'could not find grid with that name' AS message;
	END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure deleteParkinglot
-- -----------------------------------------------------

USE `parkissa`;
DROP procedure IF EXISTS `parkissa`.`deleteParkinglot`;

DELIMITER $$
USE `parkissa`$$
CREATE PROCEDURE deleteParkinglot (
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

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
