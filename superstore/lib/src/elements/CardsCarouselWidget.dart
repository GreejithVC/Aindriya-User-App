import 'package:flutter/material.dart';
import 'package:superstore/src/models/vendor.dart';
import 'package:superstore/src/pages/grocerystore.dart';
import 'package:superstore/src/pages/store_detail.dart';
import '../elements/CardsCarouselLoaderWidget.dart';

import 'CardWidget.dart';

// ignore: must_be_immutable
class CardsCarouselWidget extends StatefulWidget {
  List<Vendor> marketsList;
  CardsCarouselWidget({Key key, this.marketsList}) : super(key: key);

  @override
  _CardsCarouselWidgetState createState() => _CardsCarouselWidgetState();
}

class _CardsCarouselWidgetState extends State<CardsCarouselWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.marketsList.isEmpty
        ? Container()
        : widget.marketsList[0].shopId == 'no_data'
            ? Positioned(
                bottom: 0.0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ], color: Colors.pink),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Text('NO SHOP FOUND TO NEAR',
                        style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).scaffoldBackgroundColor)))
                  ]),
                ),
              )
            : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.marketsList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {

                    if( widget.marketsList.elementAt(index).shopType=='1' ||  widget.marketsList.elementAt(index).shopType=='3'){

                      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  GroceryStoreWidget(shopDetails: widget.marketsList.elementAt(index),shopTypeID: int.parse( widget.marketsList.elementAt(index).shopType),focusId: int.parse(widget.marketsList.elementAt(index).focusType),)));
                    }else  {

                      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  StoreViewDetails(shopDetails: widget.marketsList.elementAt(index), shopTypeID: int.parse(widget.marketsList.elementAt(index).shopType), focusId: int.parse(widget.marketsList.elementAt(index).focusType),)));

                    }
                  },
                  child: CardWidget(market: widget.marketsList.elementAt(index)),
                );
              },
            );
  }
}
