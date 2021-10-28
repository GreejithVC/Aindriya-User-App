import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:superstore/src/controllers/product_controller.dart';
import 'package:superstore/src/elements/ClearCartWidget.dart';
import 'package:superstore/src/helpers/helper.dart';
import 'package:superstore/src/models/favouriteProduct.dart';
import 'package:superstore/src/models/product_details2.dart';
import 'package:superstore/src/models/variant.dart';
import 'package:superstore/src/pages/Widget/fav_product_button.dart';

class ProductDetailsScreen extends StatefulWidget {
  final variantModel variantData;
  final ProductDetails2 choice;
  final ProductController con;
  final String shopId;
  final String shopName;
  final String subtitle;
  final String km;
  final int shopTypeID;
  final String latitude;
  final String longitude;
  final int focusId;
  final Function callback;

  const ProductDetailsScreen({
    Key key,
    this.variantData,
    this.choice,
    this.con,
    this.shopId,
    this.shopName,
    this.subtitle,
    this.km,
    this.shopTypeID,
    this.latitude,
    this.longitude,
    this.focusId,
    this.callback,
  }) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  variantModel selectedVariantData;

  @override
  void initState() {
    super.initState();
    selectedVariantData = widget?.variantData;
    widget.choice.variant.forEach((_l) {
      _l.selected = false;
    });
    selectedVariantData.selected = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(padding: EdgeInsets.all(0), children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: double.infinity,
              height: 250,
              child: CachedNetworkImage(
                imageUrl: selectedVariantData?.image,
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: 36,
              height: 36,
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(1, 1), // changes position of shadow
                  ),
                ],
              ),
              child: FavProductButton(
                productDetails2: FavouriteProduct(
                  id: widget?.choice?.id,
                  productName: widget?.choice?.product_name,
                  price: selectedVariantData?.sale_price,
                  image: selectedVariantData?.image,
                  shopId: widget?.shopId,
                  shopName: widget?.shopName,
                ),
              ),
            )
          ],
        ),
        ListView(
          padding: EdgeInsets.all(20),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Text(widget?.choice?.product_name ?? "",
                style: Theme.of(context).textTheme.headline3.merge(
                    TextStyle(fontSize: 24, fontWeight: FontWeight.w500))),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(3)),
                  child: Row(
                    children: [
                      Text(
                        "3",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                      Helper.pricePrint(selectedVariantData?.sale_price ?? ""),
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.headline3.merge(
                          TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: 24))),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Text(
                    Helper.pricePrint(selectedVariantData?.strike_price ?? ""),
                    style: Theme.of(context).textTheme.subtitle2.merge(
                        TextStyle(decoration: TextDecoration.lineThrough)),
                  ),
                ),
              ]),
            ),
            Text(
              widget?.subtitle ?? "",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            
          ],
        ),
        Container(
          height: 150,
          child: ListView.builder(
            padding: EdgeInsets.all(20),
            scrollDirection: Axis.horizontal,
            itemCount: widget.choice.variant.length,
            itemBuilder: (context, index) {
              variantModel _variantData =
                  widget.choice.variant.elementAt(index);
              return GestureDetector(
                onTap: () {
                  widget.choice.variant.forEach((_l) {
                    _l.selected = false;
                  });
                  _variantData.selected = true;
                  selectedVariantData = _variantData;
                  setState(() {});
                },
                child: Container(
                  width: 100,
                  margin: EdgeInsets.all(4),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: _variantData.selected
                              ? Theme.of(context).accentColor.withOpacity(0.8)
                              : Colors.grey,
                          width: _variantData.selected ? 3 : 1)),
                  child: CachedNetworkImage(
                    imageUrl: _variantData?.image,
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ]),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                AvailableQuantityHelper.exit(
                        context,
                        widget?.choice?.variant,
                        widget?.choice?.product_name,
                    selectedVariantData?.selected)
                    .then((receivedLocation) {
                  if (receivedLocation != null) {
                    widget?.choice?.variant?.forEach((_l) {
                      setState(() {
                        if (_l.variant_id == receivedLocation) {
                          _l.selected = true;
                        } else {
                          _l.selected = false;
                        }
                      });
                    });
                  }
                });
              },
              child: Container(
                  height: 30,
                  width: 100,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey[300],
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          '${selectedVariantData?.quantity}${selectedVariantData?.unit}'),
                      Icon(Icons.arrow_drop_down, size: 19, color: Colors.grey)
                    ],
                  )),
            ),
            1 ==
                    widget?.con?.checkProductIdCartVariant(
                        widget?.choice?.id, selectedVariantData?.variant_id)
                ? InkWell(
                    onTap: () {
                      widget?.con?.checkShopAdded(
                          widget?.choice,
                          'cart',
                          selectedVariantData,
                          widget?.shopId,
                          ClearCartShow,
                          widget?.shopName,
                          widget?.subtitle,
                          widget?.km,
                          widget?.shopTypeID,
                          widget?.latitude,
                          widget?.longitude,
                          widget?.callback,
                          widget?.focusId);
                      setState(() {});
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 7),
                      child: Container(
                          alignment: Alignment.centerRight,
                          height: 30,
                          /*width: MediaQuery.of(context).size.width * 0.25,*/
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Theme.of(context).accentColor.withOpacity(1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'add',
                                style: TextStyle(color: Colors.transparent),
                              ),
                              Text('ADD',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .merge(TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          fontWeight: FontWeight.w600))),
                              SizedBox(width: 5),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(5),
                                      topRight: Radius.circular(5)),
                                  color: Theme.of(context).accentColor,
                                ),
                                height: double.infinity,
                                width: 30,
                                child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.add),
                                    iconSize: 18,
                                    color: Theme.of(context).primaryColorLight),
                              )
                            ],
                          )),
                    ))
                : InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  widget?.con?.decrementQtyVariant(
                                      widget?.choice?.id,
                                      selectedVariantData?.variant_id);
                                });
                              },
                              child: Icon(Icons.remove_circle,
                                  color: Theme.of(context).accentColor,
                                  size: 27),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.022,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                  widget?.con?.showQtyVariant(
                                      widget?.choice?.id,
                                      selectedVariantData?.variant_id),
                                  style: Theme.of(context).textTheme.bodyText1),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.022,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  widget?.con?.incrementQtyVariant(
                                      widget?.choice?.id,
                                      selectedVariantData?.variant_id);
                                });
                              },
                              child: Icon(Icons.add_circle,
                                  color: Theme.of(context).accentColor,
                                  size: 27),
                            ),
                          ]),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  void ClearCartShow() {
    var size = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: size.height * 0.3,
            color: Color(0xff737373),
            child: Container(
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
                      padding: EdgeInsets.only(
                          left: size.width * 0.05, right: size.width * 0.05),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ClearCart(),
                            ]),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: size.width * 0.05,
                          right: size.width * 0.05,
                          top: 5,
                          bottom: 5),
                      child: Row(
                        children: [
                          Container(
                            width: size.width * 0.44,
                            height: 45.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: Colors.grey[200], width: 1)
                                /*borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40))*/
                                ),
                            // ignore: deprecated_member_use
                            child: FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Center(
                                  child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                            ),
                          ),
                          SizedBox(width: size.width * 0.02),
                          Container(
                            width: size.width * 0.44,
                            height: 45.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.circular(30),
                              /*borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40))*/
                            ),
                            // ignore: deprecated_member_use
                            child: FlatButton(
                              onPressed: () {
                                widget.con.clearCart();
                              },
                              child: Center(
                                  child: Text(
                                'Clear Cart',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class AvailableQuantityHelper {
  static exit(context, variant, name, select) => showDialog(
      context: context,
      builder: (context) => AvailableQuantityPopup(
            variantList: variant,
            title: name,
            selected: select,
          ));
}

// ignore: must_be_immutable
class AvailableQuantityPopup extends StatefulWidget {
  AvailableQuantityPopup({Key key, this.variantList, this.title, this.selected})
      : super(key: key);
  List<variantModel> variantList;
  String title;
  bool selected;

  @override
  _AvailableQuantityPopupState createState() => _AvailableQuantityPopupState();
}

class _AvailableQuantityPopupState extends State<AvailableQuantityPopup> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
      insetPadding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.09,
        left: MediaQuery.of(context).size.width * 0.09,
        right: MediaQuery.of(context).size.width * 0.09,
        bottom: MediaQuery.of(context).size.width * 0.09,
      ),
    );
  }

  _buildChild(BuildContext context) => SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(3))),
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
                child: Text('Available Quantity',
                    style: TextStyle(
                        color: Theme.of(context).disabledColor,
                        fontWeight: FontWeight.w500)),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  )),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
                child: Text(
                  widget.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .merge(TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              ListView.separated(
                itemCount: widget.variantList.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  variantModel _variantData =
                      widget.variantList.elementAt(index);

                  return Container(
                    width: double.infinity,
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      onPressed: () {
                        widget.variantList.forEach((_l) {
                          setState(() {
                            _l.selected = false;
                          });
                        });

                        _variantData.selected = true;

                        Navigator.pop(context, _variantData.variant_id);
                      },
                      padding: EdgeInsets.all(10),
                      color: _variantData.selected
                          ? Theme.of(context).backgroundColor.withOpacity(0.8)
                          : null,
                      child: RichText(
                        text: new TextSpan(children: [
                          TextSpan(
                            text:
                                '${_variantData.quantity}  ${_variantData.unit} ',
                            style: _variantData.selected
                                ? Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .merge(TextStyle(
                                      color: Colors.white,
                                    ))
                                : Theme.of(context).textTheme.headline1.merge(
                                    TextStyle(
                                        color: Theme.of(context).disabledColor,
                                        fontWeight: FontWeight.w500)),
                          ),
                          TextSpan(
                              text:
                                  Helper.pricePrint(_variantData.strike_price),
                              style: _variantData.selected
                                  ? Theme.of(context).textTheme.headline1.merge(
                                      TextStyle(
                                          color: Colors.white,
                                          decoration:
                                              TextDecoration.lineThrough))
                                  : Theme.of(context).textTheme.headline1.merge(
                                      TextStyle(
                                          color:
                                              Theme.of(context).disabledColor,
                                          fontWeight: FontWeight.w500,
                                          decoration:
                                              TextDecoration.lineThrough))),
                          TextSpan(
                            text: Helper.pricePrint(_variantData.sale_price),
                            style: _variantData.selected
                                ? Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .merge(TextStyle(
                                      color: Colors.white,
                                    ))
                                : Theme.of(context).textTheme.headline1.merge(
                                    TextStyle(
                                        color: Theme.of(context).disabledColor,
                                        fontWeight: FontWeight.w500)),
                          )
                        ]),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      )),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
}
