import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:superstore/src/controllers/fav_shop_controller.dart';
import 'package:superstore/src/elements/SearchWidgetRe.dart';
import '../elements/RectangleLoaderWidget.dart';
import '../helpers/helper.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/vendor_controller.dart';
import '../elements/BottomBarWidget.dart';
import '../elements/Productbox1Widget.dart';
import '../models/restaurant_product.dart';
import '../models/vendor.dart';
import 'chat_detail_page.dart';

// ignore: must_be_immutable
class StoreViewDetails extends StatefulWidget {
  Vendor shopDetails;
  int shopTypeID;
  int focusId;

  StoreViewDetails({Key key, this.shopDetails, this.shopTypeID, this.focusId})
      : super(key: key);

  @override
  _StoreViewDetailsState createState() => _StoreViewDetailsState();
}

class _StoreViewDetailsState extends StateMVC<StoreViewDetails>
    with SingleTickerProviderStateMixin {
  VendorController _con;

  _StoreViewDetailsState() : super(VendorController()) {
    _con = controller;
  }

  final controller1 = ScrollController();
  double itemsCount = 25;

  // ignore: non_constant_identifier_names
  double AdBlockHeight = 130.0;
  double itemHeight = 130.0;
  double screenWidth = 0.0;
  double calculateSize = 0.0;
  double shopTitle = 10.0;
  double subOpacity = 1.0;
  bool popperShow = false;

  @override
  void initState() {
    super.initState();
    controller1.addListener(onScroll);
    _con.listenForRestaurantProduct(int.parse(widget.shopDetails.shopId));
    //   _tabController = TabController(vsync: this, length: );
  }

  tabMaker() {
    // ignore: deprecated_member_use
    List<Tab> tabs = List();

    _con.vendorResProductList.forEach((element) {
      tabs.add(Tab(
        text: element.category_name,
      ));
    });
    return tabs;
  }

  onScroll() {
    setState(() {
      calculateSize = itemHeight - controller1.offset;

      if (calculateSize > 65) {
        AdBlockHeight = calculateSize;
        shopTitle = controller1.offset;
        subOpacity = 0;
      }
      if (shopTitle < 10) {
        shopTitle = 10;
        subOpacity = 1.0;
      }
      //print(cWidth);
      //loginWidth = 250.0;
    });
  }

  void callback(bool nextPage) {
    setState(() {
      this.popperShow = nextPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _con.vendorResProductList.length,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: popperShow
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: FlareActor(
                      'assets/img/winners.flr',
                      animation: 'boom',
                    )),
              )
            : BottomBarWidget(),
        body: NestedScrollView(
          controller: controller1,
          headerSliverBuilder: (BuildContext context, bool isScrolled) {
            return [
              TransitionAppBar(
                extent: 250,
                shopTitle: shopTitle,
                shopDetails: widget.shopDetails,
                shopTypeID: widget.shopTypeID,
                subOpacity: subOpacity,
                focusId: widget.focusId,
                callback: this.callback,
                itemDetails: _con.vendorResProductList,
                avatar: Container(
                  height: 50,
                  width: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(widget.shopDetails.logo),
                        fit: BoxFit.fill),
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                ),
                title: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                ),
                height: AdBlockHeight,
              ),
              SliverPersistentHeader(
                floating: false,
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    indicatorWeight: 2.0,
                    isScrollable: true,
                    indicatorColor: Colors.red,
                    unselectedLabelColor: Colors.grey,
                    tabs: tabMaker(),
                  ),
                ),
              ),
            ];
          },
          body: _con.vendorResProductList.isEmpty
              ? RectangleLoaderWidget()
              : TabBarView(
                  children: List.generate(
                    _con.vendorResProductList.length,
                    (index) {
                      RestaurantProduct _productDetails =
                          _con.vendorResProductList.elementAt(index);
                      return ProductBox1Widget(
                        productData: _productDetails.productdetails,
                        shopId: widget.shopDetails.shopId,
                        shopName: widget.shopDetails.shopName,
                        subtitle: widget.shopDetails.subtitle,
                        km: widget.shopDetails.distance,
                        shopTypeID: widget.shopTypeID,
                        latitude: widget.shopDetails.latitude,
                        longitude: widget.shopDetails.longitude,
                        callback: this.callback,
                        focusId: widget.focusId,
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}

class TransitionAppBar extends StatelessWidget {
  final Widget avatar;
  final Widget title;
  final double extent;
  final double height;
  final double shopTitle;
  final Vendor shopDetails;
  final double subOpacity;
  final int shopTypeID;
  final int focusId;
  final Function callback;
  final List<RestaurantProduct> itemDetails;

  TransitionAppBar(
      {this.avatar,
      this.title,
      this.extent = 250,
      this.height,
      this.shopTitle,
      this.shopDetails,
      this.subOpacity,
      this.shopTypeID,
      this.focusId,
      this.itemDetails,
      this.callback,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _TransitionAppBarDelegate(
          shopTypeID: shopTypeID,
          avatar: avatar,
          title: title,
          extent: extent > 200 ? extent : 91,
          height: height,
          shopTitle: shopTitle,
          shopDetails: shopDetails,
          itemDetails: itemDetails,
          callback: callback,
          focusId: focusId,
          subOpacity: subOpacity,
          scrollController: null),
    );
  }
}

class _TransitionAppBarDelegate extends SliverPersistentHeaderDelegate {
  final _avatarMarginTween = EdgeInsetsTween(
      begin: EdgeInsets.only(top: 40, bottom: 70, left: 30),
      end: EdgeInsets.only(
        left: 30,
        top: 30.0,
        bottom: 10,
      ));
  final _avatarAlignTween =
      AlignmentTween(begin: Alignment.topLeft, end: Alignment.bottomLeft);
  final double heights;
  final Widget avatar;
  final Widget title;
  final double extent;
  final double height;
  final double shopTitle;
  final Vendor shopDetails;
  final double subOpacity;
  final int shopTypeID;
  final Function callback;
  final int focusId;
  final List<RestaurantProduct> itemDetails;

  _TransitionAppBarDelegate({
    this.avatar,
    this.heights,
    this.title,
    this.extent = 250,
    this.height,
    this.shopTitle,
    this.shopDetails,
    this.subOpacity,
    this.shopTypeID,
    this.itemDetails,
    this.focusId,
    this.callback,
    @required ScrollController scrollController,
  })  : assert(avatar != null),
        assert(extent == null || extent >= 200),
        assert(title != null);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double tempVal = 34 * maxExtent / 100;
    final progress = shrinkOffset > tempVal ? 1.0 : shrinkOffset / tempVal;

    final avatarMargin = _avatarMarginTween.lerp(progress);
    final avatarAlign = _avatarAlignTween.lerp(progress);

    return Stack(
      children: <Widget>[
        Image(
            image: shopDetails.cover == 'no_image' && shopTypeID == 2
                ? AssetImage(
                    'assets/img/resturentdefaultbg.jpg',
                  )
                : NetworkImage(shopDetails.cover),
            height: 190,
            width: double.infinity,
            fit: BoxFit.cover),
        Padding(
          padding: EdgeInsets.only(top: 40, right: 20),
          child: Align(
              alignment: Alignment.topRight,
              child: Wrap(children: [
                Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).accentColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                          ),
                        ]),
                    child: IconButton(
                      icon: new Icon(Icons.chat,
                          color: Theme.of(context).primaryColorLight, size: 18),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatDetailPage(
                                shopId: shopDetails.shopId,
                                shopName: shopDetails.shopName,
                                shopMobile: '12')));
                      },
                    )),
                SizedBox(width: 20),
                Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                          ),
                        ]),
                    child: IconButton(
                      icon: new Icon(Icons.close, size: 18),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
              ])),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: AnimatedContainer(
              color: Colors.transparent,
              duration: Duration(seconds: 0),
              height: height,
              width: double.infinity,
              child: Card(
                color: Theme.of(context).primaryColor,
                elevation: 10.0,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10, left: shopTitle, right: 10),
                        child: Row(children: [

                          Text(shopDetails.shopName,
                              textAlign: TextAlign.center,
                              style:
                                  Theme.of(context).textTheme.headline6),
                          Expanded(
                            child: Text("  (9AM - 9PM)",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2),
                          ),

                          Wrap(
                            children: [
                              FavButton(vendorData: shopDetails),
                              SizedBox(width: 2),
                            ],
                          )
                        ]),
                      ),
                      Padding(
                          padding:
                              EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: subOpacity == 1.0
                              ? Text(
                                  shopDetails.subtitle,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                )
                              : Text('')),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 8, left: 10, right: 10, bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(children: [
                                Column(
                                  children: [
                                    Text(
                                        Helper.priceDistance(
                                            shopDetails.distance),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                    Text('Distance'),
                                  ],
                                ),
                                SizedBox(width: 10),
                                Column(
                                  children: [
                                    Text(
                                        '${Helper.calculateTime(double.parse(shopDetails.distance.replaceAll(',', '')))}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                    Text('Delivery Time'),
                                  ],
                                ),
                                SizedBox(width: 10),
                                Column(
                                  children: [
                                    Text('Opened',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                    Text('Status'),
                                  ],
                                ),
                              ]),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SearchResultWidgetRe(
                                          itemDetails: itemDetails,
                                          shopId: shopDetails.shopId,
                                          shopName: shopDetails.shopName,
                                          subtitle: shopDetails.subtitle,
                                          km: shopDetails.distance,
                                          shopTypeID: shopTypeID,
                                          latitude: shopDetails.latitude,
                                          longitude: shopDetails.longitude,
                                          callback: this.callback,
                                          focusId: focusId,
                                        )));
                              },
                              icon: Icon(Icons.search),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: avatarMargin,
          child: Align(
              alignment: avatarAlign,
              child: Hero(tag: shopDetails.shopId, child: avatar)),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: title,
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => (maxExtent * 68) / 100;

  @override
  bool shouldRebuild(_TransitionAppBarDelegate oldDelegate) {
    return avatar != oldDelegate.avatar || title != oldDelegate.title;
  }
}

class FavButton extends StatefulWidget {
  final Vendor vendorData;

  const FavButton({Key key, this.vendorData}) : super(key: key);
  @override
  _FavButtonState createState() => _FavButtonState();
}

class _FavButtonState extends StateMVC<FavButton> {
  // bool isFavourite = false;
  FavShopController _con;
  _FavButtonState() : super(FavShopController()) {
    _con = controller;
  }

  Widget build(BuildContext context,) {

    return Container(
        child: GestureDetector(
      onTap: () {
        setState(() {
          widget.vendorData
              ?.isFavourite =
          !(widget.vendorData
              ?.isFavourite ??
              false);
          widget.vendorData?.isFavourite ==
              true
              ? _con?.addFavShop(
              context,
              widget.vendorData)
              : _con?.deleteFavShop(
              context,
              widget.vendorData);
        });
      },
      child: Icon(
        widget.vendorData.isFavourite == true ? Icons.favorite : Icons.favorite_border,
        color: Colors.red,
      ),
    ));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Theme.of(context).primaryColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
