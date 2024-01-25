<?php
session_start();

//Liaison avec la base de données
include("include/connect.inc.php");

//Vérification de la session
if (!isset($_SESSION['connected'])) {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'window.location.replace("connexion.php");';
    echo '</script>';
    die();
}

//Vérification du rôle
if ($_SESSION['role'] != 'admin') {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'window.history.back();';
    echo '</script>';
    die();
}

//Vérification du produit
if (!isset($_POST['idProduit'])) {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'window.history.back();';
    echo '</script>';
}

try {
    $idUtilisateur = htmlentities($_POST['idUtilisateur']);
    $idProduit = htmlentities($_POST['idProduit']);
    $note = htmlentities($_POST['note']);
    $avis = htmlentities($_POST['avis']);
    $reponse = htmlentities($_POST['reponse']);

    // On vérifie la longueur de la réponse	
    if (strlen($reponse) >= 300) {
        echo '<script language="JavaScript" type="text/javascript">';
        echo 'alert("La réponse est trop longue !");';
        echo 'window.history.back();';
        echo '</script>';
        die();
    }

    //Insertion de la réponse dans la base de données
    $req_avis = $conn->prepare("UPDATE Avis SET reponse = :reponse WHERE idUtilisateur = :idUtilisateur AND idProduit = :idProduit;");
    $req_avis->execute(['reponse' => $reponse, 'idUtilisateur' => $idUtilisateur, 'idProduit' => $idProduit]);

    //Confirmation et redirection
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Réponse envoyée !");';
    echo 'window.history.back();';
    echo '</script>';
    die();

} catch (PDOException $e) {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Erreur de connexion à la base de données !");';
    echo 'window.history.back();';
    echo '</script>';
    exit();
}





?>