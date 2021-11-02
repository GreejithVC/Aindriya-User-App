import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:superstore/src/pages/ShowBillDetailsScreen.dart';
import '../repository/product_repository.dart';
import '../helpers/helper.dart';
import '../repository/order_repository.dart';
import '../controllers/cart_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../elements/CheckoutListWidget.dart';
import '../repository/product_repository.dart' as cartRepo;
import '../../generated/l10n.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends StateMVC<CheckoutPage> {
  bool popperShow = false;
  CartController _con;

  _CheckoutPageState() : super(CartController()) {
    _con = controller;
  }

  void callback(bool nextPage) {
    setState(() {
      this.popperShow = nextPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
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
            : Container(),
        body: CustomScrollView(
          slivers: <Widget>[
            ValueListenableBuilder(
                valueListenable: cartRepo.currentCart,
                builder: (context, _setting, _) {
                  // _con.grandSummary();
                  return SliverPersistentHeader(
                    pinned: true,
                    floating: false,
                    delegate: SliverCustomHeaderDelegate(
                      title: currentCheckout.value.shopName,
                      collapsedHeight: 70,
                      expandedHeight: 120,
                      paddingTop: MediaQuery.of(context).padding.top,
                      coverImgUrl:
                          'http://www.sriaghraharamatrimoni.com/assets/new_home_page/images/lp-3.png',
                      subtitle:
                          '${currentCart.value.length} ${S.of(context).items}, to pay  ${Helper.pricePrint(currentCheckout.value.grand_total)}',
                    ),
                  );
                }),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                CheckoutListWidget(
                  con: _con,
                  callback: this.callback,
                ),
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 6,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ValueListenableBuilder(
                          valueListenable: cartRepo.currentCart,
                          builder: (context, _setting, _) {
                            return Column(children: [
                              currentCheckout.value.deliveryPossible
                                  ? Container()
                                  : Container(
                                child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: size.width * 0.2,
                                              right: size.width * 0.2,
                                              top: 10),
                                          child: Container(
                                            width: double.infinity,
                                            // ignore: deprecated_member_use
                                            child: FlatButton(
                                              onPressed: () {
                                                /*Navigator.of(context).pushNamed('/Login');*/
                                              },
                                              padding: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 10,
                                                  bottom: 10),
                                              color: Colors.blueGrey.shade900,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'CHANGE ADDRESS',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2
                                                        .merge(TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColorLight,
                                                        fontWeight:
                                                        FontWeight.w500)),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text('use another address',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: Theme.of(context)
                                                            .primaryColorLight
                                                            .withOpacity(0.7),
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                              if (currentCheckout.value.deliveryPossible) Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(top: 40),
                                        alignment: Alignment.bottomCenter,
                                        child: Wrap(
                                            alignment: WrapAlignment.end,
                                            children: [
                                              InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.5,
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        top: 5,
                                                        right: 10,
                                                        left: 20,
                                                        bottom: 10),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text(
                                                              ' ${Helper.pricePrint(currentCheckout.value.grand_total)}',
                                                              style: Theme.of(
                                                                  context)
                                                                  .textTheme
                                                                  .bodyText1),
                                                          GestureDetector(
                                                            onTap: (){
                                                              Navigator.of(context).push(MaterialPageRoute(
                                                                  builder: (context) => ViewBillDetails()));

                                                            },
                                                            child: Text(
                                                              S
                                                                  .of(context)
                                                                  .view_bill_details,
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.blue,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                              textAlign:
                                                              TextAlign.center,
                                                            ),
                                                          ),
                                                        ]),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _con.gotopayment();
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.5,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        top: 12,
                                                        right: 12,
                                                        left: 12,
                                                        bottom: 12),
                                                    child: Text(
                                                      S
                                                          .of(context)
                                                          .proceed_to_pay,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .merge(TextStyle(
                                                          color: Theme.of(
                                                              context)
                                                              .scaffoldBackgroundColor)),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ])),
                                  ]) else Text(''),
                            ]);
                          })
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ));
  }
}

class SliverCustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double collapsedHeight;
  final double expandedHeight;
  final double paddingTop;
  final String coverImgUrl;
  final String title;
  final String subtitle;
  String statusBarMode = 'dark';

  SliverCustomHeaderDelegate({
    this.collapsedHeight,
    this.expandedHeight,
    this.paddingTop,
    this.coverImgUrl,
    this.title,
    this.subtitle,
  });

  @override
  double get minExtent => this.collapsedHeight + this.paddingTop;

  @override
  double get maxExtent => this.expandedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  void updateStatusBarBrightness(shrinkOffset) {
    if (shrinkOffset > 50 && this.statusBarMode == 'dark') {
      this.statusBarMode = 'light';
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ));
    } else if (shrinkOffset <= 50 && this.statusBarMode == 'light') {
      this.statusBarMode = 'dark';
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ));
    }
  }

  Color makeStickyHeaderBgColor(shrinkOffset) {
    final int alpha = (shrinkOffset / (this.maxExtent - this.minExtent) * 255)
        .clamp(0, 255)
        .toInt();
    return Color.fromARGB(alpha, 255, 255, 255);
  }

  Color makeStickyHeaderTextColor(shrinkOffset, isIcon) {
    if (shrinkOffset <= 50) {
      return isIcon ? Colors.white : Colors.transparent;
    } else {
      final int alpha = (shrinkOffset / (this.maxExtent - this.minExtent) * 255)
          .clamp(0, 255)
          .toInt();
      return Color.fromARGB(alpha, 0, 0, 0);
    }
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    this.updateStatusBarBrightness(shrinkOffset);
    return Container(
      height: this.maxExtent,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 50),
            child: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                    CachedNetworkImage(
                      // ignore: deprecated_member_use
                      imageUrl:
                          "${GlobalConfiguration().getString('base_upload')}/uploads/vendor_image/vendor_${currentCheckout.value.shopId}.png",
                      placeholder: (context, url) =>
                          new CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                      height: 60.0,
                      width: 60.0,
                    ),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(currentCheckout.value.shopName,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.headline1),
                        Text(currentCheckout.value.subtitle,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.caption),
                      ],
                    )
                    /**  Column(children: [
                        Text(S.of(context).checkout, textAlign: TextAlign.left, style: Theme.of(context).textTheme.headline1),
                        // Text('7 Items', textAlign: TextAlign.left, style: Theme.of(context).textTheme.caption),
                        ]) */
                  ]),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              color: this.makeStickyHeaderBgColor(shrinkOffset),
              child: SafeArea(
                bottom: false,
                child: Container(
                  height: this.collapsedHeight,
                  padding: EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: this
                              .makeStickyHeaderTextColor(shrinkOffset, false),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            this.title,
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                .merge(TextStyle(
                                  color: this.makeStickyHeaderTextColor(
                                      shrinkOffset, false),
                                )),
                          ),
                          Text(
                            this.subtitle,
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .merge(TextStyle(
                                  color: this.makeStickyHeaderTextColor(
                                      shrinkOffset, false),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
