<?php
session_start();

if (!isset($_SESSION['connected']) || $_SESSION['role'] == 'client') {
    header('location: index.php');
    exit();
}

include("include/connect.inc.php");

$idProduit = htmlentities($_POST['idProduit']);

$requete = $conn -> prepare("SELECT * FROM Produit WHERE idProduit = :idProduit");
$requete -> execute(["idProduit" => $idProduit]);

if ($requete -> rowCount() == 0) {
    echo "<script type='text/javascript'>
    alert('Le produit n\'existe pas');
    window.history.back();
    </script>";
    die();
}


if(isset($_POST['valider-produit'])){

    if(empty($_POST['prix'])){
        echo "<script type='text/javascript'>
        alert('Le prix est vide');
        window.history.back();
        </script>";
        die();
    } 

    

    $prix = htmlentities($_POST['prix']);
    $solde = htmlentities($_POST['solde']);

    if(empty($_POST['solde'])){
        $solde = 0;
    } 

    $solde = 1 - $solde/100;

    $requete = $conn -> prepare("UPDATE Produit SET prix = :prix, solde = :solde WHERE idProduit = :idProduit");
    $requete -> execute(["prix" => $prix, "solde" => $solde, "idProduit" => $idProduit]);

    $requete = $conn -> prepare("COMMIT;");
    $requete -> execute();
} else if(isset($_POST['valider-stock'])){
    if(empty($_POST['stock'])){
        echo "<script type='text/javascript'>
        alert('Le stock est vide');
        window.history.back();
        </script>";
        die();
    }

    if(empty($_POST['seuil'])){
        echo "<script type='text/javascript'>
        alert('Le seuil est vide');
        window.history.back();
        </script>";
        die();
    }

    if(empty($_POST['couleur'])){
        echo "<script type='text/javascript'>
        alert('La couleur est vide');
        window.history.back();
        </script>";
        die();
    }

    if(empty($_POST['etat'])){
        echo "<script type='text/javascript'>
        alert('L'état est vide');
        window.history.back();
        </script>";
        die();
    }

    $stock = htmlentities($_POST['stock']);
    $seuil = htmlentities($_POST['seuil']);
    $couleur = htmlentities($_POST['couleur']);
    $etat = $_POST['etat'];

    $requete = $conn -> prepare("UPDATE Stock SET quantiteStock = :stock, seuilStock = :seuil WHERE idProduit = :idProduit AND couleur = :couleur AND etat = :etat");
    $requete -> execute(["stock" => $stock, "seuil" => $seuil, "idProduit" => $idProduit, "couleur" => $couleur, "etat" => $etat]);

    $requete = $conn -> prepare("COMMIT;");
    $requete -> execute();
}

echo "<script type='text/javascript'>
alert('Le produit a bien été modifié');
window.location.replace('gestionProduit.php');
</script>";


?>