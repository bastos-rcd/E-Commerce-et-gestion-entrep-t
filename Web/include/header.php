<header>
    <nav class="ban">
        <a href="index.php"><img src="include/img/logo.png" id="logo"></a>
        <p>Des produits abordables, une qualité maximale</p>
        <nav>
            <ul>
                <li><img src="include/img/icon-user.png" id="user">
                    <ul class="menu-deroulant">
                        <?php
                        if (!isset($_SESSION['role'])) {
                            echo '<li><a href="connexion.php">Mon Compte</a></li>';
                        } else {
                            if ($_SESSION['role'] == 'client') {
                                echo '<li><a href="connexion.php">Mon Compte</a></li>';
                                echo '<li><a href="consultationCommande.php">Consulter commandes</a></li>';
                                echo '<li><a href="panier.php">Panier</a></li>';
                            }
                        }

                        if (!empty($_SESSION['role']) && $_SESSION['role'] == 'admin') {
                            echo '<li><a href="ajouterProduit.php">Ajouter un produit</a></li>';
                            echo '<li><a href="gestionProduit.php">Gestion des produits</a></li>';
                            echo '<li><a href="gestionClient.php">Gestion des clients</a></li>';
                        }

                        if (!empty($_SESSION['connected'])) {
                            echo '<li><a href="deconnexion.php">Déconnexion</a></li>';
                        }
                        ?>
                    </ul>
                </li>
                <ul>
        </nav>
    </nav>
    <nav class="trier">
        <div class="container-trier"><a href="boutique.php">Découvrir</a></div>
        <div class="container-trier"><a href="boutique.php?trier=new">Nouveautés</a></div>
        <div class="container-trier"><a href="boutique.php?trier=best">Nos meilleures ventes</a></div>
        <nav>
            <div class="container-trier">
                <a>Catégories</a>
                <ul class="menu-deroulant">
                    <?php
                    require_once('connect.inc.php');

                    $req_categorie = $conn->prepare("SELECT idCategorie, nom FROM Categorie ORDER BY idCategorie ASC;");
                    $req_categorie->execute();

                    while ($categorie = $req_categorie->fetch()) {
                        echo '<li><a class="categ" href="boutique.php?categ=' . $categorie['idCategorie'] . '">' . $categorie['nom'] . '</a></li>';

                        $req_sous_categorie = $conn->prepare("SELECT DISTINCT nom FROM SousCategorie WHERE idCategorie = :categorie;");
                        $req_sous_categorie->execute(["categorie" => $categorie['idCategorie']]);

                        while ($sous_categorie = $req_sous_categorie->fetch()) {
                            echo '<li><a href="boutique.php?categ=' . $categorie['idCategorie'] . '&sousCateg=' . $sous_categorie['nom'] . '">' . $sous_categorie['nom'] . '</a></li>';
                        }

                        $req_sous_categorie->closeCursor();
                    }

                    $req_categorie->closeCursor();
                    ?>
                </ul>
            </div>
        </nav>
    </nav>
</header>