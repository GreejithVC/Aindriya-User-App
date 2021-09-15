import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:responsive_ui/responsive_ui.dart';
import 'package:superstore/src/models/shop_type.dart';
import 'package:superstore/src/pages/send_package.dart';
import 'package:superstore/src/pages/stores.dart';



// ignore: must_be_immutable
class CategoryShopType extends StatefulWidget {
  List<ShopType> shopType;
  CategoryShopType({Key key,this.shopType});
  @override
  _CategoryShopTypeState createState() => _CategoryShopTypeState();
}

class _CategoryShopTypeState extends State<CategoryShopType> {


  @override
  Widget build(BuildContext context) {

    return Container(
      width:double.infinity,
      // margin:EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
      color: Colors.lightBlue.withOpacity(.2),
      child: StaggeredGridView.countBuilder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(0),
        crossAxisCount: 6,
        itemCount:widget.shopType.length,
        itemBuilder: (BuildContext context, int index) {
          ShopType _shopTypeData = widget.shopType.elementAt(index);
          return Column(
              children:[
                AspectRatio(aspectRatio: 1,
                  child: GestureDetector(
                    onTap: () {

                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        return Stores(storeType: int.parse(_shopTypeData.shopType), pageTitle:  _shopTypeData.title,focusId: int.parse(_shopTypeData.id),
                          coverImage: _shopTypeData.coverImage,previewImage: _shopTypeData.previewImage,);
                      }));

                      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => SendPackage()));
                    },
                    child: Container(
                        padding: EdgeInsets.all(10),
                        height: 150.0,
                        decoration: new BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(8),border: Border.all(color:  Color(0xffFFD700),width: 2,style: BorderStyle.solid),
                            shape: BoxShape.rectangle,
                            image: new DecorationImage(
                                fit: BoxFit.contain,
                                image: NetworkImage(_shopTypeData.previewImage)
                            )
                        )),
                  ),
                ),
                SizedBox(height:5),
                Container(
                  child: Text(
                    _shopTypeData.title,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ]
          );
        },
        staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
        mainAxisSpacing: 20,
        crossAxisSpacing: 12,
      ),
      
    );

  }
}
