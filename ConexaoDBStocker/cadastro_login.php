<?php
require("conexao.php");

header("Access-Control-Allow-Origin: *");
header("Access—Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");

try {
    $login = $_POST["login"];
    $senha = $_POST["senha"];
    # '".$empresa."','".$cnpj."','".$email."','".$endereco."','".$cidade."','".$estado."".$ganho_mensal."','".$telefone."','


    $querySt = "INSERT INTO usuario_login (login, senha, confirma_login) VALUES('" . $login . "','" . $senha . "','0')";
    $statement = $pdo->prepare($querySt);

    $statement->execute();
} catch (Exception $e) {
    echo "Erro ao cadastrar! " . $e;
}
