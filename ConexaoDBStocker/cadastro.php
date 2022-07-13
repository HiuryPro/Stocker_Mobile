<?php
require("conexao.php");

header("Access-Control-Allow-Origin: *");
header("Access—Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");

/*
$empresa = $_POST["nome_empresa"];
$cnpj = $_POST["cnpj"];
$email = $_POST["email"];
$endereco = $_POST["endereco"];
$cidade = $_POST["cidade"];
$estado = $_POST["estado"];
$ganho_mensal = (float)$_POST["ganho"];
$telefone = $_POST["telefone"];
'".$empresa."','".$cnpj."','".$email."','".$endereco."','".$cidade."','".$estado."".$ganho_mensal."','".$telefone."','
*/

$querySt = "INSERT INTO usuario_dados (nome_empresa, cnpj, email, endereco, cidade, estado, ganho_mensal, telefone) VALUES('EmpresaX', '12345678945', 'fafsfsfs@gamil.com', 'avenida poha', 'Puta','Piranha', 10000, '34988765409')";
$statement = $pdo->prepare($querySt);

$statement->execute();

echo json_encode("Inserted Data !!!");
