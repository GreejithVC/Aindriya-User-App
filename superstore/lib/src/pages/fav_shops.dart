import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
  bool startSelecting = false;
  bool selectAll = false;

  _FavShopsState() : super(FavShopController()) {
    _con = controller;
  }

  @override
  // ignore: must_call_super
  void initState() {
    print(startSelecting);
    print("startSelecting");
    _con.listenForFavShopList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColorDark,
          leading: startSelecting!= true ? IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => PagesWidget()));
            },
            icon: Icon(Icons.arrow_back_ios),
            // color: Theme.of(context).backgroundColor,
          ):null,
          title: startSelecting == false ?Text(
            "Favourite Shops",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ): GestureDetector(
            onTap: () {
              print(startSelecting);
              print("startSelecting");
              print("select all");

              setState(() {
                selectAll = !(selectAll);
                if(selectAll== true){
                  _con?.favShopList?.forEach((element) {element.isSelected=true;});
                } else {
                  _con?.favShopList?.forEach((element) {element.isSelected=false;});
                }
                // startSelecting = false;
              });
            },
            child: Row(mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selectAll == true?Icons.check_circle:Icons.circle_outlined,
                  size: 25,
                ),
                Text("  Select All",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
              ],
            ),
          ),
          centerTitle: startSelecting != true,
          actions: [
            // Visibility(
            //     visible: startSelecting == true,
            //     child: GestureDetector(
            //         onTap: () {
            //           print(startSelecting);
            //           print("startSelecting");
            //           print("select all");
            //
            //           setState(() {
            //             selectAll = !(selectAll);
            //            if(selectAll== true){
            //              _con?.favShopList?.forEach((element) {element.isSelected=true;});
            //            } else {
            //              _con?.favShopList?.forEach((element) {element.isSelected=false;});
            //            }
            //             // startSelecting = false;
            //           });
            //         },
            //         child: Padding(
            //           padding: const EdgeInsets.only(right: 24, left: 4),
            //           child: Icon(
            //              selectAll == true?Icons.check_circle:Icons.circle_outlined,
            //             size: 25,
            //           ),
            //         ))),
            Visibility(
                visible: startSelecting == true,
                child: GestureDetector(
                    onTap: () {
                      print(startSelecting);
                      print("startSelecting");
                      print("deleteSelectedFavShop");
                      _con?.deleteSelectedFavShop(context);
                      setState(() {
                        startSelecting = false;
                        print(startSelecting);
                        print("startSelecting");
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4, left: 4),
                      child: Icon(
                        Icons.delete,
                        size: 26,
                      ),
                    ))),
            Visibility(
              visible: startSelecting == true,
              child: GestureDetector(
                onTap: () {
                  print(startSelecting);
                  print("startSelecting");
                  print("cancel deleteSelectedFavShop");

                  setState(() {
                    startSelecting = false;
                    print(startSelecting);
                    print("startSelecting");
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8, left: 4),
                  child: Icon(
                    Icons.cancel,
                    size: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: (_con?.favShopList?.length ?? 0) > 0
            ? StaggeredGridView.countBuilder(
                scrollDirection: Axis.vertical,
                itemCount: _con.favShopList.length,
                shrinkWrap: true,
                crossAxisCount: 2,
                primary: false,
                padding: EdgeInsets.only(top: 16),
                itemBuilder: (context, int index) {
                  Vendor _shopTypeData = _con.favShopList.elementAt(index);

                  return GestureDetector(
                    onLongPress: () {
                      _con?.favShopList?.forEach((element) {
                        element.isSelected = false;
                      });
                      setState(() {
                        startSelecting = true;
                        selectAll =false;

                        print(startSelecting);
                        print("startSelecting");
                      });
                    },
                    child: ShopListGrid(
                      choice: _shopTypeData,
                      shopType: int.parse(_shopTypeData.shopType) ?? 0,
                      focusId: int.parse(_shopTypeData.focusType) ?? 0,
                      previewImage: _shopTypeData?.shopTypePreviewImage,
                      startSelecting: startSelecting,

                      // onItemSelected: (selectedItem) {
                      //                   //      _con?.isSelected = false;
                      //                   // },
                    ),
                  );
                },
                staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                mainAxisSpacing: 10,
                crossAxisSpacing: 5,
              )
            : EmptyOrdersWidget());
  }
}
