import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:relaymiles/model/job_data.dart';
import 'package:relaymiles/utils/strings.dart';
import 'package:relaymiles/utils/global_func.dart';
import 'package:intl/intl.dart';

import 'colors.dart';

class GlobalUI{
  static double TEXT_FIELD_PADDING = 20;
  static double BUTTON_HEIGHT = 80;
  static String FONT_NAME = "Montserrat";

  static OutlineInputBorder getTextFieldBorderStyle(){
    return OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: new BorderSide(color: COLORS.border));
  }

  static TextStyle getTextFieldHintStyle(){
    return TextStyle(fontFamily: FONT_NAME, fontSize: ScreenUtil().setSp(34), color: COLORS.text_grey);
  }

  static TextStyle getTextFieldTextStyle(){
    return TextStyle(fontFamily: FONT_NAME, fontSize: ScreenUtil().setSp(34), color: COLORS.black);
  }

  static InputDecoration getTextFiledInputDecoration(String hint){
    return InputDecoration(
      hintText: hint,
      hintStyle: GlobalUI.getTextFieldHintStyle(),
      contentPadding: EdgeInsets.all(ScreenUtil().setWidth(GlobalUI.TEXT_FIELD_PADDING)),
      border: GlobalUI.getTextFieldBorderStyle(),
      focusedBorder: GlobalUI.getTextFieldBorderStyle(),
    );
  }

  static Widget getButton(onPressFunc, String text, Color backColor, {Color borderColor, Color textColor}){
    return SizedBox(
        width: double.infinity,
        height: ScreenUtil().setHeight(GlobalUI.BUTTON_HEIGHT),
        child:
        FlatButton(
          onPressed: onPressFunc,
          textColor: textColor != null ? textColor : COLORS.white,
          child: Text(text,
            style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(38), fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
          color: backColor,
          shape: ContinuousRectangleBorder(
              side: BorderSide(color: borderColor != null ? borderColor : backColor, width: 1),
              borderRadius: BorderRadius.zero),
        )

    );
  }

  static List<Widget> getJobList(List<JobData> listData, onPressItem, bool isSearch, String keyword){
    List<Widget> list = [];
    int month = -1;
    int day = -1;
    keyword = keyword.toLowerCase();
    for (int i = 0; i<listData.length; i++){
      JobData data = listData[i];
      if (data.pickupAddress.toLowerCase().contains(keyword) || data.deliveryAddress.toLowerCase().contains(keyword) || data.loadNumber.toLowerCase().contains(keyword) || data.poster.toLowerCase().contains(keyword)) {
        DateTime date = getDateFormat(data.pickupTime);
        int m = date.month;
        int d = date.day;
        if (data.status == "6" ){
          m = -2;
          d = -2;
        }
        if (m != month || d != day) {
          String strDate = getShowDate(data.pickupTime);
          Widget dateWidget = Padding(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(50),
                right: ScreenUtil().setWidth(50),
                top: ScreenUtil().setWidth(10),
                bottom: ScreenUtil().setWidth(30)),
            child: Align(alignment: Alignment.centerLeft,
              child: Text(m == -2 ? STRINGS.completed : strDate, textAlign: TextAlign.start,
                style: TextStyle(fontFamily: GlobalUI.FONT_NAME,
                    fontSize: ScreenUtil().setSp(32),
                    fontWeight: FontWeight.normal,
                    color: COLORS.black),),),
          );
          list.add(dateWidget);
          month = m;
          day = d;
        }
        Widget widget = Container(
          margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
          width: double.infinity,
          decoration: BoxDecoration(
              color: COLORS.white,
              boxShadow: [
                BoxShadow(
                    color: Color(0xFFDDDDDD),
                    offset: Offset(0.0, 1.0),
                    blurRadius: ScreenUtil().setWidth(6)
                ),

              ]
          ),
          child: Column(children: [
            Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(40),
                  right: ScreenUtil().setWidth(40),
                  top: ScreenUtil().setWidth(30),
                  bottom: ScreenUtil().setWidth(20)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("\$" + data.price, style: TextStyle(
                      fontFamily: GlobalUI.FONT_NAME,
                      fontSize: ScreenUtil().setSp(46),
                      fontWeight: FontWeight.normal,
                      color: COLORS.red),),
                  SizedBox(width: ScreenUtil().setWidth(40),),
                  Expanded(child:
                  Text(data.trailer != null
                      ? STRINGS.trailer + ": " + data.trailer
                      : "", style: TextStyle(fontFamily: GlobalUI.FONT_NAME,
                      fontSize: ScreenUtil().setSp(27),
                      fontWeight: FontWeight.normal,
                      color: COLORS.weak_black),),
                  ),
                  FlatButton(
                    onPressed: () {
                      onPressItem(data);
                    },
                    textColor: COLORS.black,
                    padding: EdgeInsets.only(top: ScreenUtil().setWidth(5),
                        bottom: ScreenUtil().setWidth(5),
                        left: ScreenUtil().setWidth(20),
                        right: ScreenUtil().setWidth(20)),
                    child: Text(STRINGS.details,
                      style: TextStyle(fontFamily: GlobalUI.FONT_NAME,
                          fontSize: ScreenUtil().setSp(30),
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,),
                    color: Colors.transparent,
                    shape: ContinuousRectangleBorder(
                        side: BorderSide(color: COLORS.black, width: 1),
                        borderRadius: BorderRadius.zero),
                  )
                ],
              ),
            ),
            Divider(color: COLORS.grey,),
            Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(40),
                  right: ScreenUtil().setWidth(40),
                  top: ScreenUtil().setWidth(30),
                  bottom: ScreenUtil().setWidth(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 10, child:
                  Text(data.pickupCity + ", " + data.pickupState,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: GlobalUI.FONT_NAME,
                        fontSize: ScreenUtil().setSp(34),
                        fontWeight: FontWeight.normal,
                        color: COLORS.black),),),
                  Expanded(flex: 7, child: Image(
                    image: new AssetImage('assets/images/ic_arrow.png'),
                    fit: BoxFit.contain,
                    width: ScreenUtil().setWidth(60),
                    height: ScreenUtil().setWidth(30),
                  ),
                  ),
                  Expanded(flex: 10, child:
                  Text(data.deliveryCity + ", " + data.deliveryState,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: GlobalUI.FONT_NAME,
                        fontSize: ScreenUtil().setSp(34),
                        fontWeight: FontWeight.normal,
                        color: COLORS.black),),),

                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(40),
                  right: ScreenUtil().setWidth(40),
                  top: ScreenUtil().setWidth(0),
                  bottom: ScreenUtil().setWidth(30)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 10, child:
                  Text(STRINGS.pickup_at + " " + getShowTime(data.pickupTime),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: GlobalUI.FONT_NAME,
                        fontSize: ScreenUtil().setSp(24),
                        fontWeight: FontWeight.normal,
                        color: COLORS.weak_black),),),
                  Expanded(flex: 7, child: SizedBox()),
                  Expanded(flex: 10, child:
                  Text(STRINGS.drop_off + " " + getShowTime(data.dropOffTime),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: GlobalUI.FONT_NAME,
                        fontSize: ScreenUtil().setSp(24),
                        fontWeight: FontWeight.normal,
                        color: COLORS.weak_black),),),

                ],
              ),
            ),
          ],),

        );
        list.add(widget);
      }
    }
    return list;
  }
  
  static Widget getStepBar(Color color){
    return Container(
      height: ScreenUtil().setHeight(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setHeight(5))),
      ),
    );
  }
}