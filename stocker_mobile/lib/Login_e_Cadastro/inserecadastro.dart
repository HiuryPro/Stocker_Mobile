import 'package:supabase/supabase.dart';

import '../services/supabase.databaseService.dart';

class InsereCadastro {
  DataBaseService authDBNotifier = DataBaseService();

  insereAdministrador(
      GotrueSessionResponse response, String nome, String telefone) async {
    Map<String, dynamic> map = {
      "id": response.user!.id,
      "nomeAdministrador": nome,
      "email": response.user!.email,
      "telefone": telefone
    };
    await authDBNotifier.insert(tabela: "Usuario", map: map);
  }

  insereEndereco(List<dynamic> itens) async {
    Map<String, dynamic> endereco = {
      'logradouro': itens[0],
      'numero': int.parse(itens[1]),
      'bairro': itens[2],
      'cidade': itens[3].text,
      'estado': itens[4],
      'cep': itens[5].text,
      'complemento': itens[6].text
    };
    var dados = await authDBNotifier.insert(tabela: "Endereco", map: endereco);
    return dados[0]['idEndereco'];
  }

  insereEmpresa(GotrueSessionResponse response, List<dynamic> itens) async {
    Map<String, dynamic> empresa = {
      'idAdministrador': response.user!.id,
      'idEndereco': itens[0],
      'nomeEmpresa': itens[1],
      'cnpj': itens[2],
      'inscricaoEstadual': itens[3],
      'telefone': itens[4],
      'ganho_mensal': double.parse(itens[5])
    };
    await authDBNotifier.insert(tabela: "Empresa", map: empresa);
  }
}
