import 'package:flutter/material.dart';
import 'package:online_shop/main.dart';
import 'package:online_shop/src/services/authentication_services/user_personal_info_service.dart';
import 'package:online_shop/src/services/providers/account_info_provider.dart';
import 'package:online_shop/src/ui/components/avatar.dart';
import 'package:provider/provider.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final _usernameController = TextEditingController();
  final _fullnameController = TextEditingController();

  var _isLoading = false;

  void _toggleLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accountInfo = context.watch<AccountInfoProvider>().accountInfo;
    final imageUrl = accountInfo['avatarUrl'];
    final previousImageUrl = imageUrl;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Account',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          Avatar(
              imageUrl: imageUrl,
              isSetup: false,
              onUpload: (imageUrl) async {
                setState(() {
                  imageUrl = imageUrl;
                });
                final userId = supabase.auth.currentUser!.id;

                if (previousImageUrl != null) {
                  String imagePath = previousImageUrl.split('/').last;
                  imagePath = imagePath.substring(0, imagePath.indexOf('?'));
                  await supabase.storage.from('avatars').remove([
                    imagePath
                  ]);
                }

                await supabase.from('profiles').update({
                  'avatar_url': imageUrl,
                  'updated_at': DateTime.now().toIso8601String(),
                }).eq('id', userId);
                if (context.mounted) {
                  context.read<AccountInfoProvider>().updateAccountInfoField('avatarUrl', imageUrl);
                }
              }),
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'User Name'),
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _fullnameController,
            decoration: const InputDecoration(labelText: 'Full Name'),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : () {
                    UserPersonalInfoService.updateProfile(context, _usernameController, _fullnameController, _toggleLoading, false);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              fixedSize: const Size(350, 50),
            ),
            child: Text(
              _isLoading ? 'Saving...' : 'Save',
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
