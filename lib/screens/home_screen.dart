import 'package:flutter/material.dart';
import 'package:ma_app_test/firebase_stub.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final AuthService _auth = AuthService();

    return Scaffold(
      appBar: AppBar(title: const Text('Accueil')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (user != null) Text('Connecté en tant que: ${user.email}'),
            const SizedBox(height: 12),
            ElevatedButton(
              child: const Text('Planning'),
              onPressed: () => Navigator.pushNamed(context, '/planning'),
            ),
            ElevatedButton(
              child: const Text('Profil'),
              onPressed: () => Navigator.pushNamed(context, '/profile'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              child: const Text('Se déconnecter'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
