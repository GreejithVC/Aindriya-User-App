import 'addon.dart';
import 'variant.dart';

class ProductDetails2 {
  String id;

  // ignore: non_constant_identifier_names
  String product_name;
  int rating;
  String image;
  String deliveryRadius;
  String distance;

  // ignore: non_constant_identifier_names
  int num_of_imgs;
  List<variantModel> variant;
  List<AddonModel> addon;
  String productType;

  ProductDetails2();

  ProductDetails2.fromJSON(Map<String, dynamic> jsonMap) {
    print(jsonMap);
    print("dfffffffffffffffffffffffff");
    try {
      id = jsonMap['id'].toString();
      product_name = jsonMap['product_name'];
      distance = jsonMap['distance'] ?? "";
      deliveryRadius = jsonMap['del_radius'] ?? "";

      rating = jsonMap['rating'];
      image = jsonMap['image'];
      num_of_imgs = jsonMap['num_of_imgs'];
      variant = jsonMap['variant'] != null
          ? List.from(jsonMap['variant'])
              .map((element) => variantModel.fromJSON(element))
              .toList()
          : [];
      addon = jsonMap['addon'] != null
          ? List.from(jsonMap['addon'])
              .map((element) => AddonModel.fromJSON(element))
              .toList()
          : [];
      productType = jsonMap['productType'];
    } catch (e) {
      id = '';
      product_name = '';
      distance = '';
      rating = 0;
      image = '';
      num_of_imgs = 0;
      variant = [];
      productType = '';
      addon = [];
      deliveryRadius = '';

      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["product_name"] = product_name;
    map["rating"] = rating;
    map["image"] = image;
    map["num_of_imgs"] = num_of_imgs;
    map["productType"] = num_of_imgs;
    map["distance"] = distance;
    map["del_radius"] = deliveryRadius;

    return map;
  }
}
