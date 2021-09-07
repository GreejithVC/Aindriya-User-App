import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:toast/toast.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';
import '../../generated/l10n.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends StateMVC<DrawerWidget> {

  @override
  void initState() {
    print('image show${currentUser.value.image}');
    // TODO: implement initState
    super.initState();
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity ,);
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              currentUser.value.apiToken != null ? Navigator.of(context).pushNamed('/Profile') : Navigator.of(context).pushNamed('/Login');
            },
            child: currentUser.value.apiToken != null
                ? UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withOpacity(0.1),
                    ),
                    accountName: Text(
                      currentUser.value.name,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    accountEmail: Text(
                      currentUser.value.email,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Theme.of(context).accentColor,
                      backgroundImage: currentUser.value.image != 'no_image' && currentUser.value.image != null
                          ? NetworkImage(currentUser.value.image)
                          : AssetImage(
                              'assets/img/userImage.png',
                            ),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withOpacity(0.1),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          size: 32,
                          color: Theme.of(context).accentColor.withOpacity(1),
                        ),
                        SizedBox(width: 30),
                        Text(
                          'Guest',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 2);
            },
            leading: Icon(
              Icons.home,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).home,
              style: Theme.of(context).textTheme.headline1,
            ),
          ),



          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 4);
            },
            leading: Icon(
              Icons.person,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).profile,
              style: Theme.of(context).textTheme.headline1,
            ),
          ),


          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Orders');
            },
            leading: Icon(
              Icons.panorama_wide_angle,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).my_orders,
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Chat', arguments: 4);
            },
            leading: Icon(
              Icons.chat,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              'Chat',
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          ListTile(
            onTap: () {
              if (currentUser.value.apiToken != null) {
                Navigator.of(context).pushNamed('/Settings');
              } else {
                Navigator.of(context).pushNamed('/Login');
              }
            },
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).settings,
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Languages');
            },
            leading: Icon(
              Icons.translate,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).language,
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          ListTile(
            onTap: () {
              if (Theme.of(context).brightness == Brightness.dark) {
                // setBrightness(Brightness.light);
                setting.value.brightness.value = Brightness.light;
              } else {
                setting.value.brightness.value = Brightness.dark;
                //  setBrightness(Brightness.dark);
              }
              // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
              setting.notifyListeners();
            },
            leading: Icon(
              Icons.brightness_6,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              Theme.of(context).brightness == Brightness.dark ? S.of(context).light_mode : S.of(context).dark_mode,
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          ListTile(
            onTap: () {
              if (currentUser.value.apiToken != null) {
                logout().then((value) {

                  showToast("${S.of(context).logout} ${S.of(context).successfully}", gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
                  Navigator.of(context).pushNamedAndRemoveUntil('/Login', (Route<dynamic> route) => false, arguments: 1);
                });
              } else {
                Navigator.of(context).pushNamed('/Login');
              }
            },
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              currentUser.value.apiToken != null ? S.of(context).logout : S.of(context).login,
              style: Theme.of(context).textTheme.headline1,
            ),
          ),

          ListTile(
            dense: true,
            title: Text(
              '${S.of(context).version} 1.1',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            trailing: Icon(
              Icons.remove,
              color: Theme.of(context).focusColor.withOpacity(0.3),
            ),
          )
        ],
      ),
    );
  }
}
