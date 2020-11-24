
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'colors.dart';


AlertDialog mAlertDialog;

void showLoading(BuildContext context){
  showProgressDialog(context);

}


void hideDialog(BuildContext context){
  if (mAlertDialog != null){
    Navigator.of(context).pop();
    mAlertDialog = null;
  }
}




void showProgressDialog(BuildContext context) {
  try {
    mAlertDialog = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      contentPadding: EdgeInsets.all(ScreenUtil().setWidth(200)),
      content:
        LoadingIndicator(indicatorType: Indicator.ballBeat, color: COLORS.red, )

    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return mAlertDialog;
        });
  } catch (e) {
    mAlertDialog = null;
    print(e.toString());
  }
}