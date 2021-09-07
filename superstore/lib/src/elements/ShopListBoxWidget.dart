import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../helpers/helper.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../pages/grocerystore.dart';
import '../pages/store_detail.dart';
import '../models/vendor.dart';
import '../controllers/vendor_controller.dart';
import '../Widget/custom_divider_view.dart';
import 'NoShopFoundWidget.dart';
import 'RectangleLoaderWidget.dart';

// ignore: must_be_immutable
class ShopListBoxWidget extends StatefulWidget {
  VendorController con;
  String pageTitle;
  int shopType;
  int focusId;
  String previewImage;
  ShopListBoxWidget({Key key,  this.con, this.pageTitle,this.shopType, this.focusId, this.previewImage}) : super(key: key);
  @override
  _ShopListBoxWidgetState createState() => _ShopListBoxWidgetState();
}

class _ShopListBoxWidgetState extends StateMVC<ShopListBoxWidget> {
  bool ratingOne = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.con.vendorList.isEmpty?RectangleLoaderWidget():Container(
      child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 20),
                child: Text(widget.pageTitle, style: Theme.of(context).textTheme.headline1)),
            Padding(
                padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                child: Text('Fast on authentic ${widget.pageTitle}', style: Theme.of(context).textTheme.caption)),
            CustomDividerView(dividerHeight: 1.0, color: Theme.of(context).dividerColor),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Text('${widget.con.vendorList.length} STORES NEAR BY',
                          style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).backgroundColor))),
                    ),
                    /**  Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Icon(Icons.filter_list, size: 19),
                        ),
                        SizedBox(width: 8),
                        Text('SORT/FILTER', style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).backgroundColor))) */
                  ],
                ),
              ),
            ),
            ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: widget.con.vendorList.length,
              shrinkWrap: true,
              primary: false,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, int index) {
                return ShopList(choice: widget.con.vendorList[index], shopType: widget.shopType,focusId: widget.focusId,previewImage: widget.previewImage,);
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 0);
              },
            ),
            SizedBox(height: 50)
          ])),
    );
  }
}

class ShopList extends StatelessWidget {
  const ShopList({Key key, this.choice, this.shopType,this.focusId, this.previewImage}) : super(key: key);
  final Vendor choice;
  final int shopType;
  final int focusId;
  final String previewImage;
  @override
  Widget build(BuildContext context) {
    return choice.shopId!='no_data'?Hero(
      tag: choice.shopId,
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Theme.of(context).dividerColor)),
        ),
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
            if( choice.openStatus) {
              if (shopType == 1 || shopType == 3) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        GroceryStoreWidget(shopDetails: choice,
                          shopTypeID: shopType,
                          focusId: focusId,)));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        StoreViewDetails(shopDetails: choice,
                          shopTypeID: shopType,
                          focusId: focusId,)));
              }
            } else{
              Toast.show('Sorry this shop is currently closed', context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM ,);
            }
            },
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        padding: EdgeInsets.all(8),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            choice.openStatus?Colors.black.withOpacity(0):Colors.black.withOpacity(0.91), // 0 = Colored, 1 = Black & White
                            BlendMode.saturation,
                          ),
                          child:ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: choice.logo!='no_image'?CachedNetworkImage(
                                imageUrl: choice.logo,
                                placeholder: (context, url) => new CircularProgressIndicator(),
                                errorWidget: (context, url, error) => new Icon(Icons.error),
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width * 0.25,
                                height: MediaQuery.of(context).size.width * 0.28,
                              ):CachedNetworkImage(
                                imageUrl: previewImage,
                                placeholder: (context, url) => new CircularProgressIndicator(),
                                errorWidget: (context, url, error) => new Icon(Icons.error),
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width * 0.25,
                                height: MediaQuery.of(context).size.width * 0.28,
                              )),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(
                                choice.shopName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Theme.of(context).textTheme.headline1,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 0, right: 15),
                                child:
                                Text(choice.subtitle, overflow: TextOverflow.ellipsis, maxLines: 1, style: Theme.of(context).textTheme.caption),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 0, right: 15),
                                child: Text(choice.locationMark,
                                    overflow: TextOverflow.ellipsis, maxLines: 1, style: Theme.of(context).textTheme.caption),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              Wrap(children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Icon(Icons.star, color: Colors.grey[500], size: 15),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 2),
                                  child: Text('${choice.rate}     ', style: Theme.of(context).textTheme.bodyText2),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: Text(Helper.priceDistance(choice.distance), style: Theme.of(context).textTheme.bodyText2),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: Text('     ${Helper.calculateTime(double.parse(choice.distance.replaceAll(',','')))}', style: Theme.of(context).textTheme.bodyText2),
                                ),
                              ]),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ):NoShopFoundWidget();
  }
}