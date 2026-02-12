import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:petapp/services/auth_serviceprovider.dart';
import 'package:petapp/services/favorite_provider.dart';
import 'package:petapp/view/auth_wrapper.dart';
import 'package:provider/provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => FavoritesProvider()),
    ChangeNotifierProvider(create: (_) => AuthServiceprovider()),
  ],
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const AuthWrapper(),
  ),
);

  }
}
