<?php
require("conexao.php");

header("Access-Control-Allow-Origin: *");
header("Access—Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");


$makeQuery = "SELECT login , senha  FROM usuario_login ";
$statement = $pdo->prepare($makeQuery);
$statement->execute();
$myarray = array();

while ($resultsFrom = $statement ->fetch()){
array_push(
$myarray,array(
"login"=>$resultsFrom['login'],
"senha"=>$resultsFrom['senha'],
)
);
}
echo json_encode($myarray);