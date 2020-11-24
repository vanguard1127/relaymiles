import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:relaymiles/api/api_service.dart';
import 'package:relaymiles/ui/forgot_password.dart';
import 'package:relaymiles/ui/home.dart';
import 'package:relaymiles/ui/search_frag.dart';
import 'package:relaymiles/ui/signup.dart';
import 'package:relaymiles/utils/colors.dart';
import 'package:relaymiles/utils/constants.dart';
import 'package:relaymiles/utils/dialogs.dart';
import 'package:relaymiles/utils/global_func.dart';
import 'package:relaymiles/utils/global_ui.dart';
import 'package:relaymiles/utils/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LoginPage extends StatefulWidget {

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController mTxtUserId;
  TextEditingController mTxtUserPassword;
  bool isPasswordVisible = false;
  String mStrError = "";
  bool isButtonEnable = false;
  SharedPreferences prefs;

  Future<void> init() async {

    prefs = await SharedPreferences.getInstance();
    if (prefs.getString(Constants.PREF_EMAIL) != null){
      setState(() {
        mTxtUserId.text = prefs.getString(Constants.PREF_EMAIL);
        mTxtUserPassword.text = prefs.getString(Constants.PREF_PASSWORD);
        isButtonEnable = true;
      });
      login();
    }
  }
  @override
  void initState()  {
    super.initState();
    mTxtUserId = TextEditingController();
    mTxtUserPassword = TextEditingController();
    init();
  }

  void onPressedLogin(){
    if (isButtonEnable){
      login();

    }
  }

  void login(){
    String email = mTxtUserId.text;
    String password = mTxtUserPassword.text;
    if (email.isEmpty || password.isEmpty){
      showToast(STRINGS.msg_enter_email_password);
      return;
    }
    showLoading(context);
    Map<String, dynamic> map = Map();
    map["username"] = email;
    map["password"] = password;
    ApiService.create().login(Constants.SECRET_CODE, map).then((value) async {
      hideDialog(context);
      if (value.code == 1){
        prefs.setString(Constants.PREF_EMAIL, email);
        prefs.setString(Constants.PREF_PASSWORD, password);
        prefs.setString(Constants.PREF_ID, value.data.id);
        g_userData = value.data;
        g_userData.email = email;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomePage()));
      }else{
        showToast(value.message);
      }
    }).catchError((onError){
      hideDialog(context);
      showToast(STRINGS.msg_server_failed);
    });
  }

  void onPressedSignup(){
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => SignupPage()));
  }

  void onPressedForgotPassword(){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
  }

  void checkText(value){
    if (mTxtUserId.text.isNotEmpty && mTxtUserPassword.text.isNotEmpty){
      setState(() {
        isButtonEnable = true;
      });
    }else{
      setState(() {
        isButtonEnable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Scaffold(
      backgroundColor: COLORS.white,
      resizeToAvoidBottomInset: true,
      body:
          SingleChildScrollView(
            child:
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(50), right: ScreenUtil().setWidth(50)),
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setHeight(300),),
                    new Container(
                        alignment: Alignment.center,
                        width: ScreenUtil().setWidth(520),
                        height: ScreenUtil().setWidth(143),
                        child: Image(
                          image: new AssetImage('assets/images/logo.png'),
                          fit: BoxFit.contain,
                        )
                    ),
                    SizedBox(height: ScreenUtil().setHeight(120),),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(mStrError, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(30), color: COLORS.green, fontWeight: FontWeight.normal),),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20),),
                    TextField(
                        controller: mTxtUserId,
                        keyboardType: TextInputType.emailAddress,
                        onChanged:(value) => checkText(value),
                        decoration: GlobalUI.getTextFiledInputDecoration(STRINGS.email),
                        style: GlobalUI.getTextFieldTextStyle()
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20),),
                    TextField(
                        controller: mTxtUserPassword,
                        keyboardType: TextInputType.text,
                        onChanged:(value) => checkText(value),
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: STRINGS.password,
                          hintStyle: GlobalUI.getTextFieldHintStyle(),
                          contentPadding: EdgeInsets.all(ScreenUtil().setWidth(GlobalUI.TEXT_FIELD_PADDING)),
                          border: GlobalUI.getTextFieldBorderStyle(),
                          focusedBorder: GlobalUI.getTextFieldBorderStyle(),
                          suffixIcon: IconButton(
                            icon: Icon(isPasswordVisible? Icons.visibility : Icons.visibility_off, color: COLORS.border),
                            onPressed: (){
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          )
                        ),
                        style: GlobalUI.getTextFieldTextStyle()
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20),),
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: onPressedForgotPassword,
                        child: Text(STRINGS.forgot_password, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(30), color: COLORS.text_grey, fontWeight: FontWeight.normal),),),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(50),),
                    GlobalUI.getButton(onPressedLogin, STRINGS.up_sign_in, isButtonEnable ? COLORS.red : COLORS.white, borderColor : isButtonEnable ? null : COLORS.red, textColor : isButtonEnable ? null : COLORS.red),
                    SizedBox(height: ScreenUtil().setHeight(70),),
                    Text(STRINGS.new_to, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(34), color: COLORS.text_grey, fontWeight: FontWeight.normal),),
                    SizedBox(height: ScreenUtil().setHeight(20),),
                    InkWell(
                      onTap: onPressedSignup,
                      child: Text(STRINGS.up_sign_up, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(34), color: COLORS.red, fontWeight: FontWeight.bold),),),
                  ],
                ),
              )

          )

    );
  }
}
