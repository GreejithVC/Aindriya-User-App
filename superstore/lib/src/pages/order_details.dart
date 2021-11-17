import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:screenshot/screenshot.dart';
import 'package:superstore/src/controllers/order_controller.dart';
import 'package:superstore/src/elements/EmptyOrdersWidget.dart';
import 'package:superstore/src/helpers/helper.dart';
import 'package:superstore/src/models/cart_responce.dart';
import 'package:superstore/src/pages/chat_detail_page.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class OrderDetails extends StatefulWidget {
  String orderId;

  OrderDetails({Key key, this.orderId}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends StateMVC<OrderDetails> {
  OrderController _con;

  _OrderDetailsState() : super(OrderController()) {
    _con = controller;

  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();

    _con.listenForInvoiceDetails(widget.orderId);
  }
  int _counter = 0;
  Uint8List _imageFile;
  ScreenshotController screenshotController = ScreenshotController();
  bool _showButton =true;


  @override

  Widget build(BuildContext context) {

    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: Container(
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ORDER #${widget.orderId}',
                                    style: Theme.of(context).textTheme.subtitle2,
                                    textAlign: TextAlign.left,
                                  ),
                                ]),
                          ),
                        ],
                      ),
                      _con.invoiceDetailsData.status != null
                          ? Text(
                              '${_con.invoiceDetailsData.status} | Item ${Helper.pricePrint(_con.invoiceDetailsData.payment.grand_total)}',
                              style: Theme.of(context).textTheme.subtitle2,
                              textAlign: TextAlign.left,
                            )
                          : Text(''),
                    ])),
            actions: [

              GestureDetector(onTap: (){
                screenshotController
                    .capture(delay: Duration(milliseconds: 10))
                    .then((capturedImage) async {
                  ShowCapturedWidget(context, capturedImage);
                  await ImageGallerySaver.saveImage(capturedImage);
                  print("image saved to gallery");
                  setState(() {});
                  showToast(
                      "Screenshot saved to gallery",
                      gravity: Toast.BOTTOM,
                      duration: 4);

                }).catchError((onError) {
                  print(onError);
                });
              },
                child: Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Icon(Icons.camera,
                      color: Colors.white,
                      // Color(0xFF333D37),
                      size: 23),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChatDetailPage(
                          shopId: _con.invoiceDetailsData.addressShop.id,
                          shopName: _con.invoiceDetailsData.addressShop.username,
                          shopMobile: '12')));
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Icon(Icons.chat_outlined,
                      color: Colors.white,
                      // Color(0xFF333D37),
                      size: 23),
                ),
              ),
              Visibility(
                visible: _con?.invoiceDetailsData?.addressShop?.phone?.isNotEmpty == true,
                child: GestureDetector(
                  onTap: () {
                    _makePhoneCall(
                        'tel:${_con.invoiceDetailsData.addressShop.phone}');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15, left: 5),
                    child: Icon(Icons.call,
                        color: Colors.white,
                        // Color(0xFF333D37),
                        size: 23),
                  ),
                ),
              ),
            ],
          ),
          body: _con.invoiceDetailsData.productDetails.isEmpty
              ? EmptyOrdersWidget()
              : Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Column(children: [
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15, bottom: 15),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                itemCount: 1,
                                                shrinkWrap: true,
                                                primary: false,
                                                padding: EdgeInsets.only(top: 10),
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemBuilder:
                                                    (context, int index) {
                                                  return Column(children: [
                                                    Container(
                                                      width: double.infinity,
                                                      padding: EdgeInsets.only(
                                                          bottom: 20),
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                              color: Theme.of(context)
                                                                  .dividerColor,
                                                              width: 1,
                                                            )),
                                                      ),
                                                      child: Column(children: [
                                                        Text("Token",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w900,fontSize: 14),),
                                                        Text(widget.orderId.substring(9),style: TextStyle(fontSize: 24,fontWeight: FontWeight.w900),),
                                                      ],),
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      padding: EdgeInsets.only(
                                                          bottom: 20),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets.only(
                                                                      top: 6),
                                                              child: Icon(
                                                                  Icons
                                                                      .location_on,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .disabledColor),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Expanded(
                                                              child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        _con
                                                                            .invoiceDetailsData
                                                                            .addressShop
                                                                            .username,
                                                                        style: Theme.of(
                                                                                context)
                                                                            .textTheme
                                                                            .bodyText1),
                                                                    Text(
                                                                      _con
                                                                          .invoiceDetailsData
                                                                          .addressShop
                                                                          .addressSelect,
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyText2,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines: 1,
                                                                    ),
                                                                  ]),
                                                            ),
                                                          ]),
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      padding: EdgeInsets.only(
                                                          bottom: 20),
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                          color: Theme.of(context)
                                                              .dividerColor,
                                                          width: 1,
                                                        )),
                                                      ),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets.only(
                                                                      top: 6),
                                                              child: Icon(
                                                                  Icons.home,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .disabledColor),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Expanded(
                                                              child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        _con
                                                                            .invoiceDetailsData
                                                                            .addressUser
                                                                            .id,
                                                                        style: Theme.of(
                                                                                context)
                                                                            .textTheme
                                                                            .bodyText1),
                                                                    Text(
                                                                      _con
                                                                          .invoiceDetailsData
                                                                          .addressUser
                                                                          .addressSelect,
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyText2,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines: 1,
                                                                    ),
                                                                  ]),
                                                            ),
                                                          ]),
                                                    ),
                                                  ]);
                                                }),
                                            Container(
                                                padding: EdgeInsets.only(top: 20),
                                                width: double.infinity,
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          _makePhoneCall(
                                                              'tel:${_con.invoiceDetailsData.addressShop.phone}');
                                                        },
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisSize: MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets.only(
                                                                      top: 6),
                                                              child:
                                                              Icon(Icons.call,
                                                                  color: Theme.of(
                                                                      context)
                                                                      .accentColor,
                                                                  // Color(0xFF333D37),
                                                                  size: 23),

                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets.only(
                                                                        top: 3,
                                                                        left: 8,
                                                                        right: 20),
                                                                child: Text(
                                                                  _con.invoiceDetailsData.addressShop.phone
                                                                  ,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyText2,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ])),
                                          ]),
                                    ),
                                    Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).dividerColor),
                                        padding: EdgeInsets.all(20),
                                        child: Text('Bill details')),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15, bottom: 15),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                itemCount: _con.invoiceDetailsData
                                                    .productDetails.length,
                                                shrinkWrap: true,
                                                primary: false,
                                                padding: EdgeInsets.only(top: 10),
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemBuilder:
                                                    (context, int index) {
                                                  CartResponce _orderDetails =
                                                      _con.invoiceDetailsData
                                                          .productDetails
                                                          .elementAt(index);
                                                  String addonName;
                                                  _orderDetails.addon
                                                      .forEach((element) {
                                                    addonName = element.name;
                                                  });
                                                  return Container(
                                                    padding: EdgeInsets.only(
                                                        top: 10, bottom: 15),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                        color: Theme.of(context)
                                                            .dividerColor,
                                                        width: 1,
                                                      )),
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: [
                                                        _con.invoiceDetailsData
                                                                    .shopTypeId ==
                                                                '2'
                                                            ? Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 10),
                                                                child: Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(2),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border
                                                                        .all(
                                                                      width: 1,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .accentColor,
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .accentColor,
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                    width: 6.0,
                                                                    height: 6.0,
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(),
                                                        Expanded(
                                                          child: Padding(
                                                              padding:
                                                                  EdgeInsets.only(
                                                                      top: 3,
                                                                      left: 10),
                                                              child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      ' ${_orderDetails.product_name} ${_orderDetails.quantity} ${_orderDetails.unit} x ${_orderDetails.qty}',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyText1,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                    ),
                                                                    _orderDetails
                                                                                .addon
                                                                                .length !=
                                                                            0
                                                                        ? Text(
                                                                            addonName,
                                                                            style: Theme.of(context)
                                                                                .textTheme
                                                                                .bodyText2,
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                          )
                                                                        : Text(
                                                                            ''),
                                                                  ])),
                                                        ),
                                                        Align(
                                                          alignment:
                                                              Alignment.topRight,
                                                          child: Padding(
                                                              padding:
                                                                  EdgeInsets.only(
                                                                top: 10,
                                                              ),
                                                              child: Text(Helper
                                                                  .pricePrint(
                                                                      _orderDetails
                                                                          .price))),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          ]),
                                    ),
                                    Container(
                                        padding: EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                        ),
                                        width: double.infinity,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(top: 20),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Item total',
                                                            style:
                                                                Theme.of(context)
                                                                    .textTheme
                                                                    .subtitle2,
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          Helper.pricePrint(_con
                                                              .invoiceDetailsData
                                                              .payment
                                                              .sub_total),
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .subtitle2,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Delivery partner fee',
                                                            style:
                                                                Theme.of(context)
                                                                    .textTheme
                                                                    .subtitle2,
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          Helper.pricePrint(_con
                                                              .invoiceDetailsData
                                                              .payment
                                                              .delivery_fees),
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .subtitle2,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Delivery partner tips',
                                                            style:
                                                                Theme.of(context)
                                                                    .textTheme
                                                                    .subtitle2,
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          Helper.pricePrint(_con
                                                              .invoiceDetailsData
                                                              .payment
                                                              .delivery_tips),
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .subtitle2,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      padding: EdgeInsets.only(
                                                          top: 10),
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                          color: Theme.of(context)
                                                              .dividerColor,
                                                          width: 1,
                                                        )),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Pay ${_con.invoiceDetailsData.payment.method}',
                                                            style:
                                                                Theme.of(context)
                                                                    .textTheme
                                                                    .subtitle2,
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          'Bill total ${Helper.pricePrint(_con.invoiceDetailsData.payment.grand_total)}',
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .subtitle2
                                                              .merge(TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ])),
                                  ]),
                                ]),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          children: [


                            Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: _con.invoiceDetailsData.status != 'Completed'
                                  ? Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          border: Border(
                                        top: BorderSide(
                                          width: 1,
                                          color: Colors.grey[200],
                                        ),
                                      )),
                                      // ignore: deprecated_member_use
                                      child: FlatButton(
                                          onPressed: () {
                                            if (_con.invoiceDetailsData.status !=
                                                    'cancelled' &&
                                                _con.invoiceDetailsData.status !=
                                                    'Completed') {
                                              Navigator.of(context)
                                                  .pushReplacementNamed('/Map',
                                                      arguments: widget.orderId);
                                            }
                                          },
                                          padding: EdgeInsets.all(15),
                                          color: Colors.grey[200],
                                          child: Text(
                                            _con.invoiceDetailsData.status,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1
                                                .merge(TextStyle(
                                                    color: Colors.deepOrange)),
                                          )),
                                    )
                                  : _con.invoiceDetailsData.status == 'Completed' &&
                                          _con.invoiceDetailsData.rating == '0'
                                      ? InkWell(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                '/ShopRating',
                                                arguments: _con.invoiceDetailsData);
                                          },
                                          child: Column(children: [
                                            Text('Give your rating '),
                                            SizedBox(height: 5),
                                            RatingBar.builder(
                                              initialRating: 0,
                                              minRating: 1,
                                              tapOnlyMode: true,
                                              direction: Axis.horizontal,
                                              allowHalfRating: false,
                                              itemCount: 5,
                                              itemSize: 25,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 1.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                print(rating);
                                              },
                                            ),
                                            SizedBox(height: 10),
                                          ]),
                                        )
                                      : Column(children: [
                                          Text(
                                              'Your rating is ${_con.invoiceDetailsData.rating}'),
                                          SizedBox(height: 5),
                                          RatingBar.builder(
                                            initialRating: double.parse(
                                                _con.invoiceDetailsData.rating),
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            tapOnlyMode: false,
                                            itemSize: 25,
                                            itemPadding:
                                                EdgeInsets.symmetric(horizontal: 1.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              print(rating);
                                            },
                                          ),
                                          SizedBox(height: 10),
                                        ]),
                            ),
                            Visibility(
                              visible: _showButton != false,
                              child: FlatButton(onPressed:(){
                                _showButton = false;
                                screenshotController
                                    .capture(delay: Duration(milliseconds: 10))
                                    .then((capturedImage) async {
                                  ShowCapturedWidget(context, capturedImage);
                                  await ImageGallerySaver.saveImage(capturedImage);
                                  print("image saved to gallery");
                                  setState(() {});
                                  showToast(
                                      "Screenshot saved to gallery",
                                      gravity: Toast.BOTTOM,
                                      duration: 4);
                                  _showButton = true;

                                }).catchError((onError) {
                                  print(onError);
                                  _showButton = true;
                                });

                              } ,
                                  padding: EdgeInsets.all(15),
                                  color: Colors.blue,
                                  child: Text("Save as image",style: TextStyle(color: Colors.white),)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }
  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("screenshot"),
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }
  // _saved(File image) async {
  //     final result = await ImageGallerySaver.save(image.readAsBytesSync());
  //     print("File Saved to Gallery");
  //   }
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(
      msg,
      context,
      duration: duration,
      gravity: gravity,
    );
  }
}
