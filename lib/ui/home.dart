import 'dart:io';


import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import 'package:permission/permission.dart'  as permissions;
import 'package:permission/permission.dart';
import 'package:relaymiles/api/api_service.dart';
import 'package:relaymiles/ui/account_frag.dart';
import 'package:relaymiles/ui/my_loads_frag.dart';
import 'package:relaymiles/ui/search_frag.dart';
import 'package:relaymiles/utils/colors.dart';
import 'package:relaymiles/utils/constants.dart';
import 'package:relaymiles/utils/global_ui.dart';
import 'package:relaymiles/utils/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:relaymiles/utils/global_func.dart' as Globals;



class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>  with AutomaticKeepAliveClientMixin<HomePage> {
  int _currentIndex = 0;
  SharedPreferences prefs;

  var _childrens;

  var _mTabOrder = [];


  Future<Null> init() async {
    prefs = await SharedPreferences.getInstance();
    var location = Location();

    if(!await location.serviceEnabled()){
      location.requestService();
    }

  }

  void backScreen(){
    if (_mTabOrder[_currentIndex] > 0){
      _childrens[_currentIndex].removeAt(_mTabOrder[_currentIndex]);
      _mTabOrder[_currentIndex]--;
      setState(() {

      });
    }
  }

  void forwardScreen(Widget screen){
    _mTabOrder[_currentIndex]++;
    _childrens[_currentIndex].add(screen);
    setState(() {

    });
  }

  void replaceScreen(Widget screen){
    _childrens[_currentIndex].removeAt(_mTabOrder[_currentIndex]);
    _childrens[_currentIndex].add(screen);
   setState(() {

   });
  }

  @override
  void initState() {
    super.initState();

    requestPermissions();
    init();
    initPlatformState();
  }

  void _onBackgroundFetch(String taskId) async {

    Position position = await Geolocator.getCurrentPosition();
    if (position != null){
      print("get location---------------------------");
      Map<String, dynamic> map = Map();
      map["email"] = prefs.getString(Constants.PREF_EMAIL);
      map["userId"] = prefs.getString(Constants.PREF_ID);
      map["lat"] = position.latitude;
      map["long"] = position.longitude;
      ApiService.create().addLocation(Constants.SECRET_CODE, map).then((value) async {
        if (value.code == 1){
          print("added --------------------------");
        }else{
          print("wrong --------------------------");
        }
      }).catchError((onError){
        print("failed --------------------------");
      });
    }
    BackgroundFetch.finish(taskId);

    /*if (taskId == "flutter_background_fetch") {
      // Schedule a one-shot task when fetch event received (for testing).
      BackgroundFetch.scheduleTask(TaskConfig(
          taskId: "com.adrian.relaymiles",
          delay: 10000,
          periodic: false,
          forceAlarmManager: true,
          stopOnTerminate: false,
          enableHeadless: true
      ));
    }*/

    // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
    // for taking too long in the background.
//    BackgroundFetch.finish(taskId);
  }

  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    BackgroundFetch.configure(BackgroundFetchConfig(
      minimumFetchInterval: 15,
      forceAlarmManager: false,
      stopOnTerminate: false,
      startOnBoot: true,
      enableHeadless: true,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresStorageNotLow: false,
      requiresDeviceIdle: false,
      requiredNetworkType: NetworkType.ANY,
    ), _onBackgroundFetch).then((int status) {
      print('[BackgroundFetch] configure success: $status');


    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');

    });


  }

  Future<permissions.PermissionStatus> getSinglePermissionStatus(PermissionName permissionName) async {
    return await permissions.Permission.getSinglePermissionStatus(permissionName);
  }
  requestPermissions() async {
    List<PermissionName> permissionNames = [];
    if (Platform.isAndroid) {
      permissionNames.add(PermissionName.Camera);
      permissionNames.add(PermissionName.Location);
      permissionNames.add(PermissionName.Phone);
      permissionNames.add(PermissionName.Storage);
      permissionNames.add(PermissionName.State);
    }
    if (Platform.isIOS) {
      permissionNames.add(PermissionName.Internet);
      permissionNames.add(PermissionName.Camera);
      permissionNames.add(PermissionName.Location);
      permissionNames.add(PermissionName.Storage);
    }
    var permissions = await Permission.requestPermissions(permissionNames);
    bool _serviceEnabled = await Globals.g_location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await Globals.g_location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }



  void changeTab(int no) {
    if (_currentIndex == no){
      return;
    }
    setState(() {
      _currentIndex = no;
    });
  }


  @override
  bool get wantKeepAlive {
    return false;
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_childrens == null){
      _childrens = List();
      _childrens.add(List());
      _childrens.add(List());
      _childrens.add(List());
      _childrens[0].add(SearchPage(backScreen, forwardScreen,replaceScreen));
      _childrens[1].add(MyLoadPage(backScreen, forwardScreen));
      _childrens[2].add(AccountPage(backScreen, forwardScreen));
      _mTabOrder = [0, 0, 0];
    }

    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);

    return Scaffold(
      backgroundColor: Color(0xFFE1F5FE),
      body:

        _childrens[_currentIndex][_mTabOrder[_currentIndex]], // new


      bottomNavigationBar: BottomAppBar(
        color: COLORS.black,
        shape: CircularNotchedRectangle(),
        notchMargin: 2.0,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(child:
              InkWell(
                onTap: (){
                  changeTab(0);
                },
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setWidth(10)),
                    Image(
                          image: new AssetImage('assets/images/ic_search.png'),
                          fit: BoxFit.contain,
                          color: _currentIndex == 0 ? COLORS.orange : COLORS.white,
                          width: ScreenUtil().setWidth(50),
                          height: ScreenUtil().setWidth(50),
                    ),
                    SizedBox(height: ScreenUtil().setWidth(10)),
                    Text(STRINGS.up_search, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(26), fontWeight: FontWeight.bold, color: _currentIndex == 0 ? COLORS.orange : COLORS.white),),
                    SizedBox(height: ScreenUtil().setWidth(30)),
                ],)
              ),
            ),
            Expanded(child:
              InkWell(
                onTap: (){
                  changeTab(1);
                },
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setWidth(10)),
                    Image(
                          image: new AssetImage('assets/images/ic_load.png'),
                          fit: BoxFit.contain,
                          color: _currentIndex == 1 ? COLORS.orange : COLORS.white,
                          width: ScreenUtil().setWidth(50),
                          height: ScreenUtil().setWidth(50),
                    ),
                    SizedBox(height: ScreenUtil().setWidth(10)),
                    Text(STRINGS.up_my_loads, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(26), fontWeight: FontWeight.bold, color: _currentIndex == 1 ? COLORS.orange : COLORS.white),),
                    SizedBox(height: ScreenUtil().setWidth(30)),
                  ],)
              )
            ),
            Expanded(child:
              InkWell(
                onTap: (){
                  changeTab(2);
                },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: ScreenUtil().setWidth(10)),
                  Image(
                    image: new AssetImage('assets/images/ic_account.png'),
                    fit: BoxFit.contain,
                    color: _currentIndex == 2 ? COLORS.orange : COLORS.white,
                    width: ScreenUtil().setWidth(50),
                    height: ScreenUtil().setWidth(50),
                  ),
                  SizedBox(height: ScreenUtil().setWidth(10)),
                  Text(STRINGS.up_account, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(26), fontWeight: FontWeight.bold, color: _currentIndex == 2 ? COLORS.orange : COLORS.white),),
                  SizedBox(height: ScreenUtil().setWidth(30)),
                ],)
              ),
            ),
          ],
        ),

      ),
    );
  }

}