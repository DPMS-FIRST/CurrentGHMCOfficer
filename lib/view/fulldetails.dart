import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ghmcofficerslogin/model/full_details_response.dart';
import 'package:ghmcofficerslogin/model/shared_model.dart';


import 'package:ghmcofficerslogin/res/components/background_image.dart';
import 'package:ghmcofficerslogin/res/components/searchbar.dart';
import 'package:ghmcofficerslogin/res/components/sharedpreference.dart';
import 'package:ghmcofficerslogin/res/components/showtoast.dart';

import 'package:ghmcofficerslogin/res/constants/ApiConstants/api_constants.dart';
import 'package:ghmcofficerslogin/res/constants/Images/image_constants.dart';

import 'package:ghmcofficerslogin/res/constants/text_constants/text_constants.dart';
import 'package:ghmcofficerslogin/View/grievance_history.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FullGrievanceDetails extends StatefulWidget {
  const FullGrievanceDetails({super.key});

  @override
  State<FullGrievanceDetails> createState() => _FullGrievanceDetailsState();
}

class _FullGrievanceDetailsState extends State<FullGrievanceDetails> {
  StreamSubscription? connection;
  bool isoffline = false;
  GrievanceFullDetails? grievanceFullDetails;
  String errorMessage = '';
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  String? image1;
  List<Grievance> _fullGrievancesListResponse = [];
  List<Grievance> _fullGrievancesSearchListResponse = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          TextConstants.full_grievance_details,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          BgImage(imgPath: ImageConstants.bg),
          Column(
            children: [
              ReusableSearchbar(
                bgColor: Colors.white,
                screenHeight: 0.05,
                searchIcon: Icon(Icons.search),
                topPadding: 8.0,
                onChanged: (value) => _runFilter(value),
                screenWidth: 1,
                onPressed: () {},
              ),
              /* TextField(
                onChanged: (value) => _runFilter(value),
                decoration: InputDecoration(
                    labelText: "", suffixIcon: Icon(Icons.search)),
              ),  */
              Expanded(
                  child: ListView.builder(
                      itemCount: _fullGrievancesSearchListResponse.length,
                      itemBuilder: (context, index) {
                        final details =
                            _fullGrievancesSearchListResponse[index];
                        return GestureDetector(
                          onTap: () async {
                            var result = await Connectivity().checkConnectivity();
                            if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi)
                            {
                            await SharedPreferencesClass().writeTheData(
                                PreferenceConstants.historydetails, details.id);
                            //print(details?.id);
                            EasyLoading.show();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GrievanceHistory(),
                                ));
                            }
                            else if(result == ConnectivityResult.none)
                            {
                              ShowToats.showToast(
                                  "Check your internet connection", 
                                  gravity:  ToastGravity.BOTTOM,
                                  bgcolor: Colors.white,
                                  textcolor: Colors.black
                                  );
                            }
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black87, width: 1),
                            ),
                            color: Colors.transparent,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Column(
                                children: [
                                  RowComponent(
                                    TextConstants.id,
                                    details.id,
                                  ),
                                  RowComponent(
                                    TextConstants.type,
                                    details.type,
                                  ),
                                  RowComponent(
                                    TextConstants.time_stamp,
                                    details.timestamp,
                                  ),
                                  RowComponent(
                                    TextConstants.status,
                                    details.status,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      setImage(
                                        details.photo,
                                        onTap: () {
                                          if (details.photo!.contains('.pdf')) {
                                            _pdfViewerKey.currentState?.openBookmarkView();
                                            showAlert(details.photo);
                                          
                                          } else if (details.photo!
                                                  .contains('.jpg') ||
                                              details.photo!.contains('.png') ||
                                              details.photo!
                                                  .contains('.jpeg')) {
                                            showAlertImage(details.photo);
                                          }
                                        },
                                      ),
                                      setImage(
                                        details.photo2,
                                        onTap: () {
                                          if (details.photo2!
                                              .contains('.pdf')) {
                                                 _pdfViewerKey.currentState?.openBookmarkView();
                                            showAlert(details.photo2);
                                          } else if (details.photo2!
                                                  .contains('.jpg') ||
                                              details.photo2!
                                                  .contains('.png') ||
                                              details.photo2!
                                                  .contains('.jpeg')) {
                                            showAlertImage(details.photo2);
                                          }
                                        },
                                      ),
                                      setImage(
                                        details.photo3,
                                        onTap: () {
                                          if (details.photo3!
                                              .contains('.pdf')) {
                                                 _pdfViewerKey.currentState?.openBookmarkView();
                                            showAlert(details.photo3);
                                            
                                          } else if (details.photo3!
                                                  .contains('.jpg') ||
                                              details.photo3!
                                                  .contains('.png') ||
                                              details.photo3!
                                                  .contains('.jpeg')) {
                                            showAlertImage(details.photo3);
                                          }
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      })),
            ],
          ),
        ],
      ),
    );
  }

  setImage(_backgroundImage, {void Function()? onTap}) {
    if (_backgroundImage.contains('.pdf')) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(top: 10.0),
          child: Image.asset(
            ImageConstants.viewpdf,
            width: 80,
            height: 50,
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(top: 10.0),
          child: Image.asset(
            ImageConstants.viewimage,
            width: 80,
            height: 60,
          ),
        ),
      );
    }
  }

  RowComponent(var data, var value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              data.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
          SizedBox(
            width: 4,
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.toString(),
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    connection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // whenevery connection status is changed.
      if (result == ConnectivityResult.none) {
        //there is no any connection
        setState(() {
          isoffline = true;
        });
      } else if (result == ConnectivityResult.mobile) {
        //connection is mobile data network
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        //connection is from wifi
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.ethernet) {
        //connection is from wired connection
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.bluetooth) {
        //connection is from bluetooth threatening
        setState(() {
          isoffline = false;
        });
      }
    });
    super.initState();
    fetchDetails();
  }

  fetchDetails() async {
    var compid = await SharedPreferencesClass()
        .readTheData(PreferenceConstants.fulldetails);
    var modeid = await SharedPreferencesClass()
        .readTheData(PreferenceConstants.userdetails);
    var uid =
        await SharedPreferencesClass().readTheData(PreferenceConstants.empd);
    var typeid =
        await SharedPreferencesClass().readTheData(PreferenceConstants.typeid);
    var slftype =
        await SharedPreferencesClass().readTheData(PreferenceConstants.totalid);

//creating request url with base url and endpoint
    const requesturl = ApiConstants.baseurl + ApiConstants.fulldetails_endpoint;
    //creating payload because request type is POST
    var requestPayload = {
      "userid": "cgg@ghmc",
      "password": "ghmc@cgg@2018",
      "uid": uid,
      "mode": modeid,
      "comptype": compid,
      "type_id": typeid,
      "slftype": slftype
    };
    print(requestPayload);
    //no headers and authorization

    //creating dio object in order to connect package to server
    final dioObject = Dio();

    try {
      final response = await dioObject.post(
        requesturl,
        data: requestPayload,
      );

      //converting response from String to json
      final data = GrievanceFullDetails.fromJson(response.data);
      //print(response.data);
      setState(() {
        if (data.status == "true") {
          EasyLoading.dismiss();
          if (data.grievance != null && data.grievance!.length > 0) {
            grievanceFullDetails = data;
            _fullGrievancesListResponse = grievanceFullDetails!.grievance!;
            _fullGrievancesSearchListResponse = _fullGrievancesListResponse;
          }
        }
      });
    } on DioError catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 500) {
        //final errorMessage = e.response?.data["message"];
        // showAlert(errorMessage);
      }
      print("error is $e");

      //print("status code is ${e.response?.statusCode}");
    }
// step 5: print the response
  }

  _runFilter(String enteredKeyword) {
    List<Grievance> results = [];
    if (enteredKeyword.isEmpty) {
      results = _fullGrievancesListResponse;
    } else {
      print(enteredKeyword);
      results = _fullGrievancesListResponse
          .where((element) =>
              element.id!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();

      setState(() {
        _fullGrievancesSearchListResponse = results;
        print(_fullGrievancesSearchListResponse.length);
      });
    }
  }

  showAlert(String? photo) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return 
            SfPdfViewer.network(photo!,
             onDocumentLoadFailed:((details) {
                print("not working");
             }),
            key: _pdfViewerKey,
            
            );
        });
    //showDialog
  }

  showAlertImage(String? photo) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            actions: [
              Center(
                  child: Container(
                      child: /* FadeInImage(image: NetworkImage(photo!), 
                placeholder: AssetImage(ImageConstants.no_uploaded),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(ImageConstants.no_uploaded, fit: BoxFit.fitWidth,);
                },
                fit: BoxFit.fitWidth,
                ) */
                          Image.network(
                photo!,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(ImageConstants.no_uploaded);
                },
              ))),
            ],
          );
        });
  }
}
/* 
https://GhmcMobileApp.ghmc.gov.in/Areas/grievancephotos/p30911201068345.pdf
https://ghmcmobileapp.ghmc.gov.in/Areas/grievancephotos/051219613680.pdf
https://GhmcMobileApp.ghmc.gov.in/Areas/grievancephotos/p32210201039480.pdf
https://GhmcMobileApp.ghmc.gov.in/Areas/grievancephotos/p32110201036747.pdf
https://GhmcMobileApp.ghmc.gov.in/Areas/grievancephotos/p21910201032355.pdf
https://GhmcMobileApp.ghmc.gov.in/Areas/grievancephotos/p31910201032355.pdf
https://GhmcMobileApp.ghmc.gov.in/Areas/grievancephotos/p2160920972231.pdf
https://GhmcMobileApp.ghmc.gov.in/Areas/grievancephotos/p3160920972231.pdf
https://GhmcMobileApp.ghmc.gov.in/Areas/grievancephotos/p2120920965788.pdf
https://GhmcMobileApp.ghmc.gov.in/Areas/grievancephotos/p3120920965788.pdf
 */
