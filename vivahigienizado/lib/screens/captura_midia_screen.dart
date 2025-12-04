import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:vivahigienizado/services/api_service.dart';

class CapturaMidiaScreen extends StatefulWidget {
  final int servicoId;
  final String? titulo;
  final String? descricao;

  const CapturaMidiaScreen({
    Key? key,
    required this.servicoId,
    this.titulo,
    this.descricao,
  }) : super(key: key);

  @override
  State<CapturaMidiaScreen> createState() => _CapturaMidiaScreenState();
}

class _CapturaMidiaScreenState extends State<CapturaMidiaScreen> {
  final ApiService api = ApiService();

  File? imagemAntesFile;
  File? imagemDepoisFile;
  File? videoFile;
  Uint8List? videoThumbnail;

  double latitude = 0.0;
  double longitude = 0.0;

  bool _loading = false;
  double _progress = 0.0;

  Future<void> enviarServicoCompleto() async {
    if (widget.servicoId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ID do serviço inválido.")),
      );
      return;
    }

    setState(() {
      _loading = true;
      _progress = 0.0;
    });

    try {
      final sucesso = await api.atualizarServicoCompleto(
        servicoId: widget.servicoId,
        titulo: widget.titulo,
        descricao: widget.descricao,
        imagemAntes: imagemAntesFile,
        imagemDepois: imagemDepoisFile,
        video: videoFile,
        latitude: latitude,
        longitude: longitude,
      );

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Serviço atualizado com sucesso!")),
        );
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Falha ao atualizar o serviço.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    } finally {
      setState(() {
        _loading = false;
        _progress = 0.0;
      });
    }
  }

  Future<void> selecionarArquivo(String tipo) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: tipo == "video" ? FileType.video : FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      setState(() {
        if (tipo == "imagemAntes") imagemAntesFile = file;
        if (tipo == "imagemDepois") imagemDepoisFile = file;
        if (tipo == "video") {
          videoFile = file;
          _gerarThumbnailVideo(file);
        }
      });
    }
  }

  Future<void> _gerarThumbnailVideo(File video) async {
    final thumb = await VideoThumbnail.thumbnailData(
      video: video.path,
      imageFormat: ImageFormat.PNG,
      maxWidth: 200,
      quality: 75,
    );
    if (thumb != null) {
      setState(() {
        videoThumbnail = thumb;
      });
    }
  }

  Widget _buildPreview(File? file, String tipo) {
    if (file == null) return const SizedBox.shrink();
    if (tipo == "video") {
      return Column(
        children: [
          const Text("Vídeo selecionado:"),
          if (videoThumbnail != null)
            Image.memory(videoThumbnail!, height: 150),
          Text(file.path.split("/").last),
        ],
      );
    } else {
      return Column(
        children: [
          const Text("Imagem selecionada:"),
          Image.file(file, height: 150),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Captura de Mídia"),
        bottom: _loading
            ? PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  color: Colors.greenAccent,
                ),
              )
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => selecionarArquivo("imagemAntes"),
              child: const Text("Selecionar Imagem Antes"),
            ),
            _buildPreview(imagemAntesFile, "imagem"),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => selecionarArquivo("imagemDepois"),
              child: const Text("Selecionar Imagem Depois"),
            ),
            _buildPreview(imagemDepoisFile, "imagem"),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => selecionarArquivo("video"),
              child: const Text("Selecionar Vídeo"),
            ),
            _buildPreview(videoFile, "video"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : enviarServicoCompleto,
              child: _loading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text("Enviar Serviço"),
            ),
          ],
        ),
      ),
    );
  }
}

