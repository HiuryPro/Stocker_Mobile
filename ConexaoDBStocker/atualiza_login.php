<?php
require("conexao.php");

header("Access-Control-Allow-Origin: *");
header("Access—Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
header('Content-Type: application/json');

try {

    $login = $_POST["login"];
    $senha = $_POST["senha"];
    $id =  intval($_POST['id']);

    $stmt = $pdo->prepare('UPDATE usuario_login SET login = ? , senha = ? , confirma_login = 1 WHERE id = ?');
    $stmt->execute([$login, $senha, $id]);

    echo $stmt->rowCount();
} catch (PDOException $e) {
    echo 'Error: ' . $e->getMessage();
}
