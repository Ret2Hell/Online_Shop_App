import 'package:flutter/material.dart';
import 'package:online_shop/src/services/authentication_services/user_personal_info_service.dart';
import 'package:online_shop/src/ui/components/show_snackbar.dart';

class Avatar extends StatefulWidget {
  const Avatar({
    super.key,
    required this.imageUrl,
    required this.onUpload,
  });

  final String? imageUrl;
  final void Function(String) onUpload;

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  bool _isLoading = false;

  void _toggleLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
    );

    return Column(
      children: [
        CircleAvatar(
          backgroundImage: widget.imageUrl == null || widget.imageUrl!.isEmpty ? const AssetImage('assets/images/no-avatar.png') : NetworkImage(widget.imageUrl!),
          radius: 75,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'home');
                },
                style: style,
                child: const Text(
                  'Skip',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        UserPersonalInfoService.upload(context, widget.onUpload, _toggleLoading);
                        context.showSnackBar('Uploading...');
                        Future.delayed(const Duration(seconds: 1));
                        Navigator.pushReplacementNamed(context, 'home');
                      },
                style: style,
                child: Text(
                  _isLoading ? 'Uploading...' : 'Upload',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
