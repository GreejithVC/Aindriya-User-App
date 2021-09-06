
import 'package:flutter/material.dart';
import '../helpers/helper.dart';
import '../models/wallet.dart';

// ignore: must_be_immutable
class CreditCard extends StatefulWidget {
  CreditCard({Key key, this.card}) : super(key: key);
  Wallet card;
  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 216,
        width: 380,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child:Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(image:AssetImage('assets/img/wallet.png'),
                      width:60,height: 50,
                    ),
                    SizedBox(width:10),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Text(Helper.pricePrint(widget.card.balance),style: Theme.of(context).textTheme.headline3.merge(TextStyle(color:Colors.white))),
                          Text('WALLET BALANCE',style: Theme.of(context).textTheme.caption.merge(TextStyle(color:Colors.white))),
                        ]
                    )
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      padding: EdgeInsets.only(right:10,bottom:10),
                      child:

                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/Recharge', arguments: widget.card.balance);
                          },
                      child:Text('Recharge',style: Theme.of(context).textTheme.headline3.merge(TextStyle(color:Colors.white))),
                      ),
                  ),

                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}




