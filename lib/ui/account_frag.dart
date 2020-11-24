import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:optimized_cached_image/image_provider/_image_provider_io.dart';
import 'package:relaymiles/api/api_service.dart';
import 'package:relaymiles/model/job_data.dart';
import 'package:relaymiles/model/user_data.dart';
import 'package:relaymiles/ui/edit_account_frag.dart';
import 'package:relaymiles/ui/signup.dart';
import 'package:relaymiles/utils/colors.dart';
import 'package:relaymiles/utils/constants.dart';
import 'package:relaymiles/utils/global_func.dart';
import 'package:relaymiles/utils/global_ui.dart';
import 'package:relaymiles/utils/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AccountPage extends StatefulWidget {

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  Function backFunc;
  Function addFunc;
  AccountPage(this.backFunc, this.addFunc);
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  UserData mUserData;
  SharedPreferences prefs;
  @override
  void initState()  {
    super.initState();
    mUserData = g_userData;
    setState(() {

    });
    init();
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> map = Map();
    map["userId"] = prefs.getString(Constants.PREF_ID);
    ApiService.create().getLoadCompleteCnt(Constants.SECRET_CODE, map).then((value){

      if (value.code == 1){
        g_userData.loadCompleted = value.data;
        setState(() {

        });
      }
    }).catchError((onError){

    });
  }

  void onPressEditProfile(){
    widget.addFunc(EditAccountPage(widget.backFunc, widget.addFunc));
  }
  

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Scaffold(
      backgroundColor: COLORS.white,
      resizeToAvoidBottomInset: true,
      body:
          SingleChildScrollView(child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top:ScreenUtil().setWidth(120), left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40), bottom: ScreenUtil().setWidth(50)),
                    child: Row(
                      children: [
                        Expanded(
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(mUserData.firstName + " " + mUserData.lastName,  style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(40), fontWeight: FontWeight.bold, color: COLORS.black ),),
                              SizedBox(height: ScreenUtil().setWidth(20),),
                              mUserData.reviews != null ?
                              Row(children: [
                                Icon(Icons.star, color: COLORS.yellow, size: ScreenUtil().setWidth(35),),
                                SizedBox(width: ScreenUtil().setWidth(10),),
                                Text(mUserData.reviews.toString() + " / 5",  style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.normal, color: COLORS.text_grey ),),
                              ],) : SizedBox(),
                              SizedBox(height: ScreenUtil().setWidth(20),),
                              Text(STRINGS.dot + " " + mUserData.dotNumber,  style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.normal, color: COLORS.text_grey ),),
                              SizedBox(height: ScreenUtil().setWidth(20),),
                              Text(STRINGS.mc + " " + mUserData.mcNumber,  style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.normal, color: COLORS.text_grey ),),
                              SizedBox(height: ScreenUtil().setWidth(20),),
                              Text(STRINGS.member_since + ": " + getMonthYear(mUserData.createdAt),  style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.normal, color: COLORS.black ),),
                              SizedBox(height: ScreenUtil().setWidth(20),),
                              Text(STRINGS.loads_completed + ": " + (mUserData.loadCompleted != null ? mUserData.loadCompleted.toString() : ""), textAlign: TextAlign.center, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.normal, color: COLORS.black ),),
                          ],)
                              
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(180),
                          child: Column(
                            children: [
                              ClipOval(
                                child:

                                  Image(
                                  image: mUserData.profileImg != null ?
                                    OptimizedCacheImageProvider(
                                      mUserData.profileImg,
                                      cacheHeight: 200,
                                      cacheWidth: 200,

                                    ) :
                                    new AssetImage('assets/images/ic_default_profile.png'),
                                  height: ScreenUtil().setWidth(180),
                                  width: ScreenUtil().setWidth(180),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: ScreenUtil().setWidth(20),),
                              FlatButton(
                                onPressed: onPressEditProfile,
                                textColor: COLORS.black,
                                padding: EdgeInsets.only(top:ScreenUtil().setWidth(0), bottom: ScreenUtil().setWidth(0), left: ScreenUtil().setWidth(5), right: ScreenUtil().setWidth(5)),
                                child: Text(STRINGS.edit_profile,
                                  style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(26), fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                                color: Colors.transparent,
                                shape: ContinuousRectangleBorder(
                                    side: BorderSide(color: COLORS.black, width: 1),
                                    borderRadius: BorderRadius.zero),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(color: COLORS.grey,),
                  Padding(padding: EdgeInsets.only(top:ScreenUtil().setWidth(60), left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40), bottom: ScreenUtil().setWidth(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(STRINGS.customer_support, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(36), fontWeight: FontWeight.normal, color: COLORS.black ),),
                        SizedBox(height: ScreenUtil().setWidth(40),),
                        Text(STRINGS.msg_got_question,  style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.normal, color: COLORS.black ),),
                        SizedBox(height: ScreenUtil().setWidth(20),),
                        Row(
                          children: [
                            Text(STRINGS.phone + ": ",  style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.normal, color: COLORS.black ),),
                            Text(STRINGS.CONTACT_PHONE_NUMBER,  style: TextStyle(decoration: TextDecoration.underline, fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.normal, color: COLORS.black ),),
                          ],
                        ),
                        SizedBox(height: ScreenUtil().setWidth(20),),
                        Row(
                          children: [
                            Text(STRINGS.email + ": ",  style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.normal, color: COLORS.black ),),
                            Text(STRINGS.CONTACT_EMAIL_ADDRESS,  style: TextStyle(decoration: TextDecoration.underline, fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.normal, color: COLORS.black ),),
                          ],
                        ),
                      ],
                    )
                  ),
                ],
              ),
          )


    );
  }
}
