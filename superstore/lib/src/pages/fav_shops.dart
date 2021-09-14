import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:superstore/src/components/chat_detail_page_appbar.dart';
import 'package:superstore/src/controllers/fav_shop_controller.dart';
import 'package:superstore/src/elements/EmptyOrdersWidget.dart';
import 'package:superstore/src/elements/ShopListBoxWidget.dart';
import 'package:superstore/src/models/vendor.dart';
import 'package:superstore/src/pages/Widget/customAppBar.dart';

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
      appBar: CustomAppBar(
        title: "Favourite Shops",
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
