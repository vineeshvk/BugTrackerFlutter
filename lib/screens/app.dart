import 'package:flutter/material.dart';
import './login_screen/login_screen.dart';
import './home_screen/home_screen.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatelessWidget {
  String uid;
  Future<void> getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('UID');
    print(uid.toString() + 'from getPref---------------');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    ValueNotifier<Client> client = new ValueNotifier(Client(
        endPoint: 'https://bugtracker-server.herokuapp.com/',
        cache: InMemoryCache()));
    return FutureBuilder(
      future: getPref(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return null;
        }
        return GraphqlProvider(
          client: client,
          child: MaterialApp(
            theme: ThemeData(primaryColor: Colors.pinkAccent),
            debugShowCheckedModeBanner: false,
            home: uid != null
                ? HomeScreen(
                    uid: uid,
                    admin: true,
                  )
                : LoginScreen(),
          ),
        );
      },
    );
  }
}
