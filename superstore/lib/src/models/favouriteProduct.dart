import 'addon.dart';
import 'variant.dart';

class FavouriteProduct {
  String id;
  String productName;
  String price;
  String image;
  String shopId;
  String shopName;
  bool isSelected;

  FavouriteProduct({this.id, this.productName, this.shopName,this.price, this.image,this.shopId});

  FavouriteProduct.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      productName = jsonMap['productName'];
      shopName = jsonMap['shopName'];
      price = jsonMap['price'];
      image = jsonMap['image'];
      shopId = jsonMap['shopId'];
    } catch (e) {
      id = '';
      productName = '';
      shopName = '';
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
    map["shopName"] = shopName;
    map["price"] = price;
    map["image"] = image;
    map["shopId"] = shopId;
    return map;
  }
}
