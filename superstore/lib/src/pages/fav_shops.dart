import 'package:flutter/material.dart';
import 'package:superstore/src/controllers/vendor_controller.dart';
import 'package:superstore/src/elements/ShopListBoxWidget.dart';

class FavShops extends StatefulWidget {
  final VendorController con;
  final int shopType;
  final int focusId;
  final String previewImage;

  const FavShops({Key key, this.con, this.shopType, this.focusId, this.previewImage}) : super(key: key);


  @override
  _FavShopsState createState() => _FavShopsState();
}

class _FavShopsState extends State<FavShops> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title:Container(
            width: double.infinity,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        'FAV SHOPS',
                        style: Theme.of(context).textTheme.subtitle2,
                        textAlign: TextAlign.left,
                      ),

                    ]),
                  ),

                ],
              ),

            ])
        ),
      ),
      body: ListView.separated(
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




    );
  }
}
