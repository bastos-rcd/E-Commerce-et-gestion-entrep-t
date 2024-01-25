DROP TABLE IF EXISTS DetailsCommande;
DROP TABLE IF EXISTS Avis;
DROP TABLE IF EXISTS Commande;
DROP TABLE IF EXISTS Panier;
DROP TABLE IF EXISTS Carte;
DROP TABLE IF EXISTS Information;
DROP TABLE IF EXISTS SousCategorie;
DROP TABLE IF EXISTS Categorie;
DROP TABLE IF EXISTS Stock;
DROP TABLE IF EXISTS ProduitCompose;
DROP TABLE IF EXISTS Produit;
DROP TABLE IF EXISTS Utilisateur;

CREATE TABLE Utilisateur (
	idUtilisateur mediumint(5) auto_increment,
	nom varchar(20),
	email varchar(100),
	password varchar(64),
	role varchar(6),
	CONSTRAINT pk_utilisateur PRIMARY KEY (idUtilisateur)
);

CREATE TABLE Produit (
	idProduit mediumint(5) auto_increment,
	nom varchar(20),
	prix decimal(6,2),
	solde decimal(3,2),
	description varchar(500),
	note decimal(3,2),
	dateAjout date,
	CONSTRAINT pk_produit PRIMARY KEY (idProduit)
);

CREATE TABLE ProduitCompose (
	idCompose mediumint(5) auto_increment,
	idProduit mediumint(5),
	CONSTRAINT pk_produitCompose PRIMARY KEY (idCompose, idProduit),
	CONSTRAINT fk_produitCompose_idProdruit FOREIGN KEY (idProduit) REFERENCES Produit(idProduit)
);

CREATE TABLE Stock (
	idProduit mediumint(5),
	couleur varchar(10),
	etat varchar (13),
	prixEtat decimal (5,2),
	quantiteStock mediumint(8),
	seuilStock tinyint(3),
	CONSTRAINT pk_stock PRIMARY KEY (idProduit, couleur, etat),
	CONSTRAINT fk_stock_idProduit FOREIGN KEY (idProduit) REFERENCES Produit(idProduit),
	CONSTRAINT ck_stock_etat CHECK (etat='Bon état' or etat='Très bon état' or etat='Parfait état')
);

CREATE TABLE Categorie (
	idCategorie mediumint(5) auto_increment,
	nom varchar(20),
	CONSTRAINT pk_categorie PRIMARY KEY (idCategorie)
);

CREATE TABLE SousCategorie (
	idSousCategorie mediumint(5) auto_increment,
	nom varchar(20),
	idCategorie mediumint(5),
	idProduit mediumint(5),
	CONSTRAINT pk_sousCategorie PRIMARY KEY (idSousCategorie),
	CONSTRAINT fk_sousCategorie_idCategorie FOREIGN KEY (idCategorie) REFERENCES Categorie(idCategorie),
	CONSTRAINT fk_sousCategorie_idProduit FOREIGN KEY (idProduit) REFERENCES Produit(idProduit)
);

CREATE TABLE Information (
	idUtilisateur mediumint(5),
	genre varchar(3),
	adrNum varchar (5),
	adresse varchar (30),
	adrVille varchar(15),
	adrCodePostale varchar(5),
	telephone varchar(10),
	fidelite mediumint(5),
	CONSTRAINT pk_information PRIMARY KEY (idUtilisateur),
	CONSTRAINT fk_information_idUtilisateur FOREIGN KEY (idUtilisateur) REFERENCES Utilisateur(idUtilisateur),
	CONSTRAINT ck_information_genre CHECK (genre='Mr' or genre='Mme')
);

CREATE TABLE Carte (
	idUtilisateur mediumint(5),
	numero varchar(16),
	crypto varchar(3),
	CONSTRAINT pk_carte PRIMARY KEY (idUtilisateur),
	CONSTRAINT fk_carte_idUtilisateur FOREIGN KEY (idUtilisateur) REFERENCES Utilisateur(idUtilisateur)
);

CREATE TABLE Panier (
	idUtilisateur mediumint(5),
	idProduit mediumint(5),
	quantite mediumint(3),
	couleur varchar (10),
	etat varchar (13),
	CONSTRAINT pk_panier PRIMARY KEY (idUtilisateur, idProduit),
	CONSTRAINT fk_panier_idUtilisateur FOREIGN KEY (idUtilisateur) REFERENCES Utilisateur(idUtilisateur),
	CONSTRAINT fk_panier_idProduit FOREIGN KEY (idProduit) REFERENCES Produit(idProduit),
	CONSTRAINT ck_panier_etat CHECK (etat='Bon état' or etat='Très bon état' or etat='Parfait état')
);

CREATE TABLE Commande (
	idCommande mediumint (5) auto_increment,
	idUtilisateur mediumint (5),
	montant decimal (6,2),
	dateCommande date ,
	modePaiement varchar (6),
	adrNumLivraison varchar (5),
	adrLivraison varchar (30),
	villeLivraison varchar(15),
	codePostaleLivraison varchar(5),
	CONSTRAINT pk_commande PRIMARY KEY (idCommande),
	CONSTRAINT fk_commande_idUtilisateur FOREIGN KEY (idUtilisateur) REFERENCES Utilisateur(idUtilisateur),
	CONSTRAINT ck_commande_modePaiement CHECK (modePaiement='PayPal' or modePaiement='Carte')
);

CREATE TABLE Avis (
	idUtilisateur mediumint(5),
	idProduit mediumint(5),
	note decimal(3,2),
	avis varchar (300),
	reponse varchar(300),
	CONSTRAINT pk_avis PRIMARY KEY (idUtilisateur, idProduit),
	CONSTRAINT fk_avis_idProduit FOREIGN KEY (idProduit) REFERENCES Produit(idProduit),
	CONSTRAINT fk_avis_idUtilisateur FOREIGN KEY (idUtilisateur) REFERENCES Utilisateur(idUtilisateur)
);

CREATE TABLE DetailsCommande (
	idCommande mediumint(5),
	idProduit mediumint(5),
	quantite mediumint(3),
	couleur varchar (10),
	etat varchar(13),
	CONSTRAINT pk_detailsCommande PRIMARY KEY (idCommande, idProduit),
	CONSTRAINT fk_detailsCommande_idProduit FOREIGN KEY (idProduit) REFERENCES Produit(idProduit),
	CONSTRAINT fk_detailsCommande_idCommande FOREIGN KEY (idCommande) REFERENCES Commande(idCommande),
	CONSTRAINT ck_detailsCommande_etat CHECK (etat='Bon état' or etat='Très bon état' or etat='Parfait état')
);