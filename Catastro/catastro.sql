-- MySQL Script generated by MySQL Workbench
-- Sun Nov 22 23:32:57 2020
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema catastro
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema catastro
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `catastro` DEFAULT CHARACTER SET utf8 ;
USE `catastro` ;

-- -----------------------------------------------------
-- Table `catastro`.`ZONA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catastro`.`ZONA` (
  `nombre` VARCHAR(45) NOT NULL,
  `area` DECIMAL NULL,
  `concejal` VARCHAR(45) NULL,
  PRIMARY KEY (`nombre`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `catastro`.`CALLE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catastro`.`CALLE` (
  `nombre` VARCHAR(45) NOT NULL,
  `longitud` DECIMAL NULL,
  `tipo` VARCHAR(45) NULL,
  `cantidad_carriles` INT NULL,
  `zona` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`nombre`),
  INDEX `fk_calle_zona_idx` (`zona` ASC),
  CONSTRAINT `fk_calle_zona`
    FOREIGN KEY (`zona`)
    REFERENCES `catastro`.`ZONA` (`nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `catastro`.`CONSTRUCCION`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catastro`.`CONSTRUCCION` (
  `numero` INT NOT NULL,
  `superficie` DECIMAL NULL,
  `año_construccion` INT NULL,
  `calle` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`numero`, `calle`),
  INDEX `fk_construccion_calle_idx` (`calle` ASC),
  CONSTRAINT `fk_construccion_calle`
    FOREIGN KEY (`calle`)
    REFERENCES `catastro`.`CALLE` (`nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `catastro`.`BLOQUE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catastro`.`BLOQUE` (
  `superficie` DECIMAL NULL,
  `numero` INT NOT NULL,
  `calle` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`numero`, `calle`),
  CONSTRAINT `fk_bloque_construccion`
    FOREIGN KEY (`numero` , `calle`)
    REFERENCES `catastro`.`CONSTRUCCION` (`numero` , `calle`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `catastro`.`PISO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catastro`.`PISO` (
  `planta` INT NOT NULL,
  `letra` VARCHAR(45) NOT NULL,
  `numero_habitantes` INT NULL,
  `superficie` DECIMAL NULL,
  `numero` INT NOT NULL,
  `calle` VARCHAR(45) NOT NULL,
  `dueño` VARCHAR(45) NULL,
  PRIMARY KEY (`planta`, `letra`, `numero`, `calle`),
  INDEX `fk_piso_bloque_idx` (`numero` ASC, `calle` ASC),
  INDEX `fk_piso_persona_idx` (`dueño` ASC),
  CONSTRAINT `fk_piso_bloque`
    FOREIGN KEY (`numero` , `calle`)
    REFERENCES `catastro`.`BLOQUE` (`numero` , `calle`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_piso_persona`
    FOREIGN KEY (`dueño`)
    REFERENCES `catastro`.`PERSONA` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `catastro`.`PERSONA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catastro`.`PERSONA` (
  `dni` VARCHAR(45) NOT NULL,
  `nombre` VARCHAR(45) NULL,
  `fecha_nacimiento` VARCHAR(45) NULL,
  `nivel_estudios` VARCHAR(45) NULL,
  `cabeza_familia` VARCHAR(45) NOT NULL,
  `unifamiliar_numero` INT NULL,
  `unifamiliar_calle` VARCHAR(45) NULL,
  `piso_planta` INT NULL,
  `piso_letra` VARCHAR(45) NULL,
  `piso_numero` INT NULL,
  `piso_calle` VARCHAR(45) NULL,
  PRIMARY KEY (`dni`),
  INDEX `fk_persona_persona_idx` (`cabeza_familia` ASC),
  INDEX `fk_persona_unifamiliar_idx` (`unifamiliar_numero` ASC, `unifamiliar_calle` ASC),
  INDEX `fk_persona_piso_idx` (`piso_planta` ASC, `piso_letra` ASC, `piso_numero` ASC, `piso_calle` ASC),
  CONSTRAINT `fk_persona_persona`
    FOREIGN KEY (`cabeza_familia`)
    REFERENCES `catastro`.`PERSONA` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_persona_unifamiliar`
    FOREIGN KEY (`unifamiliar_numero` , `unifamiliar_calle`)
    REFERENCES `catastro`.`UNIFAMILIAR` (`numero` , `calle`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_persona_piso`
    FOREIGN KEY (`piso_planta` , `piso_letra` , `piso_numero` , `piso_calle`)
    REFERENCES `catastro`.`PISO` (`planta` , `letra` , `numero` , `calle`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `catastro`.`UNIFAMILIAR`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catastro`.`UNIFAMILIAR` (
  `numero_habitantes` INT NULL,
  `superficie` DECIMAL NULL,
  `numero` INT NOT NULL,
  `calle` VARCHAR(45) NOT NULL,
  `dueño` VARCHAR(45) NULL,
  PRIMARY KEY (`numero`, `calle`),
  INDEX `fk_unifamiliar_persona_idx` (`dueño` ASC),
  CONSTRAINT `fk_unifamiliar_construccion`
    FOREIGN KEY (`numero` , `calle`)
    REFERENCES `catastro`.`CONSTRUCCION` (`numero` , `calle`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_unifamiliar_persona`
    FOREIGN KEY (`dueño`)
    REFERENCES `catastro`.`PERSONA` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `catastro`;

DELIMITER $$
USE `catastro`$$
CREATE DEFINER = CURRENT_USER TRIGGER `catastro`.`vivienda_before_insert` BEFORE INSERT ON `PERSONA` FOR EACH ROW
BEGIN
	IF NEW.unifamiliar_calle IS NOT NULL && NEW.piso_calle IS NOT NULL THEN
		SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Una persona no puede vivir en dos viviendas diferentes';
	END IF;
END$$

USE `catastro`$$
CREATE DEFINER = CURRENT_USER TRIGGER `catastro`.`vivienda_before_update` BEFORE UPDATE ON `PERSONA` FOR EACH ROW
BEGIN
	IF NEW.unifamiliar_calle IS NOT NULL && NEW.piso_calle IS NOT NULL THEN
		SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Una persona no puede vivir en dos viviendas diferentes';
	END IF;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `catastro`.`ZONA`
-- -----------------------------------------------------
START TRANSACTION;
USE `catastro`;
INSERT INTO `catastro`.`ZONA` (`nombre`, `area`, `concejal`) VALUES ('La Laguna', 500, NULL);
INSERT INTO `catastro`.`ZONA` (`nombre`, `area`, `concejal`) VALUES ('Santa Cruz', NULL, 'Juanito');

COMMIT;


-- -----------------------------------------------------
-- Data for table `catastro`.`CALLE`
-- -----------------------------------------------------
START TRANSACTION;
USE `catastro`;
INSERT INTO `catastro`.`CALLE` (`nombre`, `longitud`, `tipo`, `cantidad_carriles`, `zona`) VALUES ('Trinidad', 50, 'Avenida', 2, 'La Laguna');
INSERT INTO `catastro`.`CALLE` (`nombre`, `longitud`, `tipo`, `cantidad_carriles`, `zona`) VALUES ('Castillo', NULL, 'Peatonal', NULL, 'Santa Cruz');

COMMIT;


-- -----------------------------------------------------
-- Data for table `catastro`.`CONSTRUCCION`
-- -----------------------------------------------------
START TRANSACTION;
USE `catastro`;
INSERT INTO `catastro`.`CONSTRUCCION` (`numero`, `superficie`, `año_construccion`, `calle`) VALUES (12, 50, 1996, 'Trinidad');
INSERT INTO `catastro`.`CONSTRUCCION` (`numero`, `superficie`, `año_construccion`, `calle`) VALUES (2, 24, 1800, 'Castillo');

COMMIT;


-- -----------------------------------------------------
-- Data for table `catastro`.`BLOQUE`
-- -----------------------------------------------------
START TRANSACTION;
USE `catastro`;
INSERT INTO `catastro`.`BLOQUE` (`superficie`, `numero`, `calle`) VALUES (24, 2, 'Castillo');

COMMIT;


-- -----------------------------------------------------
-- Data for table `catastro`.`PISO`
-- -----------------------------------------------------
START TRANSACTION;
USE `catastro`;
INSERT INTO `catastro`.`PISO` (`planta`, `letra`, `numero_habitantes`, `superficie`, `numero`, `calle`, `dueño`) VALUES (3, 'C', 1, 24, 2, 'Castillo', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `catastro`.`UNIFAMILIAR`
-- -----------------------------------------------------
START TRANSACTION;
USE `catastro`;
INSERT INTO `catastro`.`UNIFAMILIAR` (`numero_habitantes`, `superficie`, `numero`, `calle`, `dueño`) VALUES (3, 50, 12, 'Trinidad', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `catastro`.`PERSONA`
-- -----------------------------------------------------
START TRANSACTION;
USE `catastro`;
INSERT INTO `catastro`.`PERSONA` (`dni`, `nombre`, `fecha_nacimiento`, `nivel_estudios`, `cabeza_familia`, `unifamiliar_numero`, `unifamiliar_calle`, `piso_planta`, `piso_letra`, `piso_numero`, `piso_calle`) VALUES ('11111111A', 'Juanito', '1957/10/1', NULL, '11111111A', 12, 'Trinidad', NULL, NULL, NULL, NULL);
INSERT INTO `catastro`.`PERSONA` (`dni`, `nombre`, `fecha_nacimiento`, `nivel_estudios`, `cabeza_familia`, `unifamiliar_numero`, `unifamiliar_calle`, `piso_planta`, `piso_letra`, `piso_numero`, `piso_calle`) VALUES ('22222222B', 'Mercedes', '1979/3/12', NULL, '22222222B', NULL, NULL, 3, 'C', 2, 'Castillo');
INSERT INTO `catastro`.`PERSONA` (`dni`, `nombre`, `fecha_nacimiento`, `nivel_estudios`, `cabeza_familia`, `unifamiliar_numero`, `unifamiliar_calle`, `piso_planta`, `piso_letra`, `piso_numero`, `piso_calle`) VALUES ('33333333C', 'Ana', '2000/9/11', 'IES', '11111111A', 12, NULL, NULL, NULL, NULL, NULL);

COMMIT;

