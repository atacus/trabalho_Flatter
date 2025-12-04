// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/lista_servicos_screen.dart';
import 'screens/captura_midia_screen.dart'; // tela que captura foto, vídeo e GPS
import 'models/servico_model.dart';

void main() {
  runApp(const VivaHigienizadoApp());
}

class VivaHigenizadoTheme {
  static const azulEscuro = Color(0xFF1D4F73);
  static const azulMedio = Color(0xFF206A8D);
}

class VivaHigienizadoApp extends StatelessWidget {
  const VivaHigienizadoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VIVA HIGIENIZADO TURIS',
      theme: ThemeData(
        primaryColor: VivaHigenizadoTheme.azulMedio,
        colorScheme: ColorScheme.fromSeed(
          seedColor: VivaHigenizadoTheme.azulMedio,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (ctx) => const LoginScreen(),
        '/listaServicos': (ctx) => const ListaServicosScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detalheServico') {
          final servico = settings.arguments as ServicoModel;
          return MaterialPageRoute(
            builder: (_) => CapturaMidiaScreen(
              servicoId: servico.id,
              titulo: servico.titulo,
              descricao: servico.descricao,
            ),
          );
        }
        return null;
      },
    );
  }
}

