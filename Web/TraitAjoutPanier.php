<?php
session_start();

if (!isset($_SESSION['connected'])) {
  echo "<script type='text/javascript'>";
  echo "alert('Vous devez être connecté pour ajouter un produit au panier');";
  echo "window.location.replace('connexion.php');";
  echo "</script>";
}

//Liaison avec la BD
require_once('include/connect.inc.php');

//Initialisation des variables
$idUtilisateur = $_SESSION['connected'];
$idProduit = htmlentities($_POST['idProduit']);
$couleur = htmlentities($_POST['couleur']);
$etat = htmlspecialchars($_POST['etat']);

//Vérification de l'éxistence du produit dans le panier
$dejadanspan = $conn->prepare("SELECT idUtilisateur, idProduit from Panier where idUtilisateur = :idUtilisateur and idProduit = :idProduit");
$dejadanspan->execute(['idUtilisateur' => $idUtilisateur, 'idProduit' => $idProduit]);
$resultat = $dejadanspan->fetchAll();

if (!empty($resultat)) {
  echo "<script type='text/javascript'>";
  echo "alert('Produit déjà dans le panier');";
  echo "window.history.back();";
  echo "</script>";
  die();
}

//Insertion du produit dans le panier
$req_avis = $conn->prepare("INSERT INTO Panier (idUtilisateur, idProduit, quantite, couleur, etat) VALUES (:idUtilisateur, :idProduit, :quantite, :couleur, :etat);");
$req_avis->execute(['idUtilisateur' => $idUtilisateur, 'idProduit' => $idProduit, 'quantite' => 1, 'couleur' => $couleur, 'etat' => $etat]);

//Confirmation et redirection 
echo "<script type='text/javascript'>";
echo "alert('Produit ajouté au panier');";
echo "window.history.back();";
echo "</script>";
?>