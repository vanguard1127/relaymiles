import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:relaymiles/model/job_data.dart';
import 'package:relaymiles/ui/new_job_details.dart';
import 'package:relaymiles/ui/signup.dart';
import 'package:relaymiles/utils/colors.dart';
import 'package:relaymiles/utils/constants.dart';
import 'package:relaymiles/utils/dialogs.dart';
import 'package:relaymiles/utils/global_func.dart';
import 'package:relaymiles/utils/global_ui.dart';
import 'package:relaymiles/utils/strings.dart';
import 'package:relaymiles/api/api_service.dart';


class SearchPage extends StatefulWidget {
  Function backFunc;
  Function addFunc;
  Function replaceFunc;
  int mSelectPos = 0;
  SearchPage(this.backFunc, this.addFunc, this.replaceFunc);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin<SearchPage> {

  TextEditingController mTxtSearch;
  List<JobData> mListData = [];
  String mStrKeyword = "";
  List<DateTime> mListDays = [];
  @override
  void initState()  {
    super.initState();
    mTxtSearch = TextEditingController();

    Future.delayed(Duration.zero, () {
      init();
    });

  }
  void init(){
    var today = DateTime.now();
    today = today.subtract(Duration(hours: today.hour, minutes: today.minute, seconds: today.second - 1));

    mListDays.clear();
    for (int i = 0; i<7; i++){
      mListDays.add(today.add(Duration(days: i)));
    }
    setState(() {

    });
    loadData();
  }
  void loadData(){
    showLoading(context);

    Map<String, dynamic> map = Map();
    map["fromdate"] = getParameterDate(mListDays[widget.mSelectPos]);
//    map["todate"] = getParameterDate(mListDays[widget.mSelectPos]);
    ApiService.create().searchJob(Constants.SECRET_CODE, map).then((value){
      hideDialog(context);
      if (value.code == 1){
        mListData.clear();
        for (int i = 0; i<value.data.length; i++){
          mListData.add(value.data[i]);
        }
        setState(() {

        });
      }else if (value.code == 2) {
        mListData.clear();
        setState(() {

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

  @override
  bool get wantKeepAlive {
    return true;
  }

  void onPressDetail(JobData data){
    widget.addFunc(NewJobDetailPage(data, widget.backFunc, widget.addFunc, widget.replaceFunc));
  }

  List<Widget> getWeekTitle(){
    List<Widget> list = [];
    if (mListDays.length > 0) {
      for (int i = 0; i < 7; i++) {

        Widget widget = Expanded(child: Text(STRINGS.weekday[mListDays[i].weekday % 7], textAlign: TextAlign.center, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(26), fontWeight: FontWeight.normal, color: COLORS.weak_black ),),);
        list.add(widget);
      }
    }
    return list;

  }

  List<Widget> getWeekDay(){

    List<Widget> list = [];
    if (mListDays.length > 0) {
      int selectDay = mListDays[widget.mSelectPos].day;
      for (int i = 0; i < 7; i++) {
        int date = mListDays[i].day;
        Expanded item = Expanded(child:
            InkWell(
              onTap: (){
                setState(() {
                  widget.mSelectPos = i;
                });
                loadData();
              },
              child:
                Container(
                  alignment: Alignment.center,
                  width: ScreenUtil().setWidth(60),
                  height: ScreenUtil().setWidth(60),
                  decoration: new BoxDecoration(
                    color: selectDay == date ? COLORS.red : COLORS.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text(date.toString(), textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: GlobalUI.FONT_NAME,
                        fontSize: ScreenUtil().setSp(32),
                        fontWeight: FontWeight.normal,
                        color: selectDay == date ? COLORS.white : COLORS.black),),
                )
            )

        );
        list.add(item);
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Scaffold(
      backgroundColor: COLORS.dark_white,
      resizeToAvoidBottomInset: true,
      body:
          SingleChildScrollView(child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: COLORS.white,
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xFFDDDDDD),
                                offset: Offset(0.0, 1.0),
                                blurRadius: ScreenUtil().setWidth(6)
                            ),

                          ]),
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: ScreenUtil().setHeight(90),),
                          Padding(padding: EdgeInsets.only(left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40)),
                            child: Text(STRINGS.find_next_load, style: TextStyle(fontFamily: GlobalUI.FONT_NAME, fontSize: ScreenUtil().setSp(40), fontWeight: FontWeight.bold, color: COLORS.black ),),),
                          SizedBox(height: ScreenUtil().setHeight(20),),
                          Divider(color: COLORS.grey,),
                          Padding(padding: EdgeInsets.only(left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40)),
                              child:Row(
                                children:getWeekTitle(),
                              )
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10),),
                          Padding(padding: EdgeInsets.only(left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40)),
                              child:Row(
                                  children:getWeekDay()
                              )
                          ),
                          SizedBox(height: ScreenUtil().setHeight(20),),
                        ],
                      )
                  ),
                  Padding(padding: EdgeInsets.only(top:ScreenUtil().setWidth(30), left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40), bottom: ScreenUtil().setWidth(30)),
                    child:
                    TextField(
                        controller: mTxtSearch,
                        keyboardType: TextInputType.text,
                        onChanged: (value){
                          setState(() {
                            mStrKeyword = value;
                          });
                        },
                        onSubmitted: (value){},
                        decoration: InputDecoration(
                          hintText: STRINGS.location_facility_name,
                          hintStyle: GlobalUI.getTextFieldHintStyle(),
                          contentPadding: EdgeInsets.all(ScreenUtil().setWidth(GlobalUI.TEXT_FIELD_PADDING)),
                          border: new OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(ScreenUtil().setWidth(100)),
                              ),
                              borderSide: BorderSide.none
                          ),
                          fillColor: COLORS.white,
                          filled: true,
                          prefixIcon: Icon(Icons.search , color: COLORS.grey),
                        ),
                        style: GlobalUI.getTextFieldTextStyle()
                    ),

                  ),
                  Column(children: GlobalUI.getJobList(mListData, onPressDetail, true, mStrKeyword),),
                ],
              ),
          )


    );
  }
}
