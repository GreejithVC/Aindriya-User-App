import '../helpers/custom_trace.dart';

class Slide {
  String id;
  // ignore: non_constant_identifier_names
  String slider_text;
  // ignore: non_constant_identifier_names
  String button_text;
  // ignore: non_constant_identifier_names
  String button_color;
  String image;

  Slide();

  Slide.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      slider_text = jsonMap['slider_text'] != null ? jsonMap['slider_text'] : 0;
      button_text = jsonMap['button_text'] != null ? jsonMap['button_text'] : 0;
      button_color = jsonMap['button_text'] != null ? jsonMap['button_text'] : 0;
      image = jsonMap['image'];
    } catch (e) {
      id = '';
      slider_text = '';
      button_color = '';
      button_text = '';
      image = '';

      print(CustomTrace(StackTrace.current, message: e));
    }
  }
}
