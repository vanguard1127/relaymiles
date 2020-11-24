


import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:relaymiles/model/user_data.dart';
import 'package:intl/intl.dart';
import 'package:relaymiles/utils/strings.dart';
import 'dart:math' show cos, sqrt, asin;


Location g_location = new Location();
UserData g_userData;

String getNoNull(String value){
  if (value == null){
    return "";
  }else{
    return value;
  }
}

String getDistance(String meter){
  if (meter == null){
    return "";
  }
  try {
    double dmeter = double.parse(meter);
    return (dmeter / 1609.34).toStringAsFixed(2) + " " + STRINGS.mi;
  }catch(e){
    return "";
  }
}

void showToast(String text){
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,

  );
}

String getMonthYear(String dateTime){
  if (dateTime == null){
    return "";
  }
  DateTime date = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateTime);
  return new DateFormat("MMM. yyyy").format(date);
}

String getParameterDate(DateTime time){
  return new DateFormat("yyyy-MM-dd HH:mm:ss").format(time);
}

String getShowTime(String time){
  DateTime date = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(time);
  return new DateFormat("hh:mm a").format(date);
}

DateTime getDateFormat(String time){
  return new DateFormat("yyyy-MM-dd HH:mm:ss").parse(time);
}

String getShowDate(String time){
  DateTime today = DateTime.now();
  DateTime tomorrow = today.add(Duration(days: 1));
  DateTime date = getDateFormat(time);
  int m = date.month;
  int d = date.day;
  if (m == today.month && d == today.day) {
    return STRINGS.today;
  } else if (m == tomorrow.month && d == tomorrow.day) {
    return STRINGS.tomorrow + ", " + getMonthAndDay(date);
  } else {
    return getMonthAndDay(date);
  }
}

String getMonthAndDay(DateTime date) {
  var suffix = "th";
  var digit = date.day % 10;
  if ((digit > 0 && digit < 4) && (date.day < 11 || date.day > 13)) {
    suffix = ["st", "nd", "rd"][digit - 1];
  }
  return new DateFormat("MMM. d'$suffix'").format(date);
}

double calculateDistance(lat1, lon1, lat2, lon2){
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 - c((lat2 - lat1) * p)/2 +
      c(lat1 * p) * c(lat2 * p) *
          (1 - c((lon2 - lon1) * p))/2;
  return 12742 * asin(sqrt(a));
}



