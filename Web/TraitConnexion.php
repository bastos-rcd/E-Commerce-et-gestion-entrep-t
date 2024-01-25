<?php
//Liaison avec la base de données
include("include/connect.inc.php");

//Initialisation de la session
session_start();

//Récupération des données du formulaire
$email = htmlentities($_POST['email']);
$mdp = htmlentities($_POST['password']);

//Hashage du mot de passe
$mdp = hash("sha256", $mdp);

try {
    //Vérification de l'existence du compte
    $requete = $conn->prepare("SELECT * FROM Utilisateur WHERE email = :email");
    $requete->execute(['email' => $email]);
    $emailBDD = $requete->fetch();

    if ($emailBDD['email'] != $email) {
        echo '<script language="JavaScript" type="text/javascript">';
        echo 'alert("Ce compte n\'existe pas !");';
        echo 'window.history.back();';
        echo '</script>';
        die();
    }

    //Vérification du mot de passe
    if ($emailBDD['password'] == $mdp) {
        $_SESSION['connected'] = $emailBDD['idUtilisateur'];
        $_SESSION['role'] = $emailBDD['role'];

        if ($_POST['souvenir'] == "oui") {
            setcookie('Login', $email, time() + 30 * 24 * 3600);
        } else if (isset($_COOKIE['Login'])) {
            setcookie('Login', '', time() - 3600);
        }

        if ($emailBDD['role'] == 'admin') {
            //Redirection vers la page d'administration
            echo '<script language="JavaScript" type="text/javascript">';
            echo 'window.location.replace("gestionProduit.php");';
            echo '</script>';
            die();
        }



        //Redirection vers la page d'information
        echo '<script language="JavaScript" type="text/javascript">';
        echo 'window.location.replace("client.php");';
        echo '</script>';
        die();
    } else {
        //Redirection vers la page de connexion
        echo '<script language="JavaScript" type="text/javascript">';
        echo 'alert("Mot de passe incorrect !");';
        echo 'window.history.back();';
        echo '</script>';
        die();
    }

} catch (PDOException $e) {
    //Traitement des erreurs
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Problème de connexion, veuillez réessayer plus tard !");';
    echo 'window.history.back();';
    echo '</script>';
    die();
}
?>