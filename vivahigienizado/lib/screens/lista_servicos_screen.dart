// lib/screens/lista_servicos_screen.dart

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/servico_model.dart';
import '../services/login_controller.dart';

class ListaServicosScreen extends StatefulWidget {
  const ListaServicosScreen({Key? key}) : super(key: key);

  @override
  State<ListaServicosScreen> createState() => _ListaServicosScreenState();
}

class _ListaServicosScreenState extends State<ListaServicosScreen> {
  final ApiService api = ApiService();
  final LoginController loginCtrl = LoginController(ApiService());
  bool loading = true;
  String? error;
  List<ServicoModel> servicos = [];

  final Color azulEscuro = const Color(0xFF1D4F73);
  final Color azulMedio = const Color(0xFF206A8D);
  final Color cinzaClaro = const Color(0xFFD9D9D9);
  final Color texto = const Color(0xFF333333);

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final lista = await api.getServicos();
      // Converter lista dinâmica para List<ServicoModel>
      servicos = lista.map((e) => ServicoModel.fromJson(e)).toList();
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = "Falha ao carregar serviços: $e";
        loading = false;
      });
    }
  }

  Future<void> _logout() async {
    await loginCtrl.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/');
  }

  Widget _card(ServicoModel s) {
    final latlng = s.posicaoGeografica;
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/detalheServico', arguments: s);
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // thumbnail (primeira imagem se existir)
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  color: cinzaClaro,
                  borderRadius: BorderRadius.circular(10),
                  image: s.imagens.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(s.imagens.first),
                          fit: BoxFit.cover)
                      : null,
                ),
                child: s.imagens.isEmpty
                    ? Icon(Icons.photo, size: 36, color: azulMedio)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("#${s.numero}",
                            style: TextStyle(
                                color: azulMedio,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(s.titulo,
                              style: TextStyle(
                                  color: azulEscuro,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      s.descricao,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: texto),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: azulMedio),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            latlng,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          s.gpsOs, // atualizado do backend
                          style: TextStyle(color: Colors.grey[600]),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Serviços'),
        backgroundColor: azulMedio,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregar,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _carregar,
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : error != null
                  ? Center(child: Text(error!))
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      itemCount: servicos.length,
                      itemBuilder: (_, i) => _card(servicos[i]),
                    ),
        ),
      ),
    );
  }
}

