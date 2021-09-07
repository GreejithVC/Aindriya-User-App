import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';



class IntroScreen extends StatefulWidget {


  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {



  final pages =[
    PageViewModel(
      pageColor: const Color(0xFF8BC34A),
      title: Text("Grocery Fresh",style: TextStyle(fontSize: 24),),
      body: Text(""),
      mainImage: Image.asset("assets/img/intro1.png",height: 285, width: 285),
      titleTextStyle: TextStyle(fontSize: 14,color:Colors.white),
      bodyTextStyle: TextStyle(fontSize: 12 , color: Colors.white),
    ),
    PageViewModel(
      pageColor: const Color(0xFF03A9F4),
      title: Text("Vegetable Fresh",style: TextStyle(fontSize: 24),),
      body: Text(""),
      mainImage: Image.asset("assets/img/intro2.png",height: 285, width: 285),
      titleTextStyle: TextStyle(fontSize: 14,color:Colors.white),
      bodyTextStyle: TextStyle(fontSize: 12 , color: Colors.white),
    ),
    PageViewModel(
      pageColor: const Color(0xFFFEC200),
      title: Text("Pharmacy 24/7",style: TextStyle(fontSize: 24),),
      body: Text(""),
      mainImage: Image.asset("assets/img/intro3.png",height: 285, width: 285),
      titleTextStyle: TextStyle(fontSize: 14,color:Colors.white),
      bodyTextStyle: TextStyle(fontSize: 12, color: Colors.white),
    ),
  ];

  @override
  void initState() {
    super.initState();

  }

  goTONextPage(){

    Navigator.of(context).pushReplacementNamed('/Login');
  }
  @override
  Widget build(BuildContext context) {



    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) => IntroViewsFlutter(
          pages,
          showNextButton: true,
          showBackButton: true,
          showSkipButton: true,
          onTapDoneButton: () {
            goTONextPage();

          },
          pageButtonTextStyles: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
