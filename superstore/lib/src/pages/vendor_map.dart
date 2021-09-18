import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: _con.currentAddress?.latitude == null
            ? new IconButton(
                icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
                onPressed: () =>
                    widget.parentScaffoldKey.currentState.openDrawer(),
              )
            : IconButton(
                icon: new Icon(Icons.arrow_back,
                    color: Theme.of(context).hintColor),
                onPressed: () =>
                    Navigator.of(context).pushNamed('/Pages', arguments: 2),
              ),
        title: Text(
          'Explorer',
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
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
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned.fill(
            child: _con.cameraPosition == null
                ? CircularLoadingWidget(height: 0)
                : GoogleMap(
                    onTap: (LatLng latLng) {
                      setState(() {
                        _con.topMarkets.clear();
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
            left: _con.offsetY,
            child: Container(
              width: 150,
              height: 150,
              child: CardsCarouselWidget(
                marketsList: _con.topMarkets,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
