import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/fmto_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_floating_marker_titles/google_maps_flutter_floating_marker_titles.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:superstore/generated/l10n.dart';
import 'package:superstore/src/elements/autoCorectTextField.dart';
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
                zoomControlsEnabled: true,
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
              Align(
              alignment: Alignment.bottomLeft,
                child: Container(
                  margin: EdgeInsets.only(bottom: 30,left:10),

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,color: Colors.white.withOpacity(0.8)
                  ),
                  child: IconButton(
                  icon: Icon(
                  Icons.my_location,size: 28,
                  color: Theme.of(context).hintColor,
                  ),
                  onPressed: () {
                  _con.goCurrentLocation();
                  },
                  ),
                ),
              ),

            _appBar()
          ],
        ));
  }



  // IconButton(
  // icon: Icon(
  // Icons.my_location,
  // color: Theme.of(context).hintColor,
  // ),
  // onPressed: () {
  // _con.goCurrentLocation();
  // },
  // ),
  Widget _appBar() {
    return Container(
      height: 80,
      child: AppBar(
        leading: InkWell(
          onTap: () => widget.parentScaffoldKey.currentState.openDrawer(),
          child: Icon(Icons.menu, color: Theme.of(context).hintColor),
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10,left: 8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
            color: Theme.of(context).secondaryHeaderColor,
            shape:BoxShape.circle,

          ),
            child: Icon(
              Icons.notification_important_rounded,
              color: Colors.white,size: 20,
            ),

          ),

        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        title:
        ShopPicker(
            marketsList: _con?.vendorList,
            onItemSelected: (selectedItem) {

              if (selectedItem is Vendor) {
                _con?.goSelectedShopLocation(
                    selectedItem.latitude, selectedItem.longitude);
              }
            })
      ),
    );
  }


}
