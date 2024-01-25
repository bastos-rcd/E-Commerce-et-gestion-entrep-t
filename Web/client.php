<?php
session_start();

if (!isset($_SESSION['connected'])) {
	header('Location: connexion.php');
	exit();
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
		<?php
		require_once('include/connect.inc.php');
		$req = $conn->prepare("SELECT nom, email, genre, adrNum, adresse, adrVille, adrCodePostale, telephone, fidelite FROM Information I, Utilisateur U WHERE U.idUtilisateur= :id and I.idUtilisateur=U.idUtilisateur");
		$req->execute(['id' => $_SESSION['connected']]);
		$infocompte = $req->fetch();

		echo '<form action="TraitModification.php" method="post" id="modification">';
		echo '<h2>INFORMATIONS DU COMPTE</h2>';
		echo '<br>';
		echo '<br> ';
		echo '<input type="text" name="nom" placeholder="Nom" value="' . $infocompte["nom"] . '" required />';
		echo '<br> ';
		echo '<br> ';
		if ($infocompte["genre"] == "Mr") {
			echo '<input type="radio" name="genre" value="Mr" checked />Monsieur';
			echo '<input type="radio" name="genre" value="Mme" />Madame';
		} else {
			echo '<input type="radio" name="genre" value="Mr" />Monsieur';
			echo '<input type="radio" name="genre" value="Mme" checked/>Madame';
		}
		echo '<br> ';
		echo '<input type="email" name="email" placeholder="Email" value="' . $infocompte["email"] . '" required />';
		echo '<br> ';
		echo '<input type="password" name="passwordB" placeholder="Mot de passe actuel" />';
		echo '<br> ';
		echo '<input type="password" name="passwordA" placeholder="Nouveau mot de passe" />';
		echo '<br> ';
		echo '<input type="tel" name="telephone" placeholder="Téléphone" value="' . $infocompte["telephone"] . '" required />';
		echo '<br> ';
		echo '<br> ';
		echo '<label for="fidelite">Points de fidélité : ' . $infocompte['fidelite'] . '</label>';
		echo '<br> ';
		echo '<br> ';
		echo 'Adresse :';
		echo '<br> ';
		echo '<input type="text" name="num_adresse" placeholder="Numéro" value="' . $infocompte["adrNum"] . '" required />';
		echo '<br> ';
		echo '<input type="text" name="adresse" placeholder="Chemin" value="' . $infocompte["adresse"] . '" required />';
		echo '<br> ';
		echo '<input type="text" name="ville" placeholder="Ville" value="' . $infocompte["adrVille"] . '" required />';
		echo '<br> ';
		echo '<input type="text" name="code_postal" placeholder="Code POSTal" value="' . $infocompte["adrCodePostale"] . '" required />';
		echo '<br> ';
		echo '<br> ';
		echo '<input type="submit" value="Modifier" />';
		echo '</form>';
		?>
	</section>
</body>