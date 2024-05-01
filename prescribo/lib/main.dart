import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prescribo/screens/login.dart';
import 'package:prescribo/screens/register.dart';
import 'package:prescribo/screens/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;

void main(List<String> args) async {
  runApp(const Prescribo());
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
}

class Prescribo extends StatelessWidget {
  const Prescribo({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PRESCRIBO',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => SplashScreen()),
        GetPage(name: "/login", page: () => Login()),
        GetPage(name: "/register", page: () => Register()),
        GetPage(name: "/register", page: () => Register()),
      ],
    );
  }
}
