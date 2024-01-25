<?php
session_start();

if (!isset($_SESSION['connected']) || $_SESSION['role'] == 'client') {
    header('location: connexion.php');
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

    <section class="ajouter-produit">
        <form action="TraitAjoutProduit.php" method="post" enctype="multipart/form-data">
            <div>
                <fieldset>
                    <legend>Informations</legend>
                    <input type="text" name="nomProduit" placeholder="Nom" required><br><br>
                    <input type="number" min="0" name="prix" placeholder="Prix €" required><br><br>
                    <input type="number" min="0" max="100" name="solde" placeholder="Solde %" required><br><br>
                    <textarea name="description" cols="30" rows="10" placeholder="Description" required></textarea><br><br>
                    <input type="file" name="image">
                </fieldset>
                <div>
                    <fieldset>
                        <legend>Caractéristiques</legend>
                        <select name="idCategorie" required>
                            <option>--Choisir une catégorie--</option>
                            <?php
                            require_once('include/connect.inc.php');
                            $req = $conn->prepare("SELECT idCategorie, nom FROM Categorie");
                            $req->execute();
                            while ($categ = $req->fetch()) {
                                echo '<option value="' . $categ['idCategorie'] . '">' . $categ['nom'] . '</option>';
                            }
                            $req->closeCursor();
                            ?>
                        </select><br><br>
                        <input type="text" name="marque" placeholder="Marque" required><br><br>
                        <input type="text" name="couleur" placeholder="Couleur1-Couleur2" required><br><br>
                        <input type="number" name="prix_super" placeholder="Prix Très bon état" required><br><br>
                        <input type="number" name="prix_parfait" placeholder="Prix Parfait état" required>
                    </fieldset>
                    <br>
                    <fieldset>
                        <legend>Stock</legend>
                        <input type="number" name="stock" placeholder="Stock"><br><br>
                        <input type="number" name="seuil" placeholder="Seuil du stock">
                    </fieldset>
                </div>
            </div>
            <br><br>
            <input type="submit" value="Ajouter Produit">
        </form>
    </section>

</body>