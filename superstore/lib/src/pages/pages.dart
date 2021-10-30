import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:superstore/generated/l10n.dart';
import 'package:superstore/src/pages/fav_shops.dart';
import 'package:superstore/src/pages/otp_verification.dart';
import 'package:superstore/src/pages/register.dart';
import 'ProfilePage.dart';
import 'chat_page.dart';
import 'wishList.dart';
import 'vendor_map.dart';
import '../elements/DrawerWidget.dart';
import '../helpers/helper.dart';
import '../pages/home.dart';
import 'orders.dart';

// ignore: must_be_immutable
class PagesWidget extends StatefulWidget {
  dynamic currentTab;

  Widget currentPage = HomeWidget();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  PagesWidget({
    Key key,
    this.currentTab,
  }) {
    currentTab = 0;
  }

  @override
  _PagesWidgetState createState() {
    return _PagesWidgetState();
  }
}

class _PagesWidgetState extends State<PagesWidget> {
  initState() {
    super.initState();
    _selectTab(widget.currentTab);
  }

  @override
  void didUpdateWidget(PagesWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentPage =
              VendorMapWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 1:
          widget.currentPage = FavShops();
          break;
        case 2:
          widget.currentPage = ChatPage();
          break;
        case 3:
          widget.currentPage =
              HomeWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 4:
          widget.currentPage = WishList();
          break;
        case 5:
          widget.currentPage = OrdersWidget();
          break;
        case 6:
          widget.currentPage = ProfilePage();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // onWillPop: Helper.of(context).onWillPop,
      onWillPop: () => Helper.of(context).showExitPopUp(context),
      child: Scaffold(
        key: widget.scaffoldKey,
        drawer: DrawerWidget(),
        //backgroundColor: Colors.transparent,
        body: widget.currentPage,
        bottomNavigationBar: CurvedNavigationBar(
          height: 50,
          animationCurve: Curves.fastOutSlowIn,
          color: Color(0xFF333D37),
          backgroundColor: Colors.white,
          buttonBackgroundColor: Color(0xFF333D37),
          index: widget.currentTab,
          onTap: (int i) {
            this._selectTab(i);
          },
          //   // this will be set when a new tab is tapped

          items: [
            bottomBarIcons(
                Image(
                  image: AssetImage('assets/img/mapPin.png'),
                  width: 25,
                  height: 25,
                  color: Colors.white,
                ),
                "Map"),
            bottomBarIcons(
                Image(
                  image: AssetImage('assets/img/housewithheart.png'),
                  width: 25,
                  height: 25,
                  color: Colors.white,
                ),
                "Favorite"),
            bottomBarIcons(Icon(Icons.chat, color: Colors.white), "Chats"),
            bottomBarIcons(Icon(Icons.home,size: 32, color: Colors.white), "Home"),
            bottomBarIcons(
                Icon(Icons.favorite, color: Colors.white,size: 26,), "Wishlist"),
            bottomBarIcons(
                Icon(Icons.shopping_bag_outlined, color: Colors.white,size: 27,),
                "Orders"),
            bottomBarIcons(Icon(Icons.person, color: Colors.white,size: 28,), "Profile"),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.location_on_outlined),
            //   // ignore: deprecated_member_use
            //   title: Text('Map'),
            // ),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.shop),
            //     // ignore: deprecated_member_use
            //     title: Text('Favorite')),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.chat),
            //     // ignore: deprecated_member_use
            //     title: Text('Chats')),
            // BottomNavigationBarItem(
            //     icon: Image(
            //       image: AssetImage('assets/img/logo.png'),
            //       width: 35,
            //       height: 35,
            //
            //     ),
            //     // ignore: deprecated_member_use
            //     title: Text('Home')),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.favorite),
            //     // ignore: deprecated_member_use
            //     title: Text('Wishlist')),
            // BottomNavigationBarItem(
            //     icon: new Icon(Icons.shopping_bag_outlined),
            //     // ignore: deprecated_member_use
            //     title: Text('Orders')),
            // BottomNavigationBarItem(
            //   icon: new Icon(Icons.person),
            //   // ignore: deprecated_member_use
            //   title: Text(S.of(context).profile),
            // ),
          ],
        ),
      ),
    );
  }

  Widget bottomBarIcons(Widget iconData, String title) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconData,
          // ignore: deprecated_member_use
          // Text(
          //   title,
          //   style: TextStyle(color: Colors.white),
          //   maxLines: 1,
          //   overflow: TextOverflow.ellipsis,
          // ),
        ],
      ),
    );
  }
}
