import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:superstore/src/controllers/fav_shop_controller.dart';
import 'package:superstore/src/elements/EmptyOrdersWidget.dart';
import 'package:superstore/src/elements/ShopListBoxWidget.dart';
import 'package:superstore/src/models/vendor.dart';
import 'package:superstore/src/pages/pages.dart';

class FavShops extends StatefulWidget {
  @override
  _FavShopsState createState() => _FavShopsState();
}

class _FavShopsState extends StateMVC<FavShops> {
  FavShopController _con;

  _FavShopsState() : super(FavShopController()) {
    _con = controller;
  }

  @override
  // ignore: must_call_super
  void initState() {
    _con.listenForFavShopList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).primaryColorDark,
      leading:  IconButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PagesWidget()));
        },
        icon: Icon(Icons.arrow_back_ios),
        color: Theme.of(context).backgroundColor,
      ),
      title: Text(
        "Favourite Shops",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
      ),
      centerTitle: true,
    ),
      body: _con.favShopList.isEmpty
          ? EmptyOrdersWidget()
          : ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: _con.favShopList.length,
              shrinkWrap: true,
              primary: false,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, int index) {
                Vendor _shopTypeData = _con.favShopList.elementAt(index);

                return ShopList(
                  choice: _shopTypeData,
                  shopType: int.parse(_shopTypeData.shopType) ?? 0,
                  focusId: int.parse(_shopTypeData.focusType) ?? 0,
                  previewImage: _shopTypeData?.shopTypePreviewImage,
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 0);
              },
            ),
    );
  }
}
