import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:untitled12/Home.dart';
import 'package:untitled12/Sing_in.dart';

import 'package:untitled12/splash_screen.dart';

import 'Sing_Up.dart';
import 'chat_room.dart';

const String splass = '/SplashScreen';
const String Singin = '/SingIn';
const String Singup = '/SingUp';
const String home = '/Home';
const String chatroom = '/ChatRoom';

List<GetPage> getPages = [
  GetPage(name: Singin, page: () => SingIn()),
  GetPage(name: splass, page: () => SplashScreen()),
  GetPage(name: Singup, page: () => SingUp()), // Add missing comma
  GetPage(name: home, page: () => Home()), // Consistent formatting

  GetPage(
    name: chatroom,
    page: () {
      ChatRoom chatRoom = Get.arguments;
      return chatRoom;
    },
  ),
];
