<?php
require("conexao.php");

header("Access-Control-Allow-Origin: *");
header("Access—Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");


$makeQuery = "SELECT *  FROM usuario_login ";
$statement = $pdo->prepare($makeQuery);
$statement->execute();
$myarray = array();

while ($resultsFrom = $statement->fetch()) {
    array_push(
        $myarray,
        array(
            "id" => $resultsFrom['id'],
            "login" => $resultsFrom['login'],
            "senha" => $resultsFrom['senha'],
            "confirma_login" => $resultsFrom['confirma_login']
        )
    );
}
echo json_encode($myarray);
