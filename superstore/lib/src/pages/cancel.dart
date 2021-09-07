import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:superstore/src/controllers/order_controller.dart';
import 'package:superstore/src/repository/user_repository.dart';

import '../helpers/helper.dart';
import '../models/payment.dart';
import '../repository/settings_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CancelPage extends StatefulWidget {
  Payment paymentData;
  String shopName;
  String orderId;
  String shopId;
  CancelPage({Key key, this.paymentData, this.shopName, this.orderId, this.shopId}) : super(key: key);
  @override
  _CancelPageState createState() => _CancelPageState();
}

class _CancelPageState extends StateMVC<CancelPage> {
  OrderController _con;

  _CancelPageState() : super(OrderController()) {
    _con = controller;

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _con.cancelledData.orderId = widget.orderId;
    _con.cancelledData.shopId = widget.shopId;
    _con.cancelledData.amount = widget.paymentData.grand_total;
    _con.cancelledData.userId = currentUser.value.id;

  }
    @override
  Widget build(BuildContext context) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat(' hh:mm a  \n EEE d MMM').format(now);
    return Scaffold(
      /*backgroundColor: Theme.of(context).primaryColor,*/
        appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: Text(
              'Cancel Order',
              style: Theme.of(context).textTheme.headline1,
            )),
        body: ListView(
          children: [
            Container(
              padding:EdgeInsets.only(left:20,right:20,bottom:20),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width:double.infinity,
                        margin: EdgeInsets.only(top:20),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:Theme.of(context).dividerColor.withOpacity(0.3),
                        ),
                        child:Text('Hi there im ${setting.value.appName} bot. i have cancelled your order as per reuest. we have not charged you any cacellation.',
                        style: Theme.of(context).textTheme.bodyText1,
                        )
                    ),
                    Text(formattedDate,style: Theme.of(context).textTheme.caption,),
                    Container(
                        width:double.infinity,
                        margin: EdgeInsets.only(top:20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).primaryColor,
                        ),
                        child:Column(
                          children:[
                            Container(
                              width:double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8)),
                                color:Colors.blueGrey,
                              ),
                              padding: EdgeInsets.all(15),
                              child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color:Colors.red,
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(3.0)),
                                      ),
                                      child: Text('CANCELLED',
                                        style:Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .merge(TextStyle(color: Theme.of(context).primaryColorLight,)
                                        ),
                                      ),
                                    ),
                                    SizedBox(height:5),
                                    Text(widget.shopName,
                                      style: Theme.of(context).textTheme.bodyText1
                                          .merge(TextStyle(color: Theme.of(context).primaryColorLight,)
                                      ),
                                    ),
                                    SizedBox(height:5),
                                    Text('items, ${Helper.pricePrint(widget.paymentData.grand_total)} | ${widget.paymentData.method}',
                                    style: TextStyle(color: Theme.of(context).primaryColorLight,)
                                    )
                                  ]
                              ),
                            ),
                             Container(
                               padding: EdgeInsets.only(top:15,left:15,right:15),
                               child: Row(
                                   children:[
                                     Expanded(
                                       child:Container(
                                         child: Text('Bill Total'),
                                       ),
                                     ),
                                     Container(
                                       padding: EdgeInsets.only(left:10),
                                       child: Text(
                                           '${Helper.pricePrint(widget.paymentData.grand_total)}'
                                       ),
                                     ),
                                   ]
                               ),
                             ),
                            Container(
                              padding: EdgeInsets.only(top:15,left:15,right:15),
                              child: Row(
                                  children:[
                                    Expanded(
                                      child:Container(
                                        child: Text('Cancellation Fees'),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left:10),
                                      child: Text(
                                          '${Helper.pricePrint(0.0)}'
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top:15,left:15,right:15,bottom:15),
                              child: Row(
                                  children:[
                                    Expanded(
                                      child:Container(
                                        child: Text('Refund Amount'),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left:10),
                                      child: widget.paymentData.method=='cash on delivery'?Text(
                                          '${Helper.pricePrint(0.0)}'
                                      ):Text(
                                          '${Helper.pricePrint(widget.paymentData.grand_total)}'
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ]
                        ),
                    ),
                    Text(formattedDate,style: Theme.of(context).textTheme.caption,),

                    Container(
                      width:double.infinity,
                      margin: EdgeInsets.only(top:20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).primaryColor,
                      ),
                      child:Column(
                          children:[
                            Container(
                              width:double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8)),
                                color:Theme.of(context).dividerColor.withOpacity(0.4),
                              ),
                              padding: EdgeInsets.all(15),
                              child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                    Text('Before we end our conversation, may i please know why you cancelled your order',
                                      style: Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ]
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                _con.cancelledData.message = 'I choose a wrong delivery address';
                                _con.cancelOrder();
                              },
                              child: Container(
                                decoration:BoxDecoration(
                                   border:Border(
                                     bottom: BorderSide(
                                       width:0.1,
                                         color:Colors.grey
                                     )
                                   )
                                ),
                                  child:Container(
                                      padding: EdgeInsets.only(left:15,right:15),
                                      child:ListTile(
                                        contentPadding: EdgeInsets.only(left:0,right:0,top:0),
                                        title: Text('I choose a wrong delivery address',
                                          style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color:Colors.blue)),
                                        textAlign: TextAlign.center,
                                        ),
                                      )
                                  )
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                _con.cancelledData.message = 'I ordered the wrong items';
                                _con.cancelOrder();
                              },
                              child: Container(
                                  decoration:BoxDecoration(
                                      border:Border(
                                          bottom: BorderSide(
                                              width:0.1,
                                              color:Colors.grey
                                          )
                                      )
                                  ),
                                  child:Container(
                                      padding: EdgeInsets.only(left:15,right:15),
                                      child:ListTile(
                                        contentPadding: EdgeInsets.only(left:0,right:0,top:0),
                                        title: Text('I ordered the wrong items',
                                          style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color:Colors.blue)),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                  )
                              ),
                            ),

                                InkWell(
                                    onTap: (){
                                      _con.cancelledData.message = 'I forgot to apply coupon';
                                      _con.cancelOrder();
                                    },
                                    child: Container(
                                  decoration:BoxDecoration(
                                      border:Border(
                                          bottom: BorderSide(
                                              width:0.1,
                                              color:Colors.grey
                                          )
                                      )
                                  ),
                                  child:Container(
                                      padding: EdgeInsets.only(left:15,right:15),
                                      child:ListTile(
                                        contentPadding: EdgeInsets.only(left:0,right:0,top:0),
                                        title: Text('I forgot to apply coupon',
                                          style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color:Colors.blue)),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                  )
                              ),
                            ),

                                InkWell(
                                  onTap: (){
                                    _con.cancelledData.message = 'I changed my mind';
                                    _con.cancelOrder();
                                  },
                              child: Container(
                                  decoration:BoxDecoration(
                                      border:Border(
                                          bottom: BorderSide(
                                              width:0.1,
                                              color:Colors.grey
                                          )
                                      )
                                  ),
                                  child:Container(
                                      padding: EdgeInsets.only(left:15,right:15),
                                      child:ListTile(
                                        contentPadding: EdgeInsets.only(left:0,right:0,top:0),
                                        title: Text('I changed my mind',
                                          style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color:Colors.blue)),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                  )
                              ),
                            ),

                            InkWell(
                              onTap: (){
                                _con.cancelledData.message = 'Other reasons';
                                _con.cancelOrder();
                              },
                              child: Container(
                                  child:Container(
                                      padding: EdgeInsets.only(left:15,right:15),
                                      child:ListTile(
                                        contentPadding: EdgeInsets.only(left:0,right:0,top:0),
                                        title: Text('Other reasons',
                                          style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color:Colors.blue)),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                  )
                              ),
                            ),

                          ]
                      ),
                    ),
                    Text(formattedDate,style: Theme.of(context).textTheme.caption,)



                  ],
                )
            )
          ],
        ),
      );
  }
}
