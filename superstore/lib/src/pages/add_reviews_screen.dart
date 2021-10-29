import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:superstore/src/controllers/add_review_controller.dart';
import 'package:superstore/src/models/add_review_modelclass.dart';
import 'package:superstore/src/repository/user_repository.dart';

class WriteReviewScreen extends StatefulWidget {
  final String id;
  final bool isShop;

  const WriteReviewScreen({Key key, this.id, this.isShop}) : super(key: key);
  @override
  _WriteReviewScreenState createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends StateMVC<WriteReviewScreen> {
  ReviewController _con;
  final TextEditingController _reviewController = TextEditingController();

  _WriteReviewScreenState() : super(ReviewController()) {
    _con = controller;
  }
  double ratingValue = 0;
  @override
  // ignore: must_call_super
  void initState() {
    _con?.listenForReviewList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).accentColor,
          title: Text(
            "Review Product",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border:
                    Border.all(width: 1, color: Colors.grey.withOpacity(0.6)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your Ratings:",
                    style: TextStyle(fontSize: 14),
                  ),
                  RatingBar(
                    onRatingUpdate:(rating) {
                      print(rating);
                      ratingValue = rating;
                      setState(() { });
                    },
                    itemSize: 24,
                    initialRating: 0,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    allowHalfRating: true,
                    itemPadding: EdgeInsets.symmetric(horizontal: 0),
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

                  ),
                ],
              ),
            ),
            TextFormField(
              autovalidate:  true,
              controller: _reviewController,
              maxLines: 8,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  hintText: "Write your review",
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4))),
            ),
          ],
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            print("ontap////////////");
            _con?.addReview(
                context,
                AddReview(
                  time: DateTime.now().toString(),
                  rating: ratingValue.toString(),
                  review: _reviewController.text.trim(),
                  userName: currentUser?.value?.name,
                ),
                isShop: widget?.isShop,
                id: widget?.id);
          },
          child: Container(
            alignment: Alignment.center,
            height: 50,
            margin: EdgeInsets.only(left: 20, right: 20),
            padding: EdgeInsets.only(left: 16, right: 16),
            // width: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  // 10% of the width, so there are ten blinds.
                  colors: <Color>[
                    Colors.lightBlue,
                    Colors.blue
                    // Theme.of(context).accentColor,
                    // Color(0xffee0000).withOpacity(0.7),
                  ], // red to yellow
                )),
            child: Text('Submit',
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .merge(TextStyle(color: Colors.white))),
          ),
        ));
  }
}
