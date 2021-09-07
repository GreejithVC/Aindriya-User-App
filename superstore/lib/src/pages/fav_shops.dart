import 'package:flutter/material.dart';

class FavShops extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title:Container(
            width: double.infinity,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        'FAV SHOPS',
                        style: Theme.of(context).textTheme.subtitle2,
                        textAlign: TextAlign.left,
                      ),

                    ]),
                  ),

                ],
              ),
              
            ])
        ),
      ),




    );
  }
}
