import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late GlobalUIViewModel _ui;
  late AuthViewModel _auth;

  void logout() async {
    _ui.loadState(true);
    try {
      await _auth.logout().then((value) {
        Navigator.of(context).pushReplacementNamed('/login');
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message.toString())));
      });
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.toString())));
    }
    _ui.loadState(false);
  }

  @override
  void initState() {
    _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
    _auth = Provider.of<AuthViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage("assets/images/avatar.jpg"),
          ),
          SizedBox(height: 10),
          Text(
            _auth.loggedInUser!.email.toString(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          makeSettings(
            icon: Icons.list, // Use a list icon
            title: "My Products",
            subtitle: "Get listing of my products",
            onTap: () {
              Navigator.of(context).pushNamed("/my-products");
            },
          ),
          Divider(), // Add dividers
          makeSettings(
            icon: Icons.logout, // Use a logout icon
            title: "Logout",
            subtitle: "Logout from this application",
            onTap: () {
              logout();
            },
          ),
          Divider(), // Add dividers
          SizedBox(height: 20),
          Text(
            "Version: 0.0.1", // Display version information
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget makeSettings({required IconData icon, required String title, required String subtitle, Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Card(
          elevation: 4,
          color: Colors.white,
          child: ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            leading: Icon(icon, color: Theme.of(context).primaryColor), // Use theme color for icons
            title: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey), // Add a forward arrow icon
          ),
        ),
      ),
    );
  }
}
