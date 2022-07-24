<?php
require("conexao.php");

header("Access-Control-Allow-Origin: *");
header("Access—Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");


$makeQuery = "SELECT *  FROM relatoriototal ";
$statement = $pdo->prepare($makeQuery);
$statement->execute();
$myarray = array();

while ($resultsFrom = $statement->fetch()) {
    array_push(
        $myarray,
        array(
            "id" => $resultsFrom['id'],
            "nome_produto" => $resultsFrom['nome_produto'],
            "qtd_total" => $resultsFrom['qtd_total'],
            "preco_total" => $resultsFrom['preco_total'],

        )
    );
}
echo json_encode($myarray);
