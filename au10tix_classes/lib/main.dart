import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './screens/classes_screen.dart';
import './screens/class_details_screen.dart';
import './providers/auth_user.dart';
import './config/palette.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthUser()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Au10tix Classes',
      theme: ThemeData(
        primarySwatch: Palette.kToDark,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }
          if (userSnapshot.hasData) {
            return FutureBuilder(
                future: Provider.of<AuthUser>(context, listen: false)
                    .fetchUser(FirebaseAuth.instance.currentUser!.uid),
                builder: (context, userFetchSnapshot) =>
                    userFetchSnapshot.connectionState == ConnectionState.waiting
                        ? SplashScreen()
                        : ClassesScreen());
          }
          return const AuthScreen();
        },
      ),
      routes: {
        ClassDetailsScreen.routeName: (ctx) => ClassDetailsScreen(),
        ClassesScreen.routeName: (ctx) => ClassesScreen(),
      },
    );
  }
}
