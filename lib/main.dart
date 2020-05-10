import 'package:flutter/material.dart';
import 'package:flutterbook/home.dart';
import 'package:flutterbook/notifiers/product_notifier.dart';
import 'package:flutterbook/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';
import 'notifiers/auth_notifier.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthNotifier()),
        ChangeNotifierProvider(create: (context) => ProductNotifier()),
      ],
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.pink[200],
        accentColor: Colors.pink[200].withOpacity(0.6),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.brown[900],
        accentColor: Colors.brown[900],
      ),
      home: Consumer<AuthNotifier>(
        builder: (context, notifier, child) {
          return notifier.user != null ? Home() : Authenticate();
        },
      ),
    );
  }
}
