import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:relaymiles/api/api_service.dart';
import 'package:relaymiles/model/job_data.dart';
import 'package:relaymiles/ui/signup.dart';
import 'package:relaymiles/utils/colors.dart';
import 'package:relaymiles/utils/constants.dart';
import 'package:relaymiles/utils/dialogs.dart';
import 'package:relaymiles/utils/global_func.dart';
import 'package:relaymiles/utils/global_ui.dart';
import 'package:relaymiles/utils/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';



class MyJobDetailPage extends StatefulWidget {

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  Function backFunc;
  Function addFunc;
  JobData data;
  bool fromSearch;
  int mDialogNo = 0;
  MyJobDetailPage(this.data, this.backFunc, this.addFunc, this.fromSearch);


  @override
  _MyJobDetailPageState createState() {
    if (data.status != "1"){
      fromSearch = false;
    }
    return _MyJobDetailPageState();
  }
}

class _MyJobDetailPageState extends State<MyJobDetailPage> {
  SharedPreferences prefs;
  @override
  void initState()  {
    super.initState();
    init();
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    calcDistance();
  }

  void onBackPressed(){
    widget.backFunc();
  }

  void changeStatus(String status, int dialogNo, {onComplete}){
    showLoading(context);
    Map<String, dynamic> map = Map();
    map["userId"] = prefs.getString(Constants.PREF_ID);
    map["loadId"] = widget.data.id;
    map["status"] = status;
    map["email"] = prefs.getString(Constants.PREF_EMAIL);
    ApiService.create().changeJobStatus(Constants.SECRET_CODE, map).then((value){
      hideDialog(context);
      if (value.code == 1){
        widget.data.status = status;
        if (onComplete != null) {
          onComplete();
        }else{
          setState(() {
            if (dialogNo != null) {
              widget.mDialogNo = dialogNo;
            }
          });
        }


      }else{
        showToast(value.message);
      }
    }).catchError((onError){
      hideDialog(context);
      showToast(STRINGS.msg_server_failed);
    });

  }

  void onPressLoading(){
    setState(() {
      changeStatus("3", null);
    });
  }

  void onPressLoaded(){
    setState(() {
      changeStatus("4", null);
    });
  }

  void onPressDelivering(){
    setState(() {
      changeStatus("5", null);
    });
  }

  void onPressDropOff(){
    setState(() {
      widget.mDialogNo = 1;
    });
  }

  void onPressStartNatigation(){
    if (widget.fromSearch){
      changeStatus("2", null, onComplete: (){
        widget.backFunc();
      });

    }else {
      changeStatus("2", null);
    }
  }

  void onPressUpload(){
    setState(() {
      widget.mDialogNo = 3;
    });
  }

  void onPressCancelJob(){
    setState(() {
      widget.mDialogNo = -1;
    });
  }

  void onConfirmCancelJob(){
    changeStatus("0", null, onComplete: (){
      widget.backFunc();
    });
  }

  void onPressCallFacility(){

  }

  void onPressLater(){
    widget.backFunc();
  }

  void onPressBackDialog(){
    setState(() {
      widget.mDialogNo = 0;
    });
  }

  void onConfirmDropOff(){

    changeStatus("6", 2);

  }

  void onConfirmUploadPodNow(){
    setState(() {
      widget.mDialogNo = 3;
    });
  }

  void uploadFile(File image){
    showLoading(context);
    var userId = prefs.getString(Constants.PREF_ID);
    var loadId = widget.data.id;
    ApiService.create().uploadInvoice(userId, loadId, image).then((value){
      hideDialog(context);
      if (value.code == 1){
        setState(() {
          widget.mDialogNo = 0;
          widget.data.invoiceID = "";
        });
        showToast(value.message);
      }else{
        showToast(value.message);
      }
    }).catchError((onError){
      hideDialog(context);
      showToast(STRINGS.msg_server_failed);
    });
  }

  Future<void> onPressTakePhoto() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 90
    );
    if (image != null){
      uploadFile(image);
    }

  }

  Future<void> onPressUploadFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if(result != null) {
      File file = File(result.files.single.path);
      uploadFile(file);
    }
  }



  void calcDistance(){

    /*Geocoder.google(Constants.GEO_DIRECTION_API_KEY).findAddressesFromQuery(widget.data.pickupAddress).then((geocoding1){
      if (geocoding1 != null && geocoding1.length > 0 ){
        LatLng dest1 = LatLng(geocoding1[0].coordinates.latitude, geocoding1[0].coordinates.longitude);
        Geocoder.google(Constants.GEO_DIRECTION_API_KEY).findAddressesFromQuery(widget.data.deliveryAddress).then((geocoding2) async {
          if (geocoding2 != null && geocoding2.length > 0 ){
            LatLng dest2 = LatLng(geocoding2[0].coordinates.latitude, geocoding2[0].coordinates.longitude);
            PointLatLng point1 = PointLatLng(dest1.latitude, dest1.longitude);
            PointLatLng point2 = PointLatLng(dest2.latitude, dest2.longitude);
            PolylineResult result = await PolylinePoints()?.getRouteBetweenCoordinates(Constants.GEO_DIRECTION_API_KEY, point1, point2);
            if(result != null && result.points.isNotEmpty){
              // loop through all PointLatLng points and convert them
              // to a list of LatLng, required by the Polyline
              double totalDistance = 0;
              PointLatLng prev;
              result.points.forEach((PointLatLng point){
                if (prev != null) {
                  totalDistance += calculateDistance(
                      prev.latitude, prev.longitude, point.latitude,
                      point.longitude);
                }
                prev = point;
              });
              totalDistance = totalDistance * 1.60934;
              widget.data.distance = totalDistance.toStringAsFixed(2);
              setState(() {

              });

            }
          }
        }).catchError((onError){
          print(onError);
        });

      }
    }).catchError((onError){
      print(onError);
    });*/


  }





  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Scaffold(
      backgroundColor: COLORS.white,
      resizeToAvoidBottomInset: true,
      body:

          Stack(
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[

                    SizedBox(height: ScreenUtil().setHeight(90),),
                    widget.fromSearch ?
                    Padding(
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(80), right: ScreenUtil().setWidth(80)),
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(STRINGS.msg_your_load_booked, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(40), color: COLORS.black, fontWeight: FontWeight.bold),),
                          Text(STRINGS.msg_you_can_see_detail, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(32), color: COLORS.black, fontWeight: FontWeight.normal),),
                          SizedBox(height: ScreenUtil().setWidth(20),),
                          Text(STRINGS.load_summary, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(40), color: COLORS.black, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ) :
                    InkWell(
                      onTap: onBackPressed,
                      child:

                      Padding(padding: EdgeInsets.only(left: ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(20)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image(
                              image: new AssetImage('assets/images/ic_red_back.png'),
                              width: ScreenUtil().setWidth(50),
                              height: ScreenUtil().setWidth(50),
                              fit: BoxFit.fill,
                            ),
                            SizedBox(width: ScreenUtil().setWidth(20),),
                            Text(

                              STRINGS.job_details,
                              style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(40), color: COLORS.black, fontWeight: FontWeight.bold),),
                          ],
                        ),),
                    ),
                    widget.fromSearch ? SizedBox() :
                    Padding(
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(90), right: ScreenUtil().setWidth(80), top: ScreenUtil().setWidth(0), bottom: ScreenUtil().setWidth(0)),
                      child:
                      Text(STRINGS.status + ": " +
                          (widget.data.status == "1" ? STRINGS.booked :
                          widget.data.status == "2" ? STRINGS.scheduled :
                          widget.data.status == "3" ? STRINGS.loading :
                          widget.data.status == "4" ? STRINGS.en_route :
                          widget.data.status == "5" ? STRINGS.delivering :
                          widget.data.status == "6" ?
                          (widget.data.invoiceID == null ? STRINGS.completed_wait_pod : STRINGS.completed): STRINGS.booked )
                        , style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(32), color: COLORS.black, fontWeight: FontWeight.normal),),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20),),
                    Divider(color: COLORS.grey, height: 0),
                    Padding(
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(80), right: ScreenUtil().setWidth(80), top: ScreenUtil().setWidth(30), bottom: ScreenUtil().setWidth(30)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child:
                          Text(STRINGS.total_pay, textAlign: TextAlign.start, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.normal, color: COLORS.black ),),
                          ),
                          Expanded(child:
                          Text("\$" + widget.data.price, textAlign: TextAlign.start, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(46), fontWeight: FontWeight.normal, color: COLORS.red ),),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: COLORS.grey, height: 0),
                    Padding(
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(80), top: ScreenUtil().setWidth(20), bottom: ScreenUtil().setWidth(0)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            children: [
                              SizedBox(height: ScreenUtil().setWidth(5),),
                              Container(
                                width: ScreenUtil().setWidth(20),
                                height: ScreenUtil().setWidth(20),
                                decoration: BoxDecoration(
                                  color: COLORS.yellow,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: COLORS.weak_black, width: ScreenUtil().setWidth(4)),
                                ),
                              ),
                              Container(
                                width: ScreenUtil().setWidth(4),
                                height: ScreenUtil().setWidth(100),
                                color: COLORS.weak_black,
                              ),
                            ],
                          ),
                          SizedBox(width: ScreenUtil().setWidth(20),),
                          Expanded(child:
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(STRINGS.pickup, textAlign: TextAlign.start, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.normal, color: COLORS.weak_black ),),
                                Text(getShowDate(widget.data.pickupTime), textAlign: TextAlign.start, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.normal, color: COLORS.black ),),
                              ],
                            ),
                          ),
                          Expanded(child:
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.data.pickupAddress, textAlign: TextAlign.start, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.normal, color: COLORS.black ),),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(80), top: ScreenUtil().setWidth(0), bottom: ScreenUtil().setWidth(0)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: ScreenUtil().setWidth(4),
                                height: ScreenUtil().setWidth(5),
                                color: COLORS.weak_black,
                              ),
                              Container(
                                width: ScreenUtil().setWidth(20),
                                height: ScreenUtil().setWidth(20),
                                decoration: BoxDecoration(
                                  color: COLORS.drop_color,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: COLORS.weak_black, width: ScreenUtil().setWidth(4)),
                                ),
                              ),
                              Container(
                                width: ScreenUtil().setWidth(4),
                                height: ScreenUtil().setWidth(90),
                                color: Colors.transparent,
                              ),
                            ],
                          ),


                          SizedBox(width: ScreenUtil().setWidth(20),),
                          Expanded(child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(STRINGS.drop_off, textAlign: TextAlign.start, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.normal, color: COLORS.weak_black ),),
                              Text(getShowDate(widget.data.dropOffTime), textAlign: TextAlign.start, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.normal, color: COLORS.black ),),
                            ],
                          ),
                          ),
                          Expanded(child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.data.deliveryAddress +"\n", textAlign: TextAlign.start, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.normal, color: COLORS.black ),),
                            ],
                          ),
                          )
                        ],
                      ),
                    ),
                    Divider(color: COLORS.grey, height: 0),
                    IntrinsicHeight(child:Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child:
                            Padding(
                                padding: EdgeInsets.only(top: ScreenUtil().setWidth(20), bottom: ScreenUtil().setWidth(20)),
                                child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(STRINGS.weight_lbs, textAlign: TextAlign.center, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.normal, color: COLORS.black ),),
                                    Text(widget.data.weight != null ? widget.data.weight : "", textAlign: TextAlign.center, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(34), fontWeight: FontWeight.normal, color: COLORS.black ),),
                                  ],
                                )
                            ),

                          ),
                          VerticalDivider(color: COLORS.grey, width: 0),
                          Expanded(child:
                            Padding(
                                padding: EdgeInsets.only(top: ScreenUtil().setWidth(20), bottom: ScreenUtil().setWidth(20)),
                                child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(STRINGS.distance, textAlign: TextAlign.center, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.normal, color: COLORS.black ),),
                                    Text(getDistance(widget.data.distance), textAlign: TextAlign.center, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(34), fontWeight: FontWeight.normal, color: COLORS.black ),),
                                  ],
                                )
                            ),

                          ),
                          VerticalDivider(color: COLORS.grey, width: 0,),
                          Expanded(child:
                            Padding(
                                padding: EdgeInsets.only(top: ScreenUtil().setWidth(20), bottom: ScreenUtil().setWidth(20)),
                                child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(STRINGS.trailer, textAlign: TextAlign.center, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.normal, color: COLORS.black ),),
                                    Text(widget.data.trailer != null ? widget.data.trailer : "", textAlign: TextAlign.center, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(34), fontWeight: FontWeight.normal, color: COLORS.black ),),
                                  ],
                                )
                            ),

                          ),
                        ]
                      )
                    ),
                    Divider(color: COLORS.grey, height: 0),
                    widget.fromSearch  ?
                    SizedBox() :
                    Padding(
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40), top: ScreenUtil().setWidth(20), bottom: ScreenUtil().setWidth(20)),
                        child: Row(
                          children: [
                            Text(STRINGS.posted_by + ":",  style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.normal, color: COLORS.text_grey ),),
                            SizedBox(width: ScreenUtil().setWidth(10),),
                            Text(widget.data.poster, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.normal, color: COLORS.black ),),
                          ],
                        )
                    ),
                    widget.fromSearch || widget.data.reviews == null ?
                    SizedBox() :
                    Padding(
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(35), right: ScreenUtil().setWidth(40), top: ScreenUtil().setWidth(0), bottom: ScreenUtil().setWidth(20)),
                        child: Row(
                          children: [
                            Row(children: [
                              Icon(Icons.star, color: COLORS.yellow, size: ScreenUtil().setWidth(35), ),
                              SizedBox(width: ScreenUtil().setWidth(10),),
                              Text(widget.data.reviews.toString(),  style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.normal, color: COLORS.text_grey ),),
                            ],),
                          ],
                        )
                    ),
                    widget.fromSearch  ?
                    SizedBox() :
                    Divider(color: COLORS.grey, height: 0),
                    Expanded(flex:1,
                        child:
                        Padding(
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(80), right: ScreenUtil().setWidth(80), bottom: ScreenUtil().setWidth(10)),
                          child:
                          Align(
                            alignment: Alignment.bottomLeft,
                            child:
                            Text(
                              widget.data.status == "1" ? STRINGS.msg_start_navigation_to_pick_up :
                              widget.data.status == "2" ? STRINGS.msg_loading :
                              widget.data.status == "3" ? STRINGS.msg_loaded :
                              widget.data.status == "4" ? STRINGS.msg_delivering  :
                              widget.data.status == "5" ? STRINGS.msg_delivered  :
                              widget.data.status == "6" ?
                              (widget.data.invoiceID == null ? STRINGS.msg_you_not_upload_pod : STRINGS.msg_you_upload_pod_more) : "",
                              style: TextStyle(fontFamily: GlobalUI.FONT_NAME,  fontSize: ScreenUtil().setSp(34), fontWeight: FontWeight.normal, color: COLORS.black ),),),
                        )

                    ),

                    widget.data.status == "1" ?  //booked
                    Container(
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40), top: ScreenUtil().setWidth(10), bottom: ScreenUtil().setWidth(40)),
                        child:Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            GlobalUI.getButton(onPressStartNatigation, STRINGS.up_start_navigation, COLORS.black, ),
                            SizedBox(height: ScreenUtil().setWidth(20),),
                            widget.fromSearch ?
                            GlobalUI.getButton(onPressLater, STRINGS.up_later, COLORS.white, borderColor: COLORS.black , textColor: COLORS.black ) :
                            GlobalUI.getButton(onPressCancelJob, STRINGS.up_cancel_this_job, COLORS.white, borderColor: COLORS.black , textColor: COLORS.black ),
                          ],
                        )
                    ) :
                    widget.data.status == "2" ? //started navigate
                    Container(
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40), top: ScreenUtil().setWidth(10), bottom: ScreenUtil().setWidth(40)),
                        child:Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            GlobalUI.getButton(onPressLoading, STRINGS.up_confirm_loading, COLORS.black, ),
                            SizedBox(height: ScreenUtil().setWidth(20),),
                            GlobalUI.getButton(onPressCancelJob, STRINGS.up_cancel_this_job, COLORS.white, borderColor: COLORS.black , textColor: COLORS.black),
                          ],
                        )
                    ) :
                    widget.data.status == "3" ? //loading
                    Container(
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40), top: ScreenUtil().setWidth(10), bottom: ScreenUtil().setWidth(40)),
                        child:Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            GlobalUI.getButton(onPressLoaded, STRINGS.up_confirm_loaded, COLORS.black, ),
                            SizedBox(height: ScreenUtil().setWidth(20),),
                            GlobalUI.getButton(onPressCancelJob, STRINGS.up_cancel_this_job, COLORS.white, borderColor: COLORS.black , textColor: COLORS.black),
                          ],
                        )
                    ) :
                    widget.data.status == "4" ? //loaded
                    Container(
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40), top: ScreenUtil().setWidth(10), bottom: ScreenUtil().setWidth(40)),
                        child:Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            GlobalUI.getButton(onPressDelivering, STRINGS.up_confirm_delivering, COLORS.black, ),
                            SizedBox(height: ScreenUtil().setWidth(20),),
                            GlobalUI.getButton(onPressCancelJob, STRINGS.up_cancel_this_job, COLORS.white, borderColor: COLORS.black , textColor: COLORS.black),
                          ],
                        )
                    ) :
                    widget.data.status == "5" ? //delivering
                    Container(
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40), top: ScreenUtil().setWidth(10), bottom: ScreenUtil().setWidth(40)),
                        child:Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            GlobalUI.getButton(onPressDropOff, STRINGS.up_confirm_delivered, COLORS.black, ),
                            SizedBox(height: ScreenUtil().setWidth(20),),
                            GlobalUI.getButton(onPressCancelJob, STRINGS.up_cancel_this_job, COLORS.white, borderColor: COLORS.black , textColor: COLORS.black),
                          ],
                        )
                    ) :
                    widget.data.status == "6" ? //delivered, completed
                    Container(
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40), top: ScreenUtil().setWidth(10), bottom: ScreenUtil().setWidth(40)),
                        child:Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            GlobalUI.getButton(onPressUpload, STRINGS.up_upload_pod, COLORS.black, ),
                          ],
                        )
                    ) : SizedBox(),
                  ]
              ),
              widget.mDialogNo == -1 ? Container( //confirm cancel
                    height: double.infinity,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: COLORS.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFFDDDDDD),
                                    offset: Offset(0.0, -1.0),
                                    blurRadius: ScreenUtil().setWidth(6)
                                ),

                              ]),
                          padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(STRINGS.msg_cancel_job, style: TextStyle(fontFamily: GlobalUI.FONT_NAME,  fontSize: ScreenUtil().setSp(36), fontWeight: FontWeight.bold, color: COLORS.black ),),
                              SizedBox(height: ScreenUtil().setWidth(20),),
                              GlobalUI.getButton(onConfirmCancelJob, STRINGS.up_yes_cancel_job, COLORS.red, ),
                              SizedBox(height: ScreenUtil().setWidth(20),),
                              GlobalUI.getButton(onPressCallFacility, STRINGS.up_call_facility, COLORS.green, ),
                              SizedBox(height: ScreenUtil().setWidth(20),),
                              GlobalUI.getButton(onPressBackDialog, STRINGS.up_no_go_back, COLORS.white, borderColor: COLORS.black , textColor: COLORS.black),
                            ],
                          ),
                        ),
                      ),
                  ) :
              widget.mDialogNo == 1 ? Container( //confirm drop off
                height: double.infinity,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: COLORS.white,
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xFFDDDDDD),
                              offset: Offset(0.0, -1.0),
                              blurRadius: ScreenUtil().setWidth(6)
                          ),

                        ]),
                    padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(STRINGS.msg_confirm_drop_off, style: TextStyle(fontFamily: GlobalUI.FONT_NAME,  fontSize: ScreenUtil().setSp(36), fontWeight: FontWeight.bold, color: COLORS.black ),),
                        SizedBox(height: ScreenUtil().setWidth(20),),
                        GlobalUI.getButton(onConfirmDropOff, STRINGS.up_yes_confirm_drop_off, COLORS.black, ),
                        SizedBox(height: ScreenUtil().setWidth(20),),
                        GlobalUI.getButton(onPressBackDialog, STRINGS.up_go_back, COLORS.white, borderColor: COLORS.black , textColor: COLORS.black),
                      ],
                    ),
                  ),
                ),
              ) :
              widget.mDialogNo == 2 ? Container( //confirm upload
                height: double.infinity,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: COLORS.white,
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xFFDDDDDD),
                              offset: Offset(0.0, -1.0),
                              blurRadius: ScreenUtil().setWidth(6)
                          ),

                        ]),
                    padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(STRINGS.msg_congratulations_load_complete, style: TextStyle(fontFamily: GlobalUI.FONT_NAME,  fontSize: ScreenUtil().setSp(36), fontWeight: FontWeight.bold, color: COLORS.black ),),
                        SizedBox(height: ScreenUtil().setWidth(20),),
                        GlobalUI.getButton(onConfirmUploadPodNow, STRINGS.up_upload_pod_now, COLORS.black, ),
                        SizedBox(height: ScreenUtil().setWidth(20),),
                        GlobalUI.getButton(onPressBackDialog, STRINGS.up_upload_later, COLORS.white, borderColor: COLORS.black , textColor: COLORS.black),
                      ],
                    ),
                  ),
                ),
              ) :
              widget.mDialogNo == 3 ? Container( //confirm upload
                height: double.infinity,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: COLORS.white,
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xFFDDDDDD),
                              offset: Offset(0.0, -1.0),
                              blurRadius: ScreenUtil().setWidth(6)
                          ),

                        ]),
                    padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(STRINGS.msg_take_photo_upload, style: TextStyle(fontFamily: GlobalUI.FONT_NAME,  fontSize: ScreenUtil().setSp(36), fontWeight: FontWeight.bold, color: COLORS.black ),),
                        SizedBox(height: ScreenUtil().setWidth(20),),
                        GlobalUI.getButton(onPressTakePhoto, STRINGS.up_take_photo, COLORS.black, ),
                        SizedBox(height: ScreenUtil().setWidth(20),),
                        GlobalUI.getButton(onPressUploadFile, STRINGS.up_upload_file, COLORS.green, ),
                        SizedBox(height: ScreenUtil().setWidth(20),),
                        GlobalUI.getButton(onPressBackDialog, STRINGS.up_cancel, COLORS.white, borderColor: COLORS.black , textColor: COLORS.black),
                      ],
                    ),
                  ),
                ),
              ) : SizedBox()
            ],
          )



    );
  }
}
