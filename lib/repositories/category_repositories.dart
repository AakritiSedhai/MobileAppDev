import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/category_model.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class CategoryRepository{
  CollectionReference<CategoryModel> categoryRef = FirebaseService.db.collection("categories")
      .withConverter<CategoryModel>(
    fromFirestore: (snapshot, _) {
      return CategoryModel.fromFirebaseSnapshot(snapshot);
    },
    toFirestore: (model, _) => model.toJson(),
  );
    Future<List<QueryDocumentSnapshot<CategoryModel>>> getCategories() async {
    try {
      var data = await categoryRef.get();
      bool hasData = data.docs.isNotEmpty;
      // if(!hasData){
      //   makeCategory().forEach((element) async {
      //     await categoryRef.add(element);
      //   });
      // }
      final response = await categoryRef.get();
      var category = response.docs;
      return category;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<DocumentSnapshot<CategoryModel>>  getCategory(String categoryId) async {
      try{
        print(categoryId);
        final response = await categoryRef.doc(categoryId).get();
        return response;
      }catch(e){
        rethrow;
      }
  }

  List<CategoryModel> makeCategory(){
      return [
        CategoryModel(categoryName: "Facewash", status: "active", imageUrl: "https://m.media-amazon.com/images/I/51aIyNt4ypL.jpg"),
        CategoryModel(categoryName: "Moisturizer", status: "active", imageUrl: "https://www.mamaearth.sg/wp-content/uploads/2022/03/tea-tree-oil-moisturizer-with-box-_-ingredients1.jpg"),
        CategoryModel(categoryName: "Serums", status: "active", imageUrl: "https://www.dermalogica.com.au/cdn/shop/products/dermalogica-facial-oils-and-serums-biolumin-c-serum-30340501995687.jpg?v=1633479062"),
        CategoryModel(categoryName: "Sunscreen", status: "active", imageUrl: "https://images.squarespace-cdn.com/content/v1/5e2608e21195f14156e7cece/1632334507502-GL3ETZXJRARF44LUPL4D/61RVZPlzX5L._SL1500_.jpg"),
        CategoryModel(categoryName: "Toners", status: "active", imageUrl: "https://paulaschoice.sg/cdn/shop/products/SKU1350.jpg?v=1668064896"),
      ];
  }



}