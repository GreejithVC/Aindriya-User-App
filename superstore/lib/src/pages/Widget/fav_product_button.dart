import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:superstore/src/controllers/fav_product_controller.dart';
import 'package:superstore/src/models/favouriteProduct.dart';

class FavProductButton extends StatefulWidget {
  final FavouriteProduct productDetails2;

  const FavProductButton({Key key, this.productDetails2}) : super(key: key);
  @override
  _FavProductButtonState createState() => _FavProductButtonState();
}

class _FavProductButtonState extends StateMVC<FavProductButton> {

  FavProductController _con;

  _FavProductButtonState() : super(FavProductController()) {
    _con = controller;
  }
  @override
  // ignore: must_call_super
  void initState() {
    _con.listenForFavProductList();
  }

  Widget build(BuildContext context) {
    print("Fav Button ////");
    print(widget.productDetails2.productName);
    print(widget.productDetails2.productName);
    print(_con?.favProductList?.length);
    _con?.favProductList?.forEach((element) {
      print(element.id);
    });
    print(_con?.favProductList?.contains(widget.productDetails2) == true);
    print(_con?.favProductList
        ?.any((item) => item.id == widget.productDetails2.id));
    return Container(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _con?.favProductList?.any(
                      (item) => item.id == widget.productDetails2.id) ==
                  true
                  ? _con?.deleteFavProduct(context, widget.productDetails2)
                  : _con?.addFavProduct(context, widget.productDetails2);
            });
          },
          child: Icon(
            _con?.favProductList
                ?.any((item) => item.id == widget.productDetails2.id) ==
                true
                ? Icons.favorite
                : Icons.favorite_border,
            color: Colors.red,
          ),
        ));
  }
}
