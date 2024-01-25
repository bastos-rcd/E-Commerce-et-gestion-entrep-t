<?php
require_once("include/connect.inc.php");

$p_nom = htmlspecialchars($_POST['nomProduit']);
$p_prix = htmlentities($_POST['prix']);
$p_solde = 1 - (htmlentities($_POST['solde']) / 100);
$p_description = htmlentities($_POST['description']);
$p_idCateg = htmlentities($_POST['idCategorie']);
$p_marque = htmlentities($_POST['marque']);
$p_quantiteStock = htmlentities($_POST['stock']);
$p_seuilStock = htmlentities($_POST['seuil']);
$p_couleur = htmlentities($_POST['couleur']);
$p_super = htmlentities($_POST['prix_super']);
$p_parfait = htmlentities($_POST['prix_parfait']);


if ($p_quantiteStock < $p_seuilStock) {
  echo '<script language="JavaScript" type="text/javascript">';
  echo 'alert("La quantiter en stock est inferieure au seuil autoris�e");';
  echo 'window.history.back();';
  echo '</script>';
  die();
}

if ($p_seuilStock <= 0) {
  echo '<script language="JavaScript" type="text/javascript">';
  echo 'alert("Le seuil du stock doit �tre superieur � 0");';
  echo 'window.history.back();';
  echo '</script>';
  die();
}

if ($p_super < 0) {
  echo '<script language="JavaScript" type="text/javascript">';
  echo 'alert("Le prix d\'un produit tr�s bon doit �tre superieur a celui d\'un produit bon");';
  echo 'window.history.back();';
  echo '</script>';
  die();
}

if ($p_parfait < $p_super) {
  echo '<script language="JavaScript" type="text/javascript">';
  echo 'alert("Le prix d\'un produit parfait doit �tre superieur � celui d\'un produit tr�s bon");';
  echo 'window.history.back();';
  echo '</script>';
  die();
}

if ($_FILES['image']['type'] != 'image/jpeg' || $_FILES['image']['size'] > 100000) {
  echo '<script language="JavaScript" type="text/javascript">';
  echo 'alert("L\'image doit �tre en .jpg et faire moins de 100Ko");';
  echo 'window.history.back();';
  echo '</script>';
  die();
}

$requete = $conn->prepare("CALL AjouterProduit(:nom, :prix, :solde, :description, :idCateg, :marque, :stock, :seuil, :couleur, :prix_super, :prix_prfait);");
$requete->execute(['nom' => $p_nom, 'prix' => $p_prix, 'solde' => $p_solde, 'description' => $p_description, 'idCateg' => $p_idCateg, 'marque' => $p_marque, 'stock' => $p_quantiteStock, 'seuil' => $p_seuilStock, 'couleur' => $p_couleur, 'prix_super' => $p_super, 'prix_prfait' => $p_parfait]);
$requete->closeCursor();

$requete_id = $conn->prepare("SELECT idProduit FROM Produit ORDER BY idProduit DESC;");
$requete_id->execute();

$idProduit = $requete_id->fetch();

echo "ID : " . $idProduit['idProduit'];

move_uploaded_file($_FILES["image"]["tmp_name"], 'include/img/produit/' . $idProduit['idProduit'] . '.jpg');

$requete_id->closeCursor();

header("location: gestionProduit.php");
exit();
?>
