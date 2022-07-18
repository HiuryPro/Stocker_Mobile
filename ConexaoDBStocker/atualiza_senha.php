<?php
require("conexao.php");

header("Access-Control-Allow-Origin: *");
header("Access—Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
header('Content-Type: application/json');

try {

    $senha = $_POST["senha"];
    $ns =  intval($_POST['ns']);
    $id =  intval($_POST['id']);


    $stmt = $pdo->prepare('UPDATE usuario_login SET senha = ? , nova_senha = ? WHERE id = ?');
    $stmt->execute([$senha, $ns, $id]);

    echo $stmt->rowCount();
} catch (PDOException $e) {
    echo 'Error: ' . $e->getMessage();
}
