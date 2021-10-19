import 'addon.dart';
import 'variant.dart';

class FavouriteProduct {
  String id;
  String productName;
  String price;
  String image;
  String shopId;
  bool isSelected;

  FavouriteProduct({this.id, this.productName, this.price, this.image,this.shopId});

  FavouriteProduct.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      productName = jsonMap['productName'];
      price = jsonMap['price'];
      image = jsonMap['image'];
      shopId = jsonMap['shopId'];
    } catch (e) {
      id = '';
      productName = '';
      price = "";
      image = '';
      shopId = '';
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["productName"] = productName;
    map["price"] = price;
    map["image"] = image;
    map["shopId"] = shopId;
    return map;
  }
}
