import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/favorite_model.dart';
import '../../repositories/cart_repositories.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/single_product_viewmodel.dart';

class SingleProductScreen extends StatefulWidget {
  const SingleProductScreen({Key? key}) : super(key: key);

  @override
  State<SingleProductScreen> createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SingleProductViewModel>(
      create: (_) => SingleProductViewModel(),
      child: SingleProductBody(),
    );
  }
}

class SingleProductBody extends StatefulWidget {
  const SingleProductBody({Key? key}) : super(key: key);

  @override
  State<SingleProductBody> createState() => _SingleProductBodyState();
}

class _SingleProductBodyState extends State<SingleProductBody> {
  late SingleProductViewModel _singleProductViewModel;
  late AuthViewModel _authViewModel;
  String? productId;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _singleProductViewModel = Provider.of<SingleProductViewModel>(context, listen: false);
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final args = ModalRoute.of(context)!.settings.arguments.toString();
      setState(() {
        productId = args;
      });
      getData(args);
    });
    super.initState();
  }

  Future<void> getData(String productId) async {
    try {
      await _authViewModel.getFavoritesUser();
      await _singleProductViewModel.getProducts(productId);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> favoritePressed(FavoriteModel? isFavorite, String productId) async {
    try {
      await _authViewModel.favoriteAction(isFavorite, productId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Favorite updated.")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Something went wrong. Please try again.")));
      // Handle error
    }
  }

  int quantity = 1;
  bool isImageFullScreen = false;

  @override
  Widget build(BuildContext context) {
    return Consumer2<SingleProductViewModel, AuthViewModel>(
      builder: (context, singleProductVM, authVm, child) {
        return singleProductVM.product == null
            ? Center(child: Text("Error"))
            : singleProductVM.product!.id == null
            ? Center(child: CircularProgressIndicator())
            : Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                if (isImageFullScreen) {
                  setState(() {
                    isImageFullScreen = false;
                  });
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            actions: [
              Builder(builder: (context) {
                FavoriteModel? isFavorite;
                try {
                  isFavorite = authVm.favorites.firstWhere(
                          (element) => element.productId == singleProductVM.product!.id);
                } catch (e) {
                  // Handle error
                }

                return IconButton(
                  onPressed: () {
                    favoritePressed(isFavorite, singleProductVM.product!.id!);
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: isFavorite != null ? Colors.red : Colors.grey,
                  ),
                );
              }),
            ],
          ),
          extendBodyBehindAppBar: true,
          backgroundColor: Color(0xFFf5f5f4),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isImageFullScreen = !isImageFullScreen;
                    });
                  },
                  child: isImageFullScreen
                      ? Image.network(
                    singleProductVM.product!.imageUrl.toString(),
                    fit: BoxFit.contain,
                    width: double.infinity,
                  )
                      : Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        singleProductVM.product!.imageUrl.toString(),
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Image.asset(
                            'assets/images/logo.png',
                            height: 300,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Rs. ${singleProductVM.product!.productPrice.toString()}",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        singleProductVM.product!.productName.toString(),
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        singleProductVM.product!.productDescription.toString(),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      CartRepository()
                          .addToCart(singleProductVM.product!, quantity)
                          .then((value) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("Cart updated")));
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child:Center(
                      child: Text(
                        "Add to Cart",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ),


                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFfabd75)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
