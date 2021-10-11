import 'package:flutter/material.dart';
import 'package:superstore/src/elements/autoCorectTextField.dart';
import 'package:superstore/src/repository/settings_repository.dart';

import '../elements/CategoryLoaderWidget.dart';
import '../elements/MiddleSliderWidget.dart';

import '../elements/CategoryshopType.dart';
import '../elements/ShopTypesSlider.dart';
import '../elements/LocationWidget.dart';
import '../controllers/home_controller.dart';
import '../elements/HomeSliderWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/user_repository.dart';
import '../../generated/l10n.dart';

class HomeWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  HomeWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends StateMVC<HomeWidget> {
  HomeController _con;
  bool loader = false;

  _HomeWidgetState() : super(HomeController()) {
    _con = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          leading: InkWell(
            onTap: () => widget.parentScaffoldKey.currentState.openDrawer(),
            child: Icon(Icons.menu, color: Theme.of(context).hintColor),
          ),
          /**actions: [
              Icon(Icons.local_mall, color: Theme.of(context).hintColor, size: 19),
              SizedBox(width: 3),
              Padding(padding: EdgeInsets.only(right: 15, top: 15), child: Text('Offers', style: Theme.of(context).textTheme.headline1)),
              ], */
          actions: <Widget>[
            loader
                ? SizedBox(
                    width: 60,
                    height: 60,
                    child: RefreshProgressIndicator(),
                  )
                : ShoppingCartButtonWidget(
                    iconColor: Theme.of(context).hintColor,
                    labelColor: Theme.of(context).splashColor),
          ],
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).accentColor,
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          title: GestureDetector(
              onTap: () {
                //DeliveryAddressDialog(context: context);

                showModal();
              },
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).delivery_location,
                        style: Theme.of(context).textTheme.headline1),
                    currentUser.value.latitude == null ||
                            currentUser.value.longitude == null
                        ? Text(S.of(context).select_your_address,
                            style: Theme.of(context).textTheme.caption)
                        : Text(currentUser.value.selected_address,
                            style: Theme.of(context).textTheme.caption.merge(
                                TextStyle(
                                    color: Theme.of(context).backgroundColor))),
                  ])),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CountryPicker(),
                Expanded(
                    child: ListView(
                        children: [
                  Stack(children: [
                    Container(
                      // Here the height of the container is 45% of our total height
                      height: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                    HomeSliderWidget(slides: _con.slides),
                  ]),
                  Container(
                    alignment: Alignment.center,
                    color: Theme.of(context).accentColor,
                    padding: EdgeInsets.only(top: 12, bottom: 8),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(0xFFfbd100).withOpacity(0.5)),
                      child: Text('Our Stores',
                          style: Theme.of(context)
                              .textTheme
                              .headline1
                              .merge(TextStyle(fontSize: 20))),
                    ),
                  ),
                  _con.shopTypeList.isEmpty
                      ? CategoryLoaderWidget()
                      : CategoryShopType(
                          shopType: _con.shopTypeList,
                        ),
                  SizedBox(height: 15),
                  setting.value.noticeboard != ''
                      ? Padding(
                          padding: EdgeInsets.only(left: 22, right: 22),
                          child: Text(setting.value.noticeboard,
                              style: Theme.of(context).textTheme.subtitle1),
                        )
                      : Text(''),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    leading: Icon(
                      Icons.trending_up,
                      color: Theme.of(context).hintColor,
                    ),
                    title: Text(
                      'Nearby Shop',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    subtitle: Text(
                      'To Best',
                      maxLines: 2,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  SizedBox(height: 2),
                  ShopTopSlider(
                    vendorList: _con.vendorList,
                    key: null,
                  ),
                  SizedBox(height: 2),
                  MiddleSliderWidget(slides: _con.middleSlides),
                  SizedBox(height: 15),
                ])),
              ],
            ),
          ),
        ));
  }

  void showModal() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            color: Color(0xff737373),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              LocationModalPart(),
                            ]),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 5, bottom: 5),
                      child: Container(
                        width: double.infinity,
                        // ignore: deprecated_member_use
                        child: FlatButton(
                            onPressed: () {
                              setState(() => currentUser.value);
                              Navigator.pop(context);
                              _con.listenForVendor();
                            },
                            padding: EdgeInsets.all(15),
                            color: Theme.of(context).accentColor.withOpacity(1),
                            child: Text(
                              S.of(context).proceed_and_close,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .merge(TextStyle(color: Colors.white)),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
