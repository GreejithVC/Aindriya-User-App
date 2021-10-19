import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:superstore/src/models/packagetype.dart';
import 'package:superstore/src/models/vendor.dart';
import 'package:superstore/src/repository/user_repository.dart';

class FavShopController extends ControllerMVC {
  List<Vendor> favShopList = <Vendor>[];

  // addPackageType(context, id, pageType) {
  //   if (generalFormKey.currentState.validate()) {
  //     generalFormKey.currentState.save();
  //     if (pageType == 'do_add') {
  //       Overlay.of(context).insert(loader);
  //       setState(() => shopTypeList.clear());
  //       FirebaseFirestore.instance.collection('packageDetails').add({
  //         'name': packageTypeData.packageName,
  //         'maxProducts': packageTypeData.maxProductSupported,
  //         'maxCategory': packageTypeData.maxCategorySupported,
  //         'isFeaturedShop': packageTypeData.isFeaturedShop,
  //         'monthlyRate': packageTypeData.monthlyRate,
  //         'yearlyRate': packageTypeData.yearlyRate
  //       }).catchError((e) {
  //         print(e);
  //       }).whenComplete(() {
  //         Navigator.pop(context);
  //         listenForPackageTypeList();
  //         Helper.hideLoader(loader);
  //       });
  //       showToast("Update Successfully",
  //           gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
  //     }
  //   }
  // }

  // deletePackageType(id) {
  //   FirebaseFirestore.instance
  //       .collection('packageDetails')
  //       .doc(id)
  //       .delete()
  //       .then((_) {
  //     print("success!");
  //   }).catchError((e) {
  //     print(e);
  //   }).whenComplete(() {
  //     listenForPackageTypeList();
  //   });
  //   showToast("Deleted Successfully",
  //       gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
  // }
  //
  addFavShop(context, Vendor vendor) {
    print("addFavShop///");
    FirebaseFirestore.instance
        .collection('Favourites')
        .doc(currentUser.value.id)
        .collection("favouriteShops")
        .doc(vendor.shopId)
        .set(vendor.toMap())
        .catchError((e) {
      print(e);
    }).whenComplete(() {
      print("addFavShop/// whenComplete");
      listenForFavShopList();
      // Helper.hideLoader(loader);
    });
  }

  deleteSelectedFavShop(context) {
    print("deleteSelectedFavShop");
    List<Vendor> selectedShopList =
        favShopList.where((element) => element.isSelected == true).toList();
    selectedShopList?.forEach((element) {
      print("selectedShopList?.forEach((element)");
      FirebaseFirestore.instance
          .collection('Favourites')
          .doc(currentUser.value.id)
          .collection("favouriteShops")
          .doc(element.shopId)
          .delete();
    });
    listenForFavShopList();
  }

  deleteFavShop(context, Vendor vendor) {
    print("deleteFavShop///");
    FirebaseFirestore.instance
        .collection('Favourites')
        .doc(currentUser.value.id)
        .collection("favouriteShops")
        .doc(vendor.shopId)
        .delete()
        .then((_) {
      print("success!");
    }).catchError((e) {
      print(e);
    }).whenComplete(() {
      print("deleteFavShop/// whenComplete");
      listenForFavShopList();
    });
  }

  Future<void> listenForFavShopList() async {
    // setState(() => favShopList.clear());
    favShopList.clear();
    print("listenForFavShopList///");
    FirebaseFirestore.instance
        .collection('Favourites')
        .doc(currentUser.value.id)
        .collection("favouriteShops")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result);
        print(result.id);
        print(result.reference);
        print(result.data());
        setState(() => favShopList.add(Vendor.fromJSON(result.data())));
      });
    }).catchError((e) {
      print(e);
    }).whenComplete(() {
      print("listenForFavShopList/// completed");
      print(favShopList.length);
    });
  }
}
