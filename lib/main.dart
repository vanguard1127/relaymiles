import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:relaymiles/ui/login.dart';
import 'package:relaymiles/utils/colors.dart';
import 'package:relaymiles/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/api_service.dart';
import 'utils/strings.dart';

void main() {
  runApp(MyApp());
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

}

void backgroundFetchHeadlessTask(String taskId) async {
  print('[BackgroundFetch] Headless event received.');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email = prefs.getString(Constants.PREF_EMAIL);
  print("email = ---------------------------" + email);
  if (email != null && email.isNotEmpty) {
    print("get email---------------------------");
    Position position = await Geolocator.getCurrentPosition();
    print("get position---------------------------");
    if (position != null) {
      print("get location headless---------------------------");
      Map<String, dynamic> map = Map();
      map["email"] = prefs.getString(Constants.PREF_EMAIL);
      map["userId"] = prefs.getString(Constants.PREF_ID);
      map["lat"] = position.latitude;
      map["long"] = position.longitude;
      ApiService.create().addLocation(Constants.SECRET_CODE, map).then((
          value) async {
        if (value.code == 1) {
          print("added headless--------------------------");
        } else {
          print("wrong headless--------------------------");
        }
      }).catchError((onError) {
        print("failed --------------------------");
      });
    }
  }
  BackgroundFetch.finish(taskId);


}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  MaterialColor white = const MaterialColor(
    0xFFFFFFFF,
    const <int, Color>{
      50: const Color(0xFFFFFFFF),
      100: const Color(0xFFFFFFFF),
      200: const Color(0xFFFFFFFF),
      300: const Color(0xFFFFFFFF),
      400: const Color(0xFFFFFFFF),
      500: const Color(0xFFFFFFFF),
      600: const Color(0xFFFFFFFF),
      700: const Color(0xFFFFFFFF),
      800: const Color(0xFFFFFFFF),
      900: const Color(0xFFFFFFFF),
    },
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: white,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
        accentColor: COLORS.black,
        backgroundColor: COLORS.white,
        appBarTheme: AppBarTheme(brightness: Brightness.light)
      ),
      home: LoginPage(),
    );
  }
}

