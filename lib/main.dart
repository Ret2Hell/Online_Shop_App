// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_shop/src/services/providers/account_info_provider.dart';

import 'package:online_shop/src/services/providers/cart_provider.dart';
import 'package:online_shop/src/ui/screens/avatar_upload_screen.dart';
import 'package:online_shop/src/ui/components/navigation_bar.dart';
import 'package:online_shop/src/ui/screens/edit_account_screen.dart';
import 'package:online_shop/src/ui/screens/login_screen.dart';
import 'package:online_shop/src/ui/screens/splash_screen.dart';
import 'package:online_shop/src/config/environment_keys.dart';
import 'package:online_shop/src/config/themes/main_theme.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => AccountInfoProvider())
      ],
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
          'edit_account': (context) => const EditAccountScreen(),
        },
      ),
    );
  }
}
