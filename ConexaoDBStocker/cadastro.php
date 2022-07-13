<?php
require("conexao.php");

header("Access-Control-Allow-Origin: *");
header("Access—Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");

try {
    $nome_empresa = $_POST["nome_empresa"];
    $cnpj = $_POST["cnpj"];
    $email = $_POST["email"];
    $endereco = $_POST["endereco"];
    $cidade = $_POST["cidade"];
    $estado = $_POST["estado"];
    $ganho_mensal = floatval($_POST["ganho_mensal"]);
    $telefone = $_POST["telefone"];
    # '".$empresa."','".$cnpj."','".$email."','".$endereco."','".$cidade."','".$estado."".$ganho_mensal."','".$telefone."','


    $querySt = "INSERT INTO usuario_dados (nome_empresa, cnpj, email, endereco, cidade, estado, ganho_mensal, telefone) VALUES('" . $nome_empresa . "','" . $cnpj . "','" . $email . "','" . $endereco . "','" . $cidade . "','" . $estado . "','$ganho_mensal','" . $telefone . "')";
    $statement = $pdo->prepare($querySt);

    $statement->execute();
} catch (Exception $e) {
    echo "Erro ao cadastrar! " . $e;
}
