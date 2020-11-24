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



class SignupPage extends StatefulWidget {

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  TextEditingController mTxtUserEmail;
  TextEditingController mTxtFullName;
  TextEditingController mTxtPhoneNumber;
  TextEditingController mTxtUSDot;
  TextEditingController mTxtMC;
  TextEditingController mTxtUserPassword;
  bool isPasswordVisible = false;
  String mStrError = "";
  bool isButtonEnable = false;
  int mState = 0;
  bool mChkTerms = false;
  String mSelectVehicleItem;
  List<String> mVehicleList = [];

  @override
  void initState()  {
    super.initState();
    mTxtUserEmail = TextEditingController();
    mTxtUserPassword = TextEditingController();
    mTxtFullName = TextEditingController();
    mTxtPhoneNumber = TextEditingController();
    mTxtUSDot = TextEditingController();
    mTxtMC  = TextEditingController();
  }

  void onPressedContinue(){
    if (isButtonEnable){
      if (mState == 2){
        String email = mTxtUserEmail.text;
        String password = mTxtUserPassword.text;
        String name = mTxtFullName.text;
        String phone = mTxtPhoneNumber.text;
        String dotNumber = mTxtUSDot.text;
        String mcNumber = mTxtMC.text;

        showLoading(context);
        Map<String, dynamic> map = Map();
        map["name"] = name;
        map["password"] = password;
        map["phone"] = phone;
        map["email"] = email;
        map["mc_number"] = mcNumber;
        map["dot_number"] = dotNumber;
        ApiService.create().signup(Constants.SECRET_CODE, map).then((value){
          hideDialog(context);
          if (value.code == 1){
            showToast(value.message);
            setState(() {
              mState++;
            });
          }else{
            showToast(value.message);
          }
        }).catchError((onError){
          hideDialog(context);
          showToast(STRINGS.msg_server_failed);
        });
      }else if (mState < 2){
        setState(() {
          mState++;
        });

      }else if (mState == 3){
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => LoginPage()));
      }
    }
  }


  void checkText(value){
    if (mState == 0) {
      if (mTxtUserEmail.text.isNotEmpty && mTxtPhoneNumber.text.isNotEmpty && mTxtFullName.text.isNotEmpty && mTxtUserPassword.text.isNotEmpty) {
        setState(() {
          isButtonEnable = true;
        });
      } else {
        setState(() {
          isButtonEnable = false;
        });
      }
    }else if (mState == 1){
      if (mTxtUSDot.text.isNotEmpty && mTxtMC.text.isNotEmpty) {
        setState(() {
          isButtonEnable = true;
        });
      } else {
        setState(() {
          isButtonEnable = false;
        });
      }
    }else if (mState == 2){
      setState(() {
        isButtonEnable = mChkTerms;
      });
    }else if (mState == 3){
      setState(() {
        isButtonEnable = true;
      });
    }
  }

  void onPressVehicle(){
    List<Widget> list = [];

    for (int i = 0; i<mVehicleList.length; i++) {
      list.add(new FlatButton(
        child:
        Row(

          children: [
            SizedBox(width: ScreenUtil().setWidth(20),),
            Text(mVehicleList[i], textAlign: TextAlign.start,
              style: TextStyle(fontFamily : GlobalUI.FONT_NAME, color: COLORS.black,
                  fontSize: ScreenUtil().setSp(34),
                  fontWeight: FontWeight.normal),),
            SizedBox(width: ScreenUtil().setWidth(20),),
          ],

        ),
        onPressed: () {
          setState(() {
            Navigator.pop(context);
            mSelectVehicleItem = mVehicleList[i];
            checkText(null);
          });
        },
      )
      );

    }
    list.add(Row(
      children: [
        Expanded(child: SizedBox()),
        new FlatButton(
          child: new Text(STRINGS.up_cancel, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(34), color: COLORS.red, fontWeight: FontWeight.bold)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
            children: list
        );
      },
    );
  }

  void onPressedBack(){
    if (mState > 0 && mState < 3){
      setState(() {
        mState--;
      });
    }else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  void onChangeCheckTerms(value){
    mChkTerms = !mChkTerms;
    checkText(null);
  }

  String getTitle(){
    if (mState == 0){
      return STRINGS.contact_info;
    }else if (mState == 1){
      return STRINGS.us_dot_number_vehicle_type;
    }else if (mState == 2){
      return STRINGS.terms_conditions;
    }else{
      return STRINGS.sign_success;
    }
  }

  List<Widget> getContentWigdet(){
    List<Widget> list = [];
    if (mState == 0){
      list.add(TextField(
          controller: mTxtFullName,
          keyboardType: TextInputType.name,
          onChanged:(value) => checkText(value),
          decoration: GlobalUI.getTextFiledInputDecoration(STRINGS.full_name),
          style: GlobalUI.getTextFieldTextStyle()
      ));
      list.add( SizedBox(height: ScreenUtil().setHeight(20),),);
      list.add(TextField(
          controller: mTxtUserEmail,
          keyboardType: TextInputType.emailAddress,
          onChanged:(value) => checkText(value),
          decoration: GlobalUI.getTextFiledInputDecoration(STRINGS.email_address),
          style: GlobalUI.getTextFieldTextStyle()
      ));
      list.add( SizedBox(height: ScreenUtil().setHeight(20),),);
      list.add(TextField(
          controller: mTxtPhoneNumber,
          keyboardType: TextInputType.phone,
          onChanged:(value) => checkText(value),
          decoration: GlobalUI.getTextFiledInputDecoration(STRINGS.phone_number),
          style: GlobalUI.getTextFieldTextStyle()
      ));
      list.add( SizedBox(height: ScreenUtil().setHeight(20),),);
      list.add(TextField(
          controller: mTxtUserPassword,
          keyboardType: TextInputType.text,
          obscureText: !isPasswordVisible,
          onChanged:(value) => checkText(value),
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
      ));
      list.add(Expanded(child:SizedBox()));
      list.add(Text(STRINGS.step + " 1/4", style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(32), color: COLORS.text_grey, fontWeight: FontWeight.normal),));
    }else if (mState == 1){
      list.add(TextField(
          controller: mTxtUSDot,
          keyboardType: TextInputType.phone,
          onChanged:(value) => checkText(value),
          decoration: GlobalUI.getTextFiledInputDecoration(STRINGS.us_dot),
          style: GlobalUI.getTextFieldTextStyle()
      ));
      list.add( SizedBox(height: ScreenUtil().setHeight(20),),);
      list.add(TextField(
          controller: mTxtMC,
          keyboardType: TextInputType.phone,
          onChanged:(value) => checkText(value),
          decoration: GlobalUI.getTextFiledInputDecoration(STRINGS.mc),
          style: GlobalUI.getTextFieldTextStyle()
      ));
      /*list.add(
        InkWell(
          onTap: onPressVehicle,
          child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(ScreenUtil().setWidth(GlobalUI.TEXT_FIELD_PADDING)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.zero,
                border: Border.all(
                  color: COLORS.border,
                ),
              ),
              child:
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Text(mSelectVehicleItem != null ? mSelectVehicleItem : STRINGS.select_vehicle_type, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(32), color: mSelectVehicleItem != null ? COLORS.black : COLORS.text_grey, fontWeight: FontWeight.normal),)),
                  Image(
                    image: new AssetImage('assets/images/ic_up_arrow.png'),
                    width: ScreenUtil().setWidth(60),
                    height: ScreenUtil().setWidth(60),
                    fit: BoxFit.contain,
                  ),
                ],
              )
          ),
        )

      );*/
      list.add(Expanded(child:SizedBox()));
      list.add(Text(STRINGS.step + " 2/4", style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(32), color: COLORS.text_grey, fontWeight: FontWeight.normal),));
    }else if (mState == 2){
      list.add(Expanded(flex: 1,child:
          Container(
            width: double.infinity,
            height: 10,
            padding: EdgeInsets.all(ScreenUtil().setWidth(GlobalUI.TEXT_FIELD_PADDING)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(10))),
              border: Border.all(
                color: COLORS.border,
              ),
              color: COLORS.dark_white
            ),
            child:
              SingleChildScrollView(
                child:
                  Text(STRINGS.TERMS , style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(24), color: COLORS.black, fontWeight: FontWeight.normal),)
              ),
           )
      ));
      list.add( SizedBox(height: ScreenUtil().setHeight(20),),);
      list.add(CheckboxListTile(
        title: Text(STRINGS.read_accept_terms , style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(30), color: COLORS.black, fontWeight: FontWeight.bold),),
        value: mChkTerms,
        onChanged: (value) { onChangeCheckTerms(value);},
        activeColor: COLORS.black,
        controlAffinity: ListTileControlAffinity.leading,
      ));
      list.add( SizedBox(height: ScreenUtil().setHeight(20),),);
      list.add(Text(STRINGS.step + " 3/4", style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(32), color: COLORS.text_grey, fontWeight: FontWeight.normal),));
    }else{
      list.add(Text(STRINGS.sent_email1 + mTxtUserEmail.text + STRINGS.sent_email2, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(32), color: COLORS.text_grey, fontWeight: FontWeight.normal),));
    }
    return list;
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
                            Text(STRINGS.sign_up, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(40), color: COLORS.red, fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(40),),
                      Row(
                        children: [
                          Expanded(child: GlobalUI.getStepBar(COLORS.red)), SizedBox(width: ScreenUtil().setWidth(10),),
                          Expanded(child: GlobalUI.getStepBar(mState > 0 ? COLORS.red : COLORS.split)), SizedBox(width: ScreenUtil().setWidth(10),),
                          Expanded(child: GlobalUI.getStepBar(mState > 1 ? COLORS.red : COLORS.split)), SizedBox(width: ScreenUtil().setWidth(10),),
                          Expanded(child: GlobalUI.getStepBar(mState > 2 ? COLORS.red : COLORS.split)),

                        ],
                      ),
                      Expanded(flex: 1,child:
                        Column(children: [
                          Expanded(child: SizedBox()),
                          Text(getTitle(), style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(48), color: COLORS.green, fontWeight: FontWeight.bold),),
                        ],)
                      ),
                      SizedBox(height: ScreenUtil().setHeight(40),),
                      Expanded(flex: 3,child:
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: getContentWigdet(),)
                      ),
                      SizedBox(height: ScreenUtil().setHeight(40),),
                      GlobalUI.getButton(onPressedContinue, mState < 3 ? STRINGS.up_continue : STRINGS.up_start_relaymile,
                          isButtonEnable ? (mState == 3 ? COLORS.red : COLORS.black) : COLORS.white,
                          borderColor : isButtonEnable ? (mState == 3 ? COLORS.red : COLORS.black) : COLORS.weak_black,
                          textColor : isButtonEnable ? null : COLORS.weak_black),
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
