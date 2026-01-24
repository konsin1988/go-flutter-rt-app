import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class AppIcons {
  static const String home = 'assets/images/bottom_navbar/home.svg';
  static const String ai = 'assets/images/bottom_navbar/ai.svg';
  static const String services = 'assets/images/bottom_navbar/services.svg';
  static const String profile = 'assets/images/bottom_navbar/profile.svg';
}

class AppRoutes {
  static const String login = '/login';
  static const String init = '/init';
  static const String home = '/';
  static const String ai = '/ai';
  static const String services = '/services';
  static const String profile = '/profile';
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
}


const String baseRESTLink = "http://10.0.2.2:3000";
const String baseUrl = "http://10.0.2.2:3000";

late final String serverLink;
late final String baseQraphqlLink;
late final String baseWSQraphqlLink;

Future<bool> isAndroidEmulator() async {
  final info = await DeviceInfoPlugin().androidInfo;
  return !info.isPhysicalDevice;
}

Future<void> initConstants() async {
  final isEmulator = await isAndroidEmulator();
  if (isEmulator) {
    serverLink = "10.0.2.2:3000";
    baseQraphqlLink = "http://10.0.2.2:3000/graphql";
    baseWSQraphqlLink = "ws://10.0.2.2:3000/graphql";  
  } else {
    serverLink = "api.stage.hub-rt.codd.io";
    baseQraphqlLink = "https://api.stage.hub-rt.codd.io/graphql";
    baseWSQraphqlLink = "wss://api.stage.hub-rt.codd.io/graphql";
  }
}

const Duration serverLinkCheckDuration = Duration(seconds: 5);

//Имя устройства, которое следует показывать пользователям.
//Не длиннее 100 символов. Для мобильных устройств рекомендуется передавать имя устройства, заданное пользователем.
//Если такого имени нет, его можно собрать из модели устройства, названия и версии ОС и т. д.
Future<String> get k_deviceName async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;        

    return "${androidInfo.model} ${androidInfo.host}";
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return "${iosInfo.utsname.machine} ${iosInfo.name}";
  } else {
    return "Unknow_device_name";
  }
}

const int k_aiSessionFavoriteQueriesNumber = 6;
