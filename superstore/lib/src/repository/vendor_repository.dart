import 'dart:io';

import 'package:http/http.dart' as http;
import '../models/restaurant_product.dart';
import '../models/vendor.dart';
import 'user_repository.dart';
import '../helpers/helper.dart';
import 'dart:convert';
import '../helpers/custom_trace.dart';


Future<Stream<Vendor>> getVendorList(int shopType, int focusId) async {
  Uri uri = Helper.getUri('api/shoplist/$shopType/$focusId');
  Map<String, dynamic> _queryParams = {};


  _queryParams['myLat'] = currentUser.value.latitude.toString();
  _queryParams['myLon'] = currentUser.value.longitude.toString();
  uri = uri.replace(queryParameters: _queryParams);
  print(uri);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => Vendor.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Vendor.fromJSON({}));
  }
}

Future<bool>  storeLiveStatus(status, id) async {
  Uri uri = Helper.getUri('Api_vendor/dashboard/live_status/${id}/$status');
  Map<String, dynamic> _queryParams = {};

  _queryParams['api_token'] = currentUser.value.apiToken;
  uri = uri.replace(queryParameters: _queryParams);
  final client = new http.Client();
  final response = await client.post(
    uri,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(''),
  );


  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}


// ignore: non_constant_identifier_names
Future<Stream<RestaurantProduct>> get_restaurantProduct(id) async {
  Uri uri = Helper.getUri('api/category_wise_restaurantproduct/$id');
 print(uri);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => RestaurantProduct.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new RestaurantProduct.fromJSON({}));
  }
}
