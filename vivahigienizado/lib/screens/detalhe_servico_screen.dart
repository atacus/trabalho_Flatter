// /lib/screens/detalhe_servico_screen.dartg
import 'package:flutter/material.dart';
import 'package:vivahigienizado/models/servico_model.dart';

class DetalheServicoScreen extends StatelessWidget {
  final ServicoModel servico;

  const DetalheServicoScreen({super.key, required this.servico});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(servico.titulo), // corrigido (não existe "nome")
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // --- Título grande ---
            Text(
              servico.titulo,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // --- Descrição ---
            Text(
              servico.descricao,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // --- Informações do serviço ---
            const Text(
              "Informações do Serviço",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            _infoTile("Número:", servico.numero.toString()),
            _infoTile("Criado em:", servico.criadoEm),
            _infoTile("Posição Geográfica:", servico.posicaoGeografica),
            _infoTile("GMS / OS:", servico.gmsOs),

            const SizedBox(height: 20),

            // --- Fotos ---
            if (servico.imagens.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Imagens",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: servico.imagens.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 150,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200],
                            image: DecorationImage(
                              image: NetworkImage(servico.imagens[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            else
              const Text("Nenhuma imagem disponível"),

            const SizedBox(height: 20),

            // --- Vídeos ---
            if (servico.videos.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Vídeos",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Aqui você pode integrar um player no futuro
                  ...servico.videos.map((video) => ListTile(
                        leading: const Icon(Icons.play_circle_fill),
                        title: Text(video),
                        onTap: () {
                          // TODO: abrir vídeo
                        },
                      )),
                ],
              )
            else
              const Text("Nenhum vídeo disponível"),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label ",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}

