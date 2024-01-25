<?php
session_start();
if (!isset($_GET['idProduit'])) {
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

    <section class="produit-unique">
        <?php
        require_once('include/connect.inc.php');
        require_once('etoile.php');

        if(!isset($_COOKIE['historique'])){
            setcookie('historique', $_GET['idProduit'], time() + 30*24*3600);
        } else{
            $liste = explode(",", $_COOKIE['historique']);
            if(!in_array($_GET['idProduit'], $liste)){
                if(count($liste) == 10){
                    array_shift($liste);
                }
                $liste[] = $_GET['idProduit'];
                setcookie('historique', implode(",", $liste), time() + 30*24*3600);
            } else {
                $index = array_search($_GET['idProduit'], $liste);
                unset($liste[$index]);
                $liste[] = $_GET['idProduit'];
                setcookie('historique', implode(",", $liste), time() + 30*24*3600);
            }
        
        }

        $req_product = $conn->prepare("SELECT P.idProduit, P.nom, P.prix, P.solde, P.description, P.note, C.idCategorie, C.nom AS categ, S.nom AS marque FROM Produit P, Categorie C, SousCategorie S WHERE P.idProduit = :idProduit AND S.idProduit = P.idProduit AND C.idCategorie = S.idCategorie;");
        $req_product->execute(["idProduit" => htmlentities($_GET["idProduit"])]);

        $produit = $req_product->fetch();

        $count = $req_product->rowCount();
        if ($count == 0) {
            echo '<script language="JavaScript" type="text/javascript">';
            echo 'alert("Ce produit n\'existe pas !");';
            echo 'window.history.back();';
            echo '</script>';
            exit();
        }

        echo '<img src="include/img/produit/' . $produit['idProduit'] . '.jpg">';
        echo '<div>';
        echo '<h1>' . $produit['nom'] . '</h1>';
        echo '<h3>';
        echo '<a href="boutique.php?marque=' . $produit['marque'] . '">' . $produit['marque'] . '</a>';
        echo ' - ';
        echo '<a href="boutique.php?categ=' . $produit['idCategorie'] . '">' . $produit['categ'] . '</a>';
        echo '</h3>';
        if (is_null($produit['note'])) {
            echo '<p style="color:yellow;">Pas d\'avis</p>';
        } else {
            etoile($produit['note']);
        }
        echo '<hr>';

        if ((float) $produit['solde'] != 1.00) {
            echo '<h2>' . ((float) $produit['solde'] * (float) $produit['prix']) . '€ <strike style="color:red;">' . $produit['prix'] . '€</strike></h2>';
        } else {
            echo '<h2>' . $produit['prix'] . '€</h2>';
        }
        echo '<form action="TraitAjoutPanier.php" method="post">';
        echo '<input type="text" value="' . $produit['idProduit'] . '" name="idProduit" hidden>';
        echo '<input type="submit" value="Ajouter au panier" name="ajout-panier">';
        echo '<hr><div>';

        $req_couleur = $conn->prepare("SELECT DISTINCT couleur FROM Stock WHERE idProduit = :idProduit;");
        $req_couleur->execute(["idProduit" => $produit["idProduit"]]);

        echo '<select name="couleur">';
        while ($couleur = $req_couleur->fetch()) {
            echo '<option value="' . $couleur['couleur'] . '">' . $couleur['couleur'] . '</option>';
        }
        echo '</select>';

        $req_couleur->closeCursor();

        echo '<select name="etat">';
        echo '<option value="Bon état">Bon état</option>';
        echo '<option value="Très bon état">Très bon état</option>';
        echo '<option value="Parfait état">Parfait état</option>';
        echo '</select></div></form><hr>';
        echo '<p>' . $produit['description'] . '</p>';
        echo '</div>';

        $req_product->closeCursor();
        ?>
    </section>

    <section class="avis">
        <?php
        require_once('include/connect.inc.php');
        require_once('etoile.php');

        $req_avis = $conn->prepare("SELECT A.idUtilisateur, U.nom, A.note, A.avis, A.reponse FROM Avis A, Utilisateur U WHERE U.idUtilisateur = A.idUtilisateur AND A.idProduit = :idProduit;");
        $req_avis->execute(["idProduit" => htmlentities($_GET["idProduit"])]);

        if ($req_avis->rowCount() > 0) {
            echo '<h2>Avis</h2>';

            while ($avis = $req_avis->fetch()) {
                echo '<div>';
                echo '<h3>' . $avis['nom'] . '</h3>';
                etoile((float) $avis['note']);
                echo '<p>' . $avis['avis'] . '</p>';
                if (!empty($avis['reponse'])) {
                    echo '<h4>Réponse</h4>';
                    echo '<p>' . $avis['reponse'] . '</p>';
                } else if (isset($_SESSION['role']) && $_SESSION['role'] == "admin") {
                    echo '<form action="TraitReponse.php" method="post">';
                    echo '<input type="text" value="' . htmlentities($_GET["idProduit"]) . '" name="idProduit" hidden>';
                    echo '<input type="text" value="' . $avis['nom'] . '" name="nom" hidden>';
                    echo '<input type="text" value="' . $avis['avis'] . '" name="avis" hidden>';
                    echo '<input type="text" value="' . $avis['note'] . '" name="note" hidden>';
                    echo '<input type="text" value="' . $avis['idUtilisateur'] . '" name="idUtilisateur" hidden>';
                    echo '<div><textarea value="' . $avis['reponse'] . '" name="reponse">Votre réponse</textarea></div>';
                    echo '<div><input type="submit" value="Envoyer" name="ajout-reponse"></div>';
                    echo '</form>';
                }
                echo '</div>';
                echo '<br>';
            }
        }

        $req_avis->closeCursor();
        ?>

        <?php


        if (isset($_SESSION['connected']) && $_SESSION['role'] == "client") {
            $req_avis = $conn->prepare("SELECT idUtilisateur FROM Avis WHERE idProduit = :idProduit AND idUtilisateur = :idUtilisateur;");
            $req_avis->execute(["idProduit" => htmlentities($_GET["idProduit"]), "idUtilisateur" => htmlentities($_SESSION['connected'])]);
            $res = $req_avis->fetch();
            $result = $req_avis->rowCount();

            if ($result == 0) {
                echo "<h2>Donnez votre avis</h2>";
                echo '<form action="TraitAvis.php" method="post">';
                echo '<input type="text" value="' . htmlentities($_GET["idProduit"]) . '" name="idProduit" hidden>';
                echo '<input type="number" min="0" max="5" step="0.1" name="note" placeholder="Note">';
                echo '<br><br>';
                echo '<textarea name="avis" placeholder="Avis"></textarea>';
                echo '<br><br>';
                echo '<input type="submit" value="Envoyer">';
                echo '</form>';
            }

            $req_avis->closeCursor();
        }


        ?>
    </section>

    <?php
    include("include/footer.php");
    ?>
</body>

</html>