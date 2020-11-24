import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:relaymiles/api/api_service.dart';
import 'package:relaymiles/ui/login.dart';
import 'package:relaymiles/utils/colors.dart';
import 'package:relaymiles/utils/constants.dart';
import 'package:relaymiles/utils/dialogs.dart';
import 'package:relaymiles/utils/global_func.dart';
import 'package:relaymiles/utils/global_ui.dart';
import 'package:relaymiles/utils/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ForgotPasswordPage extends StatefulWidget {

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  TextEditingController mTxtUserEmail;
  bool sentLink = false;
  bool isButtonEnable = false;
  @override
  void initState()  {
    super.initState();
    mTxtUserEmail = TextEditingController();

  }

  Future<void> onPressedSendResetLink() async {
    if (isButtonEnable) {

      showLoading(context);
      Map<String, dynamic> map = Map();
      map["email"] = mTxtUserEmail.text;
      ApiService.create().resetPassword(Constants.SECRET_CODE, map).then((value){
        hideDialog(context);
        if (value.code == 1){
          setState(() {
            sentLink = true;
          });
        }else{
          showToast(value.message);
        }
      }).catchError((onError){
        hideDialog(context);
        showToast(STRINGS.msg_server_failed);
      });

    }
  }

  void onPressedBack(){
    Navigator.pop(context);
  }

  void checkText(value){
    if (mTxtUserEmail.text.isNotEmpty) {
      setState(() {
        isButtonEnable = true;
      });
    } else {
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
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Container(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(50), right: ScreenUtil().setWidth(50)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: ScreenUtil().setHeight(80),),
                      InkWell(
                        onTap: onPressedBack,
                        child:
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image(
                              image: new AssetImage('assets/images/ic_back.png'),
                              width: ScreenUtil().setWidth(60),
                              height: ScreenUtil().setWidth(60),
                              fit: BoxFit.fill,
                            ),
                            SizedBox(width: ScreenUtil().setWidth(40),),
                            Text(STRINGS.forgot_password, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(40), color: COLORS.red, fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(200),),
                      Text(sentLink ? STRINGS.email_sent : STRINGS.msg_no_worry_here_help, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(46), color: COLORS.green, fontWeight: FontWeight.bold),),
                      SizedBox(height: ScreenUtil().setHeight(20),),
                      !sentLink ? Text(STRINGS.msg_enter_username_or_email, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(34), color: COLORS.text_grey, fontWeight: FontWeight.normal),) :
                        RichText(text:TextSpan(children: [
                             TextSpan(text: STRINGS.msg_follow_link_reset_password, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(34), color: COLORS.text_grey, fontWeight: FontWeight.normal)),
                             TextSpan(text: STRINGS.click_here, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(34), color: COLORS.black, fontWeight: FontWeight.bold),
                               recognizer: new TapGestureRecognizer()
                                 ..onTap = () {
                                   onPressedSendResetLink();
                                 },
                             ),
                           ]),
                        ),
                      SizedBox(height: ScreenUtil().setHeight(20),),
                      !sentLink ? TextField(
                          controller: mTxtUserEmail,
                          keyboardType: TextInputType.emailAddress,
                          onChanged:(value) => checkText(value),
                          decoration: GlobalUI.getTextFiledInputDecoration(STRINGS.username_email),
                          style: GlobalUI.getTextFieldTextStyle()
                      ) : SizedBox(),
                      Expanded(child: SizedBox()),
                      !sentLink ? GlobalUI.getButton(onPressedSendResetLink, STRINGS.up_send_reset_link,
                          isButtonEnable ? COLORS.black : COLORS.white,
                          borderColor:  COLORS.black ,
                          textColor: isButtonEnable ? COLORS.white : COLORS.black,) : SizedBox(),
                      SizedBox(height: ScreenUtil().setHeight(40),),
                    ],
                  ),
                )

              ),

            )
          )

    );
  }
}
