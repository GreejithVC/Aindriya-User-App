import 'package:flutter/material.dart';

class ProductOrderItemWidget extends StatelessWidget {
  const ProductOrderItemWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: new Image.asset(
                'assets/img/frizz_stone.jpg',
                height: 60.0,
                width:70,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Arun Choco Ice Cream with Sals buy one get 2 offer',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Wrap(
                          children: List.generate(1, (index) {
                            return Text(
                              '57',
                              style: Theme.of(context).textTheme.headline1,
                            );
                          }),
                        ),
                        Text(
                          '28% Offer',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      //Text('\$45.0', style: Theme.of(context).textTheme.subtitle1),
                      Text(
                        " x " + '5',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
