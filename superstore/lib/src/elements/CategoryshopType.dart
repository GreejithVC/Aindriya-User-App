import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
      margin:EdgeInsets.only(left:5,right:5),
      padding: EdgeInsets.only(top:10),
      child: Wrap(
        children: List.generate(widget.shopType.length, (index) {
          ShopType _shopTypeData = widget.shopType.elementAt(index);
           return Wrap(
              children:[
                Div(
                  colL:3,
                  colM:3,
                  colS:3,
                  child:Container(
                    padding: EdgeInsets.only(bottom:10),
                    child:Column(
                        children:[
                        GestureDetector(
                        onTap: () {

                   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                               return Stores(storeType: int.parse(_shopTypeData.shopType), pageTitle:  _shopTypeData.title,focusId: int.parse(_shopTypeData.id),
                               coverImage: _shopTypeData.coverImage,previewImage: _shopTypeData.previewImage,);
                           }));

                       //Navigator.of(context).push(MaterialPageRoute(builder: (context) => SendPackage()));
                             },
                            child: Container(
                              width: 70.0,
                              height: 70.0,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(_shopTypeData.previewImage)
                                  )
                              )),
                        ),
                          SizedBox(height:5),
                          Container(
                            child: Text(
                              _shopTypeData.title,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                        ]
                    ),
                  ),

                ),
              ]
          );
        }),),
    );

  }
}
