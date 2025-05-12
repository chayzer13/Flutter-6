import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  bool _showResetPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      bool success;
      
      if (_isLogin) {
        success = await authProvider.signIn(
          _emailController.text,
          _passwordController.text,
        );
      } else {
        success = await authProvider.signUp(
          _emailController.text,
          _passwordController.text,
        );
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (success) {
          // Заменяем текущий экран на главный
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/');
          }
        } else {
          final errorMessage = authProvider.error ?? 'Произошла ошибка\nAn error occurred';
          final errorParts = errorMessage.split('\n');
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    errorParts[0],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (errorParts.length > 1)
                    Text(
                      errorParts[1],
                      style: const TextStyle(fontSize: 12),
                    ),
                ],
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    }
  }

  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пожалуйста, введите email\nPlease enter your email'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.resetPassword(_emailController.text);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Инструкции по сбросу пароля отправлены на ваш email\nPassword reset instructions sent to your email',
            ),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _showResetPassword = false;
        });
      } else {
        final errorMessage = authProvider.error ?? 'Произошла ошибка\nAn error occurred';
        final errorParts = errorMessage.split('\n');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  errorParts[0],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (errorParts.length > 1)
                  Text(
                    errorParts[1],
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Проверяем, авторизован ли пользователь
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        if (authProvider.isAuthenticated) {
          // Если авторизован, возвращаемся на главный экран
          Navigator.pushReplacementNamed(context, '/');
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isLogin ? 'Вход' : 'Регистрация'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  enabled: !_isLoading,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите email';
                    }
                    if (!value.contains('@')) {
                      return 'Введите корректный email';
                    }
                    return null;
                  },
                ),
                if (!_showResetPassword) ...[
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Пароль'),
                    obscureText: true,
                    enabled: !_isLoading,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите пароль';
                      }
                      if (value.length < 6) {
                        return 'Пароль должен быть не менее 6 символов';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 20),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  Column(
                    children: [
                      if (_isLogin && !_showResetPassword)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _showResetPassword = true;
                            });
                          },
                          child: const Text('Забыли пароль?'),
                        ),
                      if (_showResetPassword) ...[
                        ElevatedButton(
                          onPressed: _resetPassword,
                          child: const Text('Сбросить пароль'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _showResetPassword = false;
                            });
                          },
                          child: const Text('Вернуться к входу'),
                        ),
                      ] else ...[
                        ElevatedButton(
                          onPressed: _submit,
                          child: Text(_isLogin ? 'Войти' : 'Зарегистрироваться'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(_isLogin
                              ? 'Создать новый аккаунт'
                              : 'Уже есть аккаунт? Войти'),
                        ),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 