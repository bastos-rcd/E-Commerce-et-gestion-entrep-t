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

#-------------------------------
#-----------Procédure-----------
#-------------------------------

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

#-------------------------------
#------------Trigger------------
#-------------------------------

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