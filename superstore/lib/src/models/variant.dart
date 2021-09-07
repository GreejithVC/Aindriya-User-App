import '../helpers/custom_trace.dart';

// ignore: camel_case_types
class variantModel {
  // ignore: non_constant_identifier_names
  String variant_id;
  // ignore: non_constant_identifier_names
  String product_id;
  String name;
  // ignore: non_constant_identifier_names
  String sale_price;
  // ignore: non_constant_identifier_names
  String strike_price;
  String quantity;
  String unit;
  String type;
  bool selected;
  String foodType;
  String image;

  variantModel();

  variantModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      variant_id = jsonMap['variant_id'];
      product_id = jsonMap['product_id'];
      name = jsonMap['name'];
      sale_price = jsonMap['sale_price'];
      strike_price = jsonMap['strike_price'];
      quantity = jsonMap['quantity'];
      unit = jsonMap['unit'];
      type = jsonMap['type'];
      selected = jsonMap['selected'];
      foodType = jsonMap['foodType'];
      image = jsonMap['image'];
    } catch (e) {
      variant_id = '';
      product_id = '';
      name = '';
      sale_price = '';
      strike_price = '';
      quantity = '';
      unit = '';
      type = '';
      selected = false;
      foodType = '';
      image = '';
      print(CustomTrace(StackTrace.current, message: e));
    }
  }



}
