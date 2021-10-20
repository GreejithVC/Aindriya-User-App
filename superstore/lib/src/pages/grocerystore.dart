import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:superstore/src/elements/image_zoom.dart';
import 'package:superstore/src/models/delivery_options_model.dart';
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
  double AdBlockHeight = 160.0;
  double itemHeight = 160.0;
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
            ];
          },
          body: (_con.subScribedPackage?.expiryDate?.isNotEmpty == true
                      ? DateFormat("dd/MM/yyyy")
                          ?.parse(_con.subScribedPackage?.expiryDate)
                          ?.isBefore(DateTime.now())
                      : true) ||
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
  final DeliveryOptionsModel deliveryOptionsModel;
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
      this.deliveryOptionsModel,
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
          deliveryOptionsModel: deliveryOptionsModel,
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
    this.subscribedPackage,
    this.deliveryOptionsModel,
    @required ScrollController scrollController,
  })  : assert(avatar != null),
        assert(extent == null || extent >= 200),
        assert(title != null);
  int selectedRadio;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double tempVal = 34 * maxExtent / 100;
    final progress = shrinkOffset > tempVal ? 1.0 : shrinkOffset / tempVal;

    final avatarMargin = _avatarMarginTween.lerp(progress);
    final avatarAlign = _avatarAlignTween.lerp(progress);

    return Column(
      children: [
        Container(
          height: 200,
          child: PageView.builder(
            itemCount: shopDetails?.coverImageList?.length ?? 0,
            scrollDirection: Axis.horizontal,
            controller: _pageController,
            // onPageChanged: _onPageChanged,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ImageZoomScreen(
                        imageUrl:
                            shopDetails.coverImageList.elementAt(index))));
              },
              child: Image(
                  image: shopDetails.coverImageList.elementAt(index) ==
                              'no_image' &&
                          shopTypeID == 2
                      ? AssetImage(
                          'assets/img/resturentdefaultbg.jpg',
                        )
                      : NetworkImage(
                          shopDetails.coverImageList.elementAt(index)),
                  height: 190,
                  width: double.infinity,
                  fit: BoxFit.cover),
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: <Widget>[
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
                                color: Theme.of(context).primaryColorLight,
                                size: 18),
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
                                  child: Text(
                                      "  (${shopDetails?.openTime ?? ""} - ${shopDetails?.closeTime ?? ""})",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2),
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
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10),
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
                                                      subscribedPackage
                                                          ?.expiryDate,
                                                  availableCOD:
                                                      deliveryOptionsModel
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
                                      currentSearch.value.shopName =
                                          shopDetails.shopName;
                                      currentSearch.value.shopTypeID =
                                          shopTypeID;
                                      currentSearch.value.shopId =
                                          shopDetails.shopId;
                                      currentSearch.value.latitude =
                                          shopDetails.latitude;
                                      currentSearch.value.longitude =
                                          shopDetails.longitude;
                                      currentSearch.value.km =
                                          shopDetails.distance;
                                      currentSearch.value.subtitle =
                                          shopDetails.subtitle;

                                      Navigator.of(context).push(SearchModal());
                                    },
                                    icon: Icon(Icons.search),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, right: 8),
                                  child: deliveryOptionsModel?.availableCOD ==
                                          true
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
                                    color: deliveryOptionsModel?.availableCOD ==
                                            true
                                        ? Colors.black
                                        : Colors.grey.withOpacity(0.4),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: deliveryOptionsModel
                                              ?.availableTakeAway ==
                                          true
                                      ? Image.asset(
                                          'assets/img/takeaway.png',
                                          scale: 22,
                                        )
                                      : Image.asset('assets/img/takeaway.png',
                                          scale: 22,
                                          color: Colors.grey.withOpacity(0.2)),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 20),
                                  child: Text(
                                    'TakeAway',
                                    style: TextStyle(
                                        color: deliveryOptionsModel
                                                    ?.availableTakeAway ==
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
          ),
        ),
      ],
    );
  }

  String getStatus(
      {String expiryDateString, bool availableCOD, bool availableTakeaway}) {
    print("isexpire in grocery /////////////////////getStatus");
    print(expiryDateString);
    print(availableCOD);
    print(availableTakeaway);
    print(expiryDateString);
    print(DateFormat("dd/MM/yyyy")?.parse(expiryDateString));
    print((expiryDateString?.isNotEmpty == true
        ? DateFormat("dd/MM/yyyy")
            ?.parse(expiryDateString)
            ?.isBefore(DateTime.now())
        : true));
    print((availableCOD != true && availableTakeaway != true));
    print(DateTime.now());
    print("expiry ,,,,,,,,,,,,,,,,,");
    return (expiryDateString?.isNotEmpty == true
                ? DateFormat("dd/MM/yyyy")
                    ?.parse(expiryDateString)
                    ?.isBefore(DateTime.now())
                : true) ||
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
