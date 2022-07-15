<?php
require("conexao.php");

header("Access-Control-Allow-Origin: *");
header("Access—Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");


$makeQuery = "SELECT *  FROM usuario_dados ";
$statement = $pdo->prepare($makeQuery);
$statement->execute();
$myarray = array();

while ($resultsFrom = $statement->fetch()) {
    array_push(
        $myarray,
        array(
            "nome_empresa" => $resultsFrom['nome_empresa'],
            "cnpj" => $resultsFrom['cnpj'],
            "email" => $resultsFrom['email'],
            "telefone" => $resultsFrom['telefone'],
            "cidade" => $resultsFrom['cidade'],
            "estado" => $resultsFrom['estado'],
            "endereco" => $resultsFrom['endereco'],
            "ganho_mensal" => $resultsFrom['ganho_mensal'],
        )
    );
}
echo json_encode($myarray);
