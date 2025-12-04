// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  final ApiService api = ApiService();

  bool loading = false;
  String? errorMsg;

  Future<void> _login() async {
    setState(() {
      loading = true;
      errorMsg = null;
    });

    bool ok = await api.login(
      _userCtrl.text.trim(),
      _passCtrl.text.trim(),
    );

    setState(() => loading = false);

    if (ok) {
      Navigator.pushReplacementNamed(context, "/listaServicos");
    } else {
      setState(() {
        errorMsg = "Usuário ou senha inválidos.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 120,
                child: Image.asset(
                  "assets/images/logo_viva.png",
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Acesso Administrativo",
                style: TextStyle(
                  color: Color(0xFF1D4F73),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              TextField(
                controller: _userCtrl,
                decoration: InputDecoration(
                  labelText: "Usuário",
                  prefixIcon: const Icon(Icons.person, color: Color(0xFF206A8D)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              TextField(
                controller: _passCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Senha",
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF206A8D)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              if (errorMsg != null)
                Text(
                  errorMsg!,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: loading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF206A8D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Entrar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "© 2025 Viva Higienizado",
                style: TextStyle(
                  color: Color(0xFFCCCCCC),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

