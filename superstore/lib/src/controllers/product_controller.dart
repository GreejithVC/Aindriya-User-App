import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:superstore/src/models/delivery_options_model.dart';
import 'package:superstore/src/models/packagetype.dart';
import 'package:superstore/src/repository/vendor_repository.dart';
import '../models/addon.dart';
import '../models/product_details2.dart';
import '../models/variant.dart';
import '../repository/order_repository.dart';
import '../models/review_list.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../models/product.dart';
import '../models/auto_suggestion.dart';
import '../models/cart_responce.dart';

import '../repository/product_repository.dart';
import '../repository/search_repository.dart';
import '../helpers/helper.dart';
import '../repository/user_repository.dart';

class ProductController extends ControllerMVC {
  // ignore: non_constant_identifier_names
  List<Product> category_products = <Product>[];
  List<ProductDetails2> productList = <ProductDetails2>[];
  List<ReviewList> reviewList = <ReviewList>[];
  PackageTypeModel subScribedPackage;
  DeliveryOptionsModel deliveryOptionsModel;

  // ignore: non_constant_identifier_names
  List<AutoSuggestion> auto_suggestion = <AutoSuggestion>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  String searchText;
  String pageTitle;
  OverlayEntry loader;
  bool loadCart = false;
  CartResponce cartresponse = new CartResponce();

  ProductController() {
    loader = Helper.overlayLoader(context);
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForProductsByCategory(int id) async {
    final Stream<Product> stream = await getProductsByCategory(id);
    stream.listen((Product _product) {
      setState(() {
        category_products.add(_product);
      });
    }, onError: (a) {
      /** scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).verify_your_internet_connection),
          )); */
    }, onDone: () {});
  }

  void saveSearch(String search) {
    print("saveSearch");
    setRecentSearch(search);
    Navigator.of(context).pushReplacementNamed('/ProductList');
  }

  void listenForProductList(String type) async {
    print("???????aaaaaaaaaaaaaa");
    String search = await getRecentSearch();
    setState(() => searchText = search);
    setState(() => productList.clear());
    setState(() => pageTitle = searchText);
    print("???????bbbbbbbbbbbbbb");
    final Stream<ProductDetails2> stream =
        await getProductlist(type, searchText);
    print("???????cccccccccc");
    stream.listen((ProductDetails2 _product) {
      print("???????ddddddddddd");
      print(_product);
      print("/////////////product");
      setState(() => productList.add(_product));
    }, onError: (a) {
      print(a);
      // ignore: deprecated_member_use
      scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text('verify_your_internet_connection'),
      ));
    }, onDone: () {});
  }

  listenGetSuggestion(text) async {
    final Stream<AutoSuggestion> stream = await getAutosuggestion(text);
    auto_suggestion.clear();
    stream.listen((AutoSuggestion _product) {
      setState(() => auto_suggestion.add(_product));
    }, onDone: () {});
  }

  rTypeProductSearch(tempUsers, String filterString) async {
    print(tempUsers.length);
    /**List<ProductDetails2> _list = tempUsers
        .where((u) =>
        (u.product_name.toLowerCase().contains(filterString.toLowerCase())) ||
        (u.id.toLowerCase().contains(filterString.toLowerCase())))
        .toList();
        print(_list.length);
        return _list; */
  }

  showQtyVariant(id, variantID) {
    String qty;
    currentCart.value.forEach((element) {
      if (element.id == id && element.variant == variantID) {
        qty = element.qty.toString();
      }
    });
    return qty;
  }

  incrementQtyVariant(id, variantId) {
    currentCart.value.forEach((element) {
      if (element.id == id && element.variant == variantId) {
        element.qty = element.qty + 1;
      }
    });
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    currentCart.notifyListeners();
    setCurrentCartItem();
  }

  decrementQtyVariant(id, variantId) {
    bool removeState;
    currentCart.value.forEach((element) {
      if (element.id == id && element.variant == variantId) {
        if (element.qty > 1) {
          element.qty = element.qty - 1;
        } else {
          removeState = true;
        }
      }
    });
    if (removeState == true) {
      currentCart.value
          .removeWhere((item) => item.id == id && item.variant == variantId);
// ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

    }
    if (currentCart.value.length == 0) {
      currentCheckout.value.shopName = null;
      currentCheckout.value.shopTypeID = 0;
      currentCheckout.value.shopId = null;
      setCurrentCheckout(currentCheckout.value);
    }
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    currentCart.notifyListeners();
    setCurrentCartItem();
  }

  checkProductIdCartVariant(id, variantId) {
    print('check$id-$variantId');
    currentCart.value.forEach((element) {
      print(element.variant);
    });
    var estateSelected = currentCart.value.where(
        (dropdown) => dropdown.id == id && dropdown.variant == variantId);
    print(estateSelected.length);
    currentCart.value.forEach((element) {
      print(element.product_name);
    });
    if (estateSelected.length == 0) {
      return 1;
    } else {
      return 0;
    }
  }

  void checkShopAdded(
      ProductDetails2 productDetail,
      type,
      variantModel variant,
      shopId,
      cartClear,
      shopName,
      subtitle,
      km,
      shopTypeID,
      latitude,
      longitude,
      callback,
      focusId) {
    print("ssssssssssssssssssssssssss");
    print(currentCheckout?.value?.shopId);
    print(shopId);
    if (currentCheckout?.value?.shopId == shopId ||
        currentCheckout?.value?.shopId == null) {
      print(" if ");
      addToCart2(productDetail, type, variant, shopId, shopName, subtitle, km,
          shopTypeID, latitude, longitude, callback, focusId);
    } else {
      print("else cart clear");
      cartClear();
    }
  }

  prescriptionCart(shopId, shopName, shopTypeId, subtitle, latitude, longitude,
      focusTd, cartClear) {
    if (currentCheckout.value.shopId == shopId ||
        currentCheckout.value.shopId == null) {
      currentCheckout.value.shopId = shopId;
      currentCheckout.value.shopName = shopName;
      currentCheckout.value.shopTypeID = shopTypeId;
      currentCheckout.value.subtitle = subtitle;
      currentCheckout.value.shopLatitude = latitude;
      currentCheckout.value.shopLongitude = longitude;
      currentCheckout.value.focusId = focusTd;
      currentCheckout.value.deliveryPossible = true;
      Navigator.of(context).pushNamed('/Checkout');
    } else {
      cartClear();
    }
  }

  void addToCart2(
      ProductDetails2 productDetail,
      type,
      variantModel variant,
      shopId,
      shopName,
      subtitle,
      km,
      shopTypeID,
      latitude,
      longitude,
      callback,
      focusId) {
    if (currentCart.value.length == 0) {
      print("calll backk");
      if (callback != null) {
        callback(true);
        print(callback);
        print(" after callback");
        Future.delayed(const Duration(milliseconds: 2500), () {
          callback(false);
        });
      }
    }
    CartResponce cartresponce = new CartResponce();
    setState(() {
      this.loadCart = true;
    });

    cartresponce.product_name = productDetail.product_name;
    cartresponce.price = variant.sale_price;
    cartresponce.offer = int.parse(variant.variant_id);
    cartresponce.id = productDetail.id;
    cartresponce.strike = variant.strike_price;
    cartresponce.variant = variant.variant_id;
    cartresponce.quantity = variant.quantity;
    cartresponce.variantValue = variant.name;
    cartresponce.qty = 1;
    cartresponce.unit = variant.unit;
    cartresponce.userId = currentUser.value.id;
    cartresponce.image = variant.image;
    currentCheckout.value.shopId = shopId;
    currentCheckout.value.shopName = shopName;
    currentCheckout.value.subtitle = subtitle;
    currentCheckout.value.shopTypeID = shopTypeID;
    currentCheckout.value.shopLatitude = latitude;
    currentCheckout.value.shopLongitude = longitude;
    currentCheckout.value.focusId = focusId;
    currentCheckout.value.deliveryPossible = true;
    currentCheckout.value.uploadImage = 'no';
    currentCheckout.value.km = km?.toString()?.isNotEmpty == true
        ? double.parse(km?.replaceAll(',', ''))
        : 0;
    currentCart.value.add(cartresponce);
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    currentCart.notifyListeners();
    setCurrentCartItem();
    setCurrentCheckout(currentCheckout.value);
    print(currentCheckout.value.toMap());

    if (type == 'buy') {
      Navigator.of(context).pushNamed('/Checkout');
    }
    setState(() {
      this.loadCart = false;
    });
  }

  void addToCartRestaurant(
      ProductDetails2 productDetail,
      type,
      List<variantModel> variant,
      shopId,
      List<AddonModel> addon,
      shopName,
      subtitle,
      km,
      shopTypeId,
      latitude,
      longitude,
      callback,
      focusTd) {
    if (currentCart.value.length == 0) {
      callback(true);
      Future.delayed(const Duration(milliseconds: 2500), () {
        callback(false);
      });
    }
    CartResponce cartresponce = new CartResponce();
    setState(() {
      this.loadCart = true;
    });
    String salePrice;
    String variantId;
    String quantity;
    String strikePrice;
    String unit;
    String image;
    String variantName;
    variant.forEach((variantData) {
      if (variantData.selected == true) {
        salePrice = variantData.sale_price;
        variantId = variantData.variant_id;
        quantity = variantData.quantity;
        strikePrice = variantData.strike_price;
        unit = variantData.name;
        image = variantData.image;
        variantName = variantData.name;
      }
    });

    currentCart.value.removeWhere(
        (item) => item.id == productDetail.id && item.variant == variantId);

    cartresponce.product_name = productDetail.product_name;
    cartresponce.price = salePrice;
    cartresponce.image = image;
    cartresponce.offer = int.parse(variantId);
    cartresponce.id = productDetail.id;
    cartresponce.strike = strikePrice;
    cartresponce.variant = variantId;
    cartresponce.quantity = quantity;
    cartresponce.variantValue = variantName;
    cartresponce.qty = 1;
    cartresponce.unit = unit;
    cartresponce.userId = currentUser.value.id;
    currentCheckout.value.km = double.parse(km.replaceAll(',', ''));
    currentCheckout.value.shopId = shopId;
    currentCheckout.value.shopName = shopName;
    currentCheckout.value.shopTypeID = shopTypeId;
    currentCheckout.value.subtitle = subtitle;
    currentCheckout.value.shopLatitude = latitude;
    currentCheckout.value.shopLongitude = longitude;
    currentCheckout.value.focusId = focusTd;
    currentCheckout.value.uploadImage = 'no';

    cartresponce.addon = addon.where((i) => i.selected == true).toList();
    currentCheckout.value.deliveryPossible = true;
    currentCart.value.add(cartresponce);

    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    currentCart.notifyListeners();
    setCurrentCartItem();
    setCurrentCheckout(currentCheckout.value);

    if (type == 'buy') {
      Navigator.of(context).pushNamed('/Checkout');
    }
    setState(() {
      this.loadCart = false;
    });

    Navigator.pop(context);
  }

  checkRestaurantVariant(productID, addonID) {
    if (currentCart.value.length > 0) {
      var estateSelected;
      currentCart.value.forEach((element) {
        estateSelected =
            element.addon.where((dropdown) => dropdown.addon_id == addonID);
      });
      if (estateSelected.length == 0) {
        return false;
      } else {
        print('yes');
        return true;
      }
    } else {
      return false;
    }
  }

  calculateAmount() {
    int totalprice = 0;

    int addon = 0;

    currentCart.value.forEach((element) {
      element.addon.forEach((addonElement) {
        addon += int.parse(addonElement.price) * element.qty;
      });
      totalprice += (int.parse(element.price) * element.qty) + addon;
      //   int totalstrickprice = 0;
      //  totalstrickprice += int.parse(element.strike) * element.qty;
    });
    //int saveamount = 0;
    //saveamount = totalstrickprice - totalprice;

    return totalprice;
  }

  clearCart() {
    currentCheckout.value.shopName = null;
    currentCheckout.value.shopTypeID = 0;
    currentCheckout.value.shopId = null;
    currentCart.value.clear();
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    currentCart.notifyListeners();
    setCurrentCartItem();
    setCurrentCheckout(currentCheckout.value);
    // ignore: deprecated_member_use
    scaffoldKey?.currentState?.showSnackBar(SnackBar(
      content: Text('Cart Cleared Successfully'),
    ));
    Navigator.pop(context);
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
            storeLiveStatus(true, userId);
          }
        });
      }
    }).catchError((e) {
      print(e);
    }).whenComplete(() {});
  }
}
