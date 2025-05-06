import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Главная'),
            actions: [
              if (authProvider.isAuthenticated)
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await authProvider.signOut();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/auth');
                    }
                  },
                ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (authProvider.isAuthenticated) ...[
                  Text('Добро пожаловать, ${authProvider.user?.email}!'),
                  const SizedBox(height: 20),
                  const Text(
                    'Вы имеете доступ ко всем функциям приложения',
                    style: TextStyle(fontSize: 16),
                  ),
                ] else ...[
                  const Text(
                    'Вы не авторизованы',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Некоторые функции приложения недоступны',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/auth');
                    },
                    child: const Text('Войти'),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
} 