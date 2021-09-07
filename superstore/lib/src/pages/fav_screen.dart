import 'package:date_picker_timeline/extra/color.dart';
import 'package:flutter/material.dart';

class FavScreen extends StatelessWidget {
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
                        'FAV SCREEN',
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
