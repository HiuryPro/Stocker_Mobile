import 'package:supabase/supabase.dart';

import '../services/supabase.databaseService.dart';

class InsereCadastroF {
  DataBaseService authDBNotifier = DataBaseService();

  insereEndereco(List<dynamic> itens) async {
    Map<String, dynamic> endereco = {
      'IdPessoa': itens[0],
      'logradouro': itens[1],
      'numero': int.parse(itens[2]),
      'bairro': itens[3],
      'cidade': itens[4],
      'estado': itens[5],
      'cep': itens[6],
      'complemento': itens[7]
    };
    var dados = await authDBNotifier.insert(tabela: "Endereco", map: endereco);
    return dados[0]['idEndereco'];
  }

  insereFornecedor(GotrueSessionResponse response, String nome, String telefone,
      List<dynamic> forn) async {
    Map<String, dynamic> map = {
      "Nome": nome,
      "Email": forn[2],
      "Telefone": telefone,
    };
    var idEmpresa = await authDBNotifier.selectInner(
        tabela: 'Empresa',
        select: 'IdEmpresa ,Usuario!inner(Token)',
        where: {'Usuario.Token': response.user!.id});
    print(idEmpresa);

    var resposta = await authDBNotifier.insert(tabela: "Pessoa", map: map);
    print(resposta);
    var forne = await authDBNotifier.insert(tabela: 'Fornecedor', map: {
      'IdFornecedor': resposta[0]['IdPessoa'],
      'IdEmpresa': idEmpresa[0]['IdEmpresa'],
      'Cnpj': forn[0],
      'InscricaoEstadual': forn[1]
    });
    print(forne);

    return forne[0]['IdFornecedor'];
  }
}
