import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/category_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';
import '../../viewmodels/product_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AuthViewModel _authViewModel;
  late CategoryViewModel _categoryViewModel;
  late ProductViewModel _productViewModel;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _categoryViewModel = Provider.of<CategoryViewModel>(context, listen: false);
      _productViewModel = Provider.of<ProductViewModel>(context, listen: false);
      refresh();
    });
    super.initState();
  }

  Future<void> refresh() async {
    _categoryViewModel.getCategories();
    _productViewModel.getProducts();
    _authViewModel.getMyProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<CategoryViewModel, AuthViewModel, ProductViewModel>(
      builder: (context, categoryVM, authVM, productVM, child) {
        return Container(
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  margin: EdgeInsets.only(top: 60),
                  child: RefreshIndicator(
                    onRefresh: refresh,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CarouselSlider(
                            items: [
                              Image.asset("assets/images/banner1.jpg",width: double.infinity),
                              Image.asset("assets/images/banner2.jpg",width: double.infinity),
                            ],
                            options: CarouselOptions(
                              autoPlay: true,
                              aspectRatio: 16 / 9,
                              enlargeCenterPage: true,
                              viewportFraction: 1.0,
                            ),
                          ),
                          SizedBox(height: 20),
                          WelcomeText(authVM),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [...categoryVM.categories.map((e) => CategoryCard(e))],
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: GridView.count(
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.7,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              crossAxisCount: 2,

                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              HomeHeader(),
            ],
          ),
        );
      },
    );
  }

  Widget HomeHeader() {
    return Align(
        alignment: Alignment.topCenter,
        child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black26,
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(child: Container()),
                Expanded(child: Image.asset("assets/images/logo.png", height: 50, width: 50,)),
                Expanded(
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Container()
                      // Icon(Icons.search, size: 30,)
                    )),
              ],
            )));
  }

  Widget WelcomeText(AuthViewModel authVM) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Welcome, ",
                style: GoogleFonts.yesevaOne(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF6DCC0),
                ),
              ),
              Text(
                authVM.loggedInUser != null ? authVM.loggedInUser!.name.toString() : "Guest",
                style: GoogleFonts.yesevaOne(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF6DCC0),),
              ),
            ],
         ),
         )
      ]
      );
  }

  Widget CategoryCard(CategoryModel e) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/single-category", arguments: e.id.toString());
      },
      child: Container(
        width: 200,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3), // Shadow offset
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                e.imageUrl.toString(),
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              e.categoryName.toString(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
          ),
        ),

    );
  }


}




