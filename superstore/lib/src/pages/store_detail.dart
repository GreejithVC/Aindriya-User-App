import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:superstore/src/controllers/add_review_controller.dart';
import 'package:superstore/src/controllers/fav_shop_controller.dart';
import 'package:superstore/src/elements/SearchWidgetRe.dart';
import 'package:superstore/src/elements/image_zoom.dart';
import 'package:superstore/src/models/add_review_modelclass.dart';
import 'package:superstore/src/models/delivery_options_model.dart';
import 'package:superstore/src/models/packagetype.dart';
import 'package:superstore/src/pages/shop_reviews.dart';
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
    _con.listenForReviewList(id: widget.shopDetails.shopId, isShop: true);
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
                shopTitle: shopTitle,
                shopDetails: widget.shopDetails,
                shopTypeID: widget.shopTypeID,
                subOpacity: subOpacity,
                focusId: widget.focusId,
                callback: this.callback,
                itemDetails: _con.vendorResProductList,
                subscribedPackage: _con.subScribedPackage,
                deliveryOptionsModel: _con.deliveryOptionsModel,
                reviewList: _con?.reviewList,
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
                          ?.parse(_con.subScribedPackage?.expiryDate)
                          ?.isBefore(DateTime.now())
                      : true) ||
                  (_con.deliveryOptionsModel?.availableCOD != true &&
                      _con.deliveryOptionsModel?.availableTakeAway != true)
              ? Center(
                  child: Text(_con?.isFetching == true
                      ? ""
                      : "Sorry this shop is currently closed"))
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
                            deliveryRadius: widget.shopDetails.deliveryRadius,
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

  String getStatus(
      {String expiryDateString, bool availableCOD, bool availableTakeaway}) {
    print("isexpire in store /////////////////////getStatus");
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
}

class TransitionAppBar extends StatelessWidget {
  final Widget avatar;
  final Widget title;
  final double shopTitle;
  final Vendor shopDetails;
  final double subOpacity;
  final int shopTypeID;
  final int focusId;
  final Function callback;
  final List<RestaurantProduct> itemDetails;
  final PackageTypeModel subscribedPackage;
  final DeliveryOptionsModel deliveryOptionsModel;
  final List<AddReview> reviewList;

  TransitionAppBar(
      {this.avatar,
      this.title,
      this.shopTitle,
      this.shopDetails,
      this.subOpacity,
      this.shopTypeID,
      this.focusId,
      this.itemDetails,
      this.callback,
      this.subscribedPackage,
      this.deliveryOptionsModel,
      Key key,
      this.reviewList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _TransitionAppBarDelegate(
          shopTypeID: shopTypeID,
          avatar: avatar,
          title: title,
          shopTitle: shopTitle,
          shopDetails: shopDetails,
          subscribedPackage: subscribedPackage,
          deliveryOptionsModel: deliveryOptionsModel,
          itemDetails: itemDetails,
          callback: callback,
          focusId: focusId,
          subOpacity: subOpacity,
          reviewList: reviewList,
          scrollController: null),
    );
  }
}

class _TransitionAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget avatar;
  final Widget title;
  final double shopTitle;
  final Vendor shopDetails;
  final double subOpacity;
  final int shopTypeID;
  final Function callback;
  final int focusId;
  final List<RestaurantProduct> itemDetails;
  final List<AddReview> reviewList;
  final PackageTypeModel subscribedPackage;
  final DeliveryOptionsModel deliveryOptionsModel;

  _TransitionAppBarDelegate({
    this.avatar,
    this.title,
    this.shopTitle,
    this.shopDetails,
    this.subOpacity,
    this.shopTypeID,
    this.itemDetails,
    this.focusId,
    this.callback,
    this.subscribedPackage,
    this.deliveryOptionsModel,
    this.reviewList,
    @required ScrollController scrollController,
  })  : assert(avatar != null),
        assert(title != null);
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double averageRating = ((reviewList?.fold(
                0.0,
                (previousValue, element) =>
                    previousValue + double.tryParse(element?.rating ?? "0")) ??
            0) /
        (reviewList?.length ?? 0));
    return ListView(
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Stack(
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
            Visibility(
              visible: double.tryParse(shopDetails?.distance?.isNotEmpty == true
                      ? shopDetails?.distance
                      : "0") >
                  double.tryParse(
                      shopDetails?.deliveryRadius?.isNotEmpty == true
                          ? shopDetails?.deliveryRadius
                          : "0"),
              child: Container(
                width: double.infinity,
                padding:
                    EdgeInsets.only(top: 28, left: 12, bottom: 8, right: 12),
                color: Colors.black.withOpacity(0.7),
                child: Text(
                    "The shop too far away from your location. Please change your delivery/pickup location.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70)),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(shopDetails?.shopName,
                        style: Theme.of(context).textTheme.headline6),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SearchResultWidgetRe(
                                itemDetails: itemDetails,
                                shopId: shopDetails.shopId,
                                shopName: shopDetails.shopName,
                                subtitle: shopDetails.subtitle,
                                km: shopDetails.distance,
                                deliveryRadius: shopDetails.deliveryRadius,
                                shopTypeID: shopTypeID,
                                latitude: shopDetails.latitude,
                                longitude: shopDetails.longitude,
                                callback: this.callback,
                                focusId: focusId,
                              )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        Icons.search,
                        color: Color(0xFF49aecb),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      child: new Icon(Icons.chat,
                          color: Color(0xFF49aecb),
                          // Color(0xFF333D37),
                          size: 24),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatDetailPage(
                                shopId: shopDetails?.shopId,
                                shopName: shopDetails?.shopName,
                                shopMobile: '12')));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Image.asset(
                      'assets/img/location.png',
                      height: 26,
                      fit: BoxFit.contain,
                    ),
                  ),
                  FavButton(vendorData: shopDetails),
                ],
              ),
              Row(
                children: [
                  Text(
                    (averageRating > 0)
                        ? "${averageRating?.toStringAsFixed(1) ?? 0} "
                        : "No Reviews ",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                    child: AbsorbPointer(
                      child: RatingBar(
                        itemSize: 16,
                        initialRating:
                            (averageRating > 0) ? averageRating ?? 0 : 0,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        allowHalfRating: true,
                        itemPadding: EdgeInsets.symmetric(horizontal: 0),
                        ratingWidget: RatingWidget(
                          full: Icon(
                            Icons.star_purple500_sharp,
                            color: Theme.of(context).accentColor,
                          ),
                          half: Icon(
                            Icons.star_half,
                            color: Theme.of(context).accentColor,
                          ),
                          empty: Icon(
                            Icons.star_border,
                            color: Colors.grey,
                          ),
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ShopReviews(
                                shopDetails: shopDetails,
                                shopTypeID: shopTypeID,
                              )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "View All Review »",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  shopDetails?.subtitle,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                ),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.black12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  "Shop Status",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF49aecb)),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 24,
                        color: Color(0xFF333D37),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          "${shopDetails?.openTime ?? ""} - ${shopDetails?.closeTime ?? ""}",
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.store_mall_directory,
                        size: 24,
                        color: Color(0xFF333D37),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          getStatus(
                              expiryDateString: subscribedPackage?.expiryDate,
                              availableCOD: deliveryOptionsModel?.availableCOD,
                              availableTakeaway:
                                  deliveryOptionsModel?.availableTakeAway),
                        ),
                      ),
                    ],
                  ),
                  itemOption(
                      image: "assets/img/homedelivery.png",
                      title: "HomeDelivery",
                      isEnable: deliveryOptionsModel?.availableCOD == true),
                  itemOption(
                      image: "assets/img/takeawayicon.png",
                      title: "TakeAway",
                      isEnable:
                          deliveryOptionsModel?.availableTakeAway == true),
                ],
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.black12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  "Payment Options",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF49aecb)),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    itemOption(
                        image: "assets/img/ic_cod.png",
                        title: "COD",
                        isEnable: true),
                    itemOption(
                        image: "assets/img/ic_upi.png",
                        title: "UPI",
                        isEnable: true),
                    itemOption(
                        image: "assets/img/ic_card.png",
                        title: "Card",
                        isEnable: true),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget itemOption({String image, String title, bool isEnable}) {
    return Column(
      children: [
        Image.asset(
          image,
          height: 24,
          color: isEnable ? Color(0xFF333D37) : Colors.grey.withOpacity(0.4),
          fit: BoxFit.contain,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            title,
            style: TextStyle(
              color:
                  isEnable ? Color(0xFF333D37) : Colors.grey.withOpacity(0.4),
            ),
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
  double get maxExtent => 460;

  @override
  double get minExtent => 200;

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
