import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:superstore/src/models/add_review_modelclass.dart';
import 'package:superstore/src/repository/user_repository.dart';

class ReviewController extends ControllerMVC {
  List<AddReview> reviewList = <AddReview>[];

  addReview(context, AddReview addReview,
      {@required String id, @required bool isShop}) {
    print("addReview///");
    FirebaseFirestore.instance
        .collection('Reviews')
        .doc(isShop == true ? "Shops" : "Products")
        .collection(id)
        .add(addReview.toMap())
        .catchError((e) {
      print(e);
    }).whenComplete(() {
      print("addReview/// whenComplete");
      listenForReviewList();
      Navigator.pop(context);
      // Helper.hideLoader(loader);
    });
  }

  Future<void> listenForReviewList({@required String id, @required bool isShop}) async {
    reviewList.clear();
    print("listenForReviewList///");
    FirebaseFirestore.instance
        .collection('Reviews')
        .doc(isShop == true ? "Shops" : "Products")
        .collection(id)
        .get()
        .then((querySnapshot) {
      print("listenForReviewList/// querySnapshot");
      querySnapshot.docs.forEach((result) {
        print(result);
        print(result.id);
        print(result.reference);
        print(result.data());
        reviewList.add(AddReview.fromJSON(result.data()));
      });
      setState(() => reviewList.sort((a, b) {
            return a.rating.compareTo(b.rating);
          }));
      notifyListeners();
    }).catchError((e) {
      print(e);
    }).whenComplete(() {
      print("listenForReviewList/// completed");
      print(reviewList.length);
    });
  }
}
