<?php
session_start();

if (!isset($_SESSION['connected'])) {
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
    <section class="commande">
        <h1>Mes Commandes</h1>
        <?php
        require_once('include/connect.inc.php');

        $req_commande = $conn->prepare("SELECT C.idCommande,C.montant, C.dateCommande, C.modePaiement, C.adrNumLivraison, C.adrLivraison, C.codePostaleLivraison FROM Commande C WHERE C.idUtilisateur = :idUser ORDER BY dateCommande DESC;");
        $req_commande->execute(["idUser" => $_SESSION['connected']]);
        if ($req_commande->rowCount() == 0) {
            echo "<h2>Vous n'avez passé aucune commande</h2>";
        } else {
            echo '<center><table border="1">';

            while ($commande = $req_commande->fetch()) {
                echo '<thead>';
                echo '<tr><th colspan="5">Commande numéro ' . $commande['idCommande'] . ' passée le ' . $commande['dateCommande'] . '<br>Montant total : ' . $commande['montant'] . '€</th></tr>';
                echo '</thead>';

                $req_details = $conn->prepare('SELECT P.idProduit, P.nom, D.quantite, D.couleur, D.etat FROM DetailsCommande D, Produit P WHERE P.idProduit = D.idProduit AND D.idCommande = :idCommande;');
                $req_details->execute(["idCommande" => $commande['idCommande']]);
                echo '<tbody>';
                while ($details = $req_details->fetch()) {
                    echo '<tr>';
                    echo '<td><a href="produit.php?idProduit=' . $details['idProduit'] . '"><img src="include/img/produit/' . $details['idProduit'] . '.jpg"></a></td>';
                    echo '<td>' . $details['nom'] . '</td>';
                    echo '<td>' . $details['couleur'] . '</td>';
                    echo '<td>' . $details['etat'] . '</td>';
                    echo '<td>' . $details['quantite'] . '</td>';
                    echo '</tr>';
                }
                echo '</tbody>';
            }

            echo '</table></center>';
        }
        ?>
    </section>
</body>

</html>