import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:superstore/src/listener/item_selected_listener.dart';
import 'package:superstore/src/models/vendor.dart';

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
                suggestionsCallback: (pattern) => marketsList.where(
                  (item) =>
                      item.shopName
                          .toLowerCase()
                          .contains(pattern.toLowerCase()) ??
                      false,
                ),
                itemBuilder: (_, Vendor item) => Padding(
                  padding: const EdgeInsets.only(left: 8,top: 4,bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(item.shopName ?? "",style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,),
                      Text(
                        item.locationMark,
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
                  this._textEditingController.text = val.shopName ?? "";
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
}
