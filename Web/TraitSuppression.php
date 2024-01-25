<?php
require_once("include/connect.inc.php");

$idUtilisateur = $_SESSION['connected'];

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['idProduitSuppr'])) {
	$idProduit = htmlentities($_POST['idProduitSuppr']);

	$DeletePanierProduit = $conn->prepare("DELETE FROM Panier WHERE idUtilisateur = :idUtilisateur AND idProduit = :idProduit");
	$DeletePanierProduit->bindParam(':idUtilisateur', $idUtilisateur);
	$DeletePanierProduit->bindParam(':idProduit', $idProduit);

	if ($DeletePanierProduit->execute()) {
		echo '<script language="JavaScript" type="text/javascript">';
		echo 'alert("Suppression effectuée !");';
		echo 'window.location.replace("panier.php");';
		echo '</script>';
	} else {
		echo "Erreur lors de la suppression du produit.";
	}

} else {
	echo 'Accès non autorisé';
}
?>