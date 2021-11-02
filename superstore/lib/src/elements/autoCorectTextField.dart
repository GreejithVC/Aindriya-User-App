import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:superstore/src/listener/item_selected_listener.dart';
import 'package:superstore/src/models/vendor.dart';
import 'package:superstore/src/repository/user_repository.dart';

class ShopPicker extends StatelessWidget {
  final OnItemSelected onItemSelected;
  final List<Vendor> marketsList;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();

  ShopPicker({Key key, this.marketsList, this.onItemSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(marketsList.length);
    print("marketsList.length");
    print(marketsList);
    print("marketsList");
    return Container(
      // color: Theme.of(context).accentColor,
      color: Colors.transparent,
      height: 50,
      padding: EdgeInsets.only(top: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _formKey,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: TypeAheadFormField(
                suggestionsCallback: (pattern) {
                  List<Vendor> filteredList = marketsList
                      ?.where(
                        (item) => pattern?.isNotEmpty == true
                            ? item?.shopName
                                    ?.toLowerCase()
                                    ?.contains(pattern?.toLowerCase()) ??
                                false
                            : false,
                      )
                      ?.toList();
                  print("before sorting");
                  filteredList?.forEach((element) {
                    print(element?.shopName);
                  });
                  print("At sorting");
                  filteredList?.sort((a, b) {
                    print("///////");
                    double aDis = calculateDistance(
                        a?.latitude,
                        a?.longitude,
                        currentUser?.value?.latitude?.toString(),
                        currentUser?.value?.longitude?.toString());
                    double bDis = calculateDistance(
                        b?.latitude,
                        b?.longitude,
                        currentUser?.value?.latitude?.toString(),
                        currentUser?.value?.longitude?.toString());
                    print(aDis);
                    print(bDis);
                    dynamic valueRet = aDis?.compareTo(bDis);
                    print(bDis);
                    return valueRet;
                  });
                  print("afr sorting");
                  filteredList?.forEach((element) {
                    print(element?.shopName);
                  });
                  return filteredList;
                },
                itemBuilder: (_, Vendor item) => Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item?.shopName ?? "",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        item?.locationMark ?? "",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                onSuggestionSelected: (Vendor val) {
                  this._textEditingController.text = val?.shopName ?? "";
                  onItemSelected(val);
                  print(val?.latitude);
                  print("val?.latitude");
                  print(val?.longitude);
                  print("val?.longitude");

                  print(val);
                  print("val");
                },
                getImmediateSuggestions: true,
                hideSuggestionsOnKeyboardHide: false,
                hideOnEmpty: false,
                noItemsFoundBuilder: (context) => Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("No Shops Found"),
                ),
                textFieldConfiguration: TextFieldConfiguration(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Search Shops",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    suffixIcon: Icon(
                      Icons.search,
                      size: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  controller: this._textEditingController,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double calculateDistance(String lat1, String lon1, String lat2, String lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((double.tryParse(lat2 ?? "0") - double.tryParse(lat1 ?? "0")) * p) /
            2 +
        c(double.tryParse(lat1 ?? "0") * p) *
            c(double.tryParse(lat2 ?? "0") * p) *
            (1 -
                c((double.tryParse(lon2 ?? "0") -
                        double.tryParse(lon1 ?? "0")) *
                    p)) /
            2;
    return 12742 * asin(sqrt(a));
  }
}
