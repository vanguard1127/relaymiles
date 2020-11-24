import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:relaymiles/model/job_data.dart';
import 'package:relaymiles/ui/my_job_details.dart';
import 'package:relaymiles/ui/signup.dart';
import 'package:relaymiles/utils/colors.dart';
import 'package:relaymiles/utils/dialogs.dart';
import 'package:relaymiles/utils/global_func.dart';
import 'package:relaymiles/utils/global_ui.dart';
import 'package:relaymiles/utils/strings.dart';
import 'package:relaymiles/api/api_service.dart';
import 'package:relaymiles/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';



class NewJobDetailPage extends StatefulWidget {

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  Function backFunc;
  Function addFunc;
  Function replaceFunc;

  JobData data;
  NewJobDetailPage(this.data, this.backFunc, this.addFunc, this.replaceFunc);


  @override
  _NewJobDetailPageState createState() => _NewJobDetailPageState();
}

class _NewJobDetailPageState extends State<NewJobDetailPage>  with AutomaticKeepAliveClientMixin<NewJobDetailPage> {
  GoogleMapController _controller;
  bool isShowBookingConfirm = false;
  SharedPreferences prefs;
  Set<Circle> mCircles = Set.from([]);
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Set<Polyline> _polylines = {};
  @override
  void initState()  {
    super.initState();
    init();
  }
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    showMap();
  }

  @override
  bool get wantKeepAlive {
    return false;
  }

  void onBackPressed(){
    widget.backFunc();
  }

  void onPressBook(){
    setState(() {
      isShowBookingConfirm = true;
    });

  }

  void onPressConfirmBook(){
    showLoading(context);
    Map<String, dynamic> map = Map();
    map["userId"] = prefs.getString(Constants.PREF_ID);
    map["loadId"] = widget.data.id;
    map["status"] = "1";
    map["email"] = prefs.getString(Constants.PREF_EMAIL);
    ApiService.create().changeJobStatus(Constants.SECRET_CODE, map).then((value){
      hideDialog(context);
      if (value.code == 1){
        widget.data.status = "1";
        widget.replaceFunc(MyJobDetailPage(widget.data, widget.backFunc, widget.addFunc, true));
      }else{
        showToast(value.message);
      }
    }).catchError((onError){
      hideDialog(context);
      showToast(STRINGS.msg_server_failed);
    });

  }

  void onPressBookCancel(){
    setState(() {
      isShowBookingConfirm = false;
    });
  }

  void showMap(){

    Geocoder.google(Constants.GEO_DIRECTION_API_KEY).findAddressesFromQuery(widget.data.pickupAddress).then((geocoding1){
      if (geocoding1 != null && geocoding1.length > 0 ){
        LatLng dest1 = LatLng(geocoding1[0].coordinates.latitude, geocoding1[0].coordinates.longitude);
        Geocoder.google(Constants.GEO_DIRECTION_API_KEY).findAddressesFromQuery(widget.data.deliveryAddress).then((geocoding2){
          if (geocoding2 != null && geocoding2.length > 0 ){
            LatLngBounds bound;
            LatLng dest2 = LatLng(geocoding2[0].coordinates.latitude, geocoding2[0].coordinates.longitude);
            if (dest2.latitude > dest1.latitude &&
                dest2.longitude > dest1.longitude) {
              bound = LatLngBounds(southwest: dest1, northeast: dest2);
            } else if (dest2.longitude > dest1.longitude) {
              bound = LatLngBounds(
                  southwest: LatLng(dest2.latitude, dest1.longitude),
                  northeast: LatLng(dest1.latitude, dest2.longitude));
            } else if (dest2.latitude > dest1.latitude) {
              bound = LatLngBounds(
                  southwest: LatLng(dest1.latitude, dest2.longitude),
                  northeast: LatLng(dest2.latitude, dest1.longitude));
            } else {
              bound = LatLngBounds(southwest: dest2, northeast: dest1);
            }
            _controller.moveCamera(CameraUpdate.newLatLngBounds(
                bound, 50
            ));


            setPolylines(dest1, dest2);

          }
        }).catchError((onError){
          print(onError);
        });

      }
    }).catchError((onError){
      print(onError);
    });


  }



  void setPolylines(LatLng dest1, LatLng dest2) async {
    PointLatLng point1 = PointLatLng(dest1.latitude, dest1.longitude);
    PointLatLng point2 = PointLatLng(dest2.latitude, dest2.longitude);
    PolylineResult result = await polylinePoints?.getRouteBetweenCoordinates(Constants.GEO_DIRECTION_API_KEY, point1, point2);
    if(result != null && result.points.isNotEmpty){
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      double totalDistance = 0;
      PointLatLng prev;
      result.points.forEach((PointLatLng point){
        polylineCoordinates.add(
            LatLng(point.latitude, point.longitude));
        if (prev != null) {
          totalDistance += calculateDistance(
              prev.latitude, prev.longitude, point.latitude,
              point.longitude);
        }
        prev = point;
      });
      totalDistance = totalDistance * 1.60934;
//      widget.data.distance = totalDistance.toStringAsFixed(2);


    }
    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: COLORS.weak_black,
          points: polylineCoordinates,
          width: 3,
          zIndex: 1
      );

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
      mCircles = Set.from([Circle(
          circleId: CircleId("drop"),
          center: dest2,
          radius: 150,
          fillColor: COLORS.drop_color,
          strokeColor: COLORS.weak_black,
          strokeWidth: 2,
          zIndex: 2
      ),
        Circle(
            circleId: CircleId("pick"),
            center: dest1,
            radius: 150,
            fillColor: COLORS.yellow,
            strokeColor: COLORS.weak_black,
            strokeWidth: 2,
            zIndex: 2
        )]);
    });


  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Scaffold(
      backgroundColor: COLORS.dark_white,
      resizeToAvoidBottomInset: true,
      body:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[

              SizedBox(height: ScreenUtil().setHeight(90),),
              InkWell(
                onTap: onBackPressed,
                child: Padding(padding: EdgeInsets.only(left: ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(20)),
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
                      Text(STRINGS.job_details, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(40), color: COLORS.black, fontWeight: FontWeight.bold),),
                    ],
                  ),),
              ),

              SizedBox(height: ScreenUtil().setHeight(40),),
              Divider(color: COLORS.grey, height: 0),
              Padding(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40), top: ScreenUtil().setWidth(30), bottom: ScreenUtil().setWidth(30)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex:10, child:
                      Text("\$" + widget.data.price, textAlign: TextAlign.center, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(46), fontWeight: FontWeight.normal, color: COLORS.red ),),
                    ),
                    Expanded(flex:7,child:SizedBox()),
                    Expanded(flex:10, child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(STRINGS.pickup, textAlign: TextAlign.center, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.normal, color: COLORS.black ),),
                          Text(getShowDate(widget.data.pickupTime), textAlign: TextAlign.center, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.normal, color: COLORS.black ),),
                      ],)

                    ),
                  ],
                ),
              ),
              Divider(color: COLORS.grey, height: 0),
              Padding(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40), top: ScreenUtil().setWidth(20), bottom: ScreenUtil().setWidth(20)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex:10, child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(widget.data.pickupCity + ", " + widget.data.pickupState, textAlign: TextAlign.center, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(34), fontWeight: FontWeight.normal, color: COLORS.black ),),
                            Text(STRINGS.pickup, textAlign: TextAlign.center, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.normal, color: COLORS.text_grey ),),
                            Text(getShowDate(widget.data.pickupTime) + ", " + getShowTime(widget.data.pickupTime), textAlign: TextAlign.center, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.normal, color: COLORS.black ),),
                          ],
                        )
                    ),

                    Expanded(flex:7,child:Image(
                      image: new AssetImage('assets/images/ic_arrow.png'),
                      fit: BoxFit.contain,
                      width: ScreenUtil().setWidth(60),
                      height: ScreenUtil().setWidth(30),
                    ),
                    ),
                    Expanded(flex:10, child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(widget.data.deliveryCity + ", " + widget.data.deliveryState, textAlign: TextAlign.center, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(34), fontWeight: FontWeight.normal, color: COLORS.black ),),
                          Text(STRINGS.drop_off, textAlign: TextAlign.center, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.normal, color: COLORS.text_grey ),),
                          Text(getShowDate(widget.data.dropOffTime) + ", " + getShowTime(widget.data.dropOffTime), textAlign: TextAlign.center, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.normal, color: COLORS.black ),),
                        ],
                      )
                    ),
                  ],
                ),
              ),
              Divider(color: COLORS.grey, height: 0,),
              IntrinsicHeight(child:
                Row(
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
                ),
              ),
              Expanded(child: GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                circles: mCircles,
                polylines: _polylines,
                initialCameraPosition: CameraPosition(target: LatLng(30.5846494,36.2107303), zoom: 12),
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                  new Factory<OneSequenceGestureRecognizer>(
                        () => new EagerGestureRecognizer(),
                  ),
                ].toSet(),
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;

                },
              ),),
              Padding(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40), top: ScreenUtil().setWidth(40), bottom: ScreenUtil().setWidth(0)),
                child: Row(
                  children: [
                    Text(STRINGS.posted_by + ":",  style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.normal, color: COLORS.text_grey ),),
                    SizedBox(width: ScreenUtil().setWidth(10),),
                    Text(widget.data.poster, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.normal, color: COLORS.black ),),
                  ],
                )
              ),
              widget.data.reviews != null ?
              Padding(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(35), right: ScreenUtil().setWidth(40), top: ScreenUtil().setWidth(10), bottom: ScreenUtil().setWidth(20)),
                  child: Row(
                    children: [
                      Row(children: [
                        Icon(Icons.star, color: COLORS.yellow, size: ScreenUtil().setWidth(35), ),
                        SizedBox(width: ScreenUtil().setWidth(10),),
                        Text(widget.data.reviews.toString(),  style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.normal, color: COLORS.text_grey ),),
                      ],),
                    ],
                  )
              ) : SizedBox(),
              Padding(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40), top: ScreenUtil().setWidth(10), bottom: ScreenUtil().setWidth(10)),
                child:
                  isShowBookingConfirm ?
                    GlobalUI.getButton(onPressConfirmBook, STRINGS.up_confirm_booking, COLORS.black) :
                    GlobalUI.getButton(null, "", COLORS.dark_white, borderColor: COLORS.dark_white, textColor: COLORS.dark_white),
              ),
              Padding(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40), top: ScreenUtil().setWidth(10), bottom: ScreenUtil().setWidth(40)),
                child:
                  isShowBookingConfirm ?
                    GlobalUI.getButton(onPressBookCancel, STRINGS.up_cancel, COLORS.dark_white , borderColor: COLORS.black, textColor: COLORS.black) :
                    GlobalUI.getButton(onPressBook, STRINGS.up_book_this_load, COLORS.black, ),
              ),
            ]
          ),


    );
  }
}
