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

    <br><br><br><br><br><br><br><br>
    <center>
        <form class="search" action="boutique.php" method="post">
            <input type="search" name="search" placeholder="Rechercher">
            <select onclick="histo()">
                <option>--Historique--</option>
                <?php
                $liste = explode(",", $_COOKIE['historique']);
                $liste = array_reverse($liste);
                foreach($liste as $idProduit){
                    $req_produit = $conn->prepare("SELECT nom FROM Produit WHERE idProduit = :idProduit");
                    $req_produit->execute(["idProduit" => $idProduit]);
                    $produit = $req_produit->fetch();
                    echo '<option value="'.$idProduit.'">'.$produit['nom'].'</option>';
                }
                ?>
            </select>
            <script>
                function histo() {
                    var histo = document.getElementsByTagName("select")[0];
                    var idProduit = histo.options[histo.selectedIndex].value;
                    if (idProduit != "--Historique--") {
                        window.location.replace("produit.php?idProduit=" + idProduit);
                    }
                }
            </script>
        </form>
    </center>

    <form class="filtre-form" action="boutique.php" method="post">
        <section class="filtre">
            <div id="prix">
                <h2>Prix</h2>
                <select name="marge">
                    <option value="">--Choisir une marge--</option>
                    <option value="(P.prix*P.solde) >= 0 AND (P.prix*P.solde) < 100" <?php if (isset($_POST['marge']) && $_POST['marge'] == '(P.prix*P.solde) >= 0 AND (P.prix*P.solde) < 100')
                        echo 'selected'; ?>>0€ -
                        100€</option>
                    <option value="(P.prix*P.solde) >= 100 AND (P.prix*P.solde) < 200" <?php if (isset($_POST['marge']) && $_POST['marge'] == '(P.prix*P.solde) >= 100 AND (P.prix*P.solde) < 200')
                        echo 'selected'; ?>>
                        100€ - 200€</option>
                    <option value="(P.prix*P.solde) >= 200 AND (P.prix*P.solde) < 300" <?php if (isset($_POST['marge']) && $_POST['marge'] == '(P.prix*P.solde) >= 200 AND (P.prix*P.solde) < 300')
                        echo 'selected'; ?>>
                        200€ - 300€</option>
                    <option value="(P.prix*P.solde) >= 300 AND (P.prix*P.solde) < 400" <?php if (isset($_POST['marge']) && $_POST['marge'] == '(P.prix*P.solde) >= 300 AND (P.prix*P.solde) < 400')
                        echo 'selected'; ?>>
                        300€ - 400€</option>
                    <option value="(P.prix*P.solde) >= 400 AND (P.prix*P.solde) < 500" <?php if (isset($_POST['marge']) && $_POST['marge'] == '(P.prix*P.solde) >= 400 AND (P.prix*P.solde) < 500')
                        echo 'selected'; ?>>
                        400€ - 500€</option>
                    <option value="(P.prix*P.solde) >= 500 AND (P.prix*P.solde) < 600" <?php if (isset($_POST['marge']) && $_POST['marge'] == '(P.prix*P.solde) >= 500 AND (P.prix*P.solde) < 600')
                        echo 'selected'; ?>>
                        500€ - 600€</option>
                    <option value="(P.prix*P.solde) >= 600 AND (P.prix*P.solde) < 700" <?php if (isset($_POST['marge']) && $_POST['marge'] == '(P.prix*P.solde) >= 600 AND (P.prix*P.solde) < 700')
                        echo 'selected'; ?>>
                        600€ - 700€</option>
                    <option value="(P.prix*P.solde) >= 700 AND (P.prix*P.solde) < 800" <?php if (isset($_POST['marge']) && $_POST['marge'] == '(P.prix*P.solde) >= 700 AND (P.prix*P.solde) < 800')
                        echo 'selected'; ?>>
                        700€ - 800€</option>
                    <option value="(P.prix*P.solde) >= 800" <?php if (isset($_POST['marge']) && $_POST['marge'] == '(P.prix*P.solde) >= 800')
                        echo 'selected'; ?>>800€ +</option>
                </select>
            </div>
            <div id="marque">
                <h2>Marque</h2>

                <select name="marque">
                    <option value="">--Choisir une marque--</option>
                    <?php
                    require_once("include/connect.inc.php");

                    $req_marque = $conn->prepare("SELECT DISTINCT nom FROM `SousCategorie` ORDER BY nom ASC;");
                    $req_marque->execute();

                    while ($marque = $req_marque->fetch()) {
                        echo '<option value="' . $marque['nom'] . '" ' . (isset($_POST['marque']) && $_POST['marque'] == $marque['nom'] ? 'selected' : '') . '>' . $marque['nom'] . '</option>';
                    }
                    ?>
                </select>
            </div>
            <div id="ordre">
                <h2>Promos</h2>
                <div>
                    <input type="radio" name="ordre-prix" value="ASC" <?php if (isset($_POST['ordre-prix']) && $_POST['ordre-prix'] == 'ASC')
                        echo 'checked'; ?>><label>Croissant</label>
                    <input type="radio" name="ordre-prix" value="DESC" <?php if (isset($_POST['ordre-prix']) && $_POST['ordre-prix'] == 'DESC')
                        echo 'checked'; ?>><label>Décroissant</label>
                </div>
            </div>
        </section>
        <br>
        <center><input type="submit" value="Appliquer" name="filtrer"></center>
    </form>

    <section class="produit-boutique">
        <?php
        require_once("include/connect.inc.php");
        require_once("etoile.php");

        if (isset($_GET["trier"])) {
            if (htmlentities($_GET["trier"]) == 'new') {
                $req_product = $conn->prepare("SELECT idProduit, nom, prix, solde, note, dateAjout FROM Produit ORDER BY dateAjout DESC;");
                $req_product->execute();
            } else if (htmlentities($_GET["trier"]) == 'best') {
                $req_product = $conn->prepare("SELECT idProduit, nom, prix, solde, note, dateAjout FROM Produit ORDER BY note DESC;");
                $req_product->execute();
            } else {
                $req_product = $conn->prepare("SELECT idProduit, nom, prix, solde, note, dateAjout FROM Produit;");
                $req_product->execute();
            }
        } elseif (isset($_GET["categ"]) && !isset($_GET["sousCateg"])) {
            $req_product = $conn->prepare("SELECT P.idProduit, P.nom, P.prix, P.solde, P.note, P.dateAjout FROM Produit P, SousCategorie S WHERE S.idCategorie = :idCateg AND P.idProduit = S.idProduit;");
            $req_product->execute(["idCateg" => htmlentities($_GET['categ'])]);
        } elseif (isset($_GET["categ"]) && isset($_GET["sousCateg"])) {
            $req_product = $conn->prepare("SELECT P.idProduit, P.nom, P.prix, P.solde, P.note, P.dateAjout FROM Produit P, SousCategorie S WHERE S.idCategorie = :idCateg AND S.nom = :nomSC AND P.idProduit = S.idProduit;");
            $req_product->execute(["idCateg" => htmlentities($_GET['categ']), "nomSC" => htmlspecialchars($_GET['sousCateg'])]);
        } elseif (isset($_GET["marque"])) {
            $req_product = $conn->prepare("SELECT P.idProduit, P.nom, P.prix, P.solde, P.note, P.dateAjout FROM Produit P, SousCategorie S WHERE S.nom = :nomSC AND P.idProduit = S.idProduit;");
            $req_product->execute(["nomSC" => htmlentities($_GET['marque'])]);
        } elseif (!empty($_POST["search"])) {
            $req_product = $conn->prepare("SELECT DISTINCT P.idProduit, P.nom, P.prix, P.solde, P.note, P.dateAjout FROM Produit P, SousCategorie S WHERE P.nom LIKE '%" . htmlentities($_POST['search']) . "%';");
            $req_product->execute();
        } elseif (!empty($_POST["filtrer"])) {
            $marge = $_POST["marge"];
            $marque = htmlentities($_POST["marque"]);
            $ordre = isset($_POST["ordre-prix"]) ? htmlentities($_POST["ordre-prix"]) : ''; // Définir une valeur par défaut si la clé n'existe pas
        
            if (!empty($marge) && !empty($marque) && !empty($ordre)) {
                $req_product = $conn->prepare("SELECT P.idProduit, P.nom, P.prix, P.solde, P.note, P.dateAjout FROM Produit P, SousCategorie S WHERE S.nom = :nomSC AND P.idProduit = S.idProduit AND " . $marge . " ORDER BY (P.prix * P.solde) " . $ordre . ";");
                $req_product->bindParam(':nomSC', $marque);
                $req_product->execute();
            } elseif (!empty($marge) && !empty($marque)) {
                $req_product = $conn->prepare("SELECT P.idProduit, P.nom, P.prix, P.solde, P.note, P.dateAjout FROM Produit P, SousCategorie S WHERE S.nom = :nomSC AND P.idProduit = S.idProduit AND " . $marge . ";");
                $req_product->bindParam(':nomSC', $marque);
                $req_product->execute();
            } elseif (!empty($marge) && !empty($ordre)) {
                $req_product = $conn->prepare("SELECT P.idProduit, P.nom, P.prix, P.solde, P.note, P.dateAjout FROM Produit P WHERE " . $marge . " ORDER BY (prix*solde) " . $ordre . ";");
                $req_product->execute();
            } elseif (!empty($marge)) {
                $req_product = $conn->prepare("SELECT P.idProduit, P.nom, P.prix, P.solde, P.note, P.dateAjout FROM Produit P WHERE " . $marge . ";");
                $req_product->execute();
            } elseif (!empty($marque) && !empty($ordre)) {
                $req_product = $conn->prepare("SELECT P.idProduit, P.nom, P.prix, P.solde, P.note, P.dateAjout FROM Produit P, SousCategorie S WHERE S.nom = :nomSC AND P.idProduit = S.idProduit ORDER BY (P.prix*P.solde) " . $ordre . ";");
                $req_product->bindParam(':nomSC', $marque);
                $req_product->execute();
            } elseif (!empty($marque)) {
                $req_product = $conn->prepare("SELECT P.idProduit, P.nom, P.prix, P.solde, P.note, P.dateAjout FROM Produit P, SousCategorie S WHERE S.nom = :nomSC AND P.idProduit = S.idProduit ;");
                $req_product->bindParam(':nomSC', $marque);
                $req_product->execute();
            } elseif (!empty($ordre)) {
                $req_product = $conn->prepare("SELECT idProduit, nom, prix, solde, note, dateAjout FROM Produit ORDER BY (prix*solde) " . $ordre . ";");
                $req_product->execute();
            } else {
                $req_product = $conn->prepare("SELECT idProduit, nom, prix, solde, note, dateAjout FROM Produit;");
                $req_product->execute();
            }
        } else {
            $req_product = $conn->prepare("SELECT idProduit, nom, prix, solde, note, dateAjout FROM Produit;");
            $req_product->execute();
        }

        if ($req_product->rowCount() > 0) {
            $compteur = 0;

            while ($produit = $req_product->fetch()) {
                if ($compteur == 0) {
                    echo '<div class="container-produit">';
                }

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

                $compteur++;

                if ($compteur == 4) {
                    echo '</div>';
                    $compteur = 0;
                }
            }

            

            
        } else {
            echo '<br><br>';
            echo '<h1 style="text-align:center; color:aliceblue; font-family: Arial, Helvetica, sans-serif;">AUCUN PRODUIT TROUVÉ !!</h1>';
        }
        
        echo '</div><h2 style="color: white;">Packs de produits composés</h2>';

        $requete = $conn -> prepare("SELECT DISTINCT(idCompose) FROM ProduitCompose ORDER BY idCompose;");
            $requete -> execute();

            
            if ($requete->rowCount() > 0) {
                $compteur = 0;
                while ($produit = $requete->fetch()) {

                    $requeteProduits = $conn -> prepare("SELECT idProduit FROM ProduitCompose WHERE idCompose = :idCompose;");
                    $requeteProduits -> execute(["idCompose" => $produit['idCompose']]);
                    $listeProduits = $requeteProduits -> fetchAll();

                    $montant = 0;

                    for($i = 0; $i < count($listeProduits); $i++){
                        $requetePrix = $conn -> prepare("SELECT prix FROM Produit WHERE idProduit = :idProduit;");
                        $requetePrix -> execute(["idProduit" => $listeProduits[$i]['idProduit']]);
                        $prix = $requetePrix -> fetch();
                        $montant += $prix['prix'];
                    }

                    
                    if ($compteur == 0) {
                        echo '<div class="container-produit">';
                    }
    
                    echo '<a href="produitCompose.php?idProduitCompose=' . $produit['idCompose'] . '">';
                    echo '<div class="produit">';
                    echo '<img src="include/img/produit/pack'.$produit['idCompose'].'.jpg">';
                    echo '<div>';
                    echo '<p>Pack nº'.$produit['idCompose'].'</p>';
                    echo '<p>' . $montant . '€</p>';
                    echo '</div>';
                    echo '</div></a>';
    
                    $compteur++;
    
                    if ($compteur == 4) {
                        echo '</div>';
                        $compteur = 0;
                    }
                }
            }

        $req_product->closeCursor();
        ?>
    </section>

    <?php
    include("include/footer.php");
    ?>
</body>

</html>