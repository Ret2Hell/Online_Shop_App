import 'package:flutter/material.dart';
import 'package:online_shop/main.dart';
import 'package:online_shop/src/ui/components/avatar.dart';

class AvatarUploadScreen extends StatefulWidget {
  const AvatarUploadScreen({super.key});

  @override
  State<AvatarUploadScreen> createState() => _AvatarUploadScreenState();
}

class _AvatarUploadScreenState extends State<AvatarUploadScreen> {
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload Avatar',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          Avatar(
              imageUrl: _imageUrl,
              isSetup: true,
              onUpload: (imageUrl) async {
                setState(() {
                  _imageUrl = imageUrl;
                });
                final userId = supabase.auth.currentUser!.id;
                await supabase.from('profiles').update({
                  'avatar_url': imageUrl,
                  'updated_at': DateTime.now().toIso8601String(),
                }).eq('id', userId);
              }),
        ],
      ),
    );
  }
}
