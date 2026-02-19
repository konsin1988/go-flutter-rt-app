import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class AppIcons {
  AppIcons._();
  static const String home = 'assets/images/bottom_navbar/home.svg';
  static const String ai = 'assets/images/bottom_navbar/ai.svg';
  static const String services = 'assets/images/bottom_navbar/services.svg';
  static const String profile = 'assets/images/bottom_navbar/profile.svg';
  static const List<String> appIcons = [
    home, ai, services, profile,
  ];
}

class AppImageIcons {
  AppImageIcons._();
  static const String assistant = 'assets/images/app/assistant.jpg';
  static const List<String> appImageTitles = [
    assistant,
  ];
}

class AppRoutes {
  AppRoutes._();
  static const String login = '/login';
  static const String init = '/init';
  static const String home = '/';
  static const String ai = '/ai';
  static const String services = '/services';
  static const String profile = '/profile';
  static const String assistant = '/assistant';
  static const String department = '/department';
  static const String image = '/image';
  static const List<String> appRoutes = [
    login,
    init,
    home,
    ai,
    services,
    profile,
    assistant,
    department,
    image,
  ];
}

class AppBarTitles {
  AppBarTitles._();
  static const String home = 'Главная';
  static const String ai = 'Искусственный интеллект';
  static const String services = 'Сервисы';
  static const String profile = 'Профиль';
  static const List<String> tabTitles = [
    home,
    ai,
    services,
    profile,
  ];

  static const routeTitles = {
    '/assistant': 'Ваш ассистент',
    '/department': 'Департамент',
  };
}

class AppLinks {
  static const String baseURL = 
    String.fromEnvironment('BASE_URL', defaultValue: "http://10.100.221.18:8000");
  static const String graphqlURL = '$baseURL/graphql';
  static const String graphqlWS = 
    String.fromEnvironment('BASE_WS_URL', defaultValue: "ws://10.100.221.18:8000/graphql");
  //static const String serverLink = "10.0.2.2:3000";
  //static const String baseQraphqlLink = "http://10.0.2.2:3000/graphql";
  //static const String baseWSQraphqlLink = "ws://10.0.2.2:3000/graphql";  
}

