import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:superstore/src/controllers/fav_shop_controller.dart';
import 'package:superstore/src/elements/EmptyOrdersWidget.dart';
import 'package:superstore/src/elements/ShopListBoxWidget.dart';

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
        titleSpacing: 0,
        title: Container(
            width: double.infinity,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FAV SHOPS',
                            style: Theme.of(context).textTheme.subtitle2,
                            textAlign: TextAlign.left,
                          ),
                        ]),
                  ),
                ],
              ),
            ])),
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
                return ShopList(
                  choice: _con.favShopList[index],
                  shopType: int.parse(_con.favShopList[index].shopType) ?? 0,
                  focusId: int.parse(_con.favShopList[index].focusType) ?? 0,
                  previewImage: _con.favShopList[index]?.shopTypePreviewImage,
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 0);
              },
            ),
    );
  }
}
