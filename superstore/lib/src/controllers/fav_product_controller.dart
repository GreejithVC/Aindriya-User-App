import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:superstore/src/models/favouriteProduct.dart';
import 'package:superstore/src/repository/search_repository.dart';
import 'package:superstore/src/repository/user_repository.dart';

class FavProductController extends ControllerMVC {
  List<FavouriteProduct> favProductList = <FavouriteProduct>[];

  void saveSearch(String search) {
    setRecentSearch(search);
    Navigator.of(context).pushNamed('/ProductList');
  }

  addFavProduct(context, FavouriteProduct productDetails2) {
    print("addFavProduct///");
    FirebaseFirestore.instance
        .collection('Favourites')
        .doc(currentUser.value.id)
        .collection("favouriteProducts")
        .doc(productDetails2.id)
        .set(productDetails2.toMap())
        .catchError((e) {
      print(e);
    }).whenComplete(() {
      print("addFavProduct/// whenComplete");
      listenForFavProductList();
      // Helper.hideLoader(loader);
    });
  }

  deleteFavProduct(context, FavouriteProduct productDetails2) {
    print("deleteFavProduct///");
    FirebaseFirestore.instance
        .collection('Favourites')
        .doc(currentUser.value.id)
        .collection("favouriteProducts")
        .doc(productDetails2.id)
        .delete()
        .then((_) {
      print("success!");
    }).catchError((e) {
      print(e);
    }).whenComplete(() {
      print("deleteFavProduct/// whenComplete");
      listenForFavProductList();
    });
  }

  Future<void> listenForFavProductList() async {
    favProductList.clear();
    print("listenForFavProductList///");
    FirebaseFirestore.instance
        .collection('Favourites')
        .doc(currentUser.value.id)
        .collection("favouriteProducts")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result);
        print(result.id);
        print(result.reference);
        print(result.data());
        setState(
            () => favProductList.add(FavouriteProduct.fromJSON(result.data())));
      });
    }).catchError((e) {
      print(e);
    }).whenComplete(() {
      print("listenForFavProductList/// completed");
      print(favProductList.length);
    });
  }
}
