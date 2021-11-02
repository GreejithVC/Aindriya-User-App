import 'package:flutter/cupertino.dart';
import 'package:responsive_ui/responsive_ui.dart';
import '../models/tips.dart';
import '../repository/settings_repository.dart';
import '../helpers/helper.dart';
import '../repository/order_repository.dart';
import '../models/cart_responce.dart';
import '../repository/product_repository.dart';
import '../repository/user_repository.dart';
import '../Widget/custom_divider_view.dart';
import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import 'LocationWidget.dart';
import 'Productbox3Widget.dart';
import '../repository/product_repository.dart' as cartRepo;
import '../../generated/l10n.dart';


import 'TimeSlot.dart';

// ignore: must_be_immutable
class CheckoutListWidget extends StatefulWidget {
  CheckoutListWidget({Key key, this.con, this.callback}) : super(key: key);
  CartController con;
  Function callback;
  @override
  _CheckoutListWidgetState createState() => _CheckoutListWidgetState();
}

class _CheckoutListWidgetState extends State<CheckoutListWidget> {
  bool ratingOne = false;
  int selectedRadio;
  CustomDividerView _buildDivider() => CustomDividerView(
    dividerHeight: 1.0,
    color: Theme.of(context).dividerColor,
  );

  @override
  void initState() {

    widget.con.grandSummary();
    widget.con.getTimeSlot();
   if(currentCheckout.value.uploadImage==null){
     currentCheckout.value.uploadImage ='no';
   }

    super.initState();
    selectedRadio = 1;
    currentCheckout.value.deliverType = 1;

  }
  setDeliveryType(int val) {
    setState(() {
      selectedRadio = val;
      currentCheckout.value.deliverType = val;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ValueListenableBuilder(
                valueListenable: cartRepo.currentCart,
                builder: (context, _setting, _) {
                  return ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: currentCart.value.length,
                    shrinkWrap: true,
                    primary: false,
                    padding: EdgeInsets.only(top: 10),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, int index) {
                      CartResponce _cartresponce = currentCart.value.elementAt(index);
                      return ProductBox3Widget(con: widget.con, productDetails: _cartresponce);
                    },
                    separatorBuilder: (context, index) {
                      return CustomDividerView(dividerHeight: 1.0, color: Theme.of(context).dividerColor);
                    },
                  );
                }),


         /*   Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Wrap(
                alignment: WrapAlignment.start,
                children: <Widget>[
                  Container(
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 7, right: 10),
                            child: Icon(Icons.library_books, color: Colors.grey[500]),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              child: TextField(
                                  style: Theme.of(context).textTheme.subtitle2,
                                  textAlign: TextAlign.left,
                                  autocorrect: true,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: 'Any Restaurant request? we will try our best',
                                    hintStyle: Theme.of(context).textTheme.subtitle2,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                    ),
                                  )),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ), */
            SizedBox(height: 10),
            CustomDividerView(dividerHeight: 15.0),
            // Container(
            //   margin: const EdgeInsets.only(right: 10.0, left: 10, top: 20),
            //   padding: EdgeInsets.all(10),
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     color: Colors.orange[50],
            //     border: Border.all(color: Colors.brown[200], width: 1.0),
            //     borderRadius: BorderRadius.circular(10.0),
            //   ),
            //   child: Row(
            //     children: <Widget>[
            //       /*ClipOval(
            //           child: Image.asset(
            //             'assets/images/food3.jpg',
            //             height: 90.0,
            //             width: 90.0,
            //           ),
            //         ),*/
            //       // Flexible(
            //       //   child: Column(
            //       //     mainAxisAlignment: MainAxisAlignment.center,
            //       //     crossAxisAlignment: CrossAxisAlignment.start,
            //       //     children: <Widget>[
            //       //       Wrap(
            //       //         children: [
            //       //           Theme(
            //       //             data: ThemeData(unselectedWidgetColor: Colors.deepOrange),
            //       //             child: Checkbox(
            //       //               checkColor: Theme.of(context).scaffoldBackgroundColor,
            //       //               activeColor: Colors.deepOrange,
            //       //               value: this.ratingOne,
            //       //               onChanged: (bool value) {
            //       //                 setState(() {
            //       //                   this.ratingOne = value;
            //       //                 });
            //       //               },
            //       //             ),
            //       //           ),
            //       //           SizedBox(width: 2),
            //       //           Padding(
            //       //             padding: const EdgeInsets.only(top: 9),
            //       //             child: Text(
            //       //               'Opt in for No-contact Delivery ',
            //       //               style: Theme.of(context).textTheme.headline1.merge(TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w700)),
            //       //             ),
            //       //           ),
            //       //         ],
            //       //       ),
            //       //       Padding(
            //       //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //       //         child: Column(
            //       //           mainAxisAlignment: MainAxisAlignment.center,
            //       //           crossAxisAlignment: CrossAxisAlignment.start,
            //       //           children: <Widget>[
            //       //             Text(
            //       //               'Our Delivery partner will after reaching and leave the order at your door gate(Not Applicable for COD)',
            //       //               style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Colors.brown, fontWeight: FontWeight.w300)),
            //       //             ),
            //       //           ],
            //       //         ),
            //       //       ),
            //       //       SizedBox(height: 10),
            //       //     ],
            //       //   ),
            //       // ),
            //       SizedBox(height: 10),
            //     ],
            //   ),
            // ),
            setting.value.instanceDelivery?Padding(
                padding: EdgeInsets.only(top: 7, right: 0,left:5),
                child:Row(
                  children: [
                    Row(children: [
                      Wrap(
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          Radio(
                              value: 1,
                              groupValue: selectedRadio,
                              activeColor: Colors.blue,
                              onChanged: (val) {

                                setDeliveryType(val);
                              }),
                          Padding(
                            padding: EdgeInsets.only(top:12),
                            child: Text('Instant Delivery/TakeAway',style: Theme.of(context).textTheme.bodyText1,),
                          ),

                        ],),
                      //         )
                    ],),
                    Row(children: [
                      Wrap(
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          Radio(
                              value: 2,
                              groupValue: selectedRadio,
                              activeColor: Colors.blue,
                              onChanged: (val) {

                                setDeliveryType(val);
                              }),
                          Padding(
                            padding: EdgeInsets.only(top:12),
                            child: Text('Select time slot',style: Theme.of(context).textTheme.bodyText1,),
                          ),

                        ],
                      ),


                    ],),


                  ],
                )
              // child:Wrap(
              //   children: [
              //     Div(
              //         colS:6,
              //         colM:6,
              //         colL:6,
              //         child:
              //         Wrap(
              //           alignment: WrapAlignment.start,
              //           crossAxisAlignment: WrapCrossAlignment.start,
              //           children: [
              //             Radio(
              //                 value: 1,
              //                 groupValue: selectedRadio,
              //                 activeColor: Colors.blue,
              //                 onChanged: (val) {
              //
              //                   setDeliveryType(val);
              //                 }),
              //             Padding(
              //               padding: EdgeInsets.only(top:12),
              //               child: Text('Instant Delivery/TakeAway',style: Theme.of(context).textTheme.bodyText1,),
              //             ),
              //
              //           ],
              //         )
              //     ),
              //     Div(
              //         colS:6,
              //         colM:6,
              //         colL:6,
              //         child:
              //         Wrap(
              //           alignment: WrapAlignment.start,
              //           crossAxisAlignment: WrapCrossAlignment.start,
              //           children: [
              //             Radio(
              //                 value: 2,
              //                 groupValue: selectedRadio,
              //                 activeColor: Colors.blue,
              //                 onChanged: (val) {
              //
              //                  setDeliveryType(val);
              //                 }),
              //             Padding(
              //               padding: EdgeInsets.only(top:12),
              //               child: Text('Select time slot',style: Theme.of(context).textTheme.bodyText1,),
              //             ),
              //
              //           ],
              //         )
              //     ),
              //
              //
              //   ],
              // ),
            ):Container(),


            currentCheckout.value.deliverType==2?Container(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.lock_clock, size: 20.0, color: Colors.grey[700]),
                  SizedBox(width: 10),
                  Text('Delivery/Take Away Time Slot', style: Theme.of(context).textTheme.subtitle2),
                  Spacer(),
                  InkWell(
                    onTap: showSlot,
                    child: currentCheckout.value.deliveryTimeSlot != null
                        ? Text('CHANGE',
                        style:
                        Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.w600)))
                        : Text('ADD',
                        style:
                        Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.w600))),
                  )
                ],
              ),
            ):Container(),
            currentCheckout.value.deliverType==2? Padding(
                padding: EdgeInsets.only(left: 18, right: 18, top: 10),
                child: currentCheckout.value.deliveryTimeSlot != null
                    ? Text(
                  'Your selected time slot is ${currentCheckout.value.deliveryTimeSlot}',
                  style: Theme.of(context).textTheme.subtitle2,
                )
                    : Text(
                  'Please select your time slot',
                  style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(color: Colors.red)),
                )):Container(),
            SizedBox(height: 20),
            CustomDividerView(dividerHeight: 18.0),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(top: 20.0, left: 18, right: 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        child: Icon(Icons.add_location, color: Colors.grey[500], size: 30.0),
                      ),
                      Positioned(
                        top: 0.0,
                        right: 0.0,
                        child: Icon(Icons.check_circle, color: Colors.green, size: 18),
                      )
                    ],
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(S.of(context).delivery_location, style: Theme.of(context).textTheme.subtitle2),
                      SizedBox(height: 10),
                    ],
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      showModal();
                    },
                    child: currentUser.value.selected_address != null
                        ? Text(S.of(context).change_address,
                        style:
                        Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.w600)))
                        : Text('Add Address',
                        style:
                        Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.w600))),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 18, right: 18, top: 10),
              child: currentUser.value.selected_address != null
                  ? Text(
                currentUser.value.selected_address,
                style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w600)),
              )
                  : Text(
                'Please add your location',
                style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
            CustomDividerView(dividerHeight: 18.0),
           setting.value.deliveryTips?Container(
              margin: const EdgeInsets.only(right: 10.0, left: 10, top: 10),
              padding: const EdgeInsets.all(10.0),
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                          Container(child: Icon(Icons.monetization_on)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Tip Your Delivery Partner',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          Text('How it Works', style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Colors.blue)))
                        ]),
                        Padding(
                          padding: const EdgeInsets.only(left: 35),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 6),
                              Text(
                                'Thank Your delivery partner  for helping you stay safe indoors support them through these tough times with a trip',
                                style: Theme.of(context).textTheme.caption,
                              ),
                              SizedBox(height: 20),
                              Wrap(spacing: 10,
                                  children: List.generate(  currentTips.value.length, (index){
                                    Tips _tipsData =   currentTips.value.elementAt(index);

                                    return     GestureDetector(
                                        onTap: () => {
                                          currentTips.value.forEach((_l) {
                                            setState(() {
                                              _l.selected = false;
                                            });
                                          }),
                                          _tipsData.selected = true,
                                          currentCheckout.value.delivery_tips = _tipsData.amount.toDouble(),
                                         widget.con.grandSummary(),
                                        widget.callback(true),
                                        Future.delayed(const Duration(milliseconds: 2500), () {


                                        widget.callback(false);

                                          }),
                                        },
                                        child:Container(
                                            width: 65,
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(7),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 7,
                                                  offset: Offset(0, 3), // changes position of shadow
                                                ),
                                              ],
                                              color: _tipsData.selected?Colors.deepPurpleAccent:Theme.of(context).primaryColor,
                                            ),
                                            child: Center(child: Text(Helper.pricePrint(_tipsData.amount)))));


                                  })





                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ):Container(),
            SizedBox(height: 20),
            CustomDividerView(dividerHeight: 15.0),
            ValueListenableBuilder(
                valueListenable: cartRepo.currentCart,
                builder: (context, _setting, _) {
                  //widget.con.grandSummary();
                  return Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(S.of(context).bill_details, style: Theme.of(context).textTheme.bodyText1),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(S.of(context).item_total, style: Theme.of(context).textTheme.subtitle2),
                            Text(Helper.pricePrint(currentCheckout.value.sub_total), style: Theme.of(context).textTheme.subtitle2),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Delivery Fee', style: TextStyle(color: Colors.blue)),
                                      currentCheckout.value.delivery_fees  != 0
                                          ? Text('${Helper.pricePrint(currentCheckout.value.delivery_fees)}',
                                          style: Theme.of(context).textTheme.subtitle2)
                                          : Text('Free', style: Theme.of(context).textTheme.subtitle2),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text('${S.of(context).you_save} ${Helper.pricePrint(currentCheckout.value.discount)}  ${S.of(context).on_this_order}',
                                      style: Theme.of(context).textTheme.caption),
                                  SizedBox(height: 10),
                                  _buildDivider(),
                                  SizedBox(height: 10),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(S.of(context).discount, style: TextStyle(color: Colors.green)),
                                      Text('${Helper.pricePrint(currentCheckout.value.discount)}',
                                          style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(color: Colors.green))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        _buildDivider(),
                        Container(
                          alignment: Alignment.center,
                          height: 60.0,
                          child: Row(
                            children: <Widget>[
                              Text(
                                S.of(context).to_pay,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Spacer(),
                              Text(
                                '${Helper.pricePrint(currentCheckout.value.grand_total)}',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            CustomDividerView(dividerHeight: 15.0),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 18, right: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 7, right: 10),
                            child: Icon(Icons.receipt, color: Colors.grey[500]),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                                child: Text('Review your order and address details to avoid cancellation', style: Theme.of(context).textTheme.subtitle2)),
                          )
                        ],
                      )),
                  SizedBox(height: 17),
                  Container(
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 7, right: 10),
                            child: Icon(Icons.timer, color: Colors.deepOrangeAccent[200]),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                                child: Text('If you Choose to cancel you can do it with 60 seconds after placing the order',
                                    style: Theme.of(context).textTheme.subtitle2)),
                          )
                        ],
                      )),
                  SizedBox(height: 17),
                  Container(
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 7, right: 10),
                            child: Icon(Icons.assignment, color: Colors.deepOrangeAccent[200]),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                                child: Text('Post 60 seconds you will be charged a 100% cancellation fess r', style: Theme.of(context).textTheme.subtitle2)),
                          )
                        ],
                      )),
                  SizedBox(height: 10),
                  Container(
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 7, right: 10),
                            child: Icon(Icons.pan_tool, color: Colors.deepOrangeAccent[200]),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.only(top: 7),
                                child: Text('However in the event of an unusual delay of your order you will not be charged a cancellation fees',
                                    style: Theme.of(context).textTheme.subtitle2)),
                          )
                        ],
                      )),
                  SizedBox(height: 10),
                  Container(
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 7, right: 10),
                            child: Icon(Icons.thumb_up, color: Colors.deepOrangeAccent[200]),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.only(top: 7),
                                child: Text('This policy helps us avoid food wastage and compensate restaurant / delivey partners for their reports',
                                    style: Theme.of(context).textTheme.subtitle2)),
                          )
                        ],
                      )),
                  SizedBox(height: 20),
                  Container(
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 7, right: 10),
                            child: Icon(Icons.thumb_up, color: Colors.transparent),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              child: Text('Read Policy', style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Colors.blue))),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
            SizedBox(height: 20),
            CustomDividerView(dividerHeight: 18.0),
            // SizedBox(height: 100),




          ]
          ),
      ),
    );
  }

  void showModal() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            color: Color(0xff737373),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: SingleChildScrollView(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                          LocationModalPart(),
                        ]),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                      child: Container(
                        width: double.infinity,
                        // ignore: deprecated_member_use
                        child: FlatButton(
                            onPressed: () {
                              widget.con.calculateDistance(currentUser.value.latitude, currentUser.value.longitude, currentCheckout.value.shopLatitude, currentCheckout.value.shopLongitude);
                              setState(() => currentUser.value);
                              Navigator.pop(context);
                            },
                            padding: EdgeInsets.all(15),
                            color: Theme.of(context).accentColor.withOpacity(1),
                            child: Text(
                              S.of(context).proceed_and_close,
                              style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Colors.white)),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showSlot() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            color: Color(0xff737373),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: SingleChildScrollView(
                        child: widget.con.timeSlot.isNotEmpty
                            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[TimeSlotWidget(choice: widget.con.timeSlot)])
                            : Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: widget.con.timeSlot.isNotEmpty
                        ? Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                      child: Container(
                        width: double.infinity,
                        // ignore: deprecated_member_use
                        child: FlatButton(
                            onPressed: () {
                              setState(() => currentUser.value);
                              Navigator.pop(context);
                            },
                            padding: EdgeInsets.all(15),
                            color: Theme.of(context).accentColor.withOpacity(1),
                            child: Text(
                              S.of(context).proceed_and_close,
                              style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Colors.white)),
                            )),
                      ),
                    )
                        : Container(),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
