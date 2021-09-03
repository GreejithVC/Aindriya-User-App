
import 'package:flutter/material.dart';


class PackageCardList extends StatefulWidget {
  @override
  _PackageCardListState createState() => _PackageCardListState();
}

class _PackageCardListState extends State<PackageCardList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20.0, left: 20, top: 20),
      padding: EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.pink[50],
        border: Border.all(color: Colors.brown[200], width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: <Widget>[

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  children: [

                    SizedBox(width: 2),
                    Padding(
                      padding: const EdgeInsets.only(left:10,right: 30),
                      child: Text(
                        'Keep the ready to go',
                        style: Theme.of(context).textTheme.headline1.merge(TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5,left:10,right: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Please keep the items ready before the partner arrives the pickup',
                        style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Colors.brown, fontWeight: FontWeight.w300)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.only(right:10),
            child: Image(image: AssetImage('assets/img/sendbag1.png'),
                height: 100,width:63
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
