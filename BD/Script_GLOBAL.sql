DROP PROCEDURE IF EXISTS AjouterClient;
DROP PROCEDURE IF EXISTS SupprimerClient;
DROP PROCEDURE IF EXISTS ModifierClient;
DROP PROCEDURE IF EXISTS AjouterProduit;
DROP PROCEDURE IF EXISTS AjouterCommande;
DROP TRIGGER IF EXISTS t_d_commande;
DROP TRIGGER IF EXISTS t_i_detailscommande;
DROP TRIGGER IF EXISTS t_d_detailscommande;
DROP TRIGGER IF EXISTS t_i_avis;
DROP TRIGGER IF EXISTS t_d_avis;
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

#-------------------------------
#-----------Création------------
#-------------------------------

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

#-------------------------------
#-----------Insertion-----------
#-------------------------------

INSERT INTO Utilisateur VALUES (NULL, 'Administrateur', 'admin@frontmarket.com', 'b3899dc7114cd6a7ca3e1b5858a0395e553a1c7e6b18c3373610fb6580a0c684', 'admin'); # Admin2023?
INSERT INTO Utilisateur VALUES (NULL, 'Robert François', 'francois.robert@gmail.com', 'e1c50320d988e4d66248db95df5e203763d835dbebea0eb698e98d34f0a881fc', 'client'); # RobFra.2
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '10', 'Chemin des fleurs', 'Toulouse', '31000', '0600000000', 10);
INSERT INTO Carte VALUES (last_insert_id(), '1234567890123454', '123');
INSERT INTO Utilisateur VALUES (NULL, 'John Smith', 'john.smith@hotmail.fr', 'b9f8e9dc1fe55a31f1170851772e203dff455e44c64be1d7bbb8a1b429edbebe', 'client'); # JohSmi.3
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '10', 'Chemin de la forêt', 'Vieux-Moulin', '60350', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Marie Jane', 'marie.jane@gmail.com', 'e4d86f69421e65b8379a84e871ab99c3812f2785623a86b4720c7d7ecb175a53', 'client'); # MarJan.4
INSERT INTO Information VALUES (last_insert_id(), 'Mme', '10', 'Chemin des fleurs', 'Toulouse', '31000', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Antoine Leboucher', 'antoine.leboucher@gmail.com', '08b983fad63f74b9e5b630053a90c2191c667b2c866a4c6f926777d219804461', 'client'); # AntLeb.5
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '10', 'Chemin des fleurs', 'Gourdon', '46300', '0600000000', 0);
INSERT INTO Carte VALUES (last_insert_id(), '5626758783143245', '578');
INSERT INTO Utilisateur VALUES (NULL, 'Jimmy Mauriac', 'jimmy.mauriac@gmail.com', 'd68125b4f034bd536e22b6b202d81e1d0a480ac6dfbc1ac8b757c993cf8c118d', 'client'); # JimMau.5
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '10', 'Chemin des fleurs', 'Toulouse', '31200', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Hugo Berdinel', 'hugo.berdinel@gmail.com', 'c180e13a29d9600ffdf874a9900af107298c3143eb1a3ac3c62f4c13a5aac07e', 'client'); # HugBer.6
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '10', 'Chemin des fleurs', 'Toulouse', '31000', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Étienne Salauze', 'etienne.salauze@gmail.com', 'bfd58a7e4b383ac676bdad05333ab78d8ed1af68d2bbbc481482e2599e039471', 'client'); # EtiSal.7
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '10', 'Chemin des fleurs', 'Blagnac', '31700', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Damien Laboute', 'damien.alboute@gmail.com', '84d70c3598782929ba1ba9910bf87e95d043fb0d5ec13e4260341e07706ec085', 'client'); # DamLab.8
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '10', 'Chemin des fleurs', 'Toulouse', '31000', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Éliot Desportes', 'eliot.desportes@gmail.com', 'b8dc73541bd204976229ac68f162638b63aad1dec0b8e27b6d866622a9176d5c', 'client'); # EliDes.9
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '10', 'Chemin des amoureux', 'Blagnac', '31700', '0600000000', 0);
INSERT INTO Carte VALUES (last_insert_id(), '1209239853255321', '843');
INSERT INTO Utilisateur VALUES (NULL, 'Julie Baelen', 'julie.baelen@gmail.com', '514ff896f117300143ab82d33cf7fb68fa5ff774cffe58f2a56e543cacb86414', 'client'); # JulBae.10
INSERT INTO Information VALUES (last_insert_id(), 'Mme', '10', 'Chemin des amoureux', 'Blagnac', '31700', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Walaedine Sekoub', 'walaedine.sekoub@gmail.com', 'cd891081e38417ea43cd99c110b765aa72ec71d021151e4bda5872a7dd5372f4', 'client'); # WalSek.11
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '10', 'Chemin des développeurs', 'Toulouse', '31500', '0600000000', 0);
INSERT INTO Carte VALUES (last_insert_id(), '5246798656443345', '024');
INSERT INTO Utilisateur VALUES (NULL, 'Guilherme Sampaio', 'guilherme.sampaio@gmail.com', '0f66b5908afc48763e7fd42e05d83920511473c341ba0f419e611c523a4ad36a', 'client'); # GuiSamp.12
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '10', 'Avenue des développeurs', 'Toulouse', '31200', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Bastien Record', 'bastien.record@gmail.com', '4b6b487580f725870669c71b93922b30c5ac2a71ee0c1adf264821b8f7dfe1fa', 'client'); # BasRec.13
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '18', 'Chemin de l''Ayrolle', 'Caraman', '31460', '0643627848', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Anli Mohamed', 'anlie.mohamed@gmail.com', 'd8c91b36bda07113db2fa177ee26e5ec467fa0b2c169f659830dfcd8096c2627', 'client'); # AnlMoh.14
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '10', 'Rue de arènes', 'Toulouse', '31400', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Tom Meyer', 'tom.meyer@gmail.com', 'edcc037de85abc266a416beaccfcd6f2a82cfaa7aae37a3a6e0a47efcad56918', 'client'); # TomMey.15
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '10', 'Chemin des fleurs', 'Sesquières', '31200', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Léna Aini', 'lena.aini@gmail.com', 'd966c0d224085c0fc8e92deacbe6c2fe819e4a839c4a8ae784b9a7b709f1f420', 'client'); # LenAin.16
INSERT INTO Information VALUES (last_insert_id(), 'Mme', '10', 'Avenue de mon coeur', 'Toulouse', '31200', '0600000000', 0);
INSERT INTO Carte VALUES (last_insert_id(), '5456675323456675', '812');
INSERT INTO Utilisateur VALUES (NULL, 'Lola Lovato', 'lola.lovato@gmail.com', '0e5faf53846130df6e79e7a49e9b4d118bf9e067c7358085ca45e311b81358a1', 'client'); # LolLov.17
INSERT INTO Information VALUES (last_insert_id(), 'Mme', '10', 'Chemin des relous', 'Toulouse', '31000', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Marius Taillandier', 'marius.taillandier@gmail.com', 'da85aece4c1651042560a55a0bc5cc58fcb511f734126b4958392042f3b72128', 'client'); # MarTai.18
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '10', 'Rue du Quing', 'Le Cabanial', '31460', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Clarisse Gigo', 'clarisse.gigo@gmail.com', 'ba5cc34c627f24a8f48f7566bc4b834b2f32f6f4f29d777b2173424a114fe36e', 'client'); # ClaGig.19
INSERT INTO Information VALUES (last_insert_id(), 'Mme', '10', 'Chemin des travailleurs', 'Le Faget', '31460', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Enzo Foudi', 'enzo.foudi@gmail.com', 'fe613d3e425cb6863b0b06f553cb3d9db1ac3ba7d9075a8bab09823f25a570d2', 'client'); # EnzFou.20
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '3', 'Rue de la mairie', 'Le Cabanial', '31460', '0600000000', 0);
INSERT INTO Carte VALUES (last_insert_id(), '1234567899776655', '435');
INSERT INTO Utilisateur VALUES (NULL, 'Lorie Tartre', 'lorie.tartre@gmail.com', '2b3339da0b393a1a9cf588396ba0595c4e4675f660dad1cf630e6ea6c7c7faa2', 'client'); # LorTar.21
INSERT INTO Information VALUES (last_insert_id(), 'Mme', '23', 'Chemin du boulot', 'Loubens', '31460', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Sacha Staelens', 'sacha.staelens@gmail.com', 'fb2d9bbd6e293fde77edeef18b39ebbb74a13694ed01b168a0c4da36691b150d', 'client'); # SacSta.22
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '102', 'Chemin des MacDo', 'Castres', '81000', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Léna Konefal', 'lena.konefal@gmail.com', 'afacb5db6d750f907bf2d21b3239b20e2a83120a80d2ce26ef4767e3ae5fc48c', 'client'); # LenKon.23
INSERT INTO Information VALUES (last_insert_id(), 'Mme', '10', 'Chemin des fleurs', 'Puylaurens', '81000', '0600000000', 0);
INSERT INTO Carte VALUES (last_insert_id(), '0909786543345667', '012');
INSERT INTO Utilisateur VALUES (NULL, 'Khélian Cossard', 'khelian.cossard@gmail.com', '011e2ec8e8cd3bb8ca65b0e07a292635a99bc24df39093ff5369a5c3ad02e32e', 'client'); # KheCos.24
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '10', 'Chemin des fleurs', 'Caraman', '31460', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Marine Zaidweber', 'marine.zidweber@gmail.com', 'c9e444e2bed55fd767085368a67d76e2945d234a10a1daf25390dca44ad6b9e0', 'client'); # MarZed.25
INSERT INTO Information VALUES (last_insert_id(), 'Mme', '10', 'Chemin des fleurs', 'Prunet', '31460', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Pierre Alba', 'pierre.alba@gmail.com', '659b067297a167f3c42646b45d31ae5559610fe73251b1b563c94434fa30f259', 'client'); # PieAlb.26
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '10', 'Chemin des fleurs', 'Lampo', '81200', '0600000000', 0);
INSERT INTO Carte VALUES (last_insert_id(), '4343434322334544', '742');
INSERT INTO Utilisateur VALUES (NULL, 'Lee-Ann Martin', 'lee-ann.martin@gmail.com', '969eaa9d4de6352e552697b8991424ac8c84fb8049a3277ae40c5efc5b915896', 'client'); # LeeMar.27
INSERT INTO Information VALUES (last_insert_id(), 'Mme', '23', 'Chemin de la pharmacie', 'Caraman', '31460', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Noa Foudi', 'noa.foudi@gmail.com', '602719e177f51de25820129d71168c4ef225dd5a7c6bc3ef3e0fe611d3550909', 'client'); # NoaFou.28
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '3', 'Rue de la mairie', 'Le Cabanial', '31460', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Mayline Foudi', 'mayline.foudi@gmail.com', 'c87506bdfedfc82dcfc6fae7ce7896a475224eec42d1189c97129434947cbb94', 'client'); # MayFou.29
INSERT INTO Information VALUES (last_insert_id(), 'Mme', '10', 'Chemin des fleurs', 'Caraman', '31460', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Livio Viccinelli', 'livio.viccinelli@gmail.com', 'fb8cf480fb7214cf950a189bc45dbeaa42503d34f5605b82bb5a142b2c3d4b4c', 'client'); # LivVic.30
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '10', 'Chemin des pasteurs', 'Grenade', '31000', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Nicoleta Giusiuc', 'nicoleta.giusiuc@gmail.com', 'db9567f2017bb43cdd853d5a9ae683726b2b3acae11cdce1dfb76c8928fb3590', 'client'); # NicGiu.31
INSERT INTO Information VALUES (last_insert_id(), 'Mme', '10', 'Chemin des fleurs', 'Caraman', '31460', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Lucile Maurel', 'lucile.maurel@gmail.com', '86c3824243f9f49868d63eb646863ad7589ddbb51d97161fe02f80bae3e3fa24', 'client'); # LucMau.32
INSERT INTO Information VALUES (last_insert_id(), 'Mme', '10', 'Chemin des fleurs', 'Toulouse', '31000', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Mona Warin', 'mona.warin@gmail.com', '13d3feaa3796b7845198a550fa89f1688a50149bb6121f2474bb66159ef2461c', 'client'); # MonWar.33
INSERT INTO Information VALUES (last_insert_id(), 'Mme', '10', 'Chemin des potes', 'Toulouse', '31400', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Mathieu Dufourt', 'mathieu.dufourt@gmail.com', 'c8d84e7dfec61deaec059c081bec9490de9622512692b57f91da1a33a0086bc4', 'client'); # MatDuf.34
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '18', 'Lotissement le Pech', 'Le Cabanial', '31460', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Lison Issart', 'lison.issart@gmail.com', '86c545bbfe342a1cf883e3ad4cd10633b1fc665a3b76c02e5378aed238f4473d', 'client'); # LisIss.35
INSERT INTO Information VALUES (last_insert_id(), 'Mme', '10', 'Chemin des fleurs', 'Biarritz', '64200', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Doome Valentin', 'doome.valentin@gmail.com', '92f2849db240cb5d0de5e1bd33642eab1b2572c23f8be3690fb3302bdb51a08c', 'client'); # DooVal.36
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '10', 'Chemin des fleurs', 'Toulouse', '31000', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Amélie Vidal', 'amelie.vidal@gmail.com', '81987442ce247c8d556875be5b4f90a0c63430a5b182dfd7fc1b70a5014b5032', 'client'); # AmeVid.37
INSERT INTO Information VALUES (last_insert_id(), 'Mme', '23', 'Chemin des fleurs', 'Auriac', '31460', '0600000000', 0);
INSERT INTO Carte VALUES (last_insert_id(), '3456543333455654', '943');
INSERT INTO Utilisateur VALUES (NULL, 'Mathéo Katbi', 'matheo.katbi@gmail.com', 'dce6487b40310f768b7befcf8f2fcee3bc5531631d82fc0dbd93fbf13d49fea9', 'client'); # MatKat.38
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '10', 'Chemin des fleurs', 'Toulouse', '31000', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Méline Pivet', 'meline.pivet@gmail.com', '532cc773e222056e615c56a77cff9ebdb6e14d86dcafbc9cccd809c54055fa53', 'client'); # MelPiv.39
INSERT INTO Information VALUES (last_insert_id(), 'Mme', '10', 'Chemin des fleurs', 'Caraman', '31460', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Lola Mazet', 'lola.mazet@gmail.com', '0cf9289d06a2f4fcd41a6c01cb96091f5175960f03386aefa696dbff6bf94e49', 'client'); # LolMaz.40
INSERT INTO Information VALUES (last_insert_id(), 'Mme', '10', 'Chemin des fleurs', 'Bordeaux', '33300', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Marion Fontes', 'marion.fontes@gmail.com', 'bcfab3aa758ee8ddb2f5fd782db67e59634d33e310762675170152e116945bf2', 'client'); # MarFon.41
INSERT INTO Information VALUES (last_insert_id(), 'Mme', '10', 'Chemin des fleurs', 'Albi', '81990', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Marilou Nougue', 'marilou.nougue@gmail.com', 'eea342e2672f754d259242110e07d69fcff27a1770a20a373c1e7e30b4646e16', 'client'); # MarNou.42
INSERT INTO Information VALUES (last_insert_id(), 'Mme', '10', 'Chemin des fleurs', 'Beauville', '75000', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Coline Vidal', 'coline.vidal@gmail.com', '5ffe2ae24162b34f22509652cfe374d2c0db56bd92a48a3d3cd13065073a595f', 'client'); # ColVid.43
INSERT INTO Information VALUES (last_insert_id(), 'Mme', '10', 'Chemin des fleurs', 'Toulouse', '31000', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Gauthier Montagné', 'gauthier.montagne@gmail.com', 'e5e5b66544a987ded4a02493584d2a57793f759ecd4c88a3d81306cd90dab2ad', 'client'); # GauMon.44
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '10', 'Chemin des fleurs', 'Toulouse', '31000', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Noëlie Monjardez', 'noelie.monjardez@gmail.com', 'ac2147a67f004bf80cd032e3d0fd12f329b93979fe139e93a8ef00df8764a73a', 'client'); # NoeMon.45
INSERT INTO Information VALUES (last_insert_id(), 'Mme', '10', 'Chemin des fleurs', 'Revel', '31250', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Alicia Garcia', 'alicie.garcia@gmail.com', '43975227a4f946636dd678e1e2eb54d68c662388ae19532890ecc152a3f51a2a', 'client'); # AliGar.46
INSERT INTO Information VALUES (last_insert_id(), 'Mme', '10', 'Chemin des fleurs', 'Strasbourg', '67000', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Océane Papaix', 'oceane.papaix@gmail.com', '5ff17d32d77efe344c44b89274f6e913339a2b7fc8272346aea5acdcf31619bf', 'client'); # OcePap.47
INSERT INTO Information VALUES (last_insert_id(), 'Mme', '10', 'Chemin des fleurs', 'Toulouse', '31000', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Laurine Da-Silva', 'laurine.da-silva@gmail.com', '8daca23e791d6ff91a387cd0babb56e0f9c87fbabf304e47fde74f18c19bd3da', 'client'); # LauDas.48
INSERT INTO Information VALUES (last_insert_id(), 'Mme', '10', 'Chemin des fleurs', 'Toulouse', '31000', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Julie Mori', 'julie.mori@gmail.com', '7f1eea4e9129b5b4e58ceb3a7a4f220513db6bd3290abbbfe7eaf258b2ee2f75', 'client'); # JulMor.49
INSERT INTO Information VALUES (last_insert_id(), 'Mme', '10', 'Chemin des fleurs', 'Toulouse', '31000', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Stéphane Matala', 'stephane.matale@gmail.com', 'da63471ebf91d744e14ae07f797cd32f96ba9553c68110ab8aa8683fb611d5a3', 'client'); # SteMat.50
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '10', 'Chemin des fleurs', 'Toulouse', '31000', '0600000000', 0);
INSERT INTO Utilisateur VALUES (NULL, 'Rémi Boole', 'remi.boole@gmail.com', '71e486b8a029e9b5318c368c3b4463c5ecf72c9ad2eb7e7ee6e38c18481d7ae7', 'client'); # RemBoo.51
INSERT INTO Information VALUES (last_insert_id(), 'Mr', '10', 'Chemin des fleurs', 'Toulouse', '31000', '0600000000', 0);
INSERT INTO Carte VALUES (last_insert_id(), '7654456765433456', '999');
INSERT INTO Produit VALUES (NULL, 'Iphone 13 128Go', 699, 1, 'Avec l''iPhone 13, Apple propose un smartphone haut de gamme doté d''une autonomie impressionnante. Cela est dû à la présence de la puce A15 Bionic. Elle parvient à combiner de manière optimale puissance et économies d''énergie. Cela signifie que vous pouvez profiter plus longtemps des contenus affichés sur l''impressionnant écran OLED de 5,4 pouces.', NULL, '2021-09-23');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Iphone 14 Pro 256Go', 1219, 1, 'Avec l''iPhone 14 Pro, Apple propose un smartphone haut de gamme doté d''une autonomie impressionnante. Cela est dû à la présence de la puce A16 Bionic. Elle parvient à combiner de manière optimale puissance et économies d''énergie. Cela signifie que vous pouvez profiter plus longtemps des contenus affichés sur l''impressionnant écran OLED de 6,1 pouces.', NULL, '2022-10-01');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Iphone 11 64Go', 499, 1, 'L''iPhone 11 dispose de deux caméras arrière, toutes deux de 12 mégapixels, dont l''une est grand-angle. Grâce à la technologie Night Mode, les photos sont nettes et de grande qualité, même en cas de faible luminosité. La caméra frontale a 12 mégapixels et offre une fonction portrait.', NULL, '2019-09-14');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Iphone 8 32Go', 249, 1, 'L''iPhone 8 est également équipé d''un nouveau gyroscope et d''un nouvel accéléromètre. La réalité augmentée peut être utilisée sur d''autres appareils Apple mais l''iPhone 8 se débrouille mieux que l''iPhone 7 par exemple.', NULL, '2016-10-11');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Galaxy S10 128Go', 399, 1, 'Le Samsung Galaxy S10 est un bon portable Android avec processeur de 2.7GHz Octa-core qui permet d''exécuter des jeux et les applications lourds. Un avantage du Samsung Galaxy S10 est la possibilité d''utiliser deux opérateurs de téléphonie, un appareil Double-Sim avec entrée pour deux cartes SIM.', NULL, '2018-03-23');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Galaxy Note 20 256Go', 611, 1, 'Le Samsung Galaxy Note20 est équipé d''un écran Infinity de 6.7" à résolution Full HD+ de 1080 x 2400 pixels qui vous permet d''allier parfaitement un affichage de qualité exceptionnelle et une faible consommation d''énergie. De plus, la fréquence de rafraichissement de 60 Hz, vous offre une image fluide sans compromis.', NULL, '2020-08-05');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Galaxy A14 64Go', 219, 1, 'Le Samsung Galaxy A14 est un smartphone de 6,6 pouces sorti en janvier 2023. Il est doté de trois capteurs photo à l’arrière de 50, 5 et 2 MP et d’une caméra en façade sous forme de goutte d’eau pour les Selfies de 13 MP. Il fonctionne avec Android 13 et la surcouche One UI 5, embarque le Soc Mediatek Helio G80, dispose de 4 Go de RAM et 64 Go de stockage extensible par carte MicroSD', NULL, '2021-02-22');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Huaweï P30 128Go', 558, 1, 'Le smartphone Huawei P30 Pro est un appareil doté d’un grand écran OLED de 6,47 pouces. Il fonctionne avec EMUI 9 en surcouche d''Android 9 et embarque le processeur Kirin 980 avec 8 Go de mémoire vive et 256 Go de stockage (extensible par NM Card). Sa particularité ? Son quadruple module photo principal (avec capteurs de 40, 20, 8 mégapixels + ToF).', NULL, '2023-06-12');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Huaweï P8 Lite 16Go', 202, 1, 'Le Huawei P8 Lite est un smartphone milieu de gamme au format 5 pouces. Il équipé d''un processeur HiSilicon Kirin 620 cadencé à 1.2 GHz épaulé par 2 Go de RAM. Il dispose d''une capacitié de stockage de 16 Go extensible via une carte microSDXC d''une taille maximum de 128 Go.', NULL, '2017-12-11');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Huaweï P10 Plus 8Go', 145, 1, 'Fonctionnant avec Android 7, le Huawei P10 Plus est un smartphone doté d''un écran QHD de 5,5 pouces. Il se distingue par son système de double capteur photo noir & blanc et couleur (20 et 12 mégapixels)', NULL, '2016-04-11');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Rouge', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Acer Swift 3 512Go', 799.99, 1, 'Un contour d''écran de plus en plus fin. Sûre et Sans faille toute la journée.', NULL, '2022-07-07');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Acer Aspire 5 512Go', 839.66, 1, 'De multiples alternatives couleurs possibleCharnière ergonomique. Confort de frappe. Performance thermique et audio', NULL, '2022-11-30');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Asus Vivobook 512Go', 800, 1, 'Ecran 16 pouces WUXGA (1920 x 1200) - LED - 300 nits. Processeur Intel® Core™ i7-11370H (jusqu''à 4.8GHz) - Puce Intel Iris X? Graphics. Mémoire vive DDR4 12 GB - Stockage 512 GB 3.0 SSD. Windows 11 - Wi-Fi (802.11ac) - Bluetooth 5.1 - 3 mois Xbox Game Pass inclus.', NULL, '2020-12-12');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Asus Zenbook 512Go', 912, 1, 'Un contour d''écran de plus en plus fin. Sûre et Sans faille toute la journée. Ordinateur rapide et réactif', NULL, '2023-01-22');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'HP EliteBook 512Go', 220, 1, 'Intel Core i5-6300U 2,40GHz - Mémoire vive: 16Go DDR4 - Disque SSD: 512Go Système d''exploitation: Microsoft Windows 10 Processeur: IntelCore i5-6300U Mémoire vive (RAM): 16384 Capacité de stockage: SSD: 512 - HDD: Taille d''écran: 14 Chipset graphique: IntelHD Graphics 520', NULL, '2019-12-12');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'PS5 Slim', 687, 1, 'Profitez d''une vitesse de chargement fulgurante grâce à un disque SSD ultra-rapide, d''une immersion plus profonde grâce à la prise en charge du retour haptique, des gâchettes adaptatives et de l''audio 3D, et d''une toute nouvelle génération de jeux PlayStation® incroyables. Vitesse fulgurante. Des jeux époustouflants', NULL, '2023-04-12');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'XBOX Series S', 299, 1, 'Découvrez la toute nouvelle Xbox dernière génération, la plus compacte de tous les temps. 100% Digital - Passez au tout-numérique avec la Xbox série S et profitez d''une console de jeux nouvelle génération sans disque à un prix accessible. 4K HDR - Plongez dans des univers ultra détaillés avec une résolution 1080p HDR.', NULL, '2023-02-27');
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Switch OLED', 249, 1, 'Une nouvelle venue va bientôt rejoindre la gamme Nintendo Switch : la Nintendo Switch (modèle OLED) possède des dimensions proches de celles de la Nintendo Switch mais dispose d’un écran OLED plus grand aux couleurs intenses et aux contrastes élevés', NULL, '2021-10-10');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir/Rouge', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir/Rouge', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir/Rouge', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'TV QLED 139cm', 905.38, 1, 'Découvrez l''innovation QLED accessible à tous. Profitez de l''essentiel des technologies QLED avec des couleurs riches, plus de luminosité et des contrastes plus profonds grâce à la technologie embarquée Dual LED.', NULL, '2022-10-24');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'TV Crystal 108cm', 449, 1, 'Crystal UHD 4K. Une expérience complète. Tous vos divertissements réunis en un seul endroit', NULL, '2019-12-03');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'TV The Xtra', 1099, 1, 'Téléviseur 4K Ambilight. Plongez au coeur de l’action ! La grande image lumineuse et colorée du modèle Xtra et la technologie Ambilight immersive créent des moments privilégiés de visionnage comme de jeu. Ajoutez à cela un son Dolby Atmos riche en atmosphère et vous aurez tout le nécessaire pour une soirée épique à la maison.', NULL, '2023-03-03');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'TV 50', 549.99, 1, 'Téléviseur LED 4K Ambilight. Ultra-net et immersif. L''immersion dans les contenus que vous aimez. Téléviseur Ambilight. Une image nette et éclatante. Image et son cinématographiques. Dolby Vision et Dolby Atmos.', NULL, '2020-05-12');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'AirPods 2', 130, 1, 'Temps de conversation augmenté, activation vocale de Siri et nouveau boîtier de charge sans fil. Les nouveaux AirPods sont des écouteurs sans fil, et sans commune mesure. Retirez-les de leur boîtier et ils fonctionnent tout de suite avec tous vos appareils. Portez-les à vos oreilles et ils se connectent immédiatement pour vous faire profiter d’un son de haute qualité parfaitement détaillé. Plus que géniaux, ils sont magiques.', NULL, '2018-12-29');
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'AirPods Max', 600, 1, 'Voici les AirPods Max. L’accord parfait entre un son haute-fidélité enivrant et la magie intuitive des AirPods. Préparez-vous pour une expérience d’écoute inouïe.', NULL, '2022-06-24');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Vert', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Vert', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Vert', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Buds 2 Pro', 199.99, 1, 'Son HiFi immersif avec double haut-parleurs. Réduction active de bruit optimisée. Technologie Audio 360. Design élégant & ergonomique', NULL, '2021-10-10');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Buds FE', 99, 1, 'Son signature AKG. Réduction active de bruit. 3 micros pour des appels clairs. Autonomie jusqu’à 29 heures', NULL, '2020-03-12');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Tune 508BT', 39, 1, 'Casque supra-auriculaire sans fil - Bluetooth 5.3. Jusqu’à 57 h d’autonomie et charge rapide (5 min = 3 h). Son JBL Pure Bass. Connexion multipoints et appels mains libres', NULL, '2018-12-20');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Tune Flex', 49.99, 1, 'Son Pure Bass JBL. Des haut-parleurs de 12 mm intelligemment conçus, sur tige, délivrent le Son Pure Bass JBL pour que vous ressentiez chaque rythme.', NULL, '2022-09-08');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Flip 6', 120, 1, 'Votre aventure. Votre bande-son. L’audacieuse JBL Flip 6 offre un son JBL Original Pro puissant avec une clarté exceptionnelle grâce à son système de haut-parleur à 2 voies, qui se compose d’un haut-parleur optimisé en forme de circuit de course, d’un haut-parleur haute fréquence séparé et de deux radiateurs de basses.', NULL, '2019-12-09');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Clip 4', 64, 1, 'Malgré la taille compacte de la Clip 4, elle offre un son JBL Pro d’une richesse exceptionnelle ainsi que des basses dynamiques.', NULL, '2017-12-12');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Acton 2', 179.99, 1, 'Acton II est la plus petite enceinte de la gamme Marshall mais ne vous y trompez pas. Dynamique et compacte, elle est dotée de trois amplificateurs de classe D qui alimentent ses deux tweeters et son caisson de basse et produit un son colossal.', NULL, '2015-12-12');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Woburn 2', 299, 1, 'Offrant un son qui rappelle la proximité et la puissance d’un concert, Woburn II est une enceinte conçue avec le plus grand soin pour saisir la tonalité caractéristique de Marshall. La plus grande des enceintes Marshall offre un son robuste, des aigus cristallins, des médiums nets et vivants et gère les basses avec aisance.', NULL, '2017-02-04');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Vivoactive 5', 299, 1, 'Découvrez qui vous êtes avec la montre connectée vívoactive® 5. Le coach ultime toujours disponible à votre poignet pour vous permettre d''atteindre vos objectifs, quels qu''ils soient. Avec son écran ultra-lumineux et son autonomie allant jusqu''à 11 jours, cette montre connectée GPS est conçue avec des fonctions essentielles sport & santé pour vous aider à mieux comprendre votre corps', NULL, '2022-06-17');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Vivosmart 4', 132, 1, 'Élégant et connecté, ce bracelet d''activité allie design tendance et touches métalliques avec un écran ultra-lumineux et facile à lire. Comprend une analyse avancée du sommeil avec phase de sommeil paradoxal. Il est capable de mesurer les niveaux de saturation en oxygène de votre sang pendant la nuit avec l''oxymètre de pouls2 au poignet', NULL, '2019-07-12');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Watch SE', 278, 1, 'Des moyens simples de garder le contact. Des données d’entraînement motivantes. Des fonctionalités de santé et de sécurité innovantes. Et pour la première fois, des associations boîtiers-bracelets neutres en carbone. L''Apple Watch SE offre des fonctionnalités très appréciables, à un prix abordable.', NULL, '2022-09-13');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Watch Ultra', 899, 1, 'La plus robuste et performante des Apple Watch repousse encore les limites. Avec la toute nouvelle SiP S9. Une nouvelle façon d’interagir avec votre montre comme par magie, sans toucher l’écran. L’écran le plus lumineux jamais vu sur un appareil Apple. Et pour la première fois, l’opportunité de choisir une association boîtier-bracelet neutre en carbone.', NULL, '2023-09-23');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'D3200', 438, 1, 'Doté d''un capteur d''image CMOS de 24,2 mégapixels, d''un mode guide le rendant incroyablement simple à utiliser et d''une fonction vidéo Full HD, le D3200 est l''appareil idéal pour aborder le monde du reflex numérique. Son menu Retouche Photo permet de modifier vos images directement sur l''écran de l''appareil.', NULL, '2018-12-18');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'D7500', 1099, 1, 'Puissant, réactif et entièrement connecté, le D7500 hérite de la qualité d''image du très renommé D500, le boîtier DX phare de Nikon. Le D7500 est idéal pour les photographes exigeants, toujours à l’affût d’une prise de vue inédite et souhaitant un appareil photo capable de saisir la beauté telle qu’ils la voient.', NULL, '2023-10-12');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Reflex', 569, 1, 'Avec le Canon Reflex 24,1 millions de pixels, racontez vos histoires avec de superbes photos détaillées et des films Full HD de qualité cinéma, pleins de couleurs, même en conditions de luminosité difficiles. Partagez instantanément et prenez vos photos à distance grâce à la connexion Wi-Fi et à l''application Canon Camera Connect.', NULL, '2020-12-20');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'EOS', 469, 1, 'Avec le Canon EOS 24,1 millions de pixels, racontez vos histoires avec de superbes photos détaillées et des films Full HD de qualité cinéma, pleins de couleurs, même en conditions de luminosité difficiles. Partagez instantanément et prenez vos photos à distance grâce à la connexion Wi-Fi et à l''application Canon Camera Connect.', NULL, '2019-09-09');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Secteur 96W', 75, 1, 'L''adaptateur secteur USB-C 96 W offre une solution de charge rapide et efficace, au bureau, à la maison ou en déplacement.', NULL, '2022-09-09');
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Câble Lightning', 29, 1, 'Câble USB-C vers Lightning pour Apple iPhone/iPad/iPod 1m.', NULL, '2018-09-09');
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Secteur EP', 25, 1, 'Chargeur secteur Samsung', NULL, '2020-12-09');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Câble Induction', 10, 1, 'Rechargez facilement votre smartphone.', NULL, '2018-11-11');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Coque Iphone 13', 10, 1, 'Coque antichoc', NULL, '2019-10-10');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Orange', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Orange', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Orange', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Coque Iphone 11', 6, 1, 'Coque de protection spécialement conçue pour Apple iPhone 11.', NULL, '2019-10-10');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Orange', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Orange', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Orange', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Coque Galaxy S10', 9, 1, 'Coque Magnétique en 2 Parties : une partie arrière en verre trempé transparent et métal de couleur sur le contour , une partie avant avec un verre trempé pour protéger l''écran et du métal pour protéger les contours du smartphone.', NULL, '2019-10-10');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Bleu', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Coque Galaxy A14', 9, 1, 'Housse Etui Portefeuille pour ranger Papiers, Cartes, Billets. Fonction Support afin d''incliner votre Smartphone pour visionner une Vidéo.', NULL, '2019-10-10');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Coque P30', 11, 1, 'Silicone, 2 ans de garantie légale', NULL, '2019-10-10');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Parfait état', 0, 50, 5);
INSERT INTO Produit VALUES (NULL, 'Coque P8', 5, 1, 'Coque en silicone pour Huaweï P8', NULL, '2019-10-10');
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Noir', 'Parfait état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Très bon état', 0, 50, 5);
INSERT INTO Stock VALUES (last_insert_id(), 'Blanc', 'Parfait état', 0, 50, 5);
INSERT INTO ProduitCompose VALUES (NULL, 1);
INSERT INTO ProduitCompose VALUES (last_insert_id(), 42);
INSERT INTO ProduitCompose VALUES (last_insert_id(), 45);
INSERT INTO ProduitCompose VALUES (NULL, 5);
INSERT INTO ProduitCompose VALUES (last_insert_id(), 44);
INSERT INTO ProduitCompose VALUES (last_insert_id(), 47);
INSERT INTO ProduitCompose VALUES (NULL, 2);
INSERT INTO ProduitCompose VALUES (last_insert_id(), 24);
INSERT INTO ProduitCompose VALUES (NULL, 8);
INSERT INTO ProduitCompose VALUES (last_insert_id(), 49);
INSERT INTO ProduitCompose VALUES (NULL, 16);
INSERT INTO ProduitCompose VALUES (last_insert_id(), 21);
INSERT INTO ProduitCompose VALUES (last_insert_id(), 27);
INSERT INTO ProduitCompose VALUES (NULL, 13);
INSERT INTO ProduitCompose VALUES (last_insert_id(), 39);
INSERT INTO Categorie VALUES (NULL, 'Smartphones');
INSERT INTO SousCategorie VALUES (NULL, 'Apple', 1, 1);
INSERT INTO SousCategorie VALUES (NULL, 'Apple', 1, 2);
INSERT INTO SousCategorie VALUES (NULL, 'Apple', 1, 3);
INSERT INTO SousCategorie VALUES (NULL, 'Apple', 1, 4);
INSERT INTO SousCategorie VALUES (NULL, 'Samsung', 1, 5);
INSERT INTO SousCategorie VALUES (NULL, 'Samsung', 1, 6);
INSERT INTO SousCategorie VALUES (NULL, 'Samsung', 1, 7);
INSERT INTO SousCategorie VALUES (NULL, 'Huaweï', 1, 8);
INSERT INTO SousCategorie VALUES (NULL, 'Huaweï', 1, 9);
INSERT INTO SousCategorie VALUES (NULL, 'Huaweï', 1, 10);
INSERT INTO Categorie VALUES (NULL, 'Ordinateurs');
INSERT INTO SousCategorie VALUES (NULL, 'Acer', 2, 11);
INSERT INTO SousCategorie VALUES (NULL, 'Acer', 2, 12);
INSERT INTO SousCategorie VALUES (NULL, 'Asus', 2, 13);
INSERT INTO SousCategorie VALUES (NULL, 'Asus', 2, 14);
INSERT INTO SousCategorie VALUES (NULL, 'HP', 2, 15);
INSERT INTO Categorie VALUES (NULL, 'Consoles');
INSERT INTO SousCategorie VALUES (NULL, 'PlayStation', 3, 16);
INSERT INTO SousCategorie VALUES (NULL, 'Xbox', 3, 17);
INSERT INTO SousCategorie VALUES (NULL, 'Nintendo', 3, 18);
INSERT INTO Categorie VALUES (NULL, 'Télévisions');
INSERT INTO SousCategorie VALUES (NULL, 'Samsung', 4, 19);
INSERT INTO SousCategorie VALUES (NULL, 'Samsung', 4, 20);
INSERT INTO SousCategorie VALUES (NULL, 'Philips', 4, 21);
INSERT INTO SousCategorie VALUES (NULL, 'Philips', 4, 22);
INSERT INTO Categorie VALUES (NULL, 'Écouteurs / Casques');
INSERT INTO SousCategorie VALUES (NULL, 'Apple', 5, 23);
INSERT INTO SousCategorie VALUES (NULL, 'Apple', 5, 24);
INSERT INTO SousCategorie VALUES (NULL, 'Samsung', 5, 25);
INSERT INTO SousCategorie VALUES (NULL, 'Samsung', 5, 26);
INSERT INTO SousCategorie VALUES (NULL, 'JBL', 5, 27);
INSERT INTO SousCategorie VALUES (NULL, 'JBL', 5, 28);
INSERT INTO Categorie VALUES (NULL, 'Enceintes');
INSERT INTO SousCategorie VALUES (NULL, 'JBL', 6, 29);
INSERT INTO SousCategorie VALUES (NULL, 'JBL', 6, 30);
INSERT INTO SousCategorie VALUES (NULL, 'Marshall', 6, 31);
INSERT INTO SousCategorie VALUES (NULL, 'Marshall', 6, 32);
INSERT INTO Categorie VALUES (NULL, 'Montres connectées');
INSERT INTO SousCategorie VALUES (NULL, 'Garmin', 7, 33);
INSERT INTO SousCategorie VALUES (NULL, 'Garmin', 7, 34);
INSERT INTO SousCategorie VALUES (NULL, 'Apple', 7, 35);
INSERT INTO SousCategorie VALUES (NULL, 'Apple', 7, 36);
INSERT INTO Categorie VALUES (NULL, 'Appareils Proto');
INSERT INTO SousCategorie VALUES (NULL, 'Nikon', 8, 37);
INSERT INTO SousCategorie VALUES (NULL, 'Nikon', 8, 38);
INSERT INTO SousCategorie VALUES (NULL, 'Canon', 8, 39);
INSERT INTO SousCategorie VALUES (NULL, 'Canon', 8, 40);
INSERT INTO Categorie VALUES (NULL, 'Chargeurs');
INSERT INTO SousCategorie VALUES (NULL, 'Apple', 9, 41);
INSERT INTO SousCategorie VALUES (NULL, 'Apple', 9, 42);
INSERT INTO SousCategorie VALUES (NULL, 'Samsung', 9, 43);
INSERT INTO SousCategorie VALUES (NULL, 'Samsung', 9, 44);
INSERT INTO Categorie VALUES (NULL, 'Coques');
INSERT INTO SousCategorie VALUES (NULL, 'Apple', 10, 45);
INSERT INTO SousCategorie VALUES (NULL, 'Apple', 10, 46);
INSERT INTO SousCategorie VALUES (NULL, 'Samsung', 10, 47);
INSERT INTO SousCategorie VALUES (NULL, 'Samsung', 10, 48);
INSERT INTO SousCategorie VALUES (NULL, 'Huaweï', 10, 49);
INSERT INTO SousCategorie VALUES (NULL, 'Huaweï', 10, 50);
INSERT INTO Categorie VALUES (NULL, 'Autres');
INSERT INTO Commande VALUES (NULL, 2, 1352, '2023-02-05', 'Carte','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 23, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 50, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 29, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 17, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 8, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 2, 5060, '2023-12-05', 'PayPal','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 1, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 2, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 3, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 4, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 5, 6, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 3, 1454, '2023-02-05', 'Carte','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 43, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 13, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 26, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 35, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 9, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 3, 2641, '2023-12-05', 'PayPal','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 32, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 35, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 36, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 38, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 49, 6, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 4, 2013.66, '2023-02-05', 'Carte','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 26, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 47, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 12, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 39, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 32, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 5, 123.97, '2023-02-05', 'Carte','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 25, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 43, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 26, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 35, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 9, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 6, 4096.96, '2023-02-05', 'Carte', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 1, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 11, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 22, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 37, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 45, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 7, 3491.99, '2023-12-05', 'Paypal', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 44, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 11, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 2, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 7, 6, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 4, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 8, 2341, '2023-02-05', 'Carte', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 3, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 5, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 37, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 9, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 50, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 9, 3509, '2023-12-05', 'Paypal', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 3, 6, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 41, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 23, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 17, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 49, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 9, 1452, '2023-02-05', 'Carte', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 50, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 32, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 35, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 6, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 18, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 10, 2169, '2023-12-05', 'Paypal', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 9, 6, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 10, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 20, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 30, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 33, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 10, 1352.99, '2023-02-05', 'Carte', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 44, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 30, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 22, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 45, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 1, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 11, 1954.99, '2023-02-05', 'Paypal', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 31, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 11, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 26, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 33, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 15, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 12, 850, '2023-02-05', 'Paypal', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 47, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 4, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 23, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 32, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 10, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 13, 1299.66, '2023-02-05', 'Carte', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 48, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 12, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 42, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 50, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 5, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 14, 1352, '2023-02-05', 'Carte','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 23, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 50, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 29, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 17, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 8, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 14, 5060, '2023-12-05', 'PayPal','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 1, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 2, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 3, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 4, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 5, 6, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 15, 4096.96, '2023-02-05', 'Carte', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 1, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 11, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 22, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 37, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 45, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 15, 3491.99, '2023-12-05', 'Paypal', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 44, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 11, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 2, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 7, 6, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 4, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 16, 2341, '2023-02-05', 'Carte', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 3, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 5, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 37, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 9, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 50, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 16, 3509, '2023-12-05', 'Paypal', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 3, 6, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 41, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 23, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 17, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 49, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 17, 1452, '2023-02-05', 'Carte', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 50, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 32, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 35, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 6, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 18, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 18, 2169, '2023-12-05', 'Paypal', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 9, 6, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 10, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 20, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 30, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 33, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 18, 1352.99, '2023-02-05', 'Carte', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 44, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 30, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 22, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 45, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 1, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 19, 1954.99, '2023-02-05', 'Paypal', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 31, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 11, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 26, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 33, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 15, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 19, 850, '2023-02-05', 'Paypal', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 47, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 4, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 23, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 32, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 10, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 20, 1299.66, '2023-02-05', 'Carte', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 48, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 12, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 42, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 50, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 5, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 21, 1352, '2023-02-05', 'Carte','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 23, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 50, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 29, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 17, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 8, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 22, 5060, '2023-12-05', 'PayPal','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 1, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 2, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 3, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 4, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 5, 6, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 22, 1454, '2023-02-05', 'Carte','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 43, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 13, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 26, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 35, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 9, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 23, 2641, '2023-12-05', 'PayPal','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 32, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 35, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 36, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 38, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 49, 6, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 23, 2013.66, '2023-02-05', 'Carte','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 26, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 47, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 12, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 39, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 32, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 24, 123.97, '2023-02-05', 'Carte','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 25, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 43, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 26, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 35, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 9, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 25, 3491.99, '2023-12-05', 'Paypal', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 44, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 11, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 2, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 7, 6, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 4, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 26, 4096.96, '2023-02-05', 'Carte', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 1, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 11, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 22, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 37, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 45, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 26, 3491.99, '2023-12-05', 'Paypal', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 44, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 11, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 2, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 7, 6, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 4, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 27, 2341, '2023-02-05', 'Carte', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 3, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 5, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 37, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 9, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 50, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 27, 3509, '2023-12-05', 'Paypal', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 3, 6, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 41, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 23, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 17, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 49, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 28, 1452, '2023-02-05', 'Carte', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 50, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 32, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 35, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 6, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 18, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 28, 2169, '2023-12-05', 'Paypal', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 9, 6, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 10, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 20, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 30, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 33, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 29, 1352.99, '2023-02-05', 'Carte', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 44, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 30, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 22, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 45, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 1, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 30, 1954.99, '2023-02-05', 'Paypal', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 31, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 11, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 26, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 33, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 15, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 31, 850, '2023-02-05', 'Paypal', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 47, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 4, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 23, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 32, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 10, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 32, 1299.66, '2023-02-05', 'Carte', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 48, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 12, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 42, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 50, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 5, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 33, 1352, '2023-02-05', 'Carte','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 23, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 50, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 29, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 17, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 8, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 33, 5060, '2023-12-05', 'PayPal','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 1, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 2, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 3, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 4, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 5, 6, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 34, 1454, '2023-02-05', 'Carte','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 43, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 13, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 26, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 35, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 9, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 34, 2641, '2023-12-05', 'PayPal','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 32, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 35, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 36, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 38, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 49, 6, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 35, 2013.66, '2023-02-05', 'Carte','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 26, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 47, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 12, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 39, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 32, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 36, 123.97, '2023-02-05', 'Carte','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 25, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 43, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 26, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 35, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 9, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 36, 1352, '2023-02-05', 'Carte','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 23, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 50, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 29, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 17, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 8, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 37, 5060, '2023-12-05', 'PayPal','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 1, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 2, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 3, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 4, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 5, 6, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 37, 1454, '2023-02-05', 'Carte','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 43, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 13, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 26, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 35, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 9, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 38, 2641, '2023-12-05', 'PayPal','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 32, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 35, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 36, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 38, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 49, 6, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 38, 2013.66, '2023-02-05', 'Carte','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 26, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 47, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 12, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 39, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 32, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 39, 123.97, '2023-02-05', 'Carte','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 25, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 43, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 26, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 35, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 9, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 40, 4096.96, '2023-02-05', 'Carte', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 1, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 11, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 22, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 37, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 45, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 40, 3491.99, '2023-12-05', 'Paypal', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 44, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 11, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 2, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 7, 6, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 4, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 41, 2341, '2023-02-05', 'Carte', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 3, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 5, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 37, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 9, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 50, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 41, 3509, '2023-12-05', 'Paypal', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 3, 6, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 41, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 23, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 17, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 49, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 41, 1452, '2023-02-05', 'Carte', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 50, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 32, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 35, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 6, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 18, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 43, 2169, '2023-12-05', 'Paypal', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 9, 6, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 10, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 20, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 30, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 33, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 43, 1352, '2023-02-05', 'Carte','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 23, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 50, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 29, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 17, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 8, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 44, 5060, '2023-12-05', 'PayPal','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 1, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 2, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 3, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 4, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 5, 6, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 45, 1454, '2023-02-05', 'Carte','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 43, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 13, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 26, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 35, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 9, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 46, 2641, '2023-12-05', 'PayPal','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 32, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 35, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 36, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 38, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 49, 6, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 46, 2013.66, '2023-02-05', 'Carte','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 26, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 47, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 12, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 39, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 32, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 47, 123.97, '2023-02-05', 'Carte','30','Chemin de la Livraison','Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 25, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 43, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 26, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 35, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 9, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 48, 4096.96, '2023-02-05', 'Carte', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 1, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 11, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 22, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 37, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 45, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 48, 3491.99, '2023-12-05', 'Paypal', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 44, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 11, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 2, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 7, 6, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 4, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 49, 2341, '2023-02-05', 'Carte', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 3, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 5, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 37, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 9, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 50, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 50, 3509, '2023-12-05', 'Paypal', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 3, 6, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 41, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 23, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 17, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 49, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 50, 1452, '2023-02-05', 'Carte', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 50, 3, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 32, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 35, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 6, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 18, 1, 'Noir', 'Bon état');
INSERT INTO Commande VALUES (NULL, 51, 2169, '2023-12-05', 'Paypal', '29', 'Chemin de la Livraison', 'Toulouse', '31000');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 9, 6, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 10, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 20, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 30, 1, 'Noir', 'Bon état');
INSERT INTO DetailsCommande VALUES (last_insert_id(), 33, 1, 'Noir', 'Bon état');
INSERT INTO Avis VALUES (2, 1, 4.7, 'Pris en noirs, très satisfait pour un Bon état', 'Merci de votre avis.');
INSERT INTO Avis VALUES (3, 2, 3.5, 'Problème de batterie mais satisfait globalement', 'La batterie est du à l''état de l''appareil');
INSERT INTO Avis VALUES (4, 3, 4, 'Pour un ancien téléphone il est en très bon état', 'Merci de votre avis');
INSERT INTO Avis VALUES (6, 4, 3, 'La batterie de tient pas', 'Ratio, c''est un produit en Bon état seulement');
INSERT INTO Avis VALUES (9, 5, 2.2, 'Rayure présente au dos de l''appareil', 'Désolé de cette état nous amélioreront pour les prochain produits');
INSERT INTO Avis VALUES (12, 6, 5, 'Parfait rien à dire', 'Merci de votre avis');
INSERT INTO Avis VALUES (20, 7, 1.1, 'Très mauvais état', 'Désolé');
INSERT INTO Avis VALUES (51, 8, 0, 'Jamais reçus', 'Contactez notre service');
INSERT INTO Avis VALUES (33, 9, 2.5, 'Satisfait', 'Merci de votre avis');
INSERT INTO Avis VALUES (29, 10, 5, 'Parfait j''adore la couleur', 'D''autres magnifiques couleurs sont aussi disponibles');
INSERT INTO Avis VALUES (45, 11, 3, 'Rayures présentent sur les touches', 'Changez les touches');
INSERT INTO Avis VALUES (12, 12, 3.1, 'C''est cool mais chauffe vite', 'Allulmez la clime');
INSERT INTO Avis VALUES (38, 13, 4.1, 'Trop bien', 'Merci de votre avis');
INSERT INTO Avis VALUES (40, 14, 4, 'Prix un peu trop élévé', 'Nous allons y retravailler');
INSERT INTO Avis VALUES (47, 15, 3, 'Horrible', 'Désolé');
INSERT INTO Avis VALUES (17, 16, 2.1, 'la manette est cassé et elle fait beaucoup de bruit', 'Contactez notre service');
INSERT INTO Avis VALUES (36, 17, 3, 'Cool mais pas reçut la manette', 'La manette n''ai pas comprise');
INSERT INTO Avis VALUES (28, 18, 1.9, 'Le joycon bouge tout seul', 'Défaut du à son état mais présent sur les neuves');
INSERT INTO Avis VALUES (44, 19, 2, 'Télécommande cassé', 'Changez les piles');
INSERT INTO Avis VALUES (24, 20, 1, 'Qualité horrible à voir', 'Changez de télévisions');
UPDATE Produit P
SET P.note = ( SELECT A.note
            FROM Avis A
            WHERE A.idProduit = P.idProduit
);
DELIMITER //
CREATE PROCEDURE AjouterClient (	p_nom varchar(20),
									p_mail varchar(100),
									p_password varchar(64),
									p_genre varchar(3),
									p_adrNum varchar(5),
									p_adresse varchar(30),
									p_adrVille varchar(15),
									p_adrCodePostal varchar(5),
									p_telephone varchar(10)
								)
BEGIN
	IF p_genre NOT IN ('Mr', 'Mme') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Le genre doit être "Mr" ou "Mme"';
    END IF;
    IF p_mail IN (SELECT email FROM Utilisateur) THEN
    	SIGNAL SQLSTATE '45000'
    		SET MESSAGE_TEXT = 'Un compte existe déjà avec cet email';
    END IF;

    INSERT INTO Utilisateur VALUES (NULL, p_nom, p_mail, p_password, 'client');
    INSERT INTO Information VALUES (last_insert_id(), p_genre, p_adrNum, p_adresse, p_adrVille, p_adrCodePostal, p_telephone, 0);
    COMMIT;

    SELECT 'Utilisateur créé !!' AS Message;
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE SupprimerClient (  p_idUtilisateur mediumint(5)
                                )
BEGIN
    IF p_idUtilisateur NOT IN (SELECT idUtilisateur FROM Utilisateur) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Utilisateur inexistant';
    END IF;

    DELETE FROM Information WHERE idUtilisateur = p_idUtilisateur;
    DELETE FROM Carte WHERE idUtilisateur = p_idUtilisateur;
    DELETE FROM Panier WHERE idUtilisateur = p_idUtilisateur;
    DELETE FROM Commande WHERE idUtilisateur = p_idUtilisateur;
    DELETE FROM Avis WHERE idUtilisateur = p_idUtilisateur;
    DELETE FROM Utilisateur WHERE idUtilisateur = p_idUtilisateur;
    COMMIT;

    SELECT 'Utilisateur supprimé !!' AS Message;
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE ModifierClient (   p_idUtilisateur mediumint(5),
                                    p_nom varchar(20),
                                    p_mail varchar(100),
                                    p_password varchar(64),
                                    p_genre varchar(3),
                                    p_adrNum varchar(5),
                                    p_adresse varchar(30),
                                    p_adrVille varchar(15),
                                    p_adrCodePostal varchar(5),
                                    p_telephone varchar(10)
                                )
BEGIN
    IF p_idUtilisateur NOT IN (SELECT idUtilisateur FROM Utilisateur) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Utilisateur inexistant';
    END IF;
    IF p_mail IN (SELECT email FROM Utilisateur WHERE idUtilisateur <> p_idUtilisateur ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Un compte existe déjà avec cet email';
    END IF;
    IF p_genre NOT IN ('Mr', 'Mme') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Le genre doit être "Mr" ou "Mme"';
    END IF;

    IF p_password IS NOT NULL THEN
        UPDATE Utilisateur
        SET nom = p_nom, email = p_mail, password = p_password
        WHERE idUtilisateur = p_idUtilisateur;
    ELSE
        UPDATE Utilisateur
        SET nom = p_nom, email = p_mail
        WHERE idUtilisateur = p_idUtilisateur;
    END IF;

    UPDATE Information
    SET genre = p_genre, adrNum = p_adrNum, adresse = p_adresse, adrVille = p_adrVille, adrCodePostale = p_adrCodePostal, telephone = p_telephone
    WHERE idUtilisateur = p_idUtilisateur;
    COMMIT;

    SELECT 'Utilisateur modifié !!' AS Message;
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE AjouterProduit(	p_nom varchar(20),
									p_prix decimal(6,2),
									p_solde decimal(3,2),
									p_description varchar(500),
									p_idCateg mediumint(5),
									p_marque varchar(20),
									p_quantiteStock mediumint(8),
									p_seuilStock tinyint(3),
									p_couleur varchar(100),
									p_super decimal (5,2),
									p_parfait decimal (5,2)
                                )
BEGIN
	DECLARE vid mediumint(5);
    DECLARE vcouleur varchar(255);
    DECLARE n integer DEFAULT 2;

    IF p_solde <= 0 OR p_solde > 1 THEN
    	SIGNAL SQLSTATE '45000'
    		SET MESSAGE_TEXT = 'Le solde ne doit pas être ≤ 0 ou > 1';
    END IF;
    IF p_idCateg NOT IN (SELECT idCategorie FROM Categorie) THEN
    	SIGNAL SQLSTATE '45000'
    		SET MESSAGE_TEXT = 'La catégorie n''existe pas';
    END IF;
    IF p_super <= 0 THEN
    	SIGNAL SQLSTATE '45000'
    		SET MESSAGE_TEXT = 'Le prix en plus pour un produit en très bon état doit être supérieur à 0';
    END IF;
    IF p_parfait <= p_super THEN
    	SIGNAL SQLSTATE '45000'
    		SET MESSAGE_TEXT = 'Le prix en plus pour un produit en parfait état doit être supérieur à celui d''un très bon état';
    END IF;

    INSERT INTO Produit VALUES (NULL, p_nom, p_prix, p_solde, p_description, NULL, CURRENT_DATE);
    SELECT last_insert_id() INTO vid;
    INSERT INTO SousCategorie VALUES (NULL, p_marque, p_idCateg, last_insert_id());

    SET vcouleur = REGEXP_SUBSTR(p_couleur, '[^-]+', 1, 1);
    WHILE vcouleur IS NOT NULL DO
        INSERT INTO Stock VALUES (vid, vcouleur, 'Bon état', 0, p_quantiteStock, p_seuilStock);
        INSERT INTO Stock VALUES (vid, vcouleur, 'Très bon état', p_super, p_quantiteStock, p_seuilStock);
        INSERT INTO Stock VALUES (vid, vcouleur, 'Parfait état', p_parfait, p_quantiteStock, p_seuilStock);
        SET vcouleur = REGEXP_SUBSTR(p_couleur, '[^-]+', 1, n);
        SET n = n + 1;
    END WHILE;
    COMMIT;

    SELECT 'Produit inséré !!' AS Message;
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE AjouterCommande(   p_idUtilisateur mediumint(5),
                                    p_montant decimal(6,2),
                                    p_modePaiement varchar (6),
                                    p_adrNumLivraison varchar (5),
                                    p_adrLivraison varchar (30),
                                    p_villeLivraison varchar(15),
                                    p_codePostaleLivraison varchar(5),
                                    p_idProduit varchar(500),
                                    p_quantite varchar(500),
                                    p_couleur varchar(500),
                                    p_etat varchar(500),
                                    p_fidelite mediumint(5)
                                )
BEGIN
    DECLARE vidprod mediumint(5);
    DECLARE vquantite mediumint(3);
    DECLARE vcouleur varchar(10);
    DECLARE vetat varchar(13);
    DECLARE n integer DEFAULT 2;

    IF p_idUtilisateur NOT IN (SELECT idUtilisateur FROM Utilisateur) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'L''utilisateur n''existe pas';
    END IF;
    IF p_modePaiement NOT IN ('PayPal', 'Carte') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Le mode de paiement n''est pas accepté';
    END IF;

    UPDATE Information
    SET fidelite = p_fidelite
    WHERE idUtilisateur = p_idUtilisateur;

    INSERT INTO Commande VALUES (NULL, p_idUtilisateur, p_montant, CURRENT_DATE, p_modePaiement, p_adrNumLivraison, p_adrLivraison, p_villeLivraison, p_codePostaleLivraison);

    SET vidprod = REGEXP_SUBSTR(p_idProduit, '[^-]+', 1, 1);
    SET vquantite = REGEXP_SUBSTR(p_quantite, '[^-]+', 1, 1);
    SET vcouleur = REGEXP_SUBSTR(p_couleur, '[^-]+', 1, 1);
    SET vetat = REGEXP_SUBSTR(p_etat, '[^-]+', 1, 1);
    WHILE vcouleur IS NOT NULL DO
        INSERT INTO DetailsCommande VALUES (last_insert_id(), vidprod, vquantite, vcouleur, vetat);
        SET vidprod = REGEXP_SUBSTR(p_idProduit, '[^-]+', 1, n);
        SET vquantite = REGEXP_SUBSTR(p_quantite, '[^-]+', 1, n);
        SET vcouleur = REGEXP_SUBSTR(p_couleur, '[^-]+', 1, n);
        SET vetat = REGEXP_SUBSTR(p_etat, '[^-]+', 1, n);
        SET n = n + 1;
    END WHILE;
    DELETE FROM Panier WHERE idUtilisateur = p_idUtilisateur;
    COMMIT;

    SELECT 'Commande inséré !!' AS Message;
END //

DELIMITER ;

DELIMITER //
CREATE TRIGGER t_d_commande
BEFORE DELETE ON Commande
FOR EACH ROW
BEGIN
    DELETE FROM DetailsCommande WHERE idCommande = OLD.idCommande;
END //

DELIMITER ;

DELIMITER //
CREATE TRIGGER t_i_detailscommande
BEFORE INSERT ON DetailsCommande
FOR EACH ROW
BEGIN
    UPDATE Stock
    SET quantiteStock = quantiteStock - NEW.quantite
    WHERE idProduit = NEW.idProduit
        AND couleur = NEW.couleur
        AND etat = NEW.etat;
END //

DELIMITER ;

DELIMITER //
CREATE TRIGGER t_d_detailscommande
BEFORE DELETE ON DetailsCommande
FOR EACH ROW
BEGIN
    UPDATE Stock
    SET quantiteStock = quantiteStock + OLD.quantite
    WHERE idProduit = OLD.idProduit
        AND couleur = OLD.couleur
        AND etat = OLD.etat;
END //

DELIMITER ;

DELIMITER //
CREATE TRIGGER t_i_avis
AFTER INSERT ON Avis
FOR EACH ROW
BEGIN
    DECLARE vsomme decimal(8,2);
    DECLARE vnb mediumint(5);

    SELECT SUM(note) INTO vsomme FROM Avis WHERE idProduit = NEW.idProduit GROUP BY idProduit;
    SELECT COUNT(idUtilisateur) INTO vnb FROM Avis WHERE idProduit = NEW.idProduit GROUP BY idProduit;

    UPDATE Produit
    SET note = vsomme / vnb
    WHERE idProduit = NEW.idProduit;
END //

DELIMITER ;

DELIMITER //
CREATE TRIGGER t_d_avis
AFTER DELETE ON Avis
FOR EACH ROW
BEGIN
    DECLARE vsomme decimal(8,2);
    DECLARE vnb mediumint(5);

    SELECT SUM(note) INTO vsomme FROM Avis WHERE idProduit = OLD.idProduit GROUP BY idProduit;
    SELECT COUNT(idUtilisateur) INTO vnb FROM Avis WHERE idProduit = OLD.idProduit GROUP BY idProduit;

    UPDATE Produit
    SET note = vsomme / vnb
    WHERE idProduit = OLD.idProduit;
END //

DELIMITER ;