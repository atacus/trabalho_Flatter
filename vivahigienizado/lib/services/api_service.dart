import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

/// Serviço principal de comunicação com a API Viva Higienizado
class ApiService {
  static const String baseUrl = "https://vivahigienizado.com.br";

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  // ============================================================
  // UTILITÁRIOS PRIVADOS
  // ============================================================

  Future<String?> _getToken() async {
    return await storage.read(key: "auth_token");
  }

  Future<Map<String, String>> _headers({bool json = true}) async {
    final token = await _getToken();

    if (token == null) {
      throw Exception("Token não encontrado. Faça login novamente.");
    }

    final headers = {
      "Authorization": "Token $token",
      "Accept": "application/json",
    };

    if (json) headers["Content-Type"] = "application/json";

    return headers;
  }

  // ============================================================
  // LOGIN / LOGOUT
  // ============================================================

  /// Retorna true apenas se login bem-sucedido
  Future<bool> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/api/token-auth/");

    try {
      final response = await http.post(url, body: {
        "username": username,
        "password": password,
      });

      if (response.statusCode != 200) return false;

      final decoded = jsonDecode(response.body);
      if (decoded["token"] == null) return false;

      await storage.write(key: "auth_token", value: decoded["token"]);
      return true;
    } catch (e) {
      print("Erro no login: $e");
      return false;
    }
  }

  Future<void> logout() async {
    await storage.delete(key: "auth_token");
  }

  // ============================================================
  // LISTAR SERVIÇOS
  // ============================================================

  /// Retorna uma lista de Map<String,dynamic> de serviços
  Future<List<Map<String, dynamic>>> getServicos() async {
    final headers = await _headers();
    final url = Uri.parse("$baseUrl/api/servicos/");

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return List<Map<String, dynamic>>.from(decoded);
        } else {
          throw Exception("Resposta inesperada da API");
        }
      } catch (e) {
        throw Exception(
            "Falha ao decodificar serviços: possivelmente sessão expirada ou HTML retornado");
      }
    }

    throw Exception("Erro ao carregar serviços: ${response.statusCode}");
  }

  // ============================================================
  // CRIAR SERVIÇO
  // ============================================================

  Future<Map<String, dynamic>> criarServico({
    required String nomeCliente,
    required String telefone,
    required String email,
    required String descricao,
  }) async {
    final headers = await _headers();
    final url = Uri.parse("$baseUrl/api/servicos/");

    final body = jsonEncode({
      "nome_cliente": nomeCliente,
      "telefone": telefone,
      "email": email,
      "descricao": descricao,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Erro ao criar serviço: ${response.statusCode}");
  }

  // ============================================================
  // ATUALIZAR SERVIÇO COMPLETO (TEXTO + MÍDIA + GPS)
  // ============================================================

  Future<bool> atualizarServicoCompleto({
    required int servicoId,
    String? titulo,
    String? descricao,
    File? imagemAntes,
    File? imagemDepois,
    File? video,
    required double latitude,
    required double longitude,
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception("Token não encontrado.");

    final url = Uri.parse("$baseUrl/api/servicos/$servicoId/update-completo/");

    final req = http.MultipartRequest("POST", url);
    req.headers["Authorization"] = "Token $token";
    req.headers["Accept"] = "application/json";

    // Adiciona campos de texto, se fornecidos
    if (titulo != null) req.fields["titulo"] = titulo;
    if (descricao != null) req.fields["descricao"] = descricao;

    // Adiciona coordenadas GPS
    req.fields["latitude"] = latitude.toString();
    req.fields["longitude"] = longitude.toString();

    // Adiciona arquivos, se fornecidos
    if (imagemAntes != null) {
      req.files.add(await http.MultipartFile.fromPath("imagem_antes", imagemAntes.path));
    }
    if (imagemDepois != null) {
      req.files.add(await http.MultipartFile.fromPath("imagem_depois", imagemDepois.path));
    }
    if (video != null) {
      req.files.add(await http.MultipartFile.fromPath("video", video.path));
    }

    final resp = await req.send();
    return resp.statusCode == 200 || resp.statusCode == 201;
  }
}

