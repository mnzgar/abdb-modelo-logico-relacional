-- MySQL Script generated by MySQL Workbench
-- Sun Nov 22 20:37:22 2020
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema vivero
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema vivero
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `vivero` DEFAULT CHARACTER SET utf8 ;
USE `vivero` ;

-- -----------------------------------------------------
-- Table `vivero`.`VIVERO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vivero`.`VIVERO` (
  `nombre` VARCHAR(45) NOT NULL,
  `ubicacion` VARCHAR(45) NOT NULL,
  `hora_apertura` VARCHAR(45) NULL,
  `hora_cierre` VARCHAR(45) NULL,
  PRIMARY KEY (`nombre`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vivero`.`ZONAS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vivero`.`ZONAS` (
  `nombre` VARCHAR(45) NOT NULL,
  `vivero` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`nombre`, `vivero`),
  INDEX `fk_zonas_vivero_idx` (`vivero` ASC),
  CONSTRAINT `fk_zonas_vivero`
    FOREIGN KEY (`vivero`)
    REFERENCES `vivero`.`VIVERO` (`nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vivero`.`PRODUCTO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vivero`.`PRODUCTO` (
  `codigo_barras` VARCHAR(45) NOT NULL,
  `nombre` VARCHAR(45) NULL,
  `stock` INT NULL,
  `tipo` VARCHAR(45) NULL,
  `caducidad` DATETIME NULL,
  `precio` DECIMAL NULL,
  PRIMARY KEY (`codigo_barras`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vivero`.`EMPLEADO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vivero`.`EMPLEADO` (
  `dni` VARCHAR(45) NOT NULL,
  `css` VARCHAR(45) NOT NULL,
  `nombre` VARCHAR(45) NULL,
  `apellidos` VARCHAR(45) NULL,
  `tipo_contrato` VARCHAR(45) NULL,
  PRIMARY KEY (`dni`),
  UNIQUE INDEX `css_UNIQUE` (`css` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vivero`.`CLIENTE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vivero`.`CLIENTE` (
  `dni` VARCHAR(45) NOT NULL,
  `codigo_fidelizacion` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `numero_tarjeta` VARCHAR(45) NULL,
  `bonificacion` DECIMAL NULL,
  `gasto_mensual` DECIMAL NULL,
  `dominio` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NULL,
  PRIMARY KEY (`dni`),
  UNIQUE INDEX `codigo_fidelizacion_UNIQUE` (`codigo_fidelizacion` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vivero`.`PEDIDO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vivero`.`PEDIDO` (
  `codigo_pedido` INT NOT NULL,
  `fecha` DATETIME NULL,
  `precio` DECIMAL NULL,
  `empleado` VARCHAR(45) NOT NULL,
  `cliente` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codigo_pedido`),
  INDEX `fk_pedido_empleado_idx` (`empleado` ASC),
  INDEX `fk_pedido_cliente_idx` (`cliente` ASC),
  CONSTRAINT `fk_pedido_empleado`
    FOREIGN KEY (`empleado`)
    REFERENCES `vivero`.`EMPLEADO` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pedido_cliente`
    FOREIGN KEY (`cliente`)
    REFERENCES `vivero`.`CLIENTE` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vivero`.`ZONAS_PRODUCTO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vivero`.`ZONAS_PRODUCTO` (
  `zona` VARCHAR(45) NOT NULL,
  `vivero` VARCHAR(45) NOT NULL,
  `codigo_barras` VARCHAR(45) NOT NULL,
  `stock` INT NULL,
  PRIMARY KEY (`zona`, `vivero`, `codigo_barras`),
  INDEX `fk_zonas_producto_producto_idx` (`codigo_barras` ASC),
  CONSTRAINT `fk_zonas_producto_zonas`
    FOREIGN KEY (`zona` , `vivero`)
    REFERENCES `vivero`.`ZONAS` (`nombre` , `vivero`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_zonas_producto_producto`
    FOREIGN KEY (`codigo_barras`)
    REFERENCES `vivero`.`PRODUCTO` (`codigo_barras`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vivero`.`PRODUCTO_PEDIDO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vivero`.`PRODUCTO_PEDIDO` (
  `codigo_barras` VARCHAR(45) NOT NULL,
  `codigo_pedido` INT NOT NULL,
  `cantidad` INT NULL,
  PRIMARY KEY (`codigo_barras`, `codigo_pedido`),
  INDEX `fk_producto_pedido_pedido_idx` (`codigo_pedido` ASC),
  CONSTRAINT `fk_producto_pedido_producto`
    FOREIGN KEY (`codigo_barras`)
    REFERENCES `vivero`.`PRODUCTO` (`codigo_barras`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_producto_pedido_pedido`
    FOREIGN KEY (`codigo_pedido`)
    REFERENCES `vivero`.`PEDIDO` (`codigo_pedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vivero`.`ZONAS_EMPLEADO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vivero`.`ZONAS_EMPLEADO` (
  `zona` VARCHAR(45) NOT NULL,
  `vivero` VARCHAR(45) NOT NULL,
  `empleado` VARCHAR(45) NOT NULL,
  `fecha_inicio` DATETIME NULL,
  `fecha_fin` DATETIME NULL,
  PRIMARY KEY (`zona`, `vivero`, `empleado`),
  INDEX `fk_zonas_empleado_empleado_idx` (`empleado` ASC),
  CONSTRAINT `fk_zonas_empleado_zonas`
    FOREIGN KEY (`zona` , `vivero`)
    REFERENCES `vivero`.`ZONAS` (`nombre` , `vivero`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_zonas_empleado_empleado`
    FOREIGN KEY (`empleado`)
    REFERENCES `vivero`.`EMPLEADO` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `vivero` ;

-- -----------------------------------------------------
-- procedure crear_email
-- -----------------------------------------------------

DELIMITER $$
USE `vivero`$$
CREATE PROCEDURE `crear_email` (IN nombre VARCHAR(45), IN dominio VARCHAR(45), OUT email VARCHAR(45))
BEGIN
	SELECT CONCAT(nombre, '@', dominio) INTO email;
END$$

DELIMITER ;
USE `vivero`;

DELIMITER $$
USE `vivero`$$
CREATE DEFINER = CURRENT_USER TRIGGER `vivero`.`crear_email_before_insert` BEFORE INSERT ON `CLIENTE` FOR EACH ROW
BEGIN
  IF NEW.email IS NULL THEN
    CALL crear_email(NEW.nombre, NEW.dominio, @email);
    SET NEW.email = @email;
  END IF;
  END$$

USE `vivero`$$
CREATE DEFINER = CURRENT_USER TRIGGER `vivero`.`actualizar_stock_after_insert` AFTER INSERT ON `PRODUCTO_PEDIDO` FOR EACH ROW
BEGIN
	UPDATE PRODUCTO SET stock = stock - NEW.cantidad
	WHERE codigo_barras = NEW.codigo_barras;
    UPDATE ZONAS_PRODUCTO SET stock = stock - NEW.cantidad
	WHERE codigo_barras = NEW.codigo_barras;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `vivero`.`VIVERO`
-- -----------------------------------------------------
START TRANSACTION;
USE `vivero`;
INSERT INTO `vivero`.`VIVERO` (`nombre`, `ubicacion`, `hora_apertura`, `hora_cierre`) VALUES ('La Orotava', 'Tenerife', '8:00', '20:00');
INSERT INTO `vivero`.`VIVERO` (`nombre`, `ubicacion`, `hora_apertura`, `hora_cierre`) VALUES ('Tacoronte', 'Tenerife', '10:00', '18:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `vivero`.`ZONAS`
-- -----------------------------------------------------
START TRANSACTION;
USE `vivero`;
INSERT INTO `vivero`.`ZONAS` (`nombre`, `vivero`) VALUES ('Rosales', 'La Orotava');
INSERT INTO `vivero`.`ZONAS` (`nombre`, `vivero`) VALUES ('Caja', 'La Orotava');

COMMIT;


-- -----------------------------------------------------
-- Data for table `vivero`.`PRODUCTO`
-- -----------------------------------------------------
START TRANSACTION;
USE `vivero`;
INSERT INTO `vivero`.`PRODUCTO` (`codigo_barras`, `nombre`, `stock`, `tipo`, `caducidad`, `precio`) VALUES ('478A39201748', 'Margarita', 200, 'Planta', NULL, 15.99);
INSERT INTO `vivero`.`PRODUCTO` (`codigo_barras`, `nombre`, `stock`, `tipo`, `caducidad`, `precio`) VALUES ('84979801V423', 'Rosa', 500, 'Planta', NULL, 20);

COMMIT;


-- -----------------------------------------------------
-- Data for table `vivero`.`EMPLEADO`
-- -----------------------------------------------------
START TRANSACTION;
USE `vivero`;
INSERT INTO `vivero`.`EMPLEADO` (`dni`, `css`, `nombre`, `apellidos`, `tipo_contrato`) VALUES ('33333333C', 'jm3333', 'Juan', 'Marrero', 'Temporal');
INSERT INTO `vivero`.`EMPLEADO` (`dni`, `css`, `nombre`, `apellidos`, `tipo_contrato`) VALUES ('44444444D', 'sv4444', 'Sofia', 'Verde', 'Fijo');

COMMIT;


-- -----------------------------------------------------
-- Data for table `vivero`.`CLIENTE`
-- -----------------------------------------------------
START TRANSACTION;
USE `vivero`;
INSERT INTO `vivero`.`CLIENTE` (`dni`, `codigo_fidelizacion`, `nombre`, `numero_tarjeta`, `bonificacion`, `gasto_mensual`, `dominio`, `email`) VALUES ('11111111A', 1111, 'Jose', '1234', NULL, 12.3, 'yahoo.com', NULL);
INSERT INTO `vivero`.`CLIENTE` (`dni`, `codigo_fidelizacion`, `nombre`, `numero_tarjeta`, `bonificacion`, `gasto_mensual`, `dominio`, `email`) VALUES ('22222222B', 2222, 'Maria', '2345', 12, 100, 'ull.es', NULL);
INSERT INTO `vivero`.`CLIENTE` (`dni`, `codigo_fidelizacion`, `nombre`, `numero_tarjeta`, `bonificacion`, `gasto_mensual`, `dominio`, `email`) VALUES ('66666666E', 6666, 'Pablo', '6789', NULL, NULL, 'google.com', 'pablito123@google.com');

COMMIT;


-- -----------------------------------------------------
-- Data for table `vivero`.`PEDIDO`
-- -----------------------------------------------------
START TRANSACTION;
USE `vivero`;
INSERT INTO `vivero`.`PEDIDO` (`codigo_pedido`, `fecha`, `precio`, `empleado`, `cliente`) VALUES (7854390, '2020/10/12', 30, '44444444D', '11111111A');

COMMIT;


-- -----------------------------------------------------
-- Data for table `vivero`.`ZONAS_PRODUCTO`
-- -----------------------------------------------------
START TRANSACTION;
USE `vivero`;
INSERT INTO `vivero`.`ZONAS_PRODUCTO` (`zona`, `vivero`, `codigo_barras`, `stock`) VALUES ('Rosales', 'La Orotava', '478A39201748', 200);

COMMIT;

