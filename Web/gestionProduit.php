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

    <section class="gestion-produit">
        <center>
            <form class="search" action="gestionProduit.php" method="post">
                <input type="search" name="search" placeholder="Nom produit">
            </form>
        </center>
        <br>
        <?php
        require_once('include/connect.inc.php');

        if (isset($_POST['search'])) {
            $req_produit = $conn->prepare("SELECT idProduit, nom, prix, solde FROM Produit WHERE nom LIKE '%" . htmlentities($_POST['search']) . "%' ORDER BY idProduit ASC;");
            $req_produit->execute();
        } else {
            $req_produit = $conn->prepare("SELECT idProduit, nom, prix, solde FROM Produit ORDER BY idProduit ASC;");
            $req_produit->execute();
        }

        echo '<center><table border="1" width="100%">';

        while ($produit = $req_produit->fetch()) {
            echo '<tr>';
            echo '<th>' . $produit['idProduit'] . '</th>';
            echo '<th>' . $produit['nom'] . '</th>';
            echo '<form action="TraitModifProduit.php" method="post">';
            echo '<input type="text" name="idProduit" value="'.$produit['idProduit'].'" hidden>';
            echo '<th>Prix :<input type="number" min="0" name="prix" value="' . $produit['prix'] . '">€</th>';
            echo '<th>Solde :<input type="number" min="0" max="100" name="solde" value="' . (1 - $produit['solde']) * 100 . '">%</th>';
            echo '<th width="5%"><button type="submit" name="valider-produit"><img src="include/img/valider.png"/></button></th>';
            echo '</form>';
            echo '</tr>';

            $req_stock = $conn->prepare("SELECT idProduit, couleur, etat, quantiteStock, seuilStock FROM Stock WHERE idProduit = :idProduit;");
            $req_stock->execute(["idProduit" => $produit['idProduit']]);

            while ($stock = $req_stock->fetch()) {
                if ($stock['quantiteStock'] <= $stock['seuilStock']){
                    echo '<tr style="background-color: red;">';
                } else {
                    echo '<tr>';
                }
                echo '<td>' . $stock['couleur'] . '</td>';
                echo '<td>' . $stock['etat'] . '</td>';
                echo '<form action="TraitModifProduit.php" method="post">';
                echo '<input type="text" name="idProduit" value="'.$produit['idProduit'].'" hidden>';
                echo '<input type="text" name="couleur" value="'.$stock['couleur'].'" hidden>';
                echo '<input type="text" name="etat" value="'.$stock['etat'].'" hidden>';
                echo '<td>Stock :<input type="number" min="' . $stock['seuilStock'] . '" name="stock" value="' . $stock['quantiteStock'] . '"></td>';
                echo '<td>Seuil :<input type="number" name="seuil" value="' . $stock['seuilStock'] . '"></td>';
                echo '<td><button type="submit" name="valider-stock"><img src="include/img/valider.png"/></button></td>';
                echo '</form>';
                echo '</tr>';
            }

            $req_stock->closeCursor();
        }
        $req_produit->closeCursor();
        echo '</table></center>';
        ?>
    </section>

</body>