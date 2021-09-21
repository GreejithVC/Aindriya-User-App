import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:superstore/src/models/delivery_options_model.dart';
import 'package:superstore/src/models/packagetype.dart';
import 'package:superstore/src/repository/user_repository.dart';
import '../models/category.dart';

import '../repository/home_repository.dart';
import '../models/restaurant_product.dart';
import '../repository/vendor_repository.dart';
import '../models/vendor.dart';

class VendorController extends ControllerMVC {
  List<Vendor> vendorList = <Vendor>[];
  List<Category> categories = <Category>[];
  List<RestaurantProduct> vendorResProductList = <RestaurantProduct>[];
  PackageTypeModel subScribedPackage;
  DeliveryOptionsModel deliveryOptionsModel;
  VendorController();


  Future<void> listenForPackageSubscribed(String userId) async {
    print("listen for package subscribed");
    FirebaseFirestore.instance
        .collection("vendorSubscriptions")
        .doc(userId)
        .get()
        .then((value) {
      if (value?.data() != null) {
        print(value.data());
        setState(() {
          subScribedPackage = PackageTypeModel.fromJSON(value.data(), userId);
          DateTime expiryDate =
              DateFormat("dd/mm/yyyy")?.parse(subScribedPackage?.expiryDate) ??
                  DateTime.now();
          final bool isExpired = expiryDate.isBefore(DateTime.now());
          print(isExpired);
          if (isExpired == true) {
            storeLiveStatus(false, userId);
          }
        });
      }
    }).catchError((e) {
      print(e);
    }).whenComplete(() {});
  }

  Future<void> listenForVendorList(int shopType, int focusId) async {

    final Stream<Vendor> stream = await getVendorList(shopType, focusId);

    stream.listen((Vendor _list) {
      print(_list);
      setState(() => vendorList.add(_list));
      vendorList.forEach((element) {
        print(element.logo);
      });
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }


  Future<void> listenForCategories(shopId) async {
    final Stream<Category> stream = await getCategories(shopId);
    stream.listen((Category _category) {
      setState(() => categories.add(_category));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }



  Future<void> listenForRestaurantProduct(int shopType) async {
    final Stream<RestaurantProduct> stream = await get_restaurantProduct(shopType);

    stream.listen((RestaurantProduct _list) {
      setState(() => vendorResProductList.add(_list));

      vendorResProductList.forEach((element) {
        print('list');
        print(element.category_name);
      });

    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }


  sendChat(chatTxt, userId, shopId, shopMobile, shopName) {
    String chatRoom = '${DateTime.now().millisecondsSinceEpoch}$userId-$shopId';
    FirebaseFirestore.instance.collection('chatList').doc(chatRoom).set({
      'message': chatTxt.text,
      'userId': userId,
      'shopId': shopId,
      'senderName': currentUser.value.name,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'transferType': 'User'
    }).catchError((e) {
      print(e);
    });
    String chatMaster = 'U$userId-F$shopId';
    FirebaseFirestore.instance.collection('chatUser').doc(chatMaster).set(
      {
        'shopId': shopId,
        'userId': userId,
        'lastChat': chatTxt.text,
        'shopMobile': shopMobile,
        'shopunRead': 'false',
        'userMobile': currentUser.value.phone,
        'userName': currentUser.value.name,
        'shopName': shopName,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'transferType': 'User',
        'phone': 9675087369,
      },
    ).catchError((e) {
      print(e);
    });

    return true;

}


  Future<void> listenForDeliveryDetails(String userId) async {
    print("listen for DeliveryDetails");
    FirebaseFirestore.instance
        .collection("vendorDeliveryDetails")
        .doc(userId)
        .get()
        .then((value) {
      if (value?.data() != null) {
        print(value.data());
        setState(() {
          deliveryOptionsModel = DeliveryOptionsModel.fromJSON(value.data());
          if (deliveryOptionsModel?.availableCOD != true &&
              deliveryOptionsModel?.availableTakeAway != true) {
            storeLiveStatus(false, userId);
          }
        });
      }
    }).catchError((e) {
      print(e);
    }).whenComplete(() {});
  }
}
