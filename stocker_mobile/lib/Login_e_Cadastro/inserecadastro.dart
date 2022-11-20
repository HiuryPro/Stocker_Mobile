import 'package:supabase/supabase.dart';

import '../services/supabase.databaseService.dart';

class InsereCadastro {
  DataBaseService authDBNotifier = DataBaseService();

  insereAdministrador(GotrueSessionResponse response, String nome,
      String telefone, String cpf) async {
    Map<String, dynamic> map = {
      "Nome": nome,
      "Email": response.user!.email,
      "Telefone": telefone,
      'CPF': cpf
    };
    var resposta = await authDBNotifier.insert(tabela: "Pessoa", map: map);
    var update = await authDBNotifier.update(
        tabela: 'Usuario',
        where: {'Token': response.user!.id},
        setValue: {'IdPessoa': resposta[0]['IdPessoa']});
    print(update);
  }

  insereEmpresa(GotrueSessionResponse response, List<dynamic> itens) async {
    var idAdm = await authDBNotifier.select(
        tabela: 'Usuario',
        select: 'IdUsuario',
        where: {'Token': response.user!.id});

    print(idAdm);

    Map<String, dynamic> empresa = {
      'IdUsuario': idAdm[0]['IdUsuario'],
      'nomeEmpresa': itens[0],
      'cnpj': itens[1],
      'inscricaoEstadual': itens[2],
      'telefone': itens[3],
      'ganho_mensal': double.parse(itens[4])
    };
    var dados = await authDBNotifier.insert(tabela: "Empresa", map: empresa);
    print(dados);
    return dados[0]['IdEmpresa'];
  }

  insereEndereco(List<dynamic> itens) async {
    Map<String, dynamic> endereco = {
      'IdEmpresa': itens[0],
      'logradouro': itens[1],
      'numero': int.parse(itens[2]),
      'bairro': itens[3],
      'cidade': itens[4],
      'estado': itens[5],
      'cep': itens[6],
      'complemento': itens[7]
    };

    var end = await authDBNotifier.insert(tabela: 'Endereco', map: endereco);
    print(end);
  }
}
