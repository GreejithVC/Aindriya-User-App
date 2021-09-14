import 'addon.dart';
import 'variant.dart';

class FavouriteProduct {
  String id;
  String productName;
  String price;
  String image;

  FavouriteProduct({this.id, this.productName, this.price, this.image});

  FavouriteProduct.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      productName = jsonMap['productName'];
      price = jsonMap['price'];
      image = jsonMap['image'];
    } catch (e) {
      id = '';
      productName = '';
      price = "";
      image = '';
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["productName"] = productName;
    map["price"] = price;
    map["image"] = image;
    return map;
  }
}
