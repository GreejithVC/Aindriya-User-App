
import '../models/vendor.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/trending.dart';
import '../models/slide.dart';
import '../repository/home_repository.dart';
import '../models/inter_sort.dart';
import '../models/shop_type.dart';


class HomeController extends ControllerMVC {
  List<Slide> slides = <Slide>[];
  List<Slide> middleSlides = <Slide>[];
  List<Vendor>vendorList = <Vendor>[];
  List<Vendor>vendorSearch = <Vendor>[];
  List<InterSortView> interSortView = <InterSortView>[];
  List<Trending> trending = <Trending>[];
  List<ShopType> shopTypeList= <ShopType>[];
  bool loader = false;
  HomeController() {
    //listenForCategories();
    listenForSlides(1);
    listenForMiddleSlides(2);
    listenForDealOfDay();
    listenForVendor();
    listenForInter_sort_view();



  }

  Future<void> listenForSlides(id) async {
    final Stream<Slide> stream = await getSlides(id);
    stream.listen((Slide _slide) {
      setState(() => slides.add(_slide));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }


  Future<void> listenForMiddleSlides(id) async {
    final Stream<Slide> stream = await getSlides(id);
    stream.listen((Slide _slide) {
      setState(() => middleSlides.add(_slide));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForVendor() async {
    setState(() => vendorList.clear());
    final Stream<Vendor> stream = await getTopVendorList();
    stream.listen((Vendor _list) {
      setState(() => vendorList.add(_list));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForVendorSearch(searchTxt) async {
    setState(() =>loader = true);
    setState(() => vendorSearch.clear());
    final Stream<Vendor> stream = await getTopVendorListSearch(searchTxt);
    stream.listen((Vendor _list) {
      setState(() =>loader = false);
      setState(() => vendorSearch.add(_list));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }


  Future<void> listenForDealOfDay() async {
    final Stream<ShopType> stream = await getShopType();
    stream.listen((ShopType _type) {
      setState(() => shopTypeList.add(_type));
    }, onError: (a) {}, onDone: () {});
  }
/*
  Future<void> listenForCategories() async {
    final Stream<Category> stream = await getCategories();
    stream.listen((Category _category) {
      setState(() => categories.add(_category));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForShopType() async {
    final Stream<Category> stream = await getCategories();
    stream.listen((Category _category) {
      setState(() => categories.add(_category));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  } */



  // ignore: non_constant_identifier_names
  Future<void> listenForInter_sort_view() async {
    final Stream<InterSortView> stream = await getInterSort();
    stream.listen((InterSortView _interSort) {
      setState(() => interSortView.add(_interSort));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }







  Future<void> refreshHome() async {
    setState(() {
      slides = <Slide>[];
    });
    await listenForSlides(1);
  }
}
