import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/main.dart';
import 'package:online_shop/src/ui/components/show_snackbar.dart';
import 'package:online_shop/src/ui/screens/profile_setup_screen.dart';
import 'package:online_shop/src/ui/components/navigation_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserAuthenticationService {
  static Future<void> signIn(BuildContext context, TextEditingController emailController, Function(bool) toggleLoading) async {
    try {
      toggleLoading(true);
      await supabase.auth.signInWithOtp(
        email: emailController.text.trim(),
        emailRedirectTo: kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback/',
      );
      if (context.mounted) {
        context.showSnackBar('Check your email for a login link!');
        emailController.clear();
      }
    } on AuthException catch (error) {
      if (context.mounted) context.showSnackBar(error.message, isError: true);
    } catch (error) {
      if (context.mounted) context.showSnackBar('Unexpected error occurred', isError: true);
    } finally {
      if (context.mounted) toggleLoading(false);
    }
  }

  static Future<void> checkUsername(BuildContext context) async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final data = await supabase.from('profiles').select('username').eq('id', user.id).maybeSingle();
      if (context.mounted) {
        if (data != null && data['username'] != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const CustomNavigationBar()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
          );
        }
      }
    }
  }
}
