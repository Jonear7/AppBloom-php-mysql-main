

import 'package:bloom/splash.dart';
import 'package:bloom/models/utils/shared_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create the SharedPreferencesProvider and initialize it
  SharedPreferencesProvider sharedPreferencesProvider = SharedPreferencesProvider();
  await sharedPreferencesProvider.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sharedPreferencesProvider),
      ],
      child: MyApp(),
    ),
  );
}


const String API_IP_ADDRESS = '192.168.1.25';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
