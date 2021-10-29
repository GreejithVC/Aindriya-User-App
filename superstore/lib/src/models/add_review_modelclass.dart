class AddReview {
  String time;
  String userName;
  String rating;
  String review;

  AddReview({this.time, this.userName, this.rating, this.review,});

  AddReview.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      time = jsonMap['time'].toString();
      userName = jsonMap['userName'];
      rating = jsonMap['rating'];
      review = jsonMap['review'];
    } catch (e) {
      time = '';
      userName = '';
      rating = "";
      review = '';
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["time"] = time;
    map["userName"] = userName;
    map["rating"] = rating;
    map["review"] = review;
    return map;
  }
}