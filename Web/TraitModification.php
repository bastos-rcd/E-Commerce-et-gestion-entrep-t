<?php
//Liaison avec la base de données
include("include/connect.inc.php");

//Initialisation de la session
session_start();

//Récupération des données du formulaire
$nom = htmlentities($_POST['nom']);
$mdp = htmlentities($_POST['passwordA']);
$mdp2 = htmlentities($_POST['passwordB']);
$genre = htmlentities($_POST['genre']);
$numAdr = htmlentities($_POST['num_adresse']);
$adresse = htmlentities($_POST['adresse']);
$adrVille = htmlentities($_POST['ville']);
$adrCP = htmlentities($_POST['code_postal']);
$telephone = htmlentities($_POST['telephone']);
$email = htmlentities($_POST['email']);
$mdpRecherche = false;

if ($_POST['passwordA'] != "" || $_POST['passwordB'] != "") {
    //Vérification des mots de passe
    if (($_POST['passwordA'] != "" && $_POST['passwordB'] == "") || ($_POST['passwordA'] == "" && $_POST['passwordB'] != "")) {
        echo '<script language="JavaScript" type="text/javascript">';
        echo 'alert("Veuillez remplir les deux champs de mot de passe !");';
        echo 'window.location.replace("client.php");';
        echo '</script>';
        die();
    }

    //Comparaison des mots de passe
    if (isset($_POST['passwordA']) && isset($_POST['passwordB']) && $mdp == $mdp2) {
        echo '<script language="JavaScript" type="text/javascript">';
        echo 'alert("Les mots de passe sont identiques !");';
        echo 'window.location.replace("client.php");';
        echo '</script>';
        die();
    }

    //Vérification du mot de passe
    $pattern = "/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,16}$/";
    if (!preg_match($pattern, $mdp)) {
        echo '<script language="JavaScript" type="text/javascript">';
        echo 'alert("Le mot de passe doit contenir entre 8 et 16 caractères, au moins une lettre minuscule, une lettre majuscule, un chiffre et un caractère spécial !");';
        echo 'window.location.replace("client.php");';
        echo '</script>';
        die();
    }

    $mdpRecherche = true;
}


//Vérification du numéro de téléphone (français)
$pattern = "/^0[1-9]([-. ]?[0-9]{2}){4}$/";
if (!preg_match($pattern, $telephone)) {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Le numéro de téléphone n\'est pas valide !");';
    echo 'window.location.replace("client.php");';
    echo '</script>';
    die();
}

//Vérification du email
$pattern = "/^[a-z0-9._-]+@[a-z0-9._-]{2,}\.[a-z]{2,4}$/";
if (!preg_match($pattern, $email)) {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("L\'adresse mail n\'est pas valide !");';
    echo 'window.location.replace("client.php");';
    echo '</script>';
    die();
}

//Vérification du code postal
$pattern = "/^[0-9]{5}$/";
if (!preg_match($pattern, $adrCP)) {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Le code postal n\'est pas valide !");';
    echo 'window.location.replace("connexion.php");';
    echo '</script>';
    die();
}
//Vérification du numéro, de la rue et de la ville (3, chiffres pour numéro, 30 caractères, spéciaux inclus, pour rue et 15 pour ville)
$pattern = "/^[0-9]{1,3}$/";
if (!preg_match($pattern, $numAdr)) {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Le numéro de rue n\'est pas valide !");';
    echo 'window.location.replace("connexion.php");';
    echo '</script>';
    die();
}
$pattern = "/^[a-zA-Z0-9\s\-\,\.\' ]{1,30}/";
if (!preg_match($pattern, $adresse)) {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Le nom de rue n\'est pas valide !");';
    echo 'window.location.replace("connexion.php");';
    echo '</script>';
    die();
}
$pattern = "/^[a-zA-Z0-9\s\-\,\.\' ]{1,15}$/";
if (!preg_match($pattern, $adrVille)) {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Le nom de ville n\'est pas valide !");';
    echo 'window.location.replace("connexion.php");';
    echo '</script>';
    die();
}

//Hashage du mot de passe
$mdp = hash("sha256", $mdp);

try {
    if ($genre == "Mr") {
        $genre = "Mr";
    } else {
        $genre = "Mme";
    }

    //Modification des informations
    if ($mdpRecherche) {
        $requete = $conn->prepare("CALL ModifierClient(:idUtilisateur, :nom, :email, :mdp, :genre, :adrNum, :adresse, :adrVille, :adrCodePostale, :telephone)");
        $requete->execute(['idUtilisateur' => $_SESSION['connected'], 'nom' => $nom, 'email' => $email, 'mdp' => $mdp, 'genre' => $genre, 'adrNum' => $numAdr, 'adresse' => $adresse, 'adrVille' => $adrVille, 'adrCodePostale' => $adrCP, 'telephone' => $telephone]);
    } else {
        $mdp = NULL;
        $requete = $conn->prepare("CALL ModifierClient(:idUtilisateur, :nom, :email, :mdp, :genre, :adrNum, :adresse, :adrVille, :adrCodePostale, :telephone)");
        $requete->execute(['idUtilisateur' => $_SESSION['connected'], 'nom' => $nom, 'email' => $email, 'mdp' => $mdp, 'genre' => $genre, 'adrNum' => $numAdr, 'adresse' => $adresse, 'adrVille' => $adrVille, 'adrCodePostale' => $adrCP, 'telephone' => $telephone]);

    }

    //Redirection vers la page d'information
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Les informations ont bien été enregistrées !");';
    echo 'window.location.replace("client.php");';
    echo '</script>';
    die();

} catch (PDOException $e) {
    //Traitement des erreurs
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Problème de connexion, veuillez réessayer plus tard !");';
    echo 'window.location.replace("client.php");';
    echo '</script>';
    die();
}
?>