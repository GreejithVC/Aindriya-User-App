import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:multisuperstore/src/helpers/helper.dart';
import 'package:multisuperstore/src/models/vendor.dart';
import 'package:multisuperstore/src/pages/grocerystore.dart';
import 'package:multisuperstore/src/pages/store_detail.dart';


import 'CardsCarouselLoaderWidget.dart';
import 'NoShopFoundWidget.dart';

class ShopTopSlider extends StatefulWidget {
  final List<Vendor> vendorList;
  ShopTopSlider({ Key key, this.vendorList}) : super(key: key);
  @override
  _ShopTopSliderState createState() => _ShopTopSliderState();
}

class _ShopTopSliderState extends State<ShopTopSlider> {


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      padding: EdgeInsets.only(top:0),
      child:    widget.vendorList.isEmpty?CardsCarouselLoaderWidget():ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.vendorList.length,
          padding: EdgeInsets.only(left:3,right:3),
          itemBuilder: (context, index) {
            Vendor _vendorData = widget.vendorList.elementAt(index);

            return _vendorData.shopId!='no_data'?Padding(
              padding: const EdgeInsets.only(
                left: 1,
              ),
              child: AspectRatio(
                aspectRatio: 1.2,
                  child: InkWell(
                      onTap: () {


                          if(_vendorData.shopType=='1' || _vendorData.shopType=='3'){
                          
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  GroceryStoreWidget(shopDetails: _vendorData,shopTypeID: int.parse(_vendorData.shopType),focusId: int.parse(_vendorData.focusType),)));
                          }else  {

                           Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  StoreViewDetails(shopDetails: _vendorData, shopTypeID: int.parse(_vendorData.shopType), focusId: int.parse(_vendorData.focusType),)));

                        }
                      },
                      child:  Container(
                        padding:EdgeInsets.only(bottom:10),
                        decoration: BoxDecoration(
                            color:Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withOpacity(0.1),
                                blurRadius: 3.0,
                                spreadRadius: 1.5,
                              ),
                            ]),
                        margin: EdgeInsets.only(left:5,right:5, top: 10.0,bottom:10),
                        child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Stack(
                                children: [
                                  ClipRRect(
                                    //borderRadius: BorderRadius.all(Radius.circular(10)),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft:Radius.circular(0),
                                        bottomRight:Radius.circular(0),
                                      ),
                                      child:Image(image:_vendorData.cover=='no_image'?AssetImage('assets/img/loginbg.jpg'):NetworkImage(_vendorData.cover),
                                          width:double.infinity,
                                          height:180,
                                          fit:BoxFit.fill
                                      )
                                  ),
                                  Container(
                                    height:180,
                                    width: double.infinity,
                                    child: Stack(
                                        children:[
                                          Positioned(
                                              top:10,right:15,
                                              child:Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children:[
                                                    Container(
                                                      height:30,width:30,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey.withOpacity(0.2),
                                                            spreadRadius: 1,
                                                            blurRadius: 7,
                                                            offset: Offset(0, 3), // changes position of shadow
                                                          ),
                                                        ],
                                                        color: Colors.blue,
                                                      ),
                                                      child:Icon(Icons.bookmark_border_outlined,
                                                          color:Theme.of(context).primaryColorLight
                                                      ),

                                                    ),

                                                  ]
                                              )
                                          ),

                                          Positioned(
                                              bottom:10,left:15,right:15,
                                              child:Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children:[
                                                    Container(
                                                        padding: EdgeInsets.only(left:9,right:9,top:3,bottom:3),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(7),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey.withOpacity(0.2),
                                                              spreadRadius: 1,
                                                              blurRadius: 7,
                                                              offset: Offset(0, 3), // changes position of shadow
                                                            ),
                                                          ],
                                                          color: Colors.blue,
                                                        ),
                                                        child: Text(
                                                            Helper.priceDistance(_vendorData.distance),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                            style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color:Colors.white))
                                                        )

                                                    ),

                                                  ]
                                              )
                                          )
                                        ]
                                    ),
                                  ),
                                ],
                              ),

                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children:[
                                          Expanded(
                                            child: Container(
                                              padding:EdgeInsets.only(left:10,right:10,top:15),
                                              child:Text(_vendorData.shopName,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style:Theme.of(context).textTheme.subtitle1),
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.only(left: 8,right:8),
                                            child:Container(
                                              padding: const EdgeInsets.only(left:5,right:5,top:1,bottom:1),
                                              decoration: BoxDecoration(
                                                color:Theme.of(context).accentColor,
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(7.0)),
                                              ),
                                              child: Text('${_vendorData.rate} ✩',
                                                style:Theme.of(context)
                                                    .textTheme
                                                    .subtitle1
                                                    .merge(TextStyle(color: Theme.of(context).primaryColorLight,)
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right:10),
                                      child:Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children:[
                                            Expanded(
                                              child:Container(
                                                padding:EdgeInsets.only(left:10,right:10,bottom:5),
                                                child:Text(_vendorData.subtitle,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style:Theme.of(context).textTheme.caption),
                                              ),
                                            ),
                                            Text(Helper.calculateTime(double.parse(_vendorData.distance.replaceAll(',',''))),
                                                style:Theme.of(context)
                                                    .textTheme
                                                    .caption
                                            ),

                                          ]
                                      ),
                                    ),


                                  ]
                              )
                            ]
                        ),
                      ),

                    )
              ),
            ):NoShopFoundWidget();
          }),
    );

  }
}
