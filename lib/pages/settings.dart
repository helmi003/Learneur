import 'package:flutter/material.dart';
import 'package:learneur/components/appbar.dart';
import 'package:learneur/components/drawer.dart';
import 'package:adaptive_theme/adaptive_theme.dart';


class Settings  extends StatefulWidget {
  @override
  _SettingsState createState()=>_SettingsState();
}

class _SettingsState extends State<Settings>{
  bool darkmode = true;
  dynamic savedThemeMode;

  void initState() {
    super.initState();
    getCurrentTheme();
  }

  Future getCurrentTheme() async {
    savedThemeMode = await AdaptiveTheme.getThemeMode();
    if (savedThemeMode.toString() == 'AdaptiveThemeMode.dark') {
      setState(() {
        darkmode = true;
      });
    } else {
      setState(() {
        darkmode = false;
      });
    }
  }
    @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: appBarMain(context),
        drawer: drawer(),
        body: ListView(
          children: [
            SwitchListTile(
                  title: Text('Mode sombre'),
                  activeColor: Colors.orange,
                  secondary: const Icon(Icons.nightlight_round),
                  value: darkmode,
                  onChanged: (bool value) {
                    if (value == true) {
                      AdaptiveTheme.of(context).setDark();
                    } else {
                      AdaptiveTheme.of(context).setLight();
                    }
                    setState(() {
                      darkmode = value;
                    });
                  },
                ),
                ListTile(
                      title: Text(
                        "Change password",
                        style: TextStyle(fontSize: 18),
                      ),
                      leading: Icon(
                        Icons.lock,
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('password');
                      },
                    ),
          ],
        ));
  }
}