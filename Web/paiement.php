<?php
session_start();

//Vérification de la session
if (!isset($_SESSION['connected'])) {
	echo '<script language="JavaScript" type="text/javascript">';
	echo 'window.location.replace("connexion.php");';
	echo '</script>';
	die();
}

//Liaison à la base de données
require('include/connect.inc.php');

//Vérification du panier
$requete = $conn->prepare("SELECT idProduit, etat FROM Panier WHERE idUtilisateur= :id");
$requete->execute(['id' => $_SESSION['connected']]);
$panier = $requete->fetchAll();
if (empty($panier)) {
	echo '<script language="JavaScript" type="text/javascript">';
	echo 'alert("Votre panier est vide");';
	echo 'window.location.replace("index.php");';
	echo '</script>';
	die();
}
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
	<?php include("include/header.php"); ?>

	<br><br><br><br><br><br>
	<section class="formulaire">
		<form method="POST" action="TraitPaiement.php">
			<h2>PAIEMENT</h2>
			<h3>INFORMATION DE LIVRAISON</h3>
			<?php

			//Préremplissage des champs
			$requete = $conn->prepare("SELECT nom, email, genre, adrNum, adresse, adrVille, adrCodePostale, telephone, fidelite FROM Information I, Utilisateur U WHERE U.idUtilisateur= :id and I.idUtilisateur=U.idUtilisateur");
			$requete->execute(['id' => $_SESSION['connected']]);
			$infocompte = $requete->fetch();

			echo '<input type="text" name="adrNum" placeholder="Numéro" value="' . $infocompte["adrNum"] . '" required />';
			echo '<br> ';
			echo '<input type="text" name="adresse" placeholder="Chemin" value="' . $infocompte["adresse"] . '" required />';
			echo '<br> ';
			echo '<input type="text" name="ville" placeholder="Ville" value="' . $infocompte["adrVille"] . '" required />';
			echo '<br> ';
			echo '<input type="text" name="codePostal" placeholder="Code Postal" value="' . $infocompte["adrCodePostale"] . '" required />';
			echo '<br> ';
			echo '<br> ';
			echo '<div>Enregistrer cette adresse: <input type="radio" name="adresseEnregistree" value="1" />Oui';
			echo '<input type="radio" name="adresseEnregistree" value="0" checked />Non</div>';
			echo '<br> ';
			echo '<br> ';
			echo '<h3>INFORMATION DE PAIEMENT</h3>';

			//Calcul du montant total
			$requete = $conn->prepare("SELECT idProduit, etat FROM Panier WHERE idUtilisateur= :id");
			$requete->execute(['id' => $_SESSION['connected']]);
			$panier = $requete->fetchAll();

			if (empty($panier)) {
				echo '<script language="JavaScript" type="text/javascript">';
				echo 'alert("Votre panier est vide");';
				echo 'window.history.back();';
				echo '</script>';
				die();
			}
			$produits = array();
			$montantI = 0;
			foreach ($panier as $produit) {
				$requete = $conn->prepare("SELECT solde, quantite, prix FROM Produit P, Panier P2 WHERE P.idProduit= :id AND P2.idProduit=P.idProduit AND P2.idUtilisateur= :idUtilisateur");
				$requete->execute(['id' => $produit['idProduit'], 'idUtilisateur' => $_SESSION['connected']]);
				$produitA = $requete->fetch();

				$requete = $conn->prepare("SELECT prixEtat FROM Stock WHERE idProduit= :id AND etat= :etat");
				$requete->execute(['id' => $produit['idProduit'], 'etat' => $produit['etat']]);
				$prixEtat = $requete->fetch();

				$requete = $conn->prepare("SELECT fidelite FROM Information WHERE idUtilisateur= :id");
				$requete->execute(['id' => $_SESSION['connected']]);
				$fidelite = $requete->fetch();
				$fidelite = $fidelite['fidelite'];

				$montantI += $produitA['quantite'] * ($produitA['prix'] * $produitA['solde'] + $prixEtat['prixEtat']);
			}
			if ($fidelite > $montantI) {
				$montantF = 0;
				$fidelite = $fidelite - $montantI;
				$reste = 0;
			} else {
				$montantF = $montantI - $fidelite;
				$fidelite = 0;
				$reste = (int) ($montantF / 15);
			}



			echo 'Montant total : ' . $montantF . ' € (après reduction)';
			echo '<br> ';
			echo 'Vous allez gagner ' . $reste . ' points de fidelité';
			echo '<br> ';
			echo '<br> ';

			//Moyen de paiement
			echo "Moyen de paiement :";

			echo '<br> ';
			echo '<br> ';

			echo "<div style='display: flex; flex-direction: row; justify-content: space-between;'>";
			echo "<div style='display: flex; flex-direction: column; margin-left: 10%;'>";
			echo "<input type='radio' name='moyenPaiement' value='CB' required checked /> Carte Bancaire";
			echo "</div><div style='display: flex; flex-direction: column; margin-right: 5%;'>";
			echo "<input type='radio' name='moyenPaiement' value='Paypal' required /> Paypal";
			echo "</div></div>";

			echo '<br> ';

			$requete = $conn->prepare("SELECT numero, crypto FROM Carte WHERE idUtilisateur= :id");
			$requete->execute(['id' => $_SESSION['connected']]);
			$carte = $requete->fetch();

			if (!empty($carte)) {
				$numCarte = $carte['numero'];
				$crypto = $carte['crypto'];
			} else {
				$numCarte = "";
				$crypto = "";
			}

			echo "<div style='display: flex; flex-direction: row;'>";
			echo "<div style='display: flex; flex-direction: column; margin-right: 15%;'>";
			echo "Numéro de carte : <input type='text' name='numCarte'  value='" . $numCarte . "' placeholder='Numéro de carte'  />";
			echo "Cryptogramme : <input type='password' name='crypto' value='" . $crypto . "' placeholder='Cryptogramme'  />";
			echo "Enregistrer cette carte: <div style='display: flex; flex-direction: row; margin-left: 20%;'> <input type='radio' name='carteEnregistree' value='1' />Oui";
			echo "<input type='radio' name='carteEnregistree' value='0' checked >Non</input>";
			echo "</div></div>";
			echo '<br> ';
			echo "<div style='display: flex; flex-direction: column;'> Email : <input type='text' name='email' placeholder='Votre email'  />";
			echo "Mot de passe:<input type='password' name='mdp' placeholder='Mot de passe'  />";
			echo "</div></div>";

			echo '<br> ';
			echo '<br> ';

			echo '<div><input type="submit" value="Valider" name="valider" /></div>';

			echo "<input type='hidden' name='montant' value='" . $montantF . "' />";
			echo "<input type='hidden' name='fidelite' value='" . $fidelite . "' />";
			echo "<input type='hidden' name='reste' value='" . $reste . "' />";

			?>
			<br>
			<br>
		</form>
	</section>
</body>

</html>