<?php
require_once("include/connect.inc.php");

$idUtilisateur = $_SESSION['connected'];

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['idProduitPlus'])) {
    $idProduit = htmlentities($_POST['idProduitPlus']);

    // On récupère la couleur et l'etat du produit selectionné dans le panier
    $SelectPanierProduit = $conn->prepare("SELECT couleur, etat, quantite FROM Panier WHERE idUtilisateur = :idUtilisateur AND idProduit = :idProduit");

    $SelectPanierProduit->bindParam(':idUtilisateur', $idUtilisateur);
    $SelectPanierProduit->bindParam(':idProduit', $idProduit);

    $SelectPanierProduit->execute();

    // On fetch le résultat sous forme de tableau associatif
    $panierProduit = $SelectPanierProduit->fetch(PDO::FETCH_ASSOC);

    // On récupère la quantité en stock du produit sélectionné
    $qteProduit = $conn->prepare("SELECT quantiteStock FROM Stock WHERE idProduit = :idProduit AND couleur = :couleur AND etat = :etat");
    $qteProduit->bindParam(':idProduit', $idProduit);
    $qteProduit->bindParam(':couleur', $panierProduit['couleur']);
    $qteProduit->bindParam(':etat', $panierProduit['etat']);
    $qteProduit->execute();

    // On fetch le résultat sous forme de tableau associatif
    $stockProduit = $qteProduit->fetch(PDO::FETCH_ASSOC);

    if ($stockProduit['quantiteStock'] > $panierProduit['quantite']) {
        // On met à jour la quantité dans le panier
        $AddPanierProduit = $conn->prepare("UPDATE Panier SET quantite = quantite + 1 WHERE idUtilisateur = :idUtilisateur AND idProduit = :idProduit");
        $AddPanierProduit->bindParam(':idUtilisateur', $idUtilisateur);
        $AddPanierProduit->bindParam(':idProduit', $idProduit);

        if ($AddPanierProduit->execute()) {
            header("Location: panier.php"); // Utilisez header() pour rediriger l'utilisateur
            exit(); // Assurez-vous d'arrêter l'exécution du script après la redirection
        } else {
            echo "Erreur lors de l'ajout d'un produit en plus.";
        }
    } else {
        echo '<script language="JavaScript" type="text/javascript">';
        echo 'alert("Quantite maximale du produit atteint!");';
        echo 'window.location.replace("panier.php");';
        echo '</script>';
    }
} else {
    echo 'Accès non autorisé';
}
?>