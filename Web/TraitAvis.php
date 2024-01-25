<?php
session_start();

//Liaison avec la base de données
include("include/connect.inc.php");

//Vérification de la session
if (!isset($_SESSION['connected'])) {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Vous devez être connecté pour laisser un avis !");';
    echo 'window.location.replace("connexion.php");';
    echo '</script>';
    die();
}

//Vérification du rôle
if ($_SESSION['role'] != 'client') {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Vous devez être un client pour laisser un avis !");';
    echo 'window.history.back();';
    echo '</script>';
    die();
}

//Vérification du produit
if (!isset($_POST['idProduit'])) {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Ce produit n\'existe pas !");';
    echo 'window.history.back();';
    echo '</script>';
    die();
}

try {
    //Récupération des données
    $idUtilisateur = $_SESSION['connected'];
    $idProduit = htmlentities($_POST['idProduit']);
    $note = htmlentities($_POST['note']);
    $avis = htmlentities($_POST['avis']);

    //Insertion dans la base de données
    $req_avis = $conn->prepare("INSERT INTO Avis (idUtilisateur, idProduit, note, avis) VALUES (:idUtilisateur, :idProduit, :note, :avis);");
    $req_avis->execute(['idUtilisateur' => $idUtilisateur, 'idProduit' => $idProduit, 'note' => $note, 'avis' => $avis]);

    //Retour à la page précédente
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Merci de votre avis !");';
    echo 'window.history.back();';
    echo '</script>';
    die();

} catch (PDOException $e) {
    //Retour à la page précédente
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Erreur de connexion à la base de données !");';
    echo 'window.history.back();';
    echo '</script>';
    die();
}

?>