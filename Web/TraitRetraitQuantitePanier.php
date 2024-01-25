<?php
require_once("include/connect.inc.php");

$idUtilisateur = $_SESSION['connected'];

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['idProduitMoins'])) {
    $idProduit = htmlentities($_POST['idProduitMoins']);

    // On récupère la couleur et l'etat du produit selectionné dans le panier
    $SelectPanierProduit = $conn->prepare("SELECT couleur, etat, quantite FROM Panier WHERE idUtilisateur = :idUtilisateur AND idProduit = :idProduit");

    $SelectPanierProduit->bindParam(':idUtilisateur', $idUtilisateur);
    $SelectPanierProduit->bindParam(':idProduit', $idProduit);

    $SelectPanierProduit->execute();

    // On fetch le résultat sous forme de tableau associatif
    $panierProduit = $SelectPanierProduit->fetch(PDO::FETCH_ASSOC);

    if ($panierProduit['quantite'] > 1) {
        // On met à jour la quantité dans le panier
        $ReducePanierProduit = $conn->prepare("UPDATE Panier SET quantite = quantite - 1 WHERE idUtilisateur = :idUtilisateur AND idProduit = :idProduit");
        $ReducePanierProduit->bindParam(':idUtilisateur', $idUtilisateur);
        $ReducePanierProduit->bindParam(':idProduit', $idProduit);

        if ($ReducePanierProduit->execute()) {
            header("Location: panier.php"); // Utilisez header() pour rediriger l'utilisateur
            exit(); // Assurez-vous d'arrêter l'exécution du script après la redirection
        } else {
            echo "Erreur lors du retrait d'un produit.";
        }
    } else {
        echo '<script language="JavaScript" type="text/javascript">';
        echo 'alert("Quantite minimale du produit atteint!");';
        echo 'window.location.replace("panier.php");';
        echo '</script>';
    }
} else {
    echo 'Accès non autorisé';
}
?>