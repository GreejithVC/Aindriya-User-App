import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:superstore/src/models/vendor.dart';
import 'package:superstore/src/pages/grocerystore.dart';
import 'package:superstore/src/pages/store_detail.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helpers/helper.dart';

// ignore: must_be_immutable
class CardWidget extends StatelessWidget {
  Vendor market;
  String heroTag;

  CardWidget({Key key, this.market}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).focusColor.withOpacity(0.1),
              blurRadius: 15,
              offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Expanded(
              flex: 1,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  CachedNetworkImage(
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl: market.cover,
                    placeholder: (context, url) => Image.asset(
                      'assets/img/loading.gif',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 12, bottom: 8),
                    padding: EdgeInsets.only(left: 8, bottom: 2, right: 8),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(24)),
                    child: Text(
                      '${Helper.calculateTime(double.parse(market.distance.replaceAll(',', '')))}',
                      style: Theme.of(context).textTheme.caption.merge(
                          TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 10)),
                    ),
                  )
                ],
              )),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(market?.shopName ?? "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.subtitle1),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (market.shopType == '1' || market.shopType == '3') {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => GroceryStoreWidget(
                                    shopDetails: market,
                                    shopTypeID: int.parse(market.shopType),
                                    focusId: int.parse(market.focusType),
                                  )));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => StoreViewDetails(
                                    shopDetails: market,
                                    shopTypeID: int.parse(market.shopType),
                                    focusId: int.parse(market.focusType),
                                  )));
                        }
                      },
                      child: Icon(
                        Icons.visibility,
                        size: 20,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2, left: 2),
                      child: GestureDetector(
                        onTap: () async {
                          String url =
                              "https://www.google.com/maps/dir/?api=1&destination=${market.latitude},${market.longitude}&travelmode=driving&dir_action=navigate";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Icon(
                          Icons.directions,
                          size: 18,
                          color: Colors.indigoAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(children: [
                  Expanded(
                    child: Text(market.subtitle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .merge(TextStyle(fontSize: 10))),
                  ),
                  Text(Helper.priceDistance(market.distance),
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .merge(TextStyle(fontSize: 10))),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Widget _body(){
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.start,
//     mainAxisSize: MainAxisSize.max,
//     crossAxisAlignment: CrossAxisAlignment.stretch,
//     children: <Widget>[
//       // Image of the card
//       Stack(
//         fit: StackFit.loose,
//         alignment: AlignmentDirectional.bottomStart,
//         children: <Widget>[
//           ClipRRect(
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(10),
//                 topRight: Radius.circular(10)),
//             child: CachedNetworkImage(
//               height: 50,
//               width: double.infinity,
//               fit: BoxFit.cover,
//               imageUrl: market.cover,
//               placeholder: (context, url) => Image.asset(
//                 'assets/img/loading.gif',
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//                 height: 50,
//               ),
//               errorWidget: (context, url, error) => Icon(Icons.error),
//             ),
//           ),
//           Row(
//             children: <Widget>[
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
//                 decoration: BoxDecoration(
//                     color: Colors.green,
//                     borderRadius: BorderRadius.circular(24)),
//                 child: Text(
//                   '${Helper.calculateTime(double.parse(market.distance.replaceAll(',', '')))}',
//                   style: Theme.of(context).textTheme.caption.merge(
//                       TextStyle(color: Theme.of(context).primaryColor)),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//
//       Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Container(
//                           padding:
//                           EdgeInsets.only(left: 10, right: 10, top: 15),
//                           child: Text(market.shopName,
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 1,
//                               style: Theme.of(context).textTheme.subtitle1),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8, right: 8),
//                         child: Container(
//                           padding: const EdgeInsets.only(
//                               left: 5, right: 5, top: 1, bottom: 1),
//                           decoration: BoxDecoration(
//                             color: Theme.of(context).accentColor,
//                             borderRadius:
//                             BorderRadius.all(Radius.circular(7.0)),
//                           ),
//                           child: Text(
//                             '${market.rate} ✩',
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .subtitle1
//                                 .merge(TextStyle(
//                               color:
//                               Theme.of(context).primaryColorLight,
//                             )),
//                           ),
//                         ),
//                       ),
//                     ]),
//                 Padding(
//                   padding: EdgeInsets.only(right: 10),
//                   child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Container(
//                             padding: EdgeInsets.only(
//                                 left: 10, right: 10, bottom: 5),
//                             child: Text(market.subtitle,
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 style: Theme.of(context).textTheme.caption),
//                           ),
//                         ),
//                         Text(Helper.priceDistance(market.distance),
//                             style: Theme.of(context).textTheme.caption),
//                       ]),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 4),
//                   child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             if (market.shopType == '1' ||
//                                 market.shopType == '3') {
//                               Navigator.of(context).push(MaterialPageRoute(
//                                   builder: (context) => GroceryStoreWidget(
//                                     shopDetails: market,
//                                     shopTypeID:
//                                     int.parse(market.shopType),
//                                     focusId:
//                                     int.parse(market.focusType),
//                                   )));
//                             } else {
//                               Navigator.of(context).push(MaterialPageRoute(
//                                   builder: (context) => StoreViewDetails(
//                                     shopDetails: market,
//                                     shopTypeID:
//                                     int.parse(market.shopType),
//                                     focusId:
//                                     int.parse(market.focusType),
//                                   )));
//                             }
//                           },
//                           child: Container(
//                             height: 24,
//                             margin: EdgeInsets.symmetric(horizontal: 8),
//                             padding: EdgeInsets.only(
//                                 left: 8, right: 8, bottom: 3),
//                             decoration: BoxDecoration(
//                                 color: Theme.of(context).accentColor,
//                                 borderRadius: BorderRadius.circular(24)),
//                             child: Text(
//                               'Visit Shop',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .caption
//                                   .merge(TextStyle(
//                                   color:
//                                   Theme.of(context).primaryColor)),
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () async {
//                             String url =
//                                 "https://www.google.com/maps/dir/?api=1&destination=${market.latitude},${market.longitude}&travelmode=driving&dir_action=navigate";
//                             if (await canLaunch(url)) {
//                               await launch(url);
//                             } else {
//                               throw 'Could not launch $url';
//                             }
//                           },
//                           child: Container(
//                             height: 24,
//                             margin: EdgeInsets.only(right: 8),
//                             padding: EdgeInsets.symmetric(horizontal: 8),
//                             decoration: BoxDecoration(
//                                 color: Colors.indigoAccent,
//                                 borderRadius: BorderRadius.circular(24)),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(
//                                   Icons.directions,
//                                   size: 20,
//                                   color: Theme.of(context).primaryColor,
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(bottom: 5),
//                                   child: Text(
//                                     '  Directions',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .caption
//                                         .merge(TextStyle(
//                                         color: Theme.of(context)
//                                             .primaryColor)),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ]),
//                 ),
//               ])),
//     ],
//   );
// }
}
