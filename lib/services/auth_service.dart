import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Получение текущего пользователя
  User? get currentUser => _auth.currentUser;

  // Stream для отслеживания состояния авторизации
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Регистрация
  Future<User?> signUp(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Этот email уже используется\nThis email is already in use';
          break;
        case 'invalid-email':
          message = 'Некорректный формат email\nInvalid email format';
          break;
        case 'operation-not-allowed':
          message = 'Регистрация с email отключена\nEmail registration is disabled';
          break;
        case 'weak-password':
          message = 'Слишком слабый пароль\nPassword is too weak';
          break;
        default:
          message = 'Ошибка при регистрации: ${e.message}\nRegistration error: ${e.message}';
      }
      throw message;
    } catch (e) {
      throw 'Неизвестная ошибка: $e\nUnknown error: $e';
    }
  }

  // Вход
  Future<User?> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Пользователь не найден\nUser not found';
          break;
        case 'wrong-password':
          message = 'Неверный пароль\nWrong password';
          break;
        case 'invalid-email':
          message = 'Некорректный формат email\nInvalid email format';
          break;
        case 'user-disabled':
          message = 'Пользователь отключен\nUser is disabled';
          break;
        default:
          message = 'Ошибка при входе: ${e.message}\nSign in error: ${e.message}';
      }
      throw message;
    } catch (e) {
      throw 'Неизвестная ошибка: $e\nUnknown error: $e';
    }
  }

  // Выход
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Ошибка при выходе: $e\nSign out error: $e';
    }
  }
} 