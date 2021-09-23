class DeliveryOptionsModel {
  String deliveryRadius;
  bool availableCOD;
  bool availableTakeAway;

  DeliveryOptionsModel({this.deliveryRadius,this.availableTakeAway,this.availableCOD});

  DeliveryOptionsModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      deliveryRadius =
      jsonMap['deliveryRadius'] != null ? jsonMap['deliveryRadius'] : '';
      availableCOD =
      jsonMap['availableCOD'] != null ? jsonMap['availableCOD'] : false;
      availableTakeAway = jsonMap['availableTakeAway'] != null
          ? jsonMap['availableTakeAway']
          : '';
    } catch (e) {
      print(e);
    }
  }
}