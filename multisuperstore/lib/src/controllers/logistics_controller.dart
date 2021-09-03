import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../models/Dropdown.dart';
import '../models/send_package.dart';

import '../repository/settings_repository.dart';


class LogisticsController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  // ignore: non_constant_identifier_names
  List<DropDownModel> ListData = <DropDownModel>[];
  SendPackage sendPackageData = new SendPackage();
  TextEditingController pickupAddressController = TextEditingController();
  TextEditingController deliveryAddressController = TextEditingController();
  LogisticsController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  @override
  void initState() {


    // settingRepo.initSettings();

    super.initState();
  }

  listenForItem() async {

    final Stream<DropDownModel> stream = await getItems();
    stream.listen((DropDownModel _tips) {
      setState(() => ListData.add(_tips));
    }, onError: (a) {
      print(a);
    }, onDone: () {

    });
  }


}
