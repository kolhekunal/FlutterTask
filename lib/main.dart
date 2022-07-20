import 'package:demo/screens/root_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/auth.dart';
import 'routes/route_generator.dart';

import '';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
 runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Task',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new RootPage(auth: new Auth()),
      onGenerateRoute: GenerateAllRoutes.generateRoute,
    );
  }
}
