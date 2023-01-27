import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:ghmcofficerslogin/model/check_status_response.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';
import 'package:ghmcofficerslogin/res/components/background_image.dart';
import 'package:ghmcofficerslogin/res/components/searchbar.dart';
import 'package:ghmcofficerslogin/res/components/sharedpreference.dart';
import 'package:ghmcofficerslogin/res/components/textwidget.dart';
import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';
import 'package:ghmcofficerslogin/res/constants/app_constants.dart';
import 'package:ghmcofficerslogin/res/constants/routes/app_routes.dart';
import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';
import 'package:http/http.dart';
import 'package:supercharged/supercharged.dart';

class Check extends StatefulWidget {
  const Check({super.key});

  @override
  State<Check> createState() => _CheckState();
}

class _CheckState extends State<Check> {
  checkStatusResponse? _statusResponse;
  Set<String> headings = {};
  var res;
  List totalitems = [];
  List<ViewGrievances>? _list;
  Map<String, String> objects = {};
  List titles = [
    TextConstants.checkstatus_stepper_open,
    TextConstants.checkstatus_stepper_underprocess,
    TextConstants.checkstatus_stepper_resolvedbyofficer,
    TextConstants.checkstatus_stepper_closedbycitizen,
    TextConstants.checkstatus_stepper_conditionclosed
  ];
  var ticketlistResponse = [];
  var ticketlistSearchListResponse = [];

  var reslen;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("check")),
      body: Stack(children: <Widget>[
        BgImage(imgPath: ImageConstants.bg),
        Column(
          children: [
            ReusableSearchbar(
              bgColor: Colors.white,
              screenHeight: 0.05,
              searchIcon: Icon(Icons.search),
              topPadding: 8.0,
              hinttext: "Search by Id/Type/Category",
              hintetextcolor: Colors.grey,
              onChanged: ((value) {
                _runFilter(value);
              }),
              screenWidth: 1,
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: headings
                              .length /*  res
                              
                              .keys
                              .toList()
                              .length */
                          ,
                          itemBuilder: (BuildContext context, int index1) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  color: Color.fromARGB(255, 20, 55, 83),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          res.keys.toList()[index1],
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          "${res.values.toList()[index1].length}",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                    itemCount:
                                        res.values.toList()[index1].length,
                                    physics: ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index2) {
                                      return GestureDetector(
                                        onTap: (() {
                                          SharedPreferencesClass().writeTheData(
                                              PreferenceConstants
                                                  .check_status_id,
                                              res.values.toList()[index1]
                                                  [index2]["ID"]);

                                          Navigator.pushNamed(context,
                                              AppRoutes.grivancedetails);
                                        }),
                                        child: Container(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            RowComponent(
                                                TextConstants.check_status_id,
                                                res.values.toList()[index1]
                                                        [index2][
                                                    TextConstants
                                                        .check_status_id]),
                                            Line(),
                                            RowComponent(
                                                TextConstants
                                                    .check_status_category_name,
                                                res.values.toList()[index1]
                                                        [index2][
                                                    TextConstants
                                                        .check_status_category_name]),
                                            Line(),
                                            RowComponent(
                                                TextConstants
                                                    .check_status_subcategory_name,
                                                res.values.toList()[index1]
                                                        [index2][
                                                    TextConstants
                                                        .check_status_subcategory_name]),
                                            Line(),
                                            RowComponent(
                                                TextConstants
                                                    .check_status_time_stamp,
                                                res.values.toList()[index1]
                                                        [index2][
                                                    TextConstants
                                                        .check_status_time_stamp]),
                                            Line(),
                                            RowComponent(
                                                TextConstants
                                                    .check_status_assigned_to,
                                                res.values.toList()[index1]
                                                        [index2][
                                                    TextConstants
                                                        .check_status_assigned_to]),
                                            Line(),
                                            RowComponent(
                                                TextConstants
                                                    .check_status_status,
                                                res.values.toList()[index1]
                                                        [index2][
                                                    TextConstants
                                                        .check_status_status]),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10.0),
                                                child: Container(
                                                    // width: this._width,
                                                    child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 25.0),
                                                      child: Row(
                                                        children: _iconViews(
                                                            status: res.values
                                                                        .toList()[
                                                                    index1][index2]
                                                                [TextConstants
                                                                    .check_status_status]),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      children: _titleViews(),
                                                    ),
                                                  ],
                                                )))
                                          ],
                                        )),
                                      );
                                    }),
                              ],
                            );
                          }),
                    )
                  ],
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkStatusDetails();
    EasyLoading.dismiss();
  }

  _runFilter(String enteredKeyword) {
    print("object");
    var results = [];
    if (enteredKeyword.isEmpty) {
      results = ticketlistResponse;
    } else {
      print("ticketlistResponse ${ticketlistResponse}");
      results = ticketlistResponse.map((user) {
        print(user);
      }).toList();
      print("object ${results}");

      /*  results = ticketlistResponse
          .where((element) => element[0][TextConstants.check_status_id]!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList(); */

      setState(() {
        ticketlistSearchListResponse = results;
      });
    }
    //  print("list ${ticketlistSearchListResponse}");
  }

  checkStatusDetails() async {
    var mobileno = await SharedPreferencesClass()
        .readTheData(PreferenceConstants.mobileno);

    final check_status_url =
        ApiConstants.baseurl + ApiConstants.check_status_endpoint;
    final check_status_payload = {
      "mobileno": mobileno,
      "password": AppConstants.password,
      "userid": AppConstants.userid
    };
    final dio_obj = Dio();
    print("payload ${check_status_payload}");

    try {
      final check_status_response =
          await dio_obj.post(check_status_url, data: check_status_payload);

      final data = checkStatusResponse.fromJson(check_status_response.data);

      if (data.status == "success") {
        setState(() {
          _statusResponse = data;

          if (_statusResponse?.viewGrievances != null) {
            _list = _statusResponse?.viewGrievances;
            var len = _list?.length ?? 0;

            for (var i = 0; i < len; i++) {
              headings.add("${_list?[i].type}");
              var item = _list?[i];
              objects = {
                TextConstants.check_status_id: item?.id ?? "",
                TextConstants.check_status_assigned_to: item?.assignedto ?? "",
                TextConstants.check_status_category_name: item?.category ?? "",
                TextConstants.check_status_subcategory_name: item?.type ?? "",
                TextConstants.check_status_time_stamp: item?.timestamp ?? "",
                TextConstants.check_status_status: item?.status ?? "",
              };
              // print(d);
              totalitems.add(objects);
            }
            res = totalitems.groupBy((element) =>
                element[TextConstants.check_status_subcategory_name]);
          }

          ticketlistResponse = res.values.toList();
          ticketlistSearchListResponse = ticketlistResponse;
        });
      } else {
        print(data.status);
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  RowComponent(var data, var val) {
    //final void Function()? onpressed;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 1,
              child: TextWidget(
                text: "${data}",
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                textcolor: Colors.black,
                fontWeight: FontWeight.bold,
              )),
          Expanded(
              flex: 2,
              child: TextWidget(
                text: "${val}",
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                textcolor: Colors.blueGrey,
              ))
        ],
      ),
    );
  }

  bool openflag = false;
  bool underprocess = false;
  bool resolvedbyofficer = false;
  bool closedbycitizen = false;
  bool conditionclosed = false;

  List<Widget> _iconViews({required status}) {
    switch (status) {
      case TextConstants.checkstatus_stepper_open:
        openflag = true;
        underprocess = false;
        resolvedbyofficer = false;
        closedbycitizen = false;
        conditionclosed = false;

        break;
      case TextConstants.checkstatus_stepper_underprocess:
        underprocess = true;
        openflag = false;
        resolvedbyofficer = false;
        closedbycitizen = false;
        conditionclosed = false;

        break;
      case TextConstants.checkstatus_stepper_resolvedbyofficer:
        resolvedbyofficer = true;
        openflag = false;
        underprocess = false;
        closedbycitizen = false;
        conditionclosed = false;

        break;
      case TextConstants.checkstatus_stepper_closedbycitizen:
        closedbycitizen = true;
        openflag = false;
        underprocess = false;
        resolvedbyofficer = false;
        conditionclosed = false;

        break;
      case TextConstants.checkstatus_stepper_conditionclosed:
        conditionclosed = true;
        openflag = false;
        underprocess = false;
        resolvedbyofficer = false;
        closedbycitizen = false;

        break;
      default:
    }

    var list = <Widget>[];

    titles.asMap().forEach((i, icon) {
      switch (i) {
        case 0:
          list.add(
            Container(
              width: 20.0,
              height: 20.0,
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.all(new Radius.circular(22.0)),
                border: new Border.all(
                  color: openflag ? Colors.blue : Colors.black,
                  width: openflag ? 10.0 : 2.0,
                ),
              ),
            ),
          );

          break;
        case 1:
          list.add(
            Container(
              width: 20.0,
              height: 20.0,
              decoration: new BoxDecoration(
                // color: circleColor,
                borderRadius: new BorderRadius.all(new Radius.circular(22.0)),
                border: new Border.all(
                  color: underprocess ? Colors.orange : Colors.black,
                  width: underprocess ? 10.0 : 2.0,
                ),
              ),
            ),
          );
          break;
        case 2:
          list.add(
            Container(
              width: 20.0,
              height: 20.0,
              decoration: new BoxDecoration(
                // color: circleColor,
                borderRadius: new BorderRadius.all(new Radius.circular(22.0)),
                border: new Border.all(
                  color: resolvedbyofficer
                      ? Color.fromARGB(255, 56, 126, 58)
                      : Colors.black,
                  width: resolvedbyofficer ? 10.0 : 2.0,
                ),
              ),
            ),
          );
          break;
        case 3:
          list.add(
            Container(
              width: 20.0,
              height: 20.0,
              padding: EdgeInsets.all(0),
              decoration: new BoxDecoration(
                // color: circleColor,
                borderRadius: new BorderRadius.all(new Radius.circular(22.0)),
                border: new Border.all(
                  color: closedbycitizen
                      ? Color.fromARGB(255, 71, 215, 73)
                      : Colors.black,
                  width: closedbycitizen ? 10.0 : 2.0,
                ),
              ),
            ),
          );
          break;
        case 4:
          list.add(
            Container(
              width: 20.0,
              height: 20.0,
              padding: EdgeInsets.all(0),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.all(new Radius.circular(22.0)),
                border: new Border.all(
                  color: conditionclosed
                      ? Color.fromARGB(255, 104, 22, 16)
                      : Colors.black,
                  width: conditionclosed ? 10.0 : 2.0,
                ),
              ),
            ),
          );
          break;

        default:
          list.add(
            Container(
              width: 20.0,
              height: 20.0,
              padding: EdgeInsets.all(0),
              decoration: new BoxDecoration(
                // color: circleColor,
                borderRadius: new BorderRadius.all(new Radius.circular(22.0)),
                border: new Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),

              /* child: Icon(
            Icons.radio_button_off_outlined,
            color: Colors.black,
            size: 20.0,
          ), */
            ),
          );
          break;
      }
      //line between icons
      if (i != titles.length - 1) {
        list.add(Expanded(
            child: Container(
          height: 1.5,
          color: Colors.black,
        )));
      }
    });

    return list;
  }

  List<Widget> _titleViews() {
    var list = <Widget>[];
    titles.asMap().forEach((i, text) {
      list.add(Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
              )),
        ),
      ));
    });
    return list;
  }

  Line() {
    return Divider(
      thickness: 1.0,
      color: Colors.grey,
    );
  }
}
