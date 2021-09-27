import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:superstore/src/controllers/fav_shop_controller.dart';
import 'package:superstore/src/elements/SearchWidgetRe.dart';
import 'package:superstore/src/models/delivery_options_model.dart';
import 'package:superstore/src/models/packagetype.dart';
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
  double AdBlockHeight = 160.0;
  double itemHeight = 160.0;
  double screenWidth = 0.0;
  double calculateSize = 0.0;
  double shopTitle = 10.0;
  double subOpacity = 1.0;
  bool popperShow = false;

  @override
  void initState() {
    print("shop id //lllllllllllllllllllll");
    print(widget.shopDetails.shopId);
    print(_con.listenForPackageSubscribed(widget.shopDetails.shopId));

    super.initState();
    controller1.addListener(onScroll);
    _con.listenForRestaurantProduct(int.parse(widget.shopDetails.shopId));
    _con.listenForPackageSubscribed(widget.shopDetails.shopId);
    _con.listenForDeliveryDetails(widget.shopDetails.shopId);
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
            print("isexpire in store");
            print(_con?.subScribedPackage?.expiryDate);
            print(_con.deliveryOptionsModel?.availableCOD);
            print(_con.deliveryOptionsModel?.availableTakeAway);
            print("expiry ////subScribedPackage?.expiryDate");
            print(_con?.subScribedPackage?.expiryDate);
            print("expiry ////.deliveryOptionsModel?.availableCOD");
            print(_con.deliveryOptionsModel?.availableCOD);
            print("expiry ////deliveryOptionsModel?.availableTakeAway");
            print(_con.deliveryOptionsModel?.availableTakeAway);

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
                subscribedPackage: _con.subScribedPackage,
                deliveryOptionsModel: _con.deliveryOptionsModel,
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
          body: (_con.subScribedPackage?.expiryDate?.isNotEmpty == true
                              ? DateFormat("dd/MM/yyyy")
                                  ?.parse(_con.subScribedPackage?.expiryDate)?.isBefore(DateTime.now())
                              :true)
                           ||
                  (_con.deliveryOptionsModel?.availableCOD != true &&
                      _con.deliveryOptionsModel?.availableTakeAway != true)
              ? Center(child: Text("Sorry this shop is currently closed"))
              : (_con.vendorResProductList.isEmpty
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
                    )),
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
  final PackageTypeModel subscribedPackage;
  final DeliveryOptionsModel deliveryOptionsModel;

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
      this.subscribedPackage,
      this.deliveryOptionsModel,
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
          subscribedPackage: subscribedPackage,
          deliveryOptionsModel: deliveryOptionsModel,
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
  final PackageTypeModel subscribedPackage;
  final DeliveryOptionsModel deliveryOptionsModel;

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
    this.subscribedPackage,
    this.deliveryOptionsModel,
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
                              style: Theme.of(context).textTheme.headline6),
                          Expanded(
                            child: Text(
                                "  (${shopDetails?.openTime ?? ""} - ${shopDetails?.closeTime ?? ""})",
                                style: Theme.of(context).textTheme.subtitle2),
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
                                    Text(
                                        getStatus(
                                            expiryDateString:
                                                subscribedPackage?.expiryDate,
                                            availableCOD: deliveryOptionsModel
                                                ?.availableCOD,
                                            availableTakeaway:
                                                deliveryOptionsModel
                                                    ?.availableTakeAway),
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
                      Row(
                        children: [
                          // Container(
                          //   // foregroundDecoration: BoxDecoration(
                          //   // color:deliveryOptionsModel?.availableCOD == true ? Colors.transparent :Colors.grey,
                          //   // backgroundBlendMode: BlendMode.saturation,
                          // ),
                          //   // color: deliveryOptionsModel?.availableCOD == true ? Colors.transparent :Colors.grey.withOpacity(0.1),
                          //   child: Row(
                          //     children: [
                          //       Image.asset('assets/img/cod.png',scale: 20,),
                          //       Text('COD',style: Theme.of(context).textTheme.bodyText1,),
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(width: 20,),
                          // Container(color: deliveryOptionsModel?.availableTakeAway == true ? Colors.transparent :Colors.grey.withOpacity(0.5),
                          //   child: Row(
                          //     children: [
                          //       Image.asset('assets/img/takeaway.png',scale: 22,),
                          //       Text('TakeAway',style: Theme.of(context).textTheme.bodyText1,),
                          //
                          //     ],
                          //   ),
                          // )
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 8),
                            // child: deliveryOptionsModel?.availableCOD == true ? Icon(Icons.radio_button_checked,color: Colors.blue,):Icon(Icons.radio_button_off,color: Colors.black,),
                            child: deliveryOptionsModel?.availableCOD == true
                                ? Image.asset(
                                    'assets/img/cod.png',
                                    scale: 20,
                                  )
                                : Image.asset(
                                    'assets/img/cod.png',
                                    scale: 20,
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                          ),
                          Text(
                            'COD',
                            style: TextStyle(
                              color: deliveryOptionsModel?.availableCOD == true
                                  ? Colors.black
                                  : Colors.grey.withOpacity(0.4),
                            ),
                          ),
                          SizedBox(
                            width: 45,
                          ),

                          // deliveryOptionsModel?.availableTakeAway == true ? Icon(Icons.radio_button_checked,color: Colors.blue,):Icon(Icons.radio_button_off,color: Colors.black,),
                          deliveryOptionsModel?.availableTakeAway == true
                              ? Image.asset(
                                  'assets/img/takeaway.png',
                                  scale: 22,
                                )
                              : Image.asset('assets/img/takeaway.png',
                                  scale: 22,
                                  color: Colors.grey.withOpacity(0.2)),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 20),
                            child: Text(
                              'TakeAway',
                              style: TextStyle(
                                  color:
                                      deliveryOptionsModel?.availableTakeAway ==
                                              true
                                          ? Colors.black
                                          : Colors.grey.withOpacity(0.4)),
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

  String getStatus(
      {String expiryDateString, bool availableCOD, bool availableTakeaway}) {
    print("isexpire in store /////////////////////getStatus");
    print(expiryDateString);
    print(availableCOD);
    print(availableTakeaway);
    print(expiryDateString);
    print(DateFormat("dd/MM/yyyy")
        ?.parse(expiryDateString));
    print((expiryDateString?.isNotEmpty == true
        ? DateFormat("dd/MM/yyyy")
        ?.parse(expiryDateString)
        ?.isBefore(DateTime.now())
        : true));
    print((availableCOD != true && availableTakeaway != true));
    print(DateTime.now());
    print("expiry ,,,,,,,,,,,,,,,,,");
    return (expiryDateString?.isNotEmpty == true
                        ? DateFormat("dd/MM/yyyy")?.parse(expiryDateString)?.isBefore(DateTime.now())
                        : true)
                    ||
            (availableCOD != true && availableTakeaway != true)
        ? "Closed"
        : "Open";
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
  FavShopController _con;

  _FavButtonState() : super(FavShopController()) {
    _con = controller;
  }

  @override
  // ignore: must_call_super
  void initState() {
    _con.listenForFavShopList();
  }

  Widget build(BuildContext context) {
    print("Fav Button ////");
    print(widget.vendorData.shopName);
    print(widget.vendorData.shopId);
    print(_con?.favShopList?.length);
    _con?.favShopList?.forEach((element) {
      print(element.shopId);
    });
    print(_con?.favShopList?.contains(widget.vendorData) == true);
    print(_con?.favShopList
        ?.any((item) => item.shopId == widget.vendorData.shopId));
    return Container(
        child: GestureDetector(
      onTap: () {
        setState(() {
          _con?.favShopList?.any(
                      (item) => item.shopId == widget.vendorData.shopId) ==
                  true
              ? _con?.deleteFavShop(context, widget.vendorData)
              : _con?.addFavShop(context, widget.vendorData);
        });
      },
      child: Icon(
        _con?.favShopList
                    ?.any((item) => item.shopId == widget.vendorData.shopId) ==
                true
            ? Icons.favorite
            : Icons.favorite_border,
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
