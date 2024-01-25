<?php
session_start();
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
    <br><br><br><br><br><br>
    <section class="produit-accueil">
        <h1>Nouveautés</h1>
        <div>
            <?php
            require_once("include/connect.inc.php");
            require_once("etoile.php");

            $req_new_product = $conn->prepare("SELECT idProduit, nom, prix, solde, note, dateAjout FROM Produit ORDER BY dateAjout DESC;");
            $req_new_product->execute();

            for ($i = 0; $i < 5; $i++) {
                $produit = $req_new_product->fetch();
                echo '<a href="produit.php?idProduit=' . $produit['idProduit'] . '">';
                echo '<div class="produit">';
                echo '<img src="include/img/produit/' . $produit['idProduit'] . '.jpg">';
                echo '<div>';
                echo '<p>' . $produit['nom'] . '</p>';
                echo '<p>' . ((float) $produit['prix'] * (float) $produit['solde']) . '€</p>';
                echo '</div>';
                if (is_null($produit['note'])) {
                    echo '<p style="text-align: center; padding-bottom:10px; color:yellow;">Pas d\'avis</p>';
                } else {
                    etoile($produit['note']);
                }
                echo '</div></a>';
            }

            $req_new_product->closeCursor();
            ?>
        </div>
    </section>

    <section class="produit-accueil">
        <h1>Nos meilleures ventes</h1>
        <div>
            <?php
            require_once("include/connect.inc.php");
            require_once("etoile.php");

            $req_best_product = $conn->prepare("SELECT idProduit, nom, prix, solde, note, dateAjout FROM Produit ORDER BY note DESC;");
            $req_best_product->execute();

            for ($i = 0; $i < 5; $i++) {
                $produit = $req_best_product->fetch();
                echo '<a href="produit.php?idProduit=' . $produit['idProduit'] . '">';
                echo '<div class="produit">';
                echo '<img src="include/img/produit/' . $produit['idProduit'] . '.jpg">';
                echo '<div>';
                echo '<p>' . $produit['nom'] . '</p>';
                echo '<p>' . ((float) $produit['prix'] * (float) $produit['solde']) . '€</p>';
                echo '</div>';
                if (is_null($produit['note'])) {
                    echo '<p style="text-align: center; padding-bottom:10px; color:yellow;">Pas d\'avis</p>';
                } else {
                    etoile($produit['note']);
                }
                echo '</div></a>';
            }

            $req_best_product->closeCursor();
            ?>
        </div>
    </section>
    <?php
    include("include/footer.php");
    ?>
</body>

</html>