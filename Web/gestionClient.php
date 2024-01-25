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
            <form class="search" action="gestionClient.php" method="post">
                <input type="search" name="search" placeholder="Nom client">
            </form>
        </center>
        <br>
        <?php
        require_once('include/connect.inc.php');

        if (isset($_POST['search'])) {
            $req_utilisateur = $conn->prepare("SELECT I.idUtilisateur, nom, email, telephone FROM Utilisateur U, Information I WHERE U.idUtilisateur=I.idUtilisateur AND nom LIKE '%" . htmlentities($_POST['search']) . "%' ORDER BY idUtilisateur ASC;");
            $req_utilisateur->execute();
        } else {
            $req_utilisateur = $conn->prepare("SELECT I.idUtilisateur, nom, email, telephone FROM Utilisateur U, Information I where U.idUtilisateur=I.idUtilisateur ORDER BY idUtilisateur ASC;");
            $req_utilisateur->execute();
        }

        echo '<center><table border="1" width="100%">';
        echo '<tr><th> idUtilisateur</th><th>Nom</th><th>Numero de telephone</th><th>Mail</th></tr>';
        while ($utilisateur = $req_utilisateur->fetch()) {
            
            echo '<tr>';
            echo '<form action="TraitSupprClient.php" method="post">';
            echo '<th>' . $utilisateur['idUtilisateur'] . '</th>';
            echo '<th>' . $utilisateur['nom'] . '</th>';
            echo '<input type="text" name="idUtilisateur" value="'.$utilisateur['idUtilisateur'].'" hidden>';
            echo '<th>'.$utilisateur['telephone'].'</th>';
            echo '<th>'.$utilisateur['email'].'</th>';
            echo '<th width="5%"><button type="submit" name="suprimer-utilisateur"><img src="include/img/trash-icon.png"/></button></th>';
            echo '<input type="text" name="efface" id="efface" hidden>';
            echo '</form>';
            echo '</tr>';
  
           

          $req_avis = $conn->prepare("SELECT idUtilisateur, nom, A.note, avis FROM Avis A, Produit P  WHERE idUtilisateur= :idUtilisateur  AND P.idProduit = A.idProduit");
          $req_avis->execute(["idUtilisateur" => $utilisateur['idUtilisateur']]);

            while ($avis = $req_avis->fetch()) {
                echo '<tr>';
                echo '<td>'.$avis['nom'].'</td>';
                echo '<td>' . $avis['note'] . '</td>';
                echo '<td>' . $avis['avis'] . '</td>';
                echo '</tr>';
            }

            $req_avis->closeCursor();
        }

        echo '</table></center>';
        ?>
    </section>

</body>