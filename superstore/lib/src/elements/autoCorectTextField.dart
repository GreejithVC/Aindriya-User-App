import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CountryPicker extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();
  static const countriesList = [
    "gymkana",
    "india",
    "bangladesh",
    "bangla",
    "kokata",
    "kerala",
    "pakistan",
    "tamilnadu",
    "banglore",
    "karnataka",
    "mumbai",
    "delhi",
    "newdelhi",
    "thrisur",
    "kochi",
    "guruvayur",
    "chennai",
    "madurai",
    "coimbatore",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).accentColor,
      height: 100,
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
                    countriesList.where((item) =>
                        item.toLowerCase().contains(pattern.toLowerCase()),),
                itemBuilder: (_, String item) => ListTile(title: Text(item),),
                onSuggestionSelected: (String val) {
                  this._textEditingController.text = val;
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