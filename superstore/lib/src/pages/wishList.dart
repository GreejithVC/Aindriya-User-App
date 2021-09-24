import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:superstore/src/controllers/fav_product_controller.dart';
import 'package:superstore/src/elements/CardsCarouselLoaderWidget.dart';
import 'package:superstore/src/models/favouriteProduct.dart';
import 'package:superstore/src/models/vendor.dart';
import 'package:superstore/src/pages/pages.dart';

class WishList extends StatefulWidget {

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends StateMVC<WishList> {
  FavProductController _con;

  _WishListState() : super(FavProductController()) {
    _con = controller;
  }

  @override
  // ignore: must_call_super
  void initState() {
    _con.listenForFavProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColorDark,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => PagesWidget()));
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Theme.of(context).backgroundColor,
        ),
        title: Text(
          "WishList",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
      ),
      // CustomAppBar(
      //   title: "WishList",
      // ),
      body:
          // _con.favProductList.isEmpty
          //     ? EmptyOrdersWidget()
          _con.favProductList.isEmpty
              ? Container(
                  height: 280,
                  padding: EdgeInsets.only(top: 0),
                  child: CardsCarouselLoaderWidget())
              : StaggeredGridView.countBuilder(
                  padding: EdgeInsets.all(20),
                  crossAxisCount: 4,
                  itemCount: _con.favProductList.length,
                  itemBuilder: (BuildContext context, int index) {
                    FavouriteProduct _shopTypeData =
                        _con.favProductList.elementAt(index);

                    return Container(
                      height: 250,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.1),
                              blurRadius: 3.0,
                              spreadRadius: 1.5,
                            ),
                          ]),
                      child: GestureDetector(
                        onTap: () {
                          // currentSearch?.value?.shopTypeID =
                          //     _shopTypeData?.shopId?.isNotEmpty == true
                          //         ? int.tryParse(_shopTypeData?.shopId)
                          //         : 0;
                          _con.saveSearch(_shopTypeData.productName);

                          print("buton hit");
                        },
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                  //borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(0),
                                  ),
                                  child: Image(
                                      image: _shopTypeData.image == 'no_image'
                                          ? AssetImage('assets/img/loginbg.jpg')
                                          : NetworkImage(_shopTypeData.image),
                                      width: double.infinity,
                                      height: 180,
                                      fit: BoxFit.cover)),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10, top: 15),
                                              child: Text(
                                                  _shopTypeData.productName,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8),
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 5,
                                                  right: 5,
                                                  top: 1,
                                                  bottom: 1),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    print("fav tapped");
                                                    setState(() {
                                                      _con?.favProductList?.any(
                                                                  (item) =>
                                                                      item.id ==
                                                                      _shopTypeData
                                                                          .id) ==
                                                              true
                                                          ? _con
                                                              ?.deleteFavProduct(
                                                                  context,
                                                                  _shopTypeData)
                                                          : _con?.addFavProduct(
                                                              context,
                                                              _shopTypeData);
                                                    });
                                                  },
                                                  child: Icon(
                                                    _con?.favProductList?.any(
                                                                (item) =>
                                                                    item.id ==
                                                                    _shopTypeData
                                                                        .id) ==
                                                            true
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    color: Colors.red,
                                                  )),
                                              // Text('${_vendorData.rate} ✩',
                                              //   style:Theme.of(context)
                                              //       .textTheme
                                              //       .subtitle1
                                              //       .merge(TextStyle(color: Theme.of(context).primaryColorLight,)
                                              //   ),
                                              // ),
                                            ),
                                          ),
                                        ]),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: 10, left: 10),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Rs ",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption),
                                            Expanded(
                                              child: Text(_shopTypeData.price,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption),
                                            ),
                                          ]),
                                    ),
                                  ])
                            ]),
                      ),
                    );
                  },
                  staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
    );
  }
}
