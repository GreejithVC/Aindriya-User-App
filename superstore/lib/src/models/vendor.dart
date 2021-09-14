import '../helpers/custom_trace.dart';

class Vendor {
  String shopId;
  String shopName;
  String subtitle;
  String locationMark;
  String rate;
  String distance;
  String logo;
  String cover;
  bool openStatus;
  String longitude;
  String latitude;
  String shopType;
  String focusType;
  String shopTypePreviewImage;
  bool isFavourite;

  Vendor();

  Vendor.fromJSON(Map<String, dynamic> jsonMap) {
    print(jsonMap);
    try {
      shopId = jsonMap['shopId'] ?? "";
      shopName = jsonMap['shopName'] ?? "";
      subtitle = jsonMap['subtitle'] ?? "";
      locationMark = jsonMap['locationMark'] ?? "";
      rate = jsonMap['rate'] ?? "";
      distance = jsonMap['distance'] ?? "";
      logo = jsonMap['logo'] ?? "";
      shopTypePreviewImage = jsonMap['previewImage'] ?? "";
      cover = jsonMap['cover'] ?? "";
      openStatus = jsonMap['openStatus'] ?? false;
      longitude = jsonMap['longitude'] ?? "";
      latitude = jsonMap['latitude'] ?? "";
      shopType = jsonMap['shopType'] ?? "";
      focusType = jsonMap['focusType'] ?? "";
      isFavourite = jsonMap['isFavourite'] ?? false;
    } catch (e) {
      shopId = '';
      shopName = '';
      subtitle = '';
      locationMark = '';
      rate = '';
      distance = '';
      logo = '';
      cover = '';
      openStatus = false;
      longitude = '';
      latitude = '';
      focusType = '';
      shopType = '';
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["shopId"] = shopId;
    map["shopName"] = shopName;
    map["subtitle"] = subtitle;
    map["rate"] = rate;
    map["distance"] = distance;
    map["logo"] = logo;
    map["previewImage"] = shopTypePreviewImage;
    map["cover"] = cover;
    map["openStatus"] = openStatus;
    map["longitude"] = longitude;
    map["latitude"] = latitude;
    map["latitude"] = latitude;
    map["focusType"] = focusType;
    map["shopType"] = shopType;

    return map;
  }
}
