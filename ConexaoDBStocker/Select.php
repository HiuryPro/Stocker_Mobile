<?php 

include_once("./conexao.php");

$dados = array();

$query = $pdo->query("Select * from produto_venda");
$res = $query->fetchAll(PDO:: FETCH_ASSOC);

for($i = 0; $i < count($res);$i++){
    foreach($res[$i] as $key => $value){}
    $dados = $res;
}

echo($res) ?
json_encode(array("code" => 1, "result" => $dados)):
json_encode(array("code" => 0, message=>"Data not found" ))


?>