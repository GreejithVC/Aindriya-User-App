import '../helpers/custom_trace.dart';

class ShopType {
  String title;
  String previewImage;
  String coverImage;
  String shopType;
  String id;

  ShopType();

  ShopType.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id']!= null ? jsonMap['id'] : 0.0;
      title = jsonMap['title']!= null ? jsonMap['title'] : 0.0;
      previewImage = jsonMap['previewImage']!= null ? jsonMap['previewImage'] : 0.0;
      coverImage = jsonMap['coverImage']!= null ? jsonMap['coverImage'] : 0.0;
      shopType = jsonMap['shopType']!= null ? jsonMap['shopType'] : 0.0;
    } catch (e) {

      print(CustomTrace(StackTrace.current, message: e));
    }
  }
}
