# Firebase Authentication Demo

Демонстрационное приложение с аутентификацией через Firebase.

## Функциональность

- Регистрация новых пользователей
- Вход существующих пользователей
- Выход из системы
- Ограниченный доступ для неавторизованных пользователей
- Полный доступ для авторизованных пользователей

## Технологии

- Flutter
- Firebase Authentication
- Provider для управления состоянием

## Установка

1. Клонируйте репозиторий:
```bash
git clone https://github.com/your-username/firebase_auth_app.git
```

2. Установите зависимости:
```bash
flutter pub get
```

3. Настройте Firebase:
   - Создайте проект в [Firebase Console](https://console.firebase.google.com)
   - Добавьте веб-приложение в проект
   - Скопируйте конфигурацию Firebase в `lib/firebase_options.dart`

4. Запустите приложение:
```bash
flutter run -d chrome
```

## Демо

Приложение доступно по адресу: [https://your-username.github.io/firebase_auth_app](https://your-username.github.io/firebase_auth_app)
