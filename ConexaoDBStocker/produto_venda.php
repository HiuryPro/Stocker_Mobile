<?php
require("conexao.php");

header("Access-Control-Allow-Origin: *");
header("Access—Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
//(data_saida BETWEEN STR_TO_DATE('".$dedata." ', \"%d/%m/%Y\") AND STR_TO_DATE('" $atedata " ', \"%d/%m/%Y\")) ORDER BY data_saida";

$dedata = $_POST['dedata'];
$atedata = $_POST['atedata'];

$makeQuery = "SELECT *, date_format(data_saida, '%d/%m/%Y') as datas  FROM produto_venda  where (data_saida BETWEEN STR_TO_DATE( '" . $dedata . "' , \"%d/%m/%Y\") AND STR_TO_DATE( '" . $atedata . "' , \"%d/%m/%Y\")) ORDER BY data_saida ";
$statement = $pdo->prepare($makeQuery);
$statement->execute();
$myarray = array();

while ($resultsFrom = $statement->fetch()) {
    array_push(
        $myarray,
        array(
            "id" => $resultsFrom['id'],
            "nome_produto" => $resultsFrom['nome_produto'],
            "quantidade" => $resultsFrom['quantidade'],
            "preco_unitario" => $resultsFrom['preco_unitario'],
            "total" => $resultsFrom['total'],
            "data_saida" => $resultsFrom['datas'],
            "cliente" => $resultsFrom['cliente'],
        )
    );
}
echo json_encode($myarray);
