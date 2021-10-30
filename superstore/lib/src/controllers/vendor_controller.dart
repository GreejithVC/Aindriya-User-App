import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:superstore/src/models/add_review_modelclass.dart';
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
  List<AddReview> reviewList = <AddReview>[];

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
          final bool isExpired =
              subScribedPackage?.expiryDate?.isNotEmpty == true
                  ? DateFormat("dd/MM/yyyy")
                      ?.parse(subScribedPackage?.expiryDate)
                      ?.isBefore(DateTime.now())
                  : true;
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
    final Stream<RestaurantProduct> stream =
        await get_restaurantProduct(shopType);

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
    print("expiry ////subScribedPackage?.expiryDate at controller");
    print(subScribedPackage?.expiryDate);
    print("expiry ////.deliveryOptionsModel?.availableCOD");
    print(deliveryOptionsModel?.availableCOD);
    print("expiry ////deliveryOptionsModel?.availableTakeAway");
    print(deliveryOptionsModel?.availableTakeAway);
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
  Future<void> listenForReviewList(
      { String id, bool isShop}) async {
    reviewList.clear();
    print("listenForReviewList///");
    FirebaseFirestore.instance
        .collection('Reviews')
        .doc(isShop == true ? "Shops" : "Products")
        .collection(id)
        .get()
        .then((querySnapshot) {
      print("listenForReviewList/// querySnapshot");
      querySnapshot.docs.forEach((result) {
        print(result);
        print(result.id);
        print(result.reference);
        print(result.data());
        reviewList.add(AddReview.fromJSON(result.data()));
      });
      setState(() => reviewList.sort((a, b) {
        return b.rating.compareTo(a.rating);
      }));
      notifyListeners();
    }).catchError((e) {
      print(e);
    }).whenComplete(() {
      print("listenForReviewList/// completed");
      print(reviewList.length);
    });
  }
}
