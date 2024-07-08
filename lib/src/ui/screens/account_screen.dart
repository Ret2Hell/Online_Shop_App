import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:online_shop/main.dart';
import 'package:online_shop/src/services/providers/account_info_provider.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Future<void> _fetchUserData() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final data = await supabase.from('profiles').select('username, avatar_url').eq('id', user.id).single();
      final avatarUrl = data['avatar_url'];
      final String username = data['username'] as String;
      final String createdDate = DateFormat.yMMMd('en_US').format(DateTime.parse(user.createdAt));

      if (mounted) {
        final Map<String, dynamic> accountInfo = {
          'username': username,
          'createdDate': createdDate,
        };
        if (avatarUrl != null) {
          accountInfo.addAll({
            'avatarUrl': avatarUrl
          });
        }
        context.read<AccountInfoProvider>().updateAccountInfo(accountInfo);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    final accountInfo = context.watch<AccountInfoProvider>().accountInfo;
    final avatarUrl = accountInfo['avatarUrl'];
    final username = accountInfo['username'];
    final createdDate = accountInfo['createdDate'];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Account",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.yellow,
        leading: const IconButton(
          icon: Icon(
            Icons.settings,
            size: 30,
            color: Colors.white,
          ),
          onPressed: null,
        ),
      ),
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipPath(
                clipper: MyClipper(),
                child: Container(
                  width: double.infinity,
                  height: 300,
                  color: Colors.yellow,
                  child: const Column(
                    children: [
                      SizedBox(height: 0),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 110,
                left: 0,
                right: 0,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 40),
                                Text(
                                  username ?? 'N/A',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            createdDate ?? 'N/A',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const Text('Member Since', style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 40,
                                        child: VerticalDivider(
                                          color: Colors.grey,
                                          width: 80,
                                          thickness: 2,
                                        ),
                                      ),
                                      const Text('To be\nimplemented', style: TextStyle(fontSize: 12, color: Colors.red)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      'edit_account',
                                    );
                                  },
                                  style: ButtonStyle(
                                    minimumSize: WidgetStateProperty.all(const Size(double.infinity, 50)),
                                    side: WidgetStateProperty.all(const BorderSide(color: Colors.yellow, width: 2)),
                                    shape: WidgetStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                                  ),
                                  child: const Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.yellow,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: -50,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : const AssetImage('assets/images/no-avatar.png'),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 60),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                    leading: const Icon(Icons.account_balance_wallet, color: Colors.yellow),
                    title: const Text('Wallet'),
                    subtitle: const Text('Your balance: 45.00 USD'),
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                    leading: const Icon(Icons.logout_outlined, color: Colors.red),
                    title: const Text('Sign out', style: TextStyle(color: Colors.red)),
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    final path = Path();
    path.lineTo(0, height - 150);
    path.quadraticBezierTo(15, height - 115, 60, height - 110);
    path.quadraticBezierTo(width / 2, height, width - 60, height);
    path.quadraticBezierTo(width - 15, height - 5, width, height - 40);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
