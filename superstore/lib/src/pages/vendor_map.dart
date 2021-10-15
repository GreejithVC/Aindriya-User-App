import 'package:flutter/material.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/fmto_controller.dart';
import 'package:flutter_floating_map_marker_titles_core/model/floating_marker_title_info.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_floating_marker_titles/google_maps_flutter_floating_marker_titles.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:superstore/generated/l10n.dart';
import 'package:superstore/src/elements/LocationWidget.dart';
import 'package:superstore/src/elements/autoCorectTextField.dart';
import 'package:superstore/src/helpers/map_pointer.dart';
import 'package:superstore/src/models/vendor.dart';
import 'package:superstore/src/repository/user_repository.dart';
import '../controllers/map_controller.dart';
import '../elements/CardsCarouselWidget.dart';
import '../elements/CircularLoadingWidget.dart';

class VendorMapWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  VendorMapWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _VendorMapWidgetState createState() => _VendorMapWidgetState();
}

class _VendorMapWidgetState extends StateMVC<VendorMapWidget> {
  MapController _con;

  _VendorMapWidgetState() : super(MapController()) {
    _con = controller;

  }

  @override
  void initState() {
    /** _con.currentMarket = widget.routeArgument?.param as Market;
        if (_con.currentMarket?.latitude != null) {
        // user select a market
        _con.getMarketLocation();
        _con.getDirectionSteps();
        } else {
        _con.getCurrentLocation();
        } */


    _con.getCurrentLocation();
    _con.showSearchField = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("_con.floatingTitles.length");
    print(_con.floatingTitles.length);
    return Scaffold(
        body: Stack(
          // fit: StackFit.expand,
          children: <Widget>[
            Container(
              child: _con.cameraPosition == null
                  ? CircularLoadingWidget(height: 0)
                  : GoogleMapWithFMTO(
                      _con?.floatingTitles,
                      // [MapPointer.getFloatingMarkerTitleInfo()],
                      fmtoOptions: FMTOOptions(
                        titlePlacementPolicy:
                            const FloatingMarkerPlacementPolicy(
                          FloatingMarkerGravity.top,
                          24,
                        ),
                      ),
                      onTap: (LatLng latLng) {
                        setState(() {
                          _con.topMarkets.clear();
                          _con.allCircles.clear();
                        });
                      },
                      mapToolbarEnabled: false,
                      mapType: MapType.hybrid,
                      initialCameraPosition: _con.cameraPosition,
                      markers: Set.from(_con.allMarkers),
                      onMapCreated: (GoogleMapController controller) {
                        _con.googleMapController = controller;
                        _con.mapController.complete(controller);
                      },
                      onCameraMove: (CameraPosition cameraPosition) {
                        _con.cameraPosition = cameraPosition;
                      },
                      onCameraIdle: () {
                        _con.getMarketsOfArea();
                      },
                      polylines: _con.polylines,
                      circles: Set.from(_con.allCircles),
                    ),
            ),
            Positioned(
              top: _con.offsetY,
              left: _con.offsetX,
              child: Container(
                width: 150,
                height: 150,
                child: CardsCarouselWidget(
                  marketsList: _con.topMarkets,
                ),
              ),
            ),
            _appBar()
          ],
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

  Widget _appBar() {
    return Container(
      height: 80,
      child: AppBar(
        leading: InkWell(
          onTap: () => widget.parentScaffoldKey.currentState.openDrawer(),
          child: Icon(Icons.menu, color: Theme.of(context).hintColor),
        ),
        actions: <Widget>[
          Visibility(
            visible: _con?.showSearchField == false,
            child: IconButton(
              icon: Icon(
                Icons.search_outlined,size:25,
                color: Theme.of(context).hintColor,
              ),
              onPressed: () {
                setState(() {
                  _con?.showSearchField = true;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.my_location,
              color: Theme.of(context).hintColor,
            ),
            onPressed: () {
              _con.goCurrentLocation();
            },
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white.withOpacity(0.5),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        title: _con?.showSearchField == true ?
        ShopPicker(
            marketsList: _con?.vendorList,
            onItemSelected: (selectedItem) {
              setState(() {
                _con.showSearchField = false;
              });

              if (selectedItem is Vendor) {
                _con?.goSelectedShopLocation(
                    selectedItem.latitude, selectedItem.longitude);
              }
            }):GestureDetector(
            onTap: () {
              //DeliveryAddressDialog(context: context);

              showModal();
            },
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(S.of(context).delivery_location,
                  style: Theme.of(context).textTheme.headline1),
              currentUser.value.latitude == null ||
                      currentUser.value.longitude == null
                  ? Text(S.of(context).select_your_address,
                      style: Theme.of(context).textTheme.caption)
                  : Text(currentUser.value.selected_address,
                      style: Theme.of(context).textTheme.caption.merge(
                          TextStyle(color: Theme.of(context).backgroundColor))),
            ]))
      ),
    );
  }


}
