import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_floating_map_marker_titles_core/model/floating_marker_title_info.dart';
import 'package:superstore/src/models/user.dart';
import 'package:superstore/src/models/vendor.dart';

class MapPointer {
  static FloatingMarkerTitleInfo getFloatingMarkerTitleInfo(Vendor data) {
    print(data.shopName);
    print("data.shopName");
    return FloatingMarkerTitleInfo(
      id: int.parse(data?.shopId) ?? 0,
      latLng: LatLng(
          // 10.3468925,  76.2074124
          double.tryParse(data.latitude),
          double.tryParse(data.longitude)),
      title: data.shopName ?? "",
      isBold: true,
      color: Colors.blue,
    );
  }

  static FloatingMarkerTitleInfo getMyPositionTitleInfo(UserDetails data) {
    return FloatingMarkerTitleInfo(
      id: int.parse(data?.id) ?? 0,
      latLng: LatLng(
          // 10.3468925,  76.2074124
          data.latitude,
          data.longitude),
      title: data.selected_address ?? "",
      isBold: true,
      color: Colors.blue,
    );
  }
}
