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
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (authProvider.isAuthenticated) ...[
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Добро пожаловать, ${authProvider.user?.email}!',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.email),
                            title: const Text('Email'),
                            subtitle: Text(authProvider.user?.email ?? ''),
                          ),
                          ListTile(
                            leading: const Icon(Icons.verified_user),
                            title: const Text('Статус'),
                            subtitle: Text(
                              authProvider.user?.emailVerified ?? false
                                  ? 'Email подтвержден\nEmail verified'
                                  : 'Email не подтвержден\nEmail not verified',
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.access_time),
                            title: const Text('Последний вход'),
                            subtitle: Text(
                              authProvider.user?.metadata.lastSignInTime?.toString() ?? 'Неизвестно\nUnknown',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Вы имеете доступ ко всем функциям приложения',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  const Icon(
                    Icons.lock_outline,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Вы не авторизованы',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Некоторые функции приложения недоступны',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/auth');
                    },
                    icon: const Icon(Icons.login),
                    label: const Text('Войти'),
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