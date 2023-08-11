import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:n_baz/screens/account/account_screen.dart';
import 'package:n_baz/screens/cart/cart_screen.dart';
import 'package:n_baz/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/global_ui_viewmodel.dart';
import '../favorite/favorite_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController pageController = PageController();
  int selectedIndex = 0;

  _onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  _itemTapped(int selectedIndex) {
    pageController.jumpToPage(selectedIndex);
    setState(() {
      this.selectedIndex = selectedIndex;
    });
  }

  late GlobalUIViewModel _ui;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Change the background to white
      body: SafeArea(
        child: PageView(
          controller: pageController,
          children: <Widget>[
            HomeScreen(),
            FavoriteScreen(),
            CartScreen(),
            AccountScreen(),
          ],
          onPageChanged: _onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        currentIndex: selectedIndex,
        selectedItemColor: Color(0xFFF1D4B5),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(color: Color(0xFFF8EDE1)),
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        type: BottomNavigationBarType.fixed,
        onTap: _itemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorite"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}
