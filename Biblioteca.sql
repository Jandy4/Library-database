-- MySQL Script generated by MySQL Workbench
-- Sat Oct 26 16:42:37 2019
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Editura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Editura` (
  `id_Editura` INT NOT NULL,
  `Nume` VARCHAR(45) NULL,
  PRIMARY KEY (`id_Editura`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Categorie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Categorie` (
  `id_Categorie` INT NOT NULL,
  `Categorie` VARCHAR(45) NULL,
  PRIMARY KEY (`id_Categorie`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Carte`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Carte` (
  `cota` INT NOT NULL,
  `Titlu` VARCHAR(30) NOT NULL,
  `Pret` FLOAT NULL,
  `An` INT NULL,
  `Pierduta` BINARY(1) NULL,
  `Editura_id_Editura` INT NOT NULL,
  `Categorie_id_Categorie` INT NOT NULL,
  PRIMARY KEY (`cota`),
  INDEX `fk_Carte_Editura1_idx` (`Editura_id_Editura` ASC) VISIBLE,
  INDEX `fk_Carte_Categorie1_idx` (`Categorie_id_Categorie` ASC) VISIBLE,
  CONSTRAINT `fk_Carte_Editura1`
    FOREIGN KEY (`Editura_id_Editura`)
    REFERENCES `mydb`.`Editura` (`id_Editura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Carte_Categorie1`
    FOREIGN KEY (`Categorie_id_Categorie`)
    REFERENCES `mydb`.`Categorie` (`id_Categorie`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Autor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Autor` (
  `id_Autor` INT NOT NULL,
  `Nume` VARCHAR(45) NOT NULL,
  `Prenume` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_Autor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Autor_carte`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Autor_carte` (
  `id_Autor` INT NOT NULL,
  `cota` INT NOT NULL,
  `Pozitie_autor` INT NOT NULL,
  PRIMARY KEY (`id_Autor`, `cota`),
  INDEX `fk_Autor_carte_Autor1_idx` (`id_Autor` ASC) VISIBLE,
  INDEX `fk_Autor_carte_Carte1_idx` (`cota` ASC) VISIBLE,
  CONSTRAINT `fk_Autor_carte_Autor1`
    FOREIGN KEY (`id_Autor`)
    REFERENCES `mydb`.`Autor` (`id_Autor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Autor_carte_Carte1`
    FOREIGN KEY (`cota`)
    REFERENCES `mydb`.`Carte` (`cota`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Elev`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Elev` (
  `id_Elev` INT NOT NULL,
  `Nume` VARCHAR(45) NOT NULL,
  `Prenume` VARCHAR(45) NOT NULL,
  `Clasa` VARCHAR(45) NOT NULL,
  `Numar_Telefon` VARCHAR(15) NOT NULL,
  `E-mail` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_Elev`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Inchiriere`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Inchiriere` (
  `id_Inchiriere` INT NOT NULL,
  `Data_Inchiriere` DATE NOT NULL,
  `Nr_Carti_Inchiriate` INT NOT NULL,
  `Elev_id_Elev` INT NOT NULL,
  PRIMARY KEY (`id_Inchiriere`),
  INDEX `fk_Inchiriere_Elev1_idx` (`Elev_id_Elev` ASC) VISIBLE,
  CONSTRAINT `fk_Inchiriere_Elev1`
    FOREIGN KEY (`Elev_id_Elev`)
    REFERENCES `mydb`.`Elev` (`id_Elev`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Carte_Inchiriata`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Carte_Inchiriata` (
  `Carte_cota` INT NOT NULL,
  `Inchiriere_id_Inchiriere` INT NOT NULL,
  `Returnata` BINARY(1) NULL,
  PRIMARY KEY (`Carte_cota`, `Inchiriere_id_Inchiriere`),
  INDEX `fk_Carte_Inchiriata_Carte1_idx` (`Carte_cota` ASC) VISIBLE,
  INDEX `fk_Carte_Inchiriata_Inchiriere1_idx` (`Inchiriere_id_Inchiriere` ASC) VISIBLE,
  CONSTRAINT `fk_Carte_Inchiriata_Carte1`
    FOREIGN KEY (`Carte_cota`)
    REFERENCES `mydb`.`Carte` (`cota`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Carte_Inchiriata_Inchiriere1`
    FOREIGN KEY (`Inchiriere_id_Inchiriere`)
    REFERENCES `mydb`.`Inchiriere` (`id_Inchiriere`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;