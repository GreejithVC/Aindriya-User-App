import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../controllers/wallet_controller.dart';
import '../helpers/helper.dart';

// ignore: must_be_immutable
class Recharge extends StatefulWidget {
  String walletAmount;
  Recharge({Key key, this.walletAmount}) : super(key: key);

  @override
  _RechargeState createState() => _RechargeState();
}

class _RechargeState extends StateMVC<Recharge> {
  WalletController _con;
  _RechargeState() : super(WalletController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     key:   _con.scaffoldKey,
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
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
                            'Recharge',
                            style: Theme.of(context).textTheme.headline1,
                            textAlign: TextAlign.left,
                          ),

                      ]),
                    ),
                  ],
                ),

              ])
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              key: _con.RechargeFormKey,
            child:Expanded(
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
                            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start, children: [

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Your Balance', style: Theme.of(context).textTheme.headline3),

                                ],
                              ),
                            ]),
                          ),
                          Container(
                            width:double.infinity,
                              decoration: BoxDecoration(
                                  color:Colors.grey[200]
                              ),
                              padding: EdgeInsets.all(20),
                              child:Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:MainAxisAlignment.center,
                                    children: [
                                      Image(image:AssetImage('assets/img/wallet.png'),
                                      width:60,height: 50,
                                      ),
                                     SizedBox(width:10),
                                     Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children:[
                                           Text(Helper.pricePrint(widget.walletAmount),style: Theme.of(context).textTheme.headline3),
                                           Text('WALLET BALANCE',)
                                         ]
                                       )
                                    ],
                                  )
                                ],
                              )
                          ),
                         SizedBox(height: 60,),
                          Container(
                              padding: const EdgeInsets.only(left: 15, right: 15,),
                              width: double.infinity,
                              child: TextFormField(
                                  textAlign: TextAlign.left,
                                  autocorrect: true,
                                  onSaved: (input) => _con.rechargeData.amount = input,
                                  validator: (input) => input.length < 1 ? 'Please enter your amount' : null,
                                  keyboardType: TextInputType.number,
                                  style: Theme.of(context).textTheme.headline3,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).accentColor,
                                        width: 1.0,
                                      ),
                                    ),
                                  ))),
                       Container(
                              padding: EdgeInsets.only(top:20,left: 10, right: 10,),
                              width: double.infinity,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                /**    GridView.builder(
                                  itemCount:4,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  primary: false,
                                  padding: EdgeInsets.symmetric(horizontal:5),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: 10.0,crossAxisSpacing: 10,childAspectRatio: 2.5,
                                      crossAxisCount: (Orientation.portrait ==
                                          MediaQuery.of(context).orientation)
                                          ? 4
                                          : 4),
                                  itemBuilder: (context, index) {
                                    return InkResponse(
                                        onTap: () {},
                                        child:Container(
                                          height:35,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width:1,color:Colors.black,
                                                ),
                                          ),
                                          child: Center(
                                            child: Text('+500'),
                                          ),
                                        )
                                    );

                                  }), */
                         SizedBox(height:20),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text('Recharge Tip: The average monthly bill of a household is Rs.4100',textAlign: TextAlign.center,)

                           ],
                         ),
                                SizedBox(height:30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // ignore: deprecated_member_use
                                    FlatButton(
                                      onPressed: () {
                                      _con.recharge();
                                      },
                                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 70),
                                      color: Theme.of(context).accentColor.withOpacity(1),
                                      shape: StadiumBorder(),
                                      child: Text(
                                        'Recharge',
                                        style: Theme.of(context).textTheme.headline6.merge(TextStyle(color: Theme.of(context).primaryColorLight)),
                                      ),
                                    ),

                                  ],
                                ),




                              ])
                          ),




                        ]),
                      ]),
                ),
              ),
            ),
            ),

          ],
        ),
      )
    );




  }
}








