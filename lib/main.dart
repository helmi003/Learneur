import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:learneur/auth/Login.dart';
import 'package:learneur/auth/SignUp.dart';
import 'package:learneur/auth/editprofile.dart';
import 'package:learneur/auth/password.dart';
import 'package:learneur/auth/resetpwd.dart';
import 'package:learneur/courses.dart/adding/addcourse.dart';
import 'package:learneur/pages/AdminPage.dart';
import 'package:learneur/pages/Home.dart';
import 'package:learneur/pages/about.dart';
import 'package:learneur/pages/friends.dart';
import 'package:learneur/pages/getting_started.dart';
import 'package:learneur/pages/settings.dart';
import 'auth/profile.dart';
import 'pages/Start.dart';
import 'package:flutter/material.dart';
import 'pages/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';

// import 'package:flutter_downloader/flutter_downloader.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await FlutterDownloader.initialize(debug: true);
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId("d45ea910-4abb-481b-b5d7-3d9647c79eca");
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.orange,
        ),
        dark: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.orange,
        ),
        initial: AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => MaterialApp(
              theme: theme,
              darkTheme: darkTheme,
              debugShowCheckedModeBanner: false,
              home: Home(),
              routes: <String, WidgetBuilder>{
                'settings': (context) => Settings(),
                'home': (context) => HomePage(),
                'admin': (context) => AdminPage(),
                'initialhome': (context) => Home(),
                'about': (context) => About(),
                'Login': (context) => Login(),
                'SignUp': (context) => SignUp(),
                'start': (context) => Start(),
                'starting': (context) => GettingStartedScreen(),
                'profile': (context) => Profile(),
                'friends': (context) => Friends(),
                'addCourse': (context) => AddCourse(),
                'resetpsw': (context) => Resetpwd(),
                'login': (context) => Login(),
                'editProfile': (context) => EditProfile(),
                'password': (context) => ChangePassword(),
              },
            ));
  }
}
