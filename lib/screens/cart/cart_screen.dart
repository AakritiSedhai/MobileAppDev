import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../models/cart_model.dart';
import '../../repositories/cart_repositories.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;

  List<CartItem> items = [];

  Future<void> getCartItems() async {
    final response = await CartRepository().getCart();
    setState(() {
      items = response.items;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getCartItems();
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(builder: (context, authVM, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'My Cart',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context); // Go back to previous screen
              },
              icon: Icon(Icons.close, color: Colors.black),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await getCartItems();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 10),
                if (items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Your cart is empty."),
                  )
                else
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Builder(builder: (context) {
                          int totalItems = 0;
                          num totalPrice = 0;
                          items.forEach((element) {
                            totalItems += element.quantity;
                            totalPrice += (element.product.productPrice ?? 0) * element.quantity;
                          });
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text("Total Items : $totalItems"),
                              ),
                              Container(
                                child: Text("Total Price : $totalPrice"),
                              ),
                            ],
                          );
                        }),
                      ),
                      ...items.map(
                            (e) => InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed("/single-product", arguments: e.product.id!);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(10),
                                trailing: IconButton(
                                  onPressed: () {
                                    CartRepository().removeItemFromCart(e.product).then((value) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cart updated")));
                                      getCartItems();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                ),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                    e.product.imageUrl.toString(),
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(e.product.productName.toString()),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5),
                                    Text(
                                      "Price: ${e.product.productPrice.toString()}",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            CartRepository().removeFromCart(e.product).then((value) {
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cart updated")));
                                              getCartItems();
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xFFE6F0F5),
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                            padding: EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.remove,
                                              size: 15,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(e.quantity.toString()),
                                        SizedBox(width: 10),
                                        InkWell(
                                          onTap: () {
                                            CartRepository().addToCart(e.product, 1).then((value) {
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cart updated")));
                                              getCartItems();
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xFFE6F0F5),
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                            padding: EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.add,
                                              size: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
