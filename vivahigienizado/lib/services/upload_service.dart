//lib/services/upload_service.dart

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class UploadService {
  final String baseUrl = "https://SEU_SERVIDOR_AQUI/api"; 
  // Ex: http://192.168.0.10:8080/api

  /// Envia foto, vídeo e GPS para o backend
  Future<bool> enviarDados({
    required int numeroServico,
    File? foto,
    File? video,
    String? gps,
  }) async {

    final uri = Uri.parse("$baseUrl/servicos/$numeroServico/upload");

    final request = http.MultipartRequest("POST", uri);

    request.fields["gps"] = gps ?? "";
    request.fields["numero"] = numeroServico.toString();

    // Adiciona foto se existir
    if (foto != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "foto",
          foto.path,
          contentType: MediaType("image", "jpeg"),
        ),
      );
    }

    // Adiciona vídeo se existir
    if (video != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "video",
          video.path,
          contentType: MediaType("video", "mp4"),
        ),
      );
    }

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Erro upload: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Erro no envio: $e");
      return false;
    }
  }
}

