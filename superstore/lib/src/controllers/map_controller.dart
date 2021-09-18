import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:superstore/src/models/vendor.dart';

import '../repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../helpers/helper.dart';
import '../models/address.dart';
import '../repository/market_repository.dart';

class MapController extends ControllerMVC {
  List<Vendor> topMarkets = <Vendor>[];
  List<Marker> allMarkers = <Marker>[];
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
    double zoomLevel = await googleMapController.getZoomLevel();
    final Stream<Vendor> stream =
        await getNearMarkets(myLocation, areaLocation);
    stream.listen((Vendor _market) {
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
            allCircles.add(Circle(
              strokeWidth: 1,
              strokeColor: Colors.amberAccent,
              fillColor: Colors.indigo.withOpacity(0.5),
              circleId: CircleId(item.shopId),
              center: LatLng(double.tryParse(item.latitude),
                  double.tryParse(item.longitude)),
              radius: 3000,
            ));
          });
        },
      ).then((marker) {
        setState(() {
          allMarkers.add(marker);
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
          zoom: 7.227,
        );
      });

      Helper.getMyPositionMarker(
              currentUser.value.latitude, currentUser.value.longitude)
          .then((marker) {
        setState(() {
          allMarkers.add(marker);
        });
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
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
