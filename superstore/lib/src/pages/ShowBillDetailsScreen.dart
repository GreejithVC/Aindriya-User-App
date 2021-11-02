import 'package:flutter/cupertino.dart';
import '../helpers/helper.dart';
import '../repository/order_repository.dart';
import 'package:flutter/material.dart';
import '../repository/product_repository.dart' as cartRepo;
import '../../generated/l10n.dart';


class ViewBillDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).accentColor,
          title: Text(

            "View Bill Details",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border:
                Border.all(width: 1, color: Colors.grey.withOpacity(0.6)),
              ),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(S.of(context).bill_details, style: Theme.of(context).textTheme.bodyText1),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(S.of(context).item_total, style: Theme.of(context).textTheme.subtitle2),
                        Text(Helper.pricePrint(currentCheckout.value.sub_total), style: Theme.of(context).textTheme.subtitle2),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Delivery Fee', style: TextStyle(color: Colors.blue)),
                                  currentCheckout.value.delivery_fees  != 0
                                      ? Text('${Helper.pricePrint(currentCheckout.value.delivery_fees)}',
                                      style: Theme.of(context).textTheme.subtitle2)
                                      : Text('Free', style: Theme.of(context).textTheme.subtitle2),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text('${S.of(context).you_save} ${Helper.pricePrint(currentCheckout.value.discount)}  ${S.of(context).on_this_order}',
                                  style: Theme.of(context).textTheme.caption),
                              SizedBox(height: 10),
                              SizedBox(height: 10),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(S.of(context).discount, style: TextStyle(color: Colors.green)),
                                  Text('${Helper.pricePrint(currentCheckout.value.discount)}',
                                      style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(color: Colors.green))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      alignment: Alignment.center,
                      height: 60.0,
                      child: Row(
                        children: <Widget>[
                          Text(
                            S.of(context).to_pay,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Spacer(),
                          Text(
                            '${Helper.pricePrint(currentCheckout.value.grand_total)}',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )

          ],
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            print("ontap////////////");
                Navigator.pop(context);
          },
          child: Container(
            alignment: Alignment.center,
            height: 50,
            margin: EdgeInsets.only(left: 20, right: 20),
            padding: EdgeInsets.only(left: 16, right: 16),
            // width: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  // 10% of the width, so there are ten blinds.
                  colors: <Color>[
                    Colors.lightBlue,
                    Colors.blue
                    // Theme.of(context).accentColor,
                    // Color(0xffee0000).withOpacity(0.7),
                  ], // red to yellow
                )),
            child: Text('Go Back',
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .merge(TextStyle(color: Colors.white))),
          ),
        ));
  }
}
