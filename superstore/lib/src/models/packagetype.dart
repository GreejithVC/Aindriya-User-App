class PackageTypeModel {
  String id;
  String maxProductSupported;
  String maxCategorySupported;
  String packageName;
  bool isFeaturedShop;
  String monthlyRate;
  String yearlyRate;
  String subscribedOn;
  String expiryDate;
  bool isYearly;

  PackageTypeModel(
      {this.packageName,
      this.maxProductSupported,
      this.maxCategorySupported,
      this.monthlyRate,
      this.yearlyRate});

  PackageTypeModel.fromJSON(Map<String, dynamic> jsonMap, String newId) {
    try {
      id = newId;
      packageName = jsonMap['name'] != null ? jsonMap['name'] : '';
      maxProductSupported =
          jsonMap['maxProducts'] != null ? jsonMap['maxProducts'] : '';
      maxCategorySupported =
          jsonMap['maxCategory'] != null ? jsonMap['maxCategory'] : '';
      isFeaturedShop =
          jsonMap['isFeaturedShop'] != null ? jsonMap['isFeaturedShop'] : false;
      monthlyRate =
          jsonMap['monthlyRate'] != null ? jsonMap['monthlyRate'] : '';
      yearlyRate = jsonMap['yearlyRate'] != null ? jsonMap['yearlyRate'] : '';
      subscribedOn =
          jsonMap['subscribedOn'] != null ? jsonMap['subscribedOn'] : '';
      expiryDate = jsonMap['expiryDate'] != null ? jsonMap['expiryDate'] : '';
    } catch (e) {
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["title"] = packageName;
    map["id"] = id;

    return map;
  }

  @override
  String toString() {
    var map = this.toMap();
    return map.toString();
  }
}
