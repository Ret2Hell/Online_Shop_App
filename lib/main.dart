// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:online_shop/src/services/providers/cart_provider.dart';
import 'package:online_shop/src/ui/screens/avatar_upload_screen.dart';
import 'package:online_shop/src/ui/components/navigation_bar.dart';
import 'package:online_shop/src/ui/screens/login_screen.dart';
import 'package:online_shop/src/ui/screens/splash_screen.dart';
import 'package:online_shop/src/config/environment_keys.dart';
import 'package:online_shop/src/config/themes/main_theme.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: SUPABASE_ANON_KEY,
  );

  runApp(const OnlineShopApp());
}

final supabase = Supabase.instance.client;

class OnlineShopApp extends StatelessWidget {
  const OnlineShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
        title: 'Online Shop App',
        debugShowCheckedModeBanner: false,
        theme: buildThemeData(),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          'login': (context) => const LoginScreen(),
          'upload_avatar': (context) => const AvatarUploadScreen(),
          'home': (context) => const CustomNavigationBar(),
        },
      ),
    );
  }
}
