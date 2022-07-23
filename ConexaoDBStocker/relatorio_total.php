<?php

require("conexao.php");

header("Access-Control-Allow-Origin: *");
header("Access—Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");


$teste;
$teste2;

$dedata = $_POST['dedata'];
$atedata = $_POST['atedata'];


try {
    $makeQuery3 = "UPDATE relatoriototal set qtd_total = 0, preco_total = 0";
    $statement3 = $pdo->prepare($makeQuery3);
    $statement3->execute();

    echo ("Atualizou");
} catch (Exception $e) {
    echo 'Exceção capturada: ',  $e->getMessage(), "\n";
}




try {
    $makeQuery = "SELECT nome_produto  FROM produto_venda  where (data_saida BETWEEN STR_TO_DATE( '" . $dedata . "' , \"%d/%m/%Y\") AND STR_TO_DATE( '" . $atedata . "' , \"%d/%m/%Y\"))";
    $statement = $pdo->prepare($makeQuery);
    $statement->execute();


    while ($resultsFrom = $statement->fetch()) {
        try {
            $makeQuery2 = "SELECT SUM(quantidade), SUM(total)  FROM produto_venda  where (data_saida BETWEEN STR_TO_DATE( '" . $dedata . "' , \"%d/%m/%Y\") AND STR_TO_DATE( '" . $atedata . "' , \"%d/%m/%Y\")) and nome_produto = '" . $resultsFrom['nome_produto'] . "' ORDER BY data_saida ";
            $statement2 = $pdo->prepare($makeQuery2);
            $statement2->execute();


            while ($resultsFrom2 = $statement2->fetch()) {
                $teste = $resultsFrom2['SUM(quantidade)'];
                $teste2 = $resultsFrom2['SUM(total)'];

                try {
                    $makeQuery3 = "UPDATE relatoriototal set qtd_total = $teste, preco_total = $teste2 where nome_produto = '" . $resultsFrom['nome_produto'] . "'";
                    $statement3 = $pdo->prepare($makeQuery3);
                    $statement3->execute();

                    echo ("Atualizou");
                } catch (Exception $e) {
                    echo 'Exceção capturada: ',  $e->getMessage(), "\n";
                }
            }
        } catch (Exception $e) {

            echo "Exceção capturada: ", $e->getMessage(), "\n";
        }
    }

    echo $teste, $teste2;
} catch (Exception $e) {

    echo "Exceção capturada: ", $e->getMessage(), "\n";
}
