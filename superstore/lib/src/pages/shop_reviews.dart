import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:superstore/src/controllers/add_review_controller.dart';
import 'package:superstore/src/elements/image_zoom.dart';
import 'package:superstore/src/models/add_review_modelclass.dart';
import 'package:superstore/src/models/vendor.dart';
import 'package:superstore/src/pages/add_reviews_screen.dart';
import 'package:superstore/src/pages/chat_detail_page.dart';
import 'package:superstore/src/pages/store_detail.dart';

class ShopReviews extends StatefulWidget {
  final Vendor shopDetails;
  final int shopTypeID;

  ShopReviews({Key key, this.shopDetails, this.shopTypeID}) : super(key: key);

  @override
  _ShopReviewsState createState() => _ShopReviewsState();
}

class _ShopReviewsState extends StateMVC<ShopReviews> {
  ReviewController _con;

  _ShopReviewsState() : super(ReviewController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    _con.listenForReviewList(id: widget.shopDetails.shopId, isShop: true);
  }

  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    print("listenForReviewList/// length");
    print(_con?.reviewList?.length);
    double averageRating = ((_con?.reviewList?.fold(
                0.0,
                (previousValue, element) =>
                    previousValue + double.tryParse(element?.rating ?? "0")) ??
            0) /
        (_con?.reviewList?.length ?? 0));

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Container(
            height: 200,
            child: PageView.builder(
              itemCount: widget.shopDetails?.coverImageList?.length ?? 0,
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              // onPageChanged: _onPageChanged,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ImageZoomScreen(
                          imageUrl: widget.shopDetails.coverImageList
                              .elementAt(index))));
                },
                child: Image(
                    image: widget.shopDetails.coverImageList.elementAt(index) ==
                                'no_image' &&
                            widget.shopTypeID == 2
                        ? AssetImage(
                            'assets/img/resturentdefaultbg.jpg',
                          )
                        : NetworkImage(
                            widget.shopDetails.coverImageList.elementAt(index)),
                    height: 190,
                    width: double.infinity,
                    fit: BoxFit.cover),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
            margin: EdgeInsets.symmetric(horizontal: 0),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(widget.shopDetails?.shopName,
                          style: Theme.of(context).textTheme.headline6),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 0, left: 4),
                      child: GestureDetector(
                        child: new Icon(Icons.chat,
                            color: Color(0xFF49aecb),
                            // Color(0xFF333D37),
                            size: 24),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChatDetailPage(
                                  shopId: widget.shopDetails?.shopId,
                                  shopName: widget.shopDetails?.shopName,
                                  shopMobile: '12')));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8, left: 4),
                      child: Image.asset(
                        'assets/img/location.png',
                        height: 26,
                        fit: BoxFit.contain,
                      ),
                    ),
                    FavButton(vendorData: widget.shopDetails),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    widget.shopDetails?.subtitle,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Customer reviews ( ${_con?.reviewList?.length ?? ""} )",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                children: [
                                  Text(
                                    averageRating?.toStringAsFixed(1) ?? "",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  AbsorbPointer(
                                    child: RatingBar(
                                      itemSize: 16,
                                      initialRating:averageRating ?? 0,
                                      direction: Axis.horizontal,
                                      itemCount: 5,
                                      allowHalfRating: true,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 0),
                                      ratingWidget: RatingWidget(
                                        full: Icon(
                                          Icons.star_purple500_sharp,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        half: Icon(
                                          Icons.star_half,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        empty: Icon(
                                          Icons.star_border,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          var isReviewAdded = await Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => WriteReviewScreen(
                                        id: widget?.shopDetails?.shopId,
                                        isShop: true,
                                      )));
                          print("isReviewAdded////");
                          print(isReviewAdded);
                          if (isReviewAdded == true) {
                            _con?.listenForReviewList(
                                isShop: true, id: widget?.shopDetails?.shopId);
                          }
                        },
                        child: Text(
                          "Write Review »",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _con?.reviewList?.length ?? 0,
                    itemBuilder: (context, index) {
                      AddReview reviewDetails =
                          _con?.reviewList?.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  reviewDetails?.userName ?? "",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.black87),
                                )),
                                Text(
                                  convertToDisplayDate(reviewDetails?.time),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: AbsorbPointer(
                                child: RatingBar(
                                  itemSize: 16,
                                  initialRating: double.tryParse(
                                      reviewDetails?.rating ?? "0"),
                                  direction: Axis.horizontal,
                                  itemCount: 5,
                                  allowHalfRating: true,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 0),
                                  ratingWidget: RatingWidget(
                                    full: Icon(
                                      Icons.star_purple500_sharp,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    half: Icon(
                                      Icons.star_half,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    empty: Icon(
                                      Icons.star_border,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                              ),
                            ),
                            Text(
                              reviewDetails?.review ?? "",
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String convertToDisplayDate(String date) {
    if (date?.isNotEmpty == true) {
      DateTime inputDate = DateTime.parse(date);
      return toDisplayDate(inputDate);
    }
    return "";
  }

  String toDisplayDate(DateTime date) {
    var formatter = new DateFormat("dd MMM, yyyy");
    return formatter.format(date);
  }
}
