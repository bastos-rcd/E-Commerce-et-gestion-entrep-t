<?php
//Initialisation de la session
session_start();

//Liaison avec la BD
include("include/connect.inc.php");

//Récupération des données du formulaire
$nom = htmlentities("" . $_POST['prenom'] . " " . $_POST['nom']);
$mdp = htmlentities($_POST['password']);
$role = "client";
$genre = htmlentities($_POST['genre']);
$numAdr = htmlentities($_POST['num_adresse']);
$adresse = htmlentities($_POST['adresse']);
$adrVille = htmlentities($_POST['ville']);
$adrCP = htmlentities($_POST['code_postal']);
$telephone = htmlentities($_POST['telephone']);
$email = htmlentities($_POST['email']);
$fidelite = 0;

//Vérification du mot de passe
$pattern = "/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,16}$/";
if (!preg_match($pattern, $mdp)) {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Le mot de passe doit contenir entre 8 et 16 caractères, au moins une lettre minuscule, une lettre majuscule, un chiffre et un caractère spécial !");';
    echo 'window.history.back();';
    echo '</script>';
    die();
}

//Vérification du numéro de téléphone (français)
$pattern = "/^0[1-9]([-. ]?[0-9]{2}){4}$/";
if (!preg_match($pattern, $telephone)) {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Le numéro de téléphone n\'est pas valide !");';
    echo 'window.history.back();';
    echo '</script>';
    die();
}

//Vérification du email
$pattern = "/^[a-z0-9._-]+@[a-z0-9._-]{2,}\.[a-z]{2,4}$/";
if (!preg_match($pattern, $email)) {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("L\'adresse mail n\'est pas valide !");';
    echo 'window.history.back();';
    echo '</script>';
    die();
}

//Vérification du genre
if ($genre != "Mr" && $genre != "Mme") {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Mettez votre genre");';
    echo 'window.history.back();';
    echo '</script>';
    die();
}

//Vérification du code postal
$pattern = "/^[0-9]{5}$/";
if (!preg_match($pattern, $adrCP)) {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Le code postal n\'est pas valide !");';
    echo 'window.history.back();';
    echo '</script>';
    die();
}

//Vérification du numéro, de la rue et de la ville
$pattern = "/^[0-9]{1,3}$/";
if (!preg_match($pattern, $numAdr)) {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Le numéro de rue n\'est pas valide !");';
    echo 'window.history.back();';
    echo '</script>';
    die();
}
$pattern = "/^[a-zA-Z0-9\s\-\,\.\' ]{1,30}/";
if (!preg_match($pattern, $adresse)) {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Le nom de rue n\'est pas valide !");';
    echo 'window.history.back();';
    echo '</script>';
    die();
}
$pattern = "/^[a-zA-Z0-9\s\-\,\.\' ]{1,15}$/";
if (!preg_match($pattern, $adrVille)) {
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Le nom de ville n\'est pas valide !");';
    echo 'window.history.back();';
    echo '</script>';
    die();
}

//Hashage du mot de passe
$mdp = hash("sha256", $mdp);


try {
    //Vérification de l'existence du compte
    $requete = $conn->prepare("SELECT email FROM Utilisateur WHERE email = :email");
    $requete->execute(['email' => $email]);
    $emailBDD = $requete->fetchAll();

    if (count($emailBDD) != 0) {
        echo '<script language="JavaScript" type="text/javascript">';
        echo 'alert("Un compte existe déjà avec cette adresse mail !");';
        echo 'window.history.back();';
        echo '</script>';
        die();
    }

    //Création du compte
    $requete = $conn->prepare("CALL AjouterClient(:nom, :email, :mdp, :genre, :adrNum, :adresse, :ville, :codePostal, :telephone);");
    $requete->execute(['nom' => $nom, 'email' => $email, 'mdp' => $mdp, 'genre' => $genre, 'adrNum' => $numAdr, 'adresse' => $adresse, 'ville' => $adrVille, 'codePostal' => $adrCP, 'telephone' => $telephone]);

    //Récupération de l'idUtilisateur
    $requete = $conn->prepare("SELECT idUtilisateur FROM Utilisateur ORDER BY idUtilisateur DESC LIMIT 1");
    $requete->execute();
    $idUtilisateur = $requete->fetch();

    //Création de la session
    $_SESSION['connected'] = $idUtilisateur['idUtilisateur'];
    $_SESSION['role'] = $role;

    //Redirection vers la page de compte
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Votre compte a bien été créé !");';
    echo 'window.location.replace("client.php");';
    echo '</script>';
    die();

} catch (PDOException $e) {
    //Traitement des erreurs
    echo '<script language="JavaScript" type="text/javascript">';
    echo 'alert("Problème de connexion, veuillez réessayer plus tard !");';
    echo 'window.history.back();';
    echo '</script>';
    die();
}
?>