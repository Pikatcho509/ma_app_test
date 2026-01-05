import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await _auth.signInWithEmail(_emailController.text.trim(), _passwordController.text.trim());
      // On success, Firebase auth state listener in main.dart will navigate to Home
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) => (v == null || !v.contains('@')) ? 'Email invalide' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Mot de passe'),
                  obscureText: true,
                  validator: (v) => (v == null || v.length < 6) ? 'Mot de passe trop court' : null,
                ),
                const SizedBox(height: 16),
                if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 8),
                _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(child: const Text('Se connecter'), onPressed: _submit),
                TextButton(
                  child: const Text("S'inscrire"),
                  onPressed: () => Navigator.pushReplacementNamed(context, '/signup'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
