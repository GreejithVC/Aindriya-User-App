import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
// ignore: must_be_immutable
class ChatDetailPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  ChatDetailPageAppBar({Key key, this.shopId, this.shopName, this.shopMobile}) : super(key: key);
  String shopId;
  String shopName;
  String shopMobile;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).primaryColorDark,
      flexibleSpace: SafeArea(
        child: Container(padding: EdgeInsets.only(left: 5),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios,size: 20,),
                color: Theme.of(context).backgroundColor,
              ),
              SizedBox(
                width: 2,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Favourite Shops",
                      style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                  ],
                ),
              ),
             /** IconButton(
                icon: Icon(Icons.call),
                tooltip: 'Call',
                onPressed: () {
                  //_callNumber();
                },
              ), */
            ],
          ),
        ),
      ),
    );
  }



  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
