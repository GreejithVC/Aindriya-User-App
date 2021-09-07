import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_repository.dart';
import '../models/vendor.dart';



import '../models/trending.dart';
import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/slide.dart';
import '../models/category.dart';
import '../models/inter_sort.dart';

import '../models/shop_type.dart';

Future<Stream<Slide>> getSlides(id) async {
  Uri uri = Helper.getUri('api/slider/$id');

  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => Slide.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Slide.fromJSON({}));
  }
}



// ignore: missing_return
Future<Stream<Category>> getCategories(shopId) async {
  Uri uri = Helper.getUri('api/categories/$shopId');

  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => Category.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
  }
}



// ignore: missing_return
Future<Stream<ShopType>> getShopType() async {

  Uri uri = Helper.getUri('api/home_settings/shoptype');

  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return ShopType.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
  }
}

// ignore: missing_return
Future<Stream<Trending>> getTrending() async {
  Uri uri = Helper.getUri('api/trends');
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => Trending.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
  }
}

// ignore: missing_return
Future<Stream<InterSortView>> getInterSort() async {
  Uri uri = Helper.getUri('api/inter_sort_view');

  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => InterSortView.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
  }
}




Future<Stream<Vendor>>getTopVendorList() async {
  Uri uri = Helper.getUri('api/home_settings/topvendor');
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

    print(e);
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Vendor.fromJSON({}));
  }
}


Future<Stream<Vendor>>getTopVendorListSearch(searchTxt) async {
  Uri uri = Helper.getUri('api/shopSearch');
  Map<String, dynamic> _queryParams = {};



  _queryParams['myLat'] = currentUser.value.latitude.toString();
  _queryParams['myLon'] = currentUser.value.longitude.toString();
  _queryParams['search'] = searchTxt;
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

    print(e);
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Vendor.fromJSON({}));
  }
}