import 'address.dart';

class UserDetails {
  String id;
  String name;
  String email;
  String apiToken;
  String phone;
  String about;
  String image;
  String password;
  // ignore: deprecated_member_use
  List<Address> address = List<Address>();
  // ignore: non_constant_identifier_names
  String selected_address;
  double latitude;
  double longitude;


  // used for indicate if client logged in or not
  bool auth;

//  String role;

  UserDetails();

  UserDetails.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'] != null ? jsonMap['name'] : '';
      email = jsonMap['email'] != null ? jsonMap['email'] : '';
      phone = jsonMap['phone'];
      auth = jsonMap['auth'];
      apiToken = jsonMap['api_token'];
      password = jsonMap['password'];
      selected_address = jsonMap['selected_address'];
      address = jsonMap['address'] != null ? List.from(jsonMap['address']).map((element) => Address.fromJSON(element)).toList() : [];

      image = jsonMap['image'];

      latitude = jsonMap['latitude'].toDouble()!= null ? jsonMap['latitude'].toDouble() :  0.0;
      longitude = jsonMap['longitude'].toDouble() != null ? jsonMap['longitude'].toDouble() :  0.0;
    } catch (e) {

      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;

    map["api_token"] = apiToken;

    map["password"] = password;
    map["selected_address"] = selected_address;
    map["address"] = address.map((element) => element.toMap()).toList();
    map["phone"] = phone;
    map["auth"] = auth;
    map["media"] = image;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    return map;
  }

  @override
  String toString() {
    var map = this.toMap();
    map["auth"] = this.auth;
    return map.toString();
  }
}
