import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:superstore/src/models/packagetype.dart';
import 'package:superstore/src/pages/store_detail.dart';
import 'package:superstore/src/pages/upload_prescription.dart';

import '../helpers/helper.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../elements/SearchWidget.dart';
import '../elements/TopCategoriesWidget.dart';
import '../repository/product_repository.dart';
import '../controllers/vendor_controller.dart';
import '../models/vendor.dart';
import 'chat_detail_page.dart';

// ignore: must_be_immutable
class GroceryStoreWidget extends StatefulWidget {
  Vendor shopDetails;

  // PackageTypeModel subScribedPackage;
  int shopTypeID;
  int focusId;

  GroceryStoreWidget({
    Key key,
    this.shopDetails,
    this.shopTypeID,
    this.focusId,
    // this.subScribedPackage,
  }) : super(key: key);

  @override
  _GroceryStoreWidgetState createState() => _GroceryStoreWidgetState();
}

class _GroceryStoreWidgetState extends StateMVC<GroceryStoreWidget>
    with SingleTickerProviderStateMixin {
  VendorController _con;

  _GroceryStoreWidgetState() : super(VendorController()) {
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
  bool popperShow = true;

  @override
  void initState() {
    super.initState();
    controller1.addListener(onScroll);
    _con.listenForCategories(widget.shopDetails.shopId);
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

  @override
  Widget build(BuildContext context) {
    print("expiry ////subScribedPackage?.expiryDate");
    print(_con?.subScribedPackage?.expiryDate);
    print("expiry ////.deliveryOptionsModel?.availableCOD");
    print(_con.deliveryOptionsModel?.availableCOD);
    print("expiry ////deliveryOptionsModel?.availableTakeAway");
    print(_con.deliveryOptionsModel?.availableTakeAway);
    return DefaultTabController(
      length: _con.vendorResProductList.length,
      child: Scaffold(
        floatingActionButton: widget.shopTypeID == 3
            ? FloatingActionButton(
                elevation: 2,
                child: new Icon(Icons.camera_alt),
                backgroundColor: new Color(0xFFE57373),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UploadPrescription(
                            shopTypeID: widget.shopTypeID,
                            shopDetails: widget.shopDetails,
                            focusId: widget.focusId,
                          )));
                })
            : Container(),
        body: NestedScrollView(
          controller: controller1,
          headerSliverBuilder: (BuildContext context, bool isScrolled) {
            return [
              TransitionAppBar(
                extent: 250,
                shopTitle: shopTitle,
                shopDetails: widget.shopDetails,
                subOpacity: subOpacity,
                shopTypeID: widget.shopTypeID,
                subscribedPackage: _con.subScribedPackage,
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
            ];
          },
          body: ((_con.subScribedPackage?.expiryDate?.isNotEmpty == true
                              ? DateFormat("dd/mm/yyyy")
                                  ?.parse(_con.subScribedPackage?.expiryDate)
                              : DateTime.now())
                          .isBefore(DateTime.now()) ==
                      true) ||
                  (_con.deliveryOptionsModel?.availableCOD != true &&
                      _con.deliveryOptionsModel?.availableTakeAway != true)
              ? Center(child: Text("Sorry this shop is currently closed"))
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(height: 10),
                      TopCategoriesWidget(
                        focusId: widget.focusId,
                        categoryData: _con.categories,
                        shopId: widget.shopDetails.shopId,
                        shopName: widget.shopDetails.shopName,
                        subtitle: widget.shopDetails.subtitle,
                        km: widget.shopDetails.distance,
                        shopTypeID: widget.shopTypeID,
                        latitude: widget.shopDetails.latitude,
                        longitude: widget.shopDetails.longitude,
                      ),
                    ],
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
  final PackageTypeModel subscribedPackage;
  final double subOpacity;
  final int shopTypeID;

  TransitionAppBar(
      {this.avatar,
      this.title,
      this.extent = 250,
      this.height,
      this.shopTitle,
      this.shopDetails,
      this.shopTypeID,
      this.subOpacity,
      this.subscribedPackage,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _TransitionAppBarDelegate(
          avatar: avatar,
          title: title,
          extent: extent > 200 ? extent : 91,
          height: height,
          shopTitle: shopTitle,
          shopDetails: shopDetails,
          subscribedPackage: subscribedPackage,
          shopTypeID: shopTypeID,
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
  final PackageTypeModel subscribedPackage;
  final double subOpacity;
  final int shopTypeID;

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
    this.subscribedPackage,
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
            image: shopDetails.cover == 'no_image' && shopTypeID == 3
                ? AssetImage(
                    'assets/img/pharmacydefaultbg.jpg',
                  )
                : shopDetails.cover == 'no_image' && shopTypeID == 1
                    ? AssetImage(
                        'assets/img/grocerydefaultbg.jpg',
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
                              // Text(shopDetails.rate, style: Theme.of(context).textTheme.subtitle2),
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
                                        subscribedPackage
                                                    ?.expiryDate?.isNotEmpty ==
                                                true
                                            ? getStatus(
                                                subscribedPackage?.expiryDate)
                                            : "",
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
                                currentSearch.value.shopName =
                                    shopDetails.shopName;
                                currentSearch.value.shopTypeID = shopTypeID;
                                currentSearch.value.shopId = shopDetails.shopId;
                                currentSearch.value.latitude =
                                    shopDetails.latitude;
                                currentSearch.value.longitude =
                                    shopDetails.longitude;
                                currentSearch.value.km = shopDetails.distance;
                                currentSearch.value.subtitle =
                                    shopDetails.subtitle;

                                Navigator.of(context).push(SearchModal());
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

  String getStatus(String expiryDateString) {
    print(expiryDateString);
    print(DateTime.now());
    print("expiry ,,,,,,,,,,,,,,,,,");
    DateTime expiryDate = expiryDateString?.isNotEmpty == true
        ? DateFormat("dd/mm/yyyy")?.parse(expiryDateString)
        : DateTime.now();
    final bool isExpired = expiryDate.isBefore(DateTime.now());
    print(isExpired);
    return isExpired ? "Closed" : "Opened";

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
