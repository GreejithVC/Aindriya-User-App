import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_floating_map_marker_titles_core/model/floating_marker_title_info.dart';
import 'package:superstore/src/models/vendor.dart';

class MapPointer {
  static FloatingMarkerTitleInfo getFloatingMarkerTitleInfo(Vendor data) {
    return FloatingMarkerTitleInfo(
      id: data?.shopId ?? 0,
      latLng: LatLng(
          double.tryParse(data.latitude), double.tryParse(data.longitude)),
      title: data?.shopName ?? "",
      color: Colors.purple,
    );
  }
}
