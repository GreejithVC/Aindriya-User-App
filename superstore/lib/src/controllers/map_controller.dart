import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_floating_map_marker_titles_core/model/floating_marker_title_info.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:superstore/generated/l10n.dart';
import 'package:superstore/src/elements/LocationWidget.dart';
import 'package:superstore/src/helpers/map_pointer.dart';
import 'package:superstore/src/models/vendor.dart';

import '../repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../helpers/helper.dart';
import '../models/address.dart';
import '../repository/market_repository.dart';

class MapController extends ControllerMVC {
  List<Vendor> topMarkets = <Vendor>[];
  List<Vendor> vendorList = <Vendor>[];
  List<Marker> allMarkers = <Marker>[];
  List<FloatingMarkerTitleInfo> floatingTitles = <FloatingMarkerTitleInfo>[];
  Address currentAddress;
  Set<Polyline> polylines = new Set();
  List<Circle> allCircles = <Circle>[];
  double offsetX;
  double offsetY;

  // Set<Circle> circles = Set.from([Circle(
  //   circleId: CircleId(id),
  //   center: LatLng(latitude, longitude),
  //   radius: 4000,
  // )]);
  CameraPosition cameraPosition;

  // MapsUtil mapsUtil = new MapsUtil();
  Completer<GoogleMapController> mapController = Completer();
  GoogleMapController googleMapController;

  void listenForNearMarkets(Address myLocation, Address areaLocation) async {
    vendorList.clear();

    double zoomLevel = await googleMapController.getZoomLevel();

    final Stream<Vendor> stream =
        await getNearMarkets(myLocation, areaLocation);
    stream.listen((Vendor _market) {
      vendorList.add(_market);
      // Helper.calculateDistance();
      print('loaddata');

      Helper.getMarker(
        _market.toMap(),
        zoomLevel: zoomLevel,
        onItemSelected: (selectedItem) async {
          Vendor item = Vendor.fromJSON(selectedItem);
          var screenCoordinate = await googleMapController.getScreenCoordinate(
              LatLng(double.tryParse(item.latitude),
                  double.tryParse(item.longitude)));
          var devicePixelRatio = Platform.isAndroid
              ? MediaQuery.of(context).devicePixelRatio
              : 1.0;
          double yCoordinate =
              (screenCoordinate?.y?.toDouble() ?? 0) / devicePixelRatio;
          double xCoordinate =
              (screenCoordinate?.x?.toDouble() ?? 0) / devicePixelRatio;
          offsetY = yCoordinate > 200 ? (yCoordinate - 150) : yCoordinate;
          offsetX = xCoordinate > 200 ? (xCoordinate - 150) : xCoordinate;
          topMarkets.clear();
          allCircles.clear();
          setState(() {
            topMarkets.add(item);
            // floatingTitles.add(MapPointer.getFloatingMarkerTitleInfo(_market));

            allCircles.add(Circle(
              strokeWidth: 1,
              strokeColor: Colors.amberAccent,
              fillColor: Colors.indigo.withOpacity(0.5),
              circleId: CircleId(item.shopId),
              center: LatLng(double.tryParse(item.latitude),
                  double.tryParse(item.longitude)),
              radius: item?.deliveryRadius?.isNotEmpty == true
                  ? (double.tryParse(item.deliveryRadius) * 1000)
                  : 3000,
            ));
          });
        },
      ).then((marker) {
        setState(() {
          allMarkers.add(marker);
          floatingTitles.add(MapPointer.getFloatingMarkerTitleInfo(_market));
        });
      });
    }, onError: (a) {}, onDone: () {});
  }

  void getCurrentLocation() async {
    try {
      setState(() {
        cameraPosition = CameraPosition(
          target:
              LatLng(currentUser.value.latitude, currentUser.value.longitude),
          zoom: 13,
        );
      });

      Helper.getMyPositionMarker(
        currentUser.value.latitude,
        currentUser.value.longitude,
        onItemSelected: (selectedItem) async {
          showModal();
        },
      ).then((marker) {
        setState(() {
          allMarkers.add(marker);
          floatingTitles
              .add(MapPointer.getMyPositionTitleInfo(currentUser.value));
        });
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
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

  void getMarketLocation() async {
    try {
      setState(() {
        cameraPosition = CameraPosition(
          target:
              LatLng(currentUser.value.latitude, currentUser.value.longitude),
          zoom: 17.5,
        );
      });
      Helper.getMyPositionMarker(
              currentUser.value.latitude, currentUser.value.longitude)
          .then((marker) {
        setState(() {
          allMarkers.add(marker);
          floatingTitles
              .add(MapPointer.getMyPositionTitleInfo(currentUser.value));
        });
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
  }

  Future<void> goCurrentLocation() async {
    final GoogleMapController controller = await mapController.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(currentUser.value.latitude, currentUser.value.longitude),
      zoom: 14.4746,
    )));
  }

  Future<void> goSelectedShopLocation(String latitude, String longitude) async {
    print("goSelectedShopLocation");
    print(double.parse(latitude));
    print("double.parse(latitude)");
    final GoogleMapController controller = await mapController.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(double.parse(latitude), double.parse(longitude)),
      zoom: 14.4746,
    )));
    print(double.parse(latitude));
    print("double.parse(latitude)");
  }

  void getMarketsOfArea() async {
    setState(() {
      // topMarkets = <Vendor>[];
      Address areaAddress = Address.fromJSON({
        "latitude": currentUser.value.latitude,
        "longitude": currentUser.value.longitude
      });
      if (cameraPosition != null) {
        listenForNearMarkets(currentAddress, areaAddress);
      } else {
        listenForNearMarkets(currentAddress, currentAddress);
      }
    });
  }

/*
  void getDirectionSteps() async {
    currentAddress = await sett.getCurrentLocation();
    mapsUtil
        .get("origin=" +
            currentAddress.latitude.toString() +
            "," +
            currentAddress.longitude.toString() +
            "&destination=" +
            currentMarket.latitude +
            "," +
            currentMarket.longitude +
            "&key=${sett.setting.value?.googleMapsKey}")
        .then((dynamic res) {
      if (res != null) {
        List<LatLng> _latLng = res as List<LatLng>;
        _latLng?.insert(0, new LatLng(currentAddress.latitude, currentAddress.longitude));
        setState(() {
          polylines.add(new Polyline(
              visible: true,
              polylineId: new PolylineId(currentAddress.hashCode.toString()),
              points: _latLng,
              color: config.Colors().mainColor(0.8),
              width: 6));
        });
      }
    });
  }
 */
// Future refreshMap() async {
//   setState(() {
//     topMarkets = <Vendor>[];
//   });
//   //  listenForNearMarkets(currentAddress, currentAddress);
// }
}
