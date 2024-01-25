<?php
session_start();

if (isset($_SESSION['connected'])) {
	header('Location: client.php');
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
	<center>
		<a href="index.php"><img src="include/img/logo.png" id="img-formulaire"></a>
	</center>

	<section class="formulaire">

		<form action="TraitCreation.php" method="post" id="inscription">
			<h2>INSCRIPTION</h2>
			<br>
			<input type="text" name="nom" placeholder="Nom" maxlength="10" required>
			<br>
			<input type="text" name="prenom" placeholder="Prénom" maxlength="10" required>
			<br>
			<input type="radio" name="genre" value="Mr" />Monsieur
			<input type="radio" name="genre" value="Mme" />Madame
			<br>
			<input type="email" name="email" placeholder="Email" maxlength="100" required>
			<br>
			<input type="password" name="password" placeholder="Mot de passe" maxlength="64" required>
			<br>
			<input type="tel" name="telephone" placeholder="Téléphone" required>
			<br>
			Adresse :
			<br>
			<input type="text" name="num_adresse" placeholder="Numéro" maxlength="5" required>
			<br>
			<input type="text" name="adresse" placeholder="Chemin" maxlength="30" required>
			<br>
			<input type="text" name="ville" placeholder="Ville" maxlength="15" required>
			<br>
			<input type="text" name="code_postal" placeholder="Code Postal" maxlength="5" required>
			<br>
			<input type="submit" name="Valider" value="S'inscrire">

		</form>

		<form action="TraitConnexion.php" method="post" id="connexion">
			<h2 id="titreduform">CONNEXION</h2>
			<br>
			<input type="email" name="email" placeholder="Email" <?php if (isset($_COOKIE['Login'])) {
				echo "value='" . $_COOKIE['Login'] . "'";
			} ?> maxlength="100" required>
			<br>
			<input type="password" name="password" placeholder="Mot de passe" maxlength="64" required>
			<br>
			Se souvenir de moi
			<br>
			<input type='radio' name='souvenir' value='oui' <?php if (isset($_COOKIE['Login'])) {
				echo "checked";
			} ?>>Oui
			<input type='radio' name='souvenir' value='non' <?php if (!isset($_COOKIE['Login'])) {
				echo "checked";
			} ?>>Non
			<br>


			<input type="submit" name="Valider2" value="Se connecter">

		</form>

	</section>

</body>

</html>