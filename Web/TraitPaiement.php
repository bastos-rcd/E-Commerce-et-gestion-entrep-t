<?php
session_start();

//Liaison avec la base de données
require_once('include/connect.inc.php');

if (!isset($_SESSION['connected'])) {
    header('Location: connexion.php');
    exit();
}

//Vérification des données de livraison
$patternAdrNum = "/^[0-9]{1,3}$/";

if (!preg_match($patternAdrNum, $_POST['adrNum'])) {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Numéro de rue invalide");';
    echo 'window.history.back();';
    echo '</script>';
    die();
}
$adrNum = htmlentities($_POST['adrNum']);


$patternAdresse = '/^[a-zA-Z0-9\' ]{1,15}$/';

if (!preg_match($patternAdresse, $_POST['adresse'])) {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Adresse invalide");';
    echo 'window.history.back();';
    echo '</script>';
    die();
}
$adresse = htmlentities($_POST['adresse']);

$patternVille = '/^[a-zA-Z\ ]{1,15}$/';

if (!preg_match($patternVille, $_POST['ville'])) {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Ville invalide");';
    echo 'window.history.back();';
    echo '</script>';
    die();
}
$ville = htmlentities($_POST['ville']);

$patternCodePostal = '/^[0-9]{5}$/';
$codePostal = htmlentities($_POST['codePostal']);
if (!preg_match($patternCodePostal, $codePostal)) {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Code postal invalide");';
    echo 'window.history.back();';
    echo '</script>';
    die();
}

//Traitement des données de livraison
$adresseEnregistree = $_POST['adresseEnregistree'];
if ($adresseEnregistree == 1) {
    try {
        $requete = $conn->prepare("UPDATE Information SET adrNum = :adrNum, adresse = :adresse, adrVille = :adrVille, adrCodePostale = :adrCodePostale WHERE idUtilisateur = :id");
        $requete->execute(['adrNum' => $adrNum, 'adresse' => $adresse, 'adrVille' => $ville, 'adrCodePostale' => $codePostal, 'id' => $_SESSION['connected']]);
    } catch (PDOException $e) {
        echo "<script language='JavaScript' type='text/javascript'>";
        echo "alert('Erreur lors de l\'enregistrement de l\'adresse, paiement annulé');";
        echo "window.history.back();";
        echo "</script>";
    }

}

if (!isset($_POST['moyenPaiement']) || empty($_POST['moyenPaiement'])) {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Veuillez choisir un type de carte");';
    echo 'window.history.back();';
    echo '</script>';
    die();
}

//Traitement si paiement par carte
if ($_POST['moyenPaiement'] == "CB") {
    $moyenPaiement = 'Carte';
    $numeroCarte = htmlentities($_POST['numCarte']);
    $patternNumeroCarte = "/^[0-9]{16}$/";
    if (!preg_match($patternNumeroCarte, $numeroCarte)) {
        echo '<script language="JavaScript" type="text/javascript">';
        echo 'alert("Numéro de carte invalide");';
        echo 'window.history.back();';
        echo '</script>';
        die();
    }
    $crypto = htmlentities($_POST['crypto']);
    $patternCrypto = "/^[0-9]{3}$/";
    if (!preg_match($patternCrypto, $crypto)) {
        echo '<script language="JavaScript" type="text/javascript">';
        echo 'alert("Cryptogramme invalide");';
        echo 'window.history.back();';
        echo '</script>';
        die();
    }
    //Enregistrement de la carte
    if ($_POST['carteEnregistree'] == 1) {
        $requete = $conn->prepare("SELECT numero, crypto FROM Carte WHERE idUtilisateur = :id");
        $requete->execute(['id' => $_SESSION['connected']]);
        $carte = $requete->fetch();
        if (!empty($carte)) {
            try {
                $requete = $conn->prepare("UPDATE Carte SET numero = :numero, crypto = :crypto WHERE idUtilisateur = :id");
                $requete->execute(['numero' => $numeroCarte, 'crypto' => $crypto, 'id' => $_SESSION['connected']]);
            } catch (PDOException $e) {
                echo "<script language='JavaScript' type='text/javascript'>";
                echo "alert('Erreur lors de l\'enregistrement de la carte, paiement annulé');";
                echo "window.history.back();";
                echo "</script>";
            }
        } else {
            try {
                $requete = $conn->prepare("INSERT INTO Carte VALUES(:id, :numero, :crypto)");
                $requete->execute(['id' => $_SESSION['connected'], 'numero' => $numeroCarte, 'crypto' => $crypto]);
            } catch (PDOException $e) {
                echo "<script language='JavaScript' type='text/javascript'>";
                echo "alert('Erreur lors de l\'enregistrement de la carte, paiement annulé');";
                echo "window.history.back();";
                echo "</script>";
            }
        }
    }




} else {
    //Traitement de paiement par Paypal
    $moyenPaiement = 'Paypal';
    $patternMail = "/^[a-zA-Z0-9._-]+@[a-zA-Z0-9._-]{2,}\.[a-z]{2,4}$/";
    $mail = htmlentities($_POST['email']);

    if ($mail == "") {
        echo '<script language="JavaScript" type="text/javascript">';
        echo 'alert("Veuillez entrer une adresse mail");';
        echo 'window.history.back();';
        echo '</script>';
        die();
    }

    if (htmlentities($_POST['mdp']) == "") {
        echo '<script language="JavaScript" type="text/javascript">';
        echo 'alert("Veuillez entrer un mot de passe");';
        echo 'window.history.back();';
        echo '</script>';
        die();
    }

    if (!preg_match($patternMail, $mail)) {
        echo '<script language="JavaScript" type="text/javascript">';
        echo 'alert("Adresse mail invalide");';
        echo 'window.history.back();';
        echo '</script>';
        die();
    }
}

//Traitement de la commande
$strIdProduit = "";
$strQuantite = "";
$strCouleur = "";
$strEtat = "";

$requete = $conn->prepare("SELECT idProduit, quantite, couleur, etat FROM Panier WHERE idUtilisateur = :id");
$requete->execute(['id' => $_SESSION['connected']]);
$panier = $requete->fetchAll();

if (empty($panier)) {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Votre panier est vide");';
    echo 'window.history.back();';
    echo '</script>';
    die();
}

//Mise en forme pour la procédure stockée
foreach ($panier as $produit) {
    $strIdProduit = $strIdProduit . $produit['idProduit'] . "-";
    $strQuantite = $strQuantite . $produit['quantite'] . "-";
    $strCouleur = $strCouleur . $produit['couleur'] . "-";
    $strEtat = $strEtat . $produit['etat'] . "-";
}

$strIdProduit = substr($strIdProduit, 0, -1);
$strQuantite = substr($strQuantite, 0, -1);
$strCouleur = substr($strCouleur, 0, -1);
$strEtat = substr($strEtat, 0, -1);

$reste = $_POST['reste'];
//Éxecution de la procédure stockée
$requete = $conn->prepare("CALL AjouterCommande(:idUtilisateur, :montant, :modePaiement, :adrNum, :adresse, :adrVille, :adrCodePostal, :idProduit, :quantite, :couleur, :etat, :reste)");
$requete->execute(['idUtilisateur' => $_SESSION['connected'], 'montant' => $_POST['montant'], 'modePaiement' => $moyenPaiement, 'adrNum' => $adrNum, 'adresse' => $adresse, 'adrVille' => $ville, 'adrCodePostal' => $codePostal, 'idProduit' => $strIdProduit, 'quantite' => $strQuantite, 'couleur' => $strCouleur, 'etat' => $strEtat, 'reste' => $reste]);
$requete->closeCursor();


//Confirmation et redirection
echo "<script language='JavaScript' type='text/javascript'>";
echo "alert('Paiement effectué');";
echo "window.location.replace('index.php');";
echo "</script>";
die();

?>