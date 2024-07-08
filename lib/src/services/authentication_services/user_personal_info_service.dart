import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_shop/main.dart';
import 'package:online_shop/src/services/providers/account_info_provider.dart';
import 'package:online_shop/src/ui/components/show_snackbar.dart';
import 'package:online_shop/src/ui/screens/avatar_upload_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserPersonalInfoService {
  static Future<void> updateProfile(BuildContext context, TextEditingController usernameController, TextEditingController fullnameController, Function(bool) toggleLoading, bool isSetup) async {
    toggleLoading(true);
    final username = usernameController.text.trim();
    final fullname = fullnameController.text.trim();
    if (isSetup) {
      if (username.isEmpty || fullname.isEmpty) {
        context.showSnackBar('Please fill in all fields', isError: true);
        toggleLoading(false);
        return;
      }
    } else {
      if (username.isEmpty && fullname.isEmpty) {
        context.showSnackBar('Please fill in at least one field', isError: true);
        toggleLoading(false);
        return;
      }
    }

    final user = supabase.auth.currentUser;
    final updates = {
      'id': user!.id,
      'updated_at': DateTime.now().toIso8601String(),
    };
    if (username.isNotEmpty) {
      updates['username'] = username;
    }
    if (fullname.isNotEmpty) {
      updates['full_name'] = fullname;
    }

    try {
      await supabase.from('profiles').upsert(updates);
      if (context.mounted) {
        context.showSnackBar('Successfully updated profile!');
        if (username.isNotEmpty) {
          context.read<AccountInfoProvider>().updateAccountInfoField('username', username);
        }
        if (fullname.isNotEmpty) {
          context.read<AccountInfoProvider>().updateAccountInfoField('full_name', fullname);
        }
        usernameController.clear();
        fullnameController.clear();
        if (isSetup) {
          await Future.delayed(const Duration(seconds: 1));
          if (context.mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const AvatarUploadScreen(),
              ),
            );
          }
        }
      }
    } on PostgrestException catch (error) {
      if (context.mounted) context.showSnackBar(error.message, isError: true);
    } catch (error) {
      if (context.mounted) {
        context.showSnackBar('Unexpected error occurred', isError: true);
      }
    } finally {
      if (context.mounted) {
        toggleLoading(false);
      }
    }
  }

  static Future<void> upload(BuildContext context, Function(String) onUpload, Function(bool) toggleLoading) async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );
    if (imageFile == null) {
      return;
    }
    toggleLoading(true);

    try {
      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;
      await supabase.storage.from('avatars').uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(contentType: imageFile.mimeType),
          );
      final imageUrlResponse = await supabase.storage.from('avatars').createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);
      onUpload(imageUrlResponse);
    } on StorageException catch (error) {
      if (context.mounted) {
        context.showSnackBar(error.message, isError: true);
      }
    } catch (error) {
      if (context.mounted) {
        context.showSnackBar('Unexpected error occurred', isError: true);
      }
    }

    if (context.mounted) {
      toggleLoading(false);
    }
  }
}
