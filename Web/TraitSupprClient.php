<?php
session_start();

if (!isset($_SESSION['connected']) || $_SESSION['role'] == 'client') {
    header('location: index.php');
    exit();
}

include("include/connect.inc.php");

$idUtilisateur = htmlentities($_POST['idUtilisateur']);

$requete = $conn->prepare("CALL SupprimerClient(:idUtilisateur)");
$requete->execute(["idUtilisateur" => $idUtilisateur]);

echo "<script type='text/javascript'>
alert('Le client a été supprimé');
window.location.replace('gestionClient.php');
</script>";
die();

?>
