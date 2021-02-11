CREATE DATABASE Foody;
USE Foody;

#Creation des tables
CREATE TABLE Client (
	CodeCli VARCHAR(5) PRIMARY KEY,
    Societe VARCHAR(50),
    Contact VARCHAR(30),
    Fonction VARCHAR(30),
    Address VARCHAR(50),
    Ville VARCHAR(20),
    Region VARCHAR(20),
    CodePostal VARCHAR(10),
    Pays VARCHAR(20),
    Tel VARCHAR(20),
    Fax VARCHAR(20));

CREATE TABLE Messager (
	NoMess INT AUTO_INCREMENT PRIMARY KEY,
    NomMess VARCHAR(20),
    Tel VARCHAR(20));
    
CREATE TABLE Fournisseur (
	NoFour INT AUTO_INCREMENT PRIMARY KEY,
    Societe VARCHAR(50),
    Contact VARCHAR(30),
    Fonction VARCHAR(30),
    Address VARCHAR(50),
    Ville VARCHAR(20),
    Region VARCHAR(20),
    CodePostal VARCHAR(10),
    Pays VARCHAR(20),
    Tel VARCHAR(20),
    Fax VARCHAR(20),
    PageAccueil VARCHAR(100));

CREATE TABLE Categorie (
	CodeCateg INT AUTO_INCREMENT PRIMARY KEY,
    NomCateg VARCHAR(25),
    Description VARCHAR(150));

CREATE TABLE Employe (
	NoEmp INT AUTO_INCREMENT PRIMARY KEY,
    Nom VARCHAR(15), 
    Prenom VARCHAR(15),
    Fonction VARCHAR(30),
    TitreCourtoisie VARCHAR(4),
    DateNaissance DATE,
    DateEmbauche DATE,
    Adresse VARCHAR(50),
    Ville VARCHAR(20),
    Region VARCHAR(20),
    CodePostal VARCHAR(10),
    Pays VARCHAR(20),
    TelDom VARCHAR(20),
    Extension INT,
    RendCompteA INT REFERENCES Employe(NoEmp));

CREATE TABLE Produit (
	Refprod INT AUTO_INCREMENT PRIMARY KEY,
    Nomprod VARCHAR(50),
    NoFour INT,
    CodeCateg INT,
    QteParUnit VARCHAR(20),
    PrixUnit FLOAT,
    UnitesStock INT,
    UnitesCom INT,
    NiveauReap INT,
    Indisponible INT,
    FOREIGN KEY (NoFour) REFERENCES Fournisseur(NoFour),
    FOREIGN KEY (CodeCateg) REFERENCES Categorie(CodeCateg));

CREATE TABLE Commande (
	NoCom INT PRIMARY KEY,
    CodeCli VARCHAR(5),
    NoEmp INT,
    DateCom DATE,
    AlivAvant DATE,
    DateEnv DATE,
    NoMess INT,
    Port VARCHAR(10),
    Destinataire VARCHAR(50),
    AdrLiv VARCHAR(50),
    VilleLiv VARCHAR(20),
    RegionLiv VARCHAR(20),
    CodePostalLiv VARCHAR(10),
    PaysLiv VARCHAR(20),
    FOREIGN KEY (CodeCli) REFERENCES Client(CodeCli),
    FOREIGN KEY (NoEmp) REFERENCES Employe(NoEmp),
    FOREIGN KEY (NoMess) REFERENCES Messager(NoMess));
    
CREATE TABLE DetailCommande (
	NoCom INT,
    RefProd INT,
    PrixUnit FLOAT,
    Qte INT,
    Remise  FLOAT,
    FOREIGN KEY (NoCom) REFERENCES Commande(NoCom),
    FOREIGN KEY (RefProd) REFERENCES Produit(Refprod),
    PRIMARY KEY(NoCom,RefProd));

#Changement de value en default de variable local_infile pour accepter lire les fichier local
SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1; #1=ON,0=OFF
SHOW GLOBAL VARIABLES LIKE 'local_infile';

#Insertion des données
LOAD DATA LOCAL INFILE 'C:/Users/gneis/Dropbox/Simplon/BDD/Projet_Foody/data_foody/messager.csv' 
INTO TABLE Messager 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/gneis/Dropbox/Simplon/BDD/Projet_Foody/data_foody/categorie.csv' 
INTO TABLE Categorie 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/gneis/Dropbox/Simplon/BDD/Projet_Foody/data_foody/client.csv' 
INTO TABLE Client 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/gneis/Dropbox/Simplon/BDD/Projet_Foody/data_foody/fournisseur.csv' 
INTO TABLE Fournisseur 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/gneis/Dropbox/Simplon/BDD/Projet_Foody/data_foody/employe.csv' 
INTO TABLE Employe 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/gneis/Dropbox/Simplon/BDD/Projet_Foody/data_foody/produit.csv' 
INTO TABLE Produit 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/gneis/Dropbox/Simplon/BDD/Projet_Foody/data_foody/commande.csv' 
INTO TABLE Commande 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/gneis/Dropbox/Simplon/BDD/Projet_Foody/data_foody/detailsCommande.csv' 
INTO TABLE DetailCommande 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;