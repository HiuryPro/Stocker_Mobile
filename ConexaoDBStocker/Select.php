<?php
require("conexao.php");

header("Access-Control-Allow-Origin: *");
header("Access—Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");


$makeQuery = "SELECT * FROM produto_venda ";
$statement = $pdo->prepare($makeQuery);
$statement->execute();
$myarray = array();

while ($resultsFrom = $statement ->fetch()){
array_push(
$myarray,array(
"id"=>$resultsFrom['id'],

"nome_produto"=>$resultsFrom['nome_produto'],
"cliente"=>$resultsFrom['cliente']
)
);
}
echo json_encode($myarray);
