<?php
session_start();
if (!isset($_SESSION['connected'])) {
	header('location: connexion.php');
	exit();
}
include("TraitSuppression.php");
include("TraitAjoutQuantitePanier.php");
include("TraitRetraitQuantitePanier.php");
?>

<!DOCTYPE html>
<html lang="fr">

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="include/style.css">
	<link rel="icon" href="include/img/icon-site.png">
	<title>Front Market</title>
</head>

<body>
	<?php
	include("include/header.php");
	require_once('include/connect.inc.php');
	?>

	<br><br><br><br><br><br><br>

	<section class="panier">
		<h1>Panier</h1>
		<?php
		$produitPanier = $conn->query("SELECT idProduit,quantite, couleur, etat FROM Panier WHERE idUtilisateur =" . $idUtilisateur);
		if ($produitPanier->rowCount() == 0) {
			echo "<h2>Il n'y a aucun produit dans le panier</h2>";
		} else {
			echo "<center><table border='2'>";
			echo "<tr><th>Image</th><th>Nom</th><th>Quantite</th><th>Couleur</th><th>Etat</th><th>Prix</th><th>Ajouter</th><th>Retirer</th><th>Supprimer</th></tr>";
			while ($row = $produitPanier->fetch(PDO::FETCH_ASSOC)) {
				$result[] = $row;
			}
			foreach ($result as $produit) {
				echo "<tr>";
				echo '<td><a href="produit.php?idProduit=' . $produit['idProduit'] . '"><img src="include/img/produit/' . $produit['idProduit'] . '.jpg" width="100" height="100"></td>';

				// Exécuter la requête pour obtenir le résultat
				$queryProduit = $conn->query("SELECT nom, prix, solde FROM Produit WHERE idProduit=" . $produit['idProduit']);

				// Fetch le résultat
				$queryProduit = $queryProduit->fetch(PDO::FETCH_ASSOC);

				// Afficher la valeur
				echo "<td>" . $queryProduit['nom'] . "</td>";
				echo "<td>" . $produit['quantite'] . "</td>";
				echo "<td>" . $produit['couleur'] . "</td>";
				echo "<td>" . $produit['etat'] . "</td>";
				echo "<td>" . $queryProduit['prix'] * $queryProduit['solde'] * $produit['quantite'] . "</td>";

				// Image Ajouter 
				echo '<form method="post" action="panier.php" >';
				echo "<input type=\"hidden\" name=\"idProduitPlus\" value=\"" . $produit['idProduit'] . "\">";
				echo '<td><input type="image" src="include/img/add-icon.png" width="100" height="100" alt="Ajouter"></td>';
				echo '</form>';

				// Image Retirer 
				echo '<form method="post" action="panier.php" >';
				echo "<input type=\"hidden\" name=\"idProduitMoins\" value=\"" . $produit['idProduit'] . "\">";
				echo '<td><input type="image" src="include/img/reduce-icon.png" width="100" height="100" alt="Retirer"></td>';
				echo '</form>';

				// Image Supprimer
				echo '<form method="post" action="panier.php" >';
				echo "<input type=\"hidden\" name=\"idProduitSuppr\" value=\"" . $produit['idProduit'] . "\">";
				echo '<td><input type="image" src="include/img/trash-icon.png" width="100" height="100" alt="Supprimer" "></td>';
				echo '</form>';
				echo "</tr>";
			}
			echo "</table></center><BR/><BR/>";
			echo '<center><a class="valider-panier" href="paiement.php">Valider mon panier</a></center>';
		}
		?>
	</section>
</body>

</html>