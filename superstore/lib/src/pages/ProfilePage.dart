import 'dart:io';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:image_picker/image_picker.dart';
import 'package:superstore/generated/l10n.dart';
import 'package:superstore/src/controllers/home_controller.dart';
import 'package:superstore/src/controllers/user_controller.dart';
import 'package:superstore/src/elements/LocationWidget.dart';
import 'package:superstore/src/elements/image_zoom.dart';
import 'package:superstore/src/models/user.dart';
import 'package:superstore/src/pages/fav_shops.dart';
import 'package:superstore/src/pages/wishList.dart';
import 'package:superstore/src/repository/settings_repository.dart';
import 'package:superstore/src/repository/user_repository.dart';
import '../repository/product_repository.dart' as cartRepo;
import 'package:toast/toast.dart';
import '../repository/user_repository.dart' as userRepo;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  HomeController _con;
  UserController _userController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    print("zoom");
                    print(currentUser.value.image);
                    print(currentUser.value.image != 'no_image' &&
                        currentUser.value.image != null);
                    if (currentUser.value.image != 'no_image' &&
                        currentUser.value.image != null) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ImageZoomScreen(
                                imageUrl: currentUser.value.image,
                              )));
                    }
                  },
                  child: Container(
                    height: 190,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'assets/img/resturentdefaultbg.jpg',
                          )),
                    ),
                    child: Stack(
                      children: [
                        currentUser.value.image != 'no_image' &&
                                currentUser.value.image != null
                            ? Image(
                                image: NetworkImage(currentUser.value.image),
                                height: 190,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              )
                            : Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Image(
                                    image: AssetImage(
                                        'assets/img/resturentdefaultbg.jpg'),
                                    height: 190,
                                    width: double.infinity,
                                    fit: BoxFit.fill,
                                  ),
                                  // Container(
                                  //   margin: EdgeInsets.only(top:180),
                                  //   width: MediaQuery.of(context).size.width,
                                  //   height:10,
                                  //   decoration: BoxDecoration(
                                  //       color:Theme.of(context).primaryColor,
                                  //       borderRadius: BorderRadius.only(
                                  //           topLeft: Radius.circular(0),
                                  //           topRight: Radius.circular(0))),
                                  //   child:Column(
                                  //     children: [
                                  //       Text('hh',style:TextStyle(color:Colors.transparent))
                                  //     ],
                                  //   ),
                                  //
                                  // ),
                                  Positioned(
                                      top: 50,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            height: 90.0,
                                            width: 90.0,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: GestureDetector(
                                              onTap: () {
                                                Imagepickerbottomsheet();
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                backgroundImage: currentUser
                                                                .value.image !=
                                                            'no_image' &&
                                                        currentUser
                                                                .value.image !=
                                                            null
                                                    ? NetworkImage(
                                                        currentUser.value.image)
                                                    : AssetImage(
                                                        'assets/img/userImage.png',
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                        Positioned(
                            bottom: 10,
                            right: 10,
                            child: GestureDetector(
                                onTap: () {
                                  Imagepickerbottomsheet();
                                },
                                child: Icon(
                                  Icons.edit_outlined,
                                  size: 25,
                                  color: Colors.white,
                                )))
                      ],
                    ),
                  ),
                ),
                Container(
                    color: Theme.of(context).primaryColor,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      currentUser.value.name,
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(currentUser.value.email,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .merge(
                                                TextStyle(color: Colors.grey))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        /**
                            Container(
                            margin: EdgeInsets.only(top:20,left:20,right:10),
                            child:Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                            Container(
                            child:Column(
                            children: [
                            Text('123343', textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline1,),
                            SizedBox(height:5),
                            Text('Like',style:Theme.of(context).textTheme.subtitle1.merge(TextStyle(color:Colors.grey)))
                            ],
                            ),
                            ),
                            SizedBox(width:40),
                            Container(
                            child:Column(
                            children: [
                            Text('123343', textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline1,),
                            SizedBox(height:5),
                            Text('Comment',style:Theme.of(context).textTheme.subtitle1.merge(TextStyle(color:Colors.grey)))
                            ],
                            ),
                            ),

                            ],
                            ),
                            ), */
                      ],
                    )),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          ListView(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(top: 0),
                            shrinkWrap: true,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Item(
                                      Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 26,
                                      ),
                                      "Edit Profile",
                                      tapFucntion: () {
                                        Navigator.of(context)
                                            .pushNamed('/Settings');
                                      },
                                    ),
                                    SizedBox(width: 10),
                                    Item(
                                        Image.asset(
                                          'assets/img/ic_address.png',
                                          height: 26,
                                          color: Colors.white,
                                          fit: BoxFit.contain,
                                        ),
                                        "Address", tapFucntion: () {
                                      showModal();
                                    }),
                                    SizedBox(width: 10),
                                    Item(
                                        Image.asset(
                                          'assets/img/ic_home.png',
                                          height: 26,
                                          color: Colors.white,
                                          fit: BoxFit.contain,
                                        ),
                                        "Home Location", tapFucntion: () async {
                                      LocationResult result =
                                          await showLocationPicker(
                                        context,
                                        setting?.value?.googleMapsKey,
                                        initialCenter: LatLng(
                                            currentUser?.value?.latitude ?? 0,
                                            currentUser?.value?.longitude ?? 0),
                                        automaticallyAnimateToCurrentLocation:
                                            true,
                                        myLocationButtonEnabled: true,
                                        layersButtonEnabled: true,
                                        resultCardAlignment:
                                            Alignment.bottomCenter,
                                      );

                                      if (result != null) {
                                        _userController?.addressData?.latitude =
                                            result?.latLng?.latitude;
                                        _userController
                                                ?.addressData?.longitude =
                                            result?.latLng?.longitude;
                                        _userController?.addressData
                                            ?.addressSelect = result?.address;
                                        _userController
                                            ?.addressData?.isDefault = 'false';
                                        currentUser?.value?.latitude =
                                            result?.latLng?.latitude;
                                        currentUser?.value?.longitude =
                                            result?.latLng?.longitude;
                                      }

                                      AddressBottomsheet(
                                          _userController?.addressData);
                                    }),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Item(
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        "WishList", tapFucntion: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WishList()));
                                    }),
                                    SizedBox(width: 10),
                                    Item(
                                        Image(
                                          image: AssetImage(
                                              'assets/img/housewithheart.png'),
                                          width: 24,
                                          height: 24,
                                          color: Colors.white,
                                        ),
                                        "FavShop", tapFucntion: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FavShops()));
                                    }),
                                    SizedBox(width: 10),
                                    Item(
                                        Icon(
                                          Icons.shopping_cart,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        "Cart", tapFucntion: () {
                                      if (currentUser.value.apiToken != null) {
                                        if (cartRepo.currentCart.value.length !=
                                            0) {
                                          Navigator.of(context)
                                              .pushNamed('/Checkout');
                                        } else {
                                          Navigator.of(context)
                                              .pushNamed('/EmptyList');
                                        }
                                      } else {
                                        Navigator.of(context)
                                            .pushNamed('/Login');
                                      }
                                    }),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Item(
                                        Icon(
                                          Icons.chat,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        "Chat"),
                                    SizedBox(width: 10),
                                    Item(
                                      Icon(
                                        Icons.shopping_bag_outlined,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      "My Orders",
                                      tapFucntion: () {
                                        Navigator.of(context)
                                            .pushNamed('/Orders');
                                        // Navigator.of(context).pushNamed('/Pages', arguments: 4);
                                      },
                                    ),
                                    SizedBox(width: 10),
                                    Item(
                                      Icon(
                                        Icons.exit_to_app,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      "Logout",
                                      tapFucntion: () {
                                        logout().then((value) {
                                          showToast(
                                              "${S.of(context).logout} ${S.of(context).successfully}",
                                              gravity: Toast.BOTTOM,
                                              duration: Toast.LENGTH_SHORT);
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  '/Login',
                                                  (Route<dynamic> route) =>
                                                      false,
                                                  arguments: 2);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              // InkWell(
                              //   onTap: () {
                              //     Navigator.of(context)
                              //         .pushNamed('/Pages', arguments: 2);
                              //   },
                              //   child: Container(
                              //     padding: EdgeInsets.symmetric(horizontal: 25),
                              //     height: 60,
                              //     child: Row(
                              //       mainAxisAlignment:
                              //           MainAxisAlignment.spaceBetween,
                              //       children: <Widget>[
                              //         Text(
                              //           S.of(context).home,
                              //           style: Theme.of(context)
                              //               .textTheme
                              //               .headline1
                              //               .merge(TextStyle(
                              //                   fontWeight: FontWeight.w500)),
                              //         ),
                              //         Icon(
                              //           Icons.home_outlined,
                              //           color: Theme.of(context).accentColor,
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // InkWell(
                              //   onTap: () {
                              //     Navigator.of(context).pushNamed('/Settings');
                              //   },
                              //   child: Container(
                              //     padding: EdgeInsets.symmetric(horizontal: 25),
                              //     height: 60,
                              //     width: MediaQuery.of(context).size.width,
                              //     child: Row(
                              //       mainAxisAlignment:
                              //           MainAxisAlignment.spaceBetween,
                              //       children: <Widget>[
                              //         Text(
                              //           S.of(context).settings,
                              //           style: Theme.of(context)
                              //               .textTheme
                              //               .headline1
                              //               .merge(TextStyle(
                              //                   fontWeight: FontWeight.w500)),
                              //         ),
                              //         Icon(Icons.settings_applications_rounded,
                              //             color: Theme.of(context).accentColor)
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // InkWell(
                              //   onTap: () {
                              //     Navigator.of(context).pushNamed('/Orders');
                              //     // Navigator.of(context).pushNamed('/Pages', arguments: 4);
                              //   },
                              //   child: Container(
                              //     padding: EdgeInsets.symmetric(horizontal: 25),
                              //     height: 60,
                              //     width: MediaQuery.of(context).size.width,
                              //     child: Row(
                              //       mainAxisAlignment:
                              //           MainAxisAlignment.spaceBetween,
                              //       children: <Widget>[
                              //         Text(
                              //           S.of(context).my_orders,
                              //           style: Theme.of(context)
                              //               .textTheme
                              //               .headline1
                              //               .merge(TextStyle(
                              //                   fontWeight: FontWeight.w500)),
                              //         ),
                              //         Icon(
                              //           Icons.shopping_bag_outlined,
                              //           color: Theme.of(context).accentColor,
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // InkWell(
                              //   onTap: () {
                              //     if (Theme.of(context).brightness ==
                              //         Brightness.dark) {
                              //       // setBrightness(Brightness.light);
                              //       setting.value.brightness.value =
                              //           Brightness.light;
                              //     } else {
                              //       setting.value.brightness.value =
                              //           Brightness.dark;
                              //       //  setBrightness(Brightness.dark);
                              //     }
                              //     // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                              //     setting.notifyListeners();
                              //   },
                              //   child: Container(
                              //     padding: EdgeInsets.symmetric(horizontal: 25),
                              //     height: 60,
                              //     width: MediaQuery.of(context).size.width,
                              //     child: Row(
                              //       mainAxisAlignment:
                              //           MainAxisAlignment.spaceBetween,
                              //       children: <Widget>[
                              //         Text(
                              //           Theme.of(context).brightness ==
                              //                   Brightness.dark
                              //               ? S.of(context).light_mode
                              //               : S.of(context).dark_mode,
                              //           style: Theme.of(context)
                              //               .textTheme
                              //               .headline1
                              //               .merge(TextStyle(
                              //                   fontWeight: FontWeight.w500)),
                              //         ),
                              //         Icon(
                              //           Icons.brightness_6,
                              //           color: Theme.of(context).accentColor,
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // InkWell(
                              //   onTap: () {
                              //     logout().then((value) {
                              //       showToast(
                              //           "${S.of(context).logout} ${S.of(context).successfully}",
                              //           gravity: Toast.BOTTOM,
                              //           duration: Toast.LENGTH_SHORT);
                              //       Navigator.of(context)
                              //           .pushNamedAndRemoveUntil('/Login',
                              //               (Route<dynamic> route) => false,
                              //               arguments: 2);
                              //     });
                              //   },
                              //   child: Container(
                              //     padding: EdgeInsets.symmetric(horizontal: 25),
                              //     height: 60,
                              //     width: MediaQuery.of(context).size.width,
                              //     child: Row(
                              //       mainAxisAlignment:
                              //           MainAxisAlignment.spaceBetween,
                              //       children: <Widget>[
                              //         Text(
                              //           S.of(context).logout,
                              //           style: Theme.of(context)
                              //               .textTheme
                              //               .headline1
                              //               .merge(TextStyle(
                              //                   fontWeight: FontWeight.w500)),
                              //         ),
                              //         Icon(Icons.exit_to_app,
                              //             color: Theme.of(context).accentColor)
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void AddressBottomsheet(address) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.51,
            color: Color(0xff737373),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0)),
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
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AddressModalPart(
                                  con: _userController, address: address),
                            ]),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 5, bottom: 5),
                      child: Container(
                        width: double.infinity,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(30),
                          /*borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40))*/
                        ),
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          onPressed: () {
                            _userController.saveAddress();
                          },
                          child: Center(
                              child: Text(
                            'SAVE AND PROCEED',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
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
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0)),
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
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              LocationModalPart(),
                            ]),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 5, bottom: 5),
                      child: Container(
                        width: double.infinity,
                        // ignore: deprecated_member_use
                        child: FlatButton(
                            onPressed: () {
                              setState(() => currentUser.value);
                              Navigator.pop(context);
                              _con.listenForVendor();
                            },
                            padding: EdgeInsets.all(15),
                            color: Theme.of(context).accentColor.withOpacity(1),
                            child: Text(
                              S.of(context).proceed_and_close,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .merge(TextStyle(color: Colors.white)),
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

  Widget Item(Widget iconData, String title, {GestureTapCallback tapFucntion}) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: tapFucntion,
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 8),
                height: 50,
                width: 50,
                alignment: Alignment.center,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  // color: Theme.of(context).secondaryHeaderColor,
                  color: Color(0xFF49aecb),
                  shape: BoxShape.circle,
                ),
                child: iconData),
            Text(
              title,
              style: Theme.of(context).textTheme.headline1.merge(
                    TextStyle(fontWeight: FontWeight.w500, height: 1),
                  ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Imagepickerbottomsheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                new ListTile(
                  leading: new Icon(Icons.camera),
                  title: new Text('Camera'),
                  onTap: () => getImage(),
                ),
                new ListTile(
                  leading: new Icon(Icons.image),
                  title: new Text('Gallery'),
                  onTap: () => getImagegaller(),
                ),
              ],
            ),
          );
        });
  }

  File _image;
  int currStep = 0;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, maxHeight: 480, maxWidth: 640);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        register(_image);
        Navigator.of(context).pop();
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImagegaller() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        register(_image);

        Navigator.of(context).pop();
      } else {
        print('No image selected.');
      }
    });
  }

  void register(File image) async {
    UserDetails _user = userRepo.currentUser.value;

    final String _apiToken = 'api_token=${_user.apiToken}';
    // ignore: deprecated_member_use
    final uri = Uri.parse(
        "${GlobalConfiguration().getString('base_url')}Api/profileimage/${currentUser.value.id}?$_apiToken");
    var request = http.MultipartRequest('POST', uri);
    var pic = await http.MultipartFile.fromPath('image', image.path);
    request.files.add(pic);
    var response = await request.send();
    if (response.statusCode == 200) {
      // Navigator.of(context).pushReplacementNamed('/Success');

      setState(() {
        currentUser.value.image = 'no_image';
        // ignore: deprecated_member_use
        currentUser.value.image =
            '${GlobalConfiguration().getString('api_base_url')}uploads/user_image/user_${currentUser.value.id}.jpg';
      });
      setCurrentUserUpdate(currentUser.value);
    } else {}
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(
      msg,
      context,
      duration: duration,
      gravity: gravity,
    );
  }
}
