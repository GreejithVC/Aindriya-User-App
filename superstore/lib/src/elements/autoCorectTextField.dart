
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:superstore/src/listener/item_selected_listener.dart';
import 'package:superstore/src/models/vendor.dart';



class ShopPicker extends StatelessWidget {
  final OnItemSelected onItemSelected;
  final List<Vendor> marketsList;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();

  ShopPicker({Key key, this.marketsList, this.onItemSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(marketsList.length);
    print("marketsList.length");
    print(marketsList);
    print("marketsList");
    return Container(
      color: Theme.of(context).accentColor,
      height: 65,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _formKey,
            child: Container(

              height: 50,
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(8)
              ),
              child: TypeAheadFormField(

                suggestionsCallback: (pattern) =>
                    marketsList.where((item) =>
                    item.shopName.toLowerCase().contains(pattern.toLowerCase()) ?? false,),
                itemBuilder: (_, Vendor item) => ListTile(title: Text(item.shopName ?? ""),),
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
                noItemsFoundBuilder: (context) =>
                    Padding(padding: EdgeInsets.all(8),
                      child: Text("No Shops Found"),
                    ),
                textFieldConfiguration: TextFieldConfiguration(
                  decoration: InputDecoration(hintText: "Search Shops",suffixIcon: Icon(Icons.search,size: 20,),
                    border: OutlineInputBorder(),),
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