import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../pages/category_product.dart';
import '../models/category.dart';
import 'CategoryLoaderWidget.dart';

// ignore: must_be_immutable
class TopCategoriesWidget extends StatefulWidget {
  List<Category> categoryData;
  String shopId;
  String shopName;
  String subtitle;
  String km;
  int shopTypeID;
  String longitude;
  String latitude;
  int focusId;

  TopCategoriesWidget(
      {Key key,
      this.categoryData,
      this.shopId,
      this.shopName,
      this.subtitle,
      this.km,
      this.shopTypeID,
      this.latitude,
      this.longitude,
      this.focusId})
      : super(key: key);

  @override
  _TopCategoriesWidgetState createState() => _TopCategoriesWidgetState();
}

class _TopCategoriesWidgetState extends State<TopCategoriesWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: StaggeredGridView.countBuilder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(0),
        crossAxisCount: 6,
        itemCount: widget.categoryData.length,
        itemBuilder: (BuildContext context, int index) {
          Category _categoryData = widget.categoryData.elementAt(index);
          return Column(children: [
            AspectRatio(aspectRatio: 1,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CategoryProduct(
                            categoryData: _categoryData,
                            shopId: widget.shopId,
                            shopName: widget.shopName,
                            subtitle: widget.subtitle,
                            km: widget.km,
                            shopTypeID: widget.shopTypeID,
                            latitude: widget.latitude,
                            longitude: widget.longitude,
                            focusId: widget.focusId,
                          )));
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    height: 150.0,
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: Color(0xffFFD700),
                            width: 2,
                            style: BorderStyle.solid),
                        shape: BoxShape.rectangle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                              _categoryData.image,
                            )))),
              ),
            ),
            SizedBox(height: 5),
            Container(
              child: Text(
                _categoryData.name,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ]);
        },
        staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
        mainAxisSpacing: 20,
        crossAxisSpacing: 12,
      ),
    );
  }
}
