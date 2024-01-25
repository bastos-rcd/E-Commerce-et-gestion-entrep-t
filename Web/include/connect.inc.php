<?php
try {
    $user = 'saemysql04';
    $password = 'E3aRtLp4e646Fn';
    $conn = new PDO('mysql:host=localhost;dbname=saemysql04;charset=UTF8', $user, $password);
} catch (PDOException $e) {
    echo "Erreur: " . $e->getMessage() . "<br>";
}
?>