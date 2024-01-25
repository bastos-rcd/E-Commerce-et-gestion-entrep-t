<?php
session_start();

if (!isset($_SESSION['connected'])) {
    header('Location: index.php');
    exit();
}

include ('include/connect.inc.php');

$idCompose = $_POST['idCompose'];

// try {
    $requete = $conn -> prepare("SELECT idProduit FROM ProduitCompose WHERE idCompose = :idCompose");
    $requete -> execute(['idCompose' => $idCompose]);
    while($row = $requete -> fetch()) {
        $idProduit = $row['idProduit'];
        $couleur = $_POST['couleur' . $idProduit];
        $etat = $_POST['etat' . $idProduit];
        $requeteProduitDansPanier = $conn -> prepare("SELECT idProduit FROM Panier WHERE idUtilisateur = :idUtilisateur AND idProduit = :idProduit");
        $requeteProduitDansPanier -> execute(['idUtilisateur' => $_SESSION['connected'], 'idProduit' => $idProduit]);
        if ($requeteProduitDansPanier -> rowCount() == 0){
            $requetePanier = $conn -> prepare("INSERT INTO Panier VALUES (:idUtilisateur, :idProduit, :quantite, :couleur, :etat)");
            $requetePanier -> execute(['idUtilisateur' => $_SESSION['connected'], 'idProduit' => $idProduit, 'quantite' => 1, 'couleur' => $couleur, 'etat' => $etat]);
        } else{
            $requetePanier = $conn -> prepare("UPDATE Panier SET quantite = quantite + 1 WHERE idUtilisateur = :idUtilisateur AND idProduit = :idProduit");
            $requetePanier -> execute(['idUtilisateur' => $_SESSION['connected'], 'idProduit' => $idProduit]);
        }
        
    }

    echo '<script>
    alert("Produit composé ajouté au panier");
    window.location.replace("panier.php");
    </script>';
    
// } catch (PDOException $e) {
//     echo '<script>
//     alert("Erreur: ' . $e->getMessage() . '");
//     window.history.back();
//     </script>';

// }


?>