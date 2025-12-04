// lib/models/servico_model.dart

class ServicoModel {
  final int numero; // Primary key do Django
  final String titulo;
  final String descricao;
  final String criadoEm; // Formato: "dd/MM/yyyy HH:mm"
  final String posicaoGeografica; // Novo campo
  final String gmsOs; // Novo campo GMS_OS
  final List<String> imagens; // Lista de URLs de imagens do serviço

  ServicoModel({
    required this.numero,
    required this.titulo,
    required this.descricao,
    required this.criadoEm,
    required this.posicaoGeografica,
    required this.gmsOs,
    List<String>? imagens,
  }) : imagens = imagens ?? [];

  // Getter id para compatibilidade
  int get id => numero;

  // Getter compatível com tela que usa 'gpsOs'
  String get gpsOs => gmsOs;

  // Conversão de JSON para modelo
  factory ServicoModel.fromJson(Map<String, dynamic> json) {
    // Montar lista de imagens a partir dos campos do backend (exemplo: antes/depois)
    List<String> listaImagens = [];
    if (json['imagem_antes'] != null && json['imagem_antes'] != '') {
      listaImagens.add(json['imagem_antes']);
    }
    if (json['imagem_depois'] != null && json['imagem_depois'] != '') {
      listaImagens.add(json['imagem_depois']);
    }

    return ServicoModel(
      numero: json['numero'] ?? 0,
      titulo: json['titulo'] ?? '',
      descricao: json['descricao'] ?? '',
      criadoEm: json['criado_em'] ?? '',
      posicaoGeografica: json['posicao_geografica'] ?? 'Não Realizado',
      gmsOs: json['GMS_OS'] ?? '',
      imagens: listaImagens,
    );
  }

  // Conversão do modelo para JSON
  Map<String, dynamic> toJson() {
    return {
      'numero': numero,
      'titulo': titulo,
      'descricao': descricao,
      'criado_em': criadoEm,
      'posicao_geografica': posicaoGeografica,
      'GMS_OS': gmsOs,
      'imagens': imagens,
    };
  }
}

