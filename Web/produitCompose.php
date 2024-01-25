<?php
session_start();
if (!isset($_GET['idProduitCompose'])) {
    header('location: index.php');
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
    <?php
    include("include/header.php");
    ?>

    <br><br><br><br><br><br><br>
    <section class="produit-compose">
        <form action="TraitPanierCompose.php" method="post">
            <?php
            require_once('include/connect.inc.php');
            require_once('etoile.php');

            $req_produit_compose = $conn->prepare("SELECT idProduit FROM ProduitCompose WHERE idCompose = :idCompose;");
            $req_produit_compose->execute(["idCompose" => htmlentities($_GET["idProduitCompose"])]);

            if ($req_produit_compose->rowCount() == 0) {
                echo '<script language="JavaScript" type="text/javascript">';
                echo 'alert("Ce produit composé n\'existe pas !");';
                echo 'window.history.back();';
                echo '</script>';
                exit();
            }

            echo '<input type="text" name="idCompose" value="' . htmlentities($_GET["idProduitCompose"]) . '" hidden>';

            while ($produit_compose = $req_produit_compose->fetch()) {
                $req_produit = $conn->prepare("SELECT P.idProduit, P.nom, P.prix, P.description FROM Produit P WHERE P.idProduit = :idProduit;");
                $req_produit->execute(["idProduit" => $produit_compose['idProduit']]);
                $produit = $req_produit->fetch();

                echo '<div>';
                echo '<img src="include/img/produit/' . $produit['idProduit'] . '.jpg">';
                echo '<div>';
                echo '<h1>' . $produit['nom'] . '</h1>';
                echo '<hr>';
                echo '<h2>' . $produit['prix'] . '€</h2>';
                echo '<hr><div>';

                $req_couleur = $conn->prepare("SELECT DISTINCT couleur FROM Stock WHERE idProduit = :idProduit;");
                $req_couleur->execute(["idProduit" => $produit["idProduit"]]);

                echo '<select name="couleur' . $produit["idProduit"] . '">';
                while ($couleur = $req_couleur->fetch()) {
                    echo '<option value="' . $couleur['couleur'] . '">' . $couleur['couleur'] . '</option>';
                }
                echo '</select>';

                $req_couleur->closeCursor();

                echo '<select name="etat' . $produit["idProduit"] . '">';
                echo '<option value="Bon état">Bon état</option>';
                echo '<option value="Très bon état">Très bon état</option>';
                echo '<option value="Parfait état">Parfait état</option>';
                echo '</select></div><hr>';
                echo '<p>' . $produit['description'] . '</p>';
                echo '</div>';

                echo '</div>';

                $req_produit->closeCursor();
            }
            $req_produit_compose->closeCursor();
            ?>
            <br><br>
            <center><input type="submit" value="Ajouter au panier"></center>
        </form>
    </section>

    <?php
    include("include/footer.php");
    ?>
</body>

</html>