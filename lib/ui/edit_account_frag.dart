
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:optimized_cached_image/image_provider/_image_provider_io.dart';
import 'package:relaymiles/api/api_service.dart';
import 'package:relaymiles/model/job_data.dart';
import 'package:relaymiles/model/user_data.dart';
import 'package:relaymiles/ui/login.dart';
import 'package:relaymiles/ui/signup.dart';
import 'package:relaymiles/utils/colors.dart';
import 'package:relaymiles/utils/constants.dart';
import 'package:relaymiles/utils/dialogs.dart';
import 'package:relaymiles/utils/global_ui.dart';
import 'package:relaymiles/utils/strings.dart';
import 'package:relaymiles/utils/global_func.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EditAccountPage extends StatefulWidget {

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  Function backFunc;
  Function addFunc;
  EditAccountPage(this.backFunc, this.addFunc);
  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  SharedPreferences prefs;
  UserData mUserData;
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
  }

  void onBackPressed(){
    widget.backFunc();
  }

  void onPressEditPassword(){
    showDialog(
        context: context,
        child: new PasswordDialog());
  }

  Future<void> onPressEditPhoto() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 90
    );
    if (image != null){
      uploadFile(image);
    }
  }

  void uploadFile(File image){
    showLoading(context);
    var userId = prefs.getString(Constants.PREF_ID);
    ApiService.create().changeProfilePhoto(userId,  image).then((value){
      hideDialog(context);
      if (value.code == 1){
        setState(() {
          mUserData.profileImg = value.data;
        });
      }else{
        showToast(value.message);
      }
    }).catchError((onError){
      hideDialog(context);
      showToast(STRINGS.msg_server_failed);
    });
  }

  void onLogout(){
    prefs.setString(Constants.PREF_EMAIL, null);
    prefs.setString(Constants.PREF_PASSWORD, null);
    prefs.setString(Constants.PREF_ID, null);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => LoginPage()));
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
                  Padding(padding: EdgeInsets.only(top:ScreenUtil().setWidth(90), left: ScreenUtil().setWidth(0), right: ScreenUtil().setWidth(40), bottom: ScreenUtil().setWidth(40)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child:InkWell(
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

                                        STRINGS.edit_profile,
                                        style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(40), color: COLORS.black, fontWeight: FontWeight.bold),),
                                    ],
                                  ),),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(180),
                          child:
                            InkWell(
                              onTap: onPressEditPhoto,
                              child:Stack(
                                children: [
                                  ClipOval(
                                    child: Image(
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
                                  ClipOval(
                                    child: Container(
                                      height: ScreenUtil().setWidth(180),
                                      width: ScreenUtil().setWidth(180),
                                      decoration: BoxDecoration(
                                          color: COLORS.trans_black
                                      ),
                                      alignment: Alignment.center,
                                      child: Image(
                                        image: new AssetImage('assets/images/ic_pencil.png'),
                                        width: ScreenUtil().setWidth(70),
                                        height: ScreenUtil().setWidth(70),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                         )
                      ],
                    ),
                  ),
                  Divider(color: COLORS.grey, height: 0,),
                  Padding(padding: EdgeInsets.only( left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40)),
                    child: Row(
                      children: [
                        Expanded(flex:1, child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: ScreenUtil().setWidth(30),),
                              Text(STRINGS.first_name, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.normal, color: COLORS.black ),),
                              Text(mUserData.firstName, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(34), fontWeight: FontWeight.normal, color: COLORS.black ),),
                              SizedBox(height: ScreenUtil().setWidth(30),),
                            ],
                          ),
                        ),
                        VerticalDivider(color: COLORS.grey, width: 0, ),
                        SizedBox(width: ScreenUtil().setWidth(80),),
                        Expanded(flex:2, child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: ScreenUtil().setWidth(30),),
                              Text(STRINGS.last_name, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.normal, color: COLORS.black ),),
                              Text(mUserData.lastName, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(34), fontWeight: FontWeight.normal, color: COLORS.black ),),
                              SizedBox(height: ScreenUtil().setWidth(30),),
                            ],
                          ),
                        ),
                      ],
                    )
                  ),
                  Divider(color: COLORS.grey, height: 0,),
                  Padding(padding: EdgeInsets.only( left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40), top: ScreenUtil().setWidth(30), bottom: ScreenUtil().setWidth(30)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(STRINGS.phone_number, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.normal, color: COLORS.black ),),
                        Text(mUserData.phoneNumber, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(34), fontWeight: FontWeight.normal, color: COLORS.black ),),
                      ]
                    )
                  ),
                  Divider(color: COLORS.grey, height: 0,),
                  Padding(padding: EdgeInsets.only( left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40), top: ScreenUtil().setWidth(30), bottom: ScreenUtil().setWidth(30)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(STRINGS.email_address, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.normal, color: COLORS.black ),),
                            Text(mUserData.email, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(34), fontWeight: FontWeight.normal, color: COLORS.black ),),
                          ]
                      )
                  ),
                  Divider(color: COLORS.grey, height: 0,),
                  Padding(padding: EdgeInsets.only( left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40), top: ScreenUtil().setWidth(30), bottom: ScreenUtil().setWidth(30)),
                      child:
                        Row(
                          children: [
                            Expanded(child:
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(STRINGS.password, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.normal, color: COLORS.black ),),
                                    Text("********", style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(34), fontWeight: FontWeight.normal, color: COLORS.black ),),
                                  ]
                              )
                            ),
                            FlatButton(
                              onPressed: (){ onPressEditPassword();},
                              textColor: COLORS.black,
                              padding: EdgeInsets.only(top:ScreenUtil().setWidth(0), bottom: ScreenUtil().setWidth(0), left: ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(20)),
                              child: Text(STRINGS.edit,
                                style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(30), fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                              color: Colors.transparent,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: ContinuousRectangleBorder(
                                  side: BorderSide(color: COLORS.black, width: 1),
                                  borderRadius: BorderRadius.zero),
                            )
                          ],
                        )

                  ),
                  Divider(color: COLORS.grey, height: 0,),
                  Padding(padding: EdgeInsets.only( left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40), top: ScreenUtil().setWidth(30), bottom: ScreenUtil().setWidth(30)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(STRINGS.dot_number, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.normal, color: COLORS.black ),),
                            Text(mUserData.dotNumber, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(34), fontWeight: FontWeight.normal, color: COLORS.black ),),
                          ]
                      )
                  ),
                  Divider(color: COLORS.grey, height: 0,),
                  Padding(padding: EdgeInsets.only( left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40), top: ScreenUtil().setWidth(30), bottom: ScreenUtil().setWidth(30)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(STRINGS.mc_number, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.normal, color: COLORS.black ),),
                            Text(mUserData.mcNumber, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(34), fontWeight: FontWeight.normal, color: COLORS.black ),),
                          ]
                      )
                  ),
                  Divider(color: COLORS.grey, height: 0,),

                  Padding(padding: EdgeInsets.only( left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40), top: ScreenUtil().setWidth(30), bottom: ScreenUtil().setWidth(30)),
                    child:GlobalUI.getButton(onLogout, STRINGS.logout, COLORS.red, ),
                  ),

                ],
              ),
          )


    );
  }
}


class PasswordDialog extends StatefulWidget {

  @override
  _PasswordDialogState createState() => new _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  TextEditingController textOldPassword = TextEditingController();
  TextEditingController textNewPassword = TextEditingController();
  bool isPasswordVisibleOld = false;
  bool isPasswordVisibleNew = false;
  bool isNewPasswordVisible = false;
  SharedPreferences prefs;
  Future<Null> init() async {
    prefs = await SharedPreferences.getInstance();

  }
  @override
  initState(){
    super.initState();
    init();
  }

  void onPressedOk(){
    FocusScope.of(context).requestFocus(FocusNode());
    String oldPass = textOldPassword.text;
    String newPass = textNewPassword.text;
    print(oldPass);
    if (oldPass.isEmpty || newPass.isEmpty){

    }else{

      showLoading(context);
      Map<String, dynamic> map = Map();
      map["email"] = prefs.getString(Constants.PREF_EMAIL);
      map["oldPassword"] = oldPass;
      map["newPassword"] = newPass;
      ApiService.create().changePassword(Constants.SECRET_CODE, map).then((value){
        hideDialog(context);
        if (value.code == 1){
          prefs.setString(Constants.PREF_PASSWORD, newPass);
          showToast(value.message);
          Navigator.pop(context);
        }else{
          showToast(value.message);
        }

      }).catchError((onError){
        hideDialog(context);
        showToast(STRINGS.msg_server_failed);
      });
    }
  }

  void onPressCancel(){
    Navigator.pop(context);
  }



  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        Container(
          width: ScreenUtil().setWidth(600),
          height: ScreenUtil().setWidth(500),
          padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
          child:
          Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(STRINGS.change_password, style: TextStyle(fontSize: ScreenUtil().setSp(34), fontWeight: FontWeight.bold, color: COLORS.black),),
                SizedBox(height: ScreenUtil().setWidth(20),),
                TextField(
                    controller: textOldPassword,
                    keyboardType: TextInputType.text,
                    obscureText: !isPasswordVisibleOld,
                    decoration: InputDecoration(
                        hintText: STRINGS.old_password,
                        hintStyle: GlobalUI.getTextFieldHintStyle(),
                        contentPadding: EdgeInsets.all(ScreenUtil().setWidth(GlobalUI.TEXT_FIELD_PADDING)),
                        border: GlobalUI.getTextFieldBorderStyle(),
                        focusedBorder: GlobalUI.getTextFieldBorderStyle(),
                        suffixIcon: IconButton(
                          icon: Icon(isPasswordVisibleOld? Icons.visibility : Icons.visibility_off, color: COLORS.border),
                          onPressed: (){
                            setState(() {
                              isPasswordVisibleOld = !isPasswordVisibleOld;
                            });
                          },
                        )
                    ),
                    style: GlobalUI.getTextFieldTextStyle()
                ),
                SizedBox(height: ScreenUtil().setWidth(20),),
                TextField(
                    controller: textNewPassword,
                    keyboardType: TextInputType.text,
                    obscureText: !isNewPasswordVisible,
                    decoration: InputDecoration(
                        hintText: STRINGS.new_password,
                        hintStyle: GlobalUI.getTextFieldHintStyle(),
                        contentPadding: EdgeInsets.all(ScreenUtil().setWidth(GlobalUI.TEXT_FIELD_PADDING)),
                        border: GlobalUI.getTextFieldBorderStyle(),
                        focusedBorder: GlobalUI.getTextFieldBorderStyle(),
                        suffixIcon: IconButton(
                          icon: Icon(isNewPasswordVisible? Icons.visibility : Icons.visibility_off, color: COLORS.border),
                          onPressed: (){
                            setState(() {
                              isNewPasswordVisible = !isNewPasswordVisible;
                            });
                          },
                        )
                    ),
                    style: GlobalUI.getTextFieldTextStyle()
                ),
                SizedBox(height: ScreenUtil().setWidth(10),),
                Expanded(child: SizedBox(),),
                Row(children: <Widget>[
                  Expanded(child:
                  SizedBox(
                      height: ScreenUtil().setWidth(80),
                      child:
                        GlobalUI.getButton(onPressedOk, STRINGS.ok, COLORS.black),

                  ),),
                  SizedBox(
                    width: ScreenUtil().setWidth(40),),
                  Expanded(child:
                  SizedBox(
                      height: ScreenUtil().setWidth(80),
                      child:
                        GlobalUI.getButton(onPressCancel, STRINGS.cancel, COLORS.white, borderColor: COLORS.black, textColor: COLORS.black ),

                    ),
                  ),
                ],),
              ]),

        )
      ],
    );
  }
}
