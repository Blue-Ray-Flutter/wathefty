import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_version/new_version.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wathefty/API.dart';
import 'package:wathefty/Pages/individual/Disability.dart';
import 'package:wathefty/Pages/public/guest_job_list.dart';
import 'dart:ui' as ui;
import 'package:wathefty/data.dart';
import 'package:wathefty/main.dart';
import 'Pages/company/home.dart';
import 'Pages/company/job_list.dart';
import 'Pages/company/menu.dart';
import 'Pages/company/settings.dart';
import 'Pages/individual/home.dart';
import 'Pages/individual/menu.dart';
import 'Pages/individual/my_jobs.dart';
import 'Pages/individual/profile.dart';
import 'Pages/individual/settings.dart';
import 'Pages/public/filter_individuals.dart';

String lang = "ar";
String globalImage = 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png', globalUid = '0', globalType = 'Guest';
List<String> imgList = ['https://www.pngall.com/wp-content/uploads/8/Job-Work-PNG-File.png'];
Future<Map> loadUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var uid = prefs.getString('uid');
  var img = prefs.getString('profile_photo_path') ?? 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png';
  var type = prefs.getString('type');
  if (uid != null) {
    globalType = type as String;
    globalUid = uid;
    globalImage = img;
    return {'uid': uid, 'image': img, 'type': type};
  } else {
    return {};
  }
}

Future<Map> logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var provider = prefs.getString('provider');
  Map tmp = await logoutAPI();
  if (!tmp['status']) {
    Get.snackbar(tr("Please make sure you're connected to the internet"), '',
        duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.orange, leftBarIndicatorColor: Colors.orange);
    return {};
  }
  if (provider == 'facebook') {
    await FacebookAuth.instance.logOut();
  } else if (provider == 'google') {
    // await _googleSignIn.disconnect();
  }
  prefs.clear();
  Get.offAll(() => StartPage());
  globalType = 'Guest';
  globalUid = '0';
  globalImage = 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png';
  return tmp;
}

// List lst = [];
// Future loadpictures() async {
//   Uri url = Uri.https('takallam-live.com', '/app/getImages');
//   var response = await http.post(url);
//   List pict = [];
//   if (response.statusCode == 200) {
//     Map<String, dynamic> map = json.decode(response.body);
//     List<dynamic> data = map["data"];
//     if (data.isNotEmpty) {
//       for (var u in data) {
//         pict.add(u['url']);
//       }
//       lst = pict;
//       return pict;
//     }
//   } else {
//     return pict;
//   }
// }
// advancedStatusCheck(NewVersion newVersion, BuildContext context) async {
//   final status = await newVersion.getVersionStatus();
//   if (status == null) return;
//   if (status.canUpdate) {
//     newVersion.showUpdateDialog(
//       allowDismissal: false,
//       context: context,
//       versionStatus: status,
//       dialogTitle: tr('A new update is available'),
//       dialogText: tr('Please update the application to keep using it'),
//     );
//   }
// }
updateCheck(BuildContext context) {
  final newVersion = NewVersion(iOSAppStoreCountry: 'JO');
  newVersion.showAlertIfNecessary(context: context);
}

selectLanguage(BuildContext context) {
  var language = context.locale.toString();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: GestureDetector(
              onTap: () async {
                var _newLocale = (language == 'ar' ? const Locale('en') : const Locale('ar'));
                await context.setLocale(_newLocale);
                lang = language == 'ar' ? "en" : "ar";
                Get.updateLocale(_newLocale);
                Get.back();
              },
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color: Colors.black12),
                  ),
                  alignment: Alignment.center,
                  height: 70,
                  width: 70,
                  child: Text(language == 'ar' ? "English" : "عربي", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black))),
            ));
      });
}

AppBar watheftyBar(BuildContext context, String title, double fontSize) {
  return AppBar(
      centerTitle: true,
      leading: IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back), color: Colors.white),
      actions: [
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: IconButton(
                icon: Icon(Icons.language, color: Colors.white),
                onPressed: () {
                  selectLanguage(context);
                }))
      ],
      backgroundColor: hexStringToColor('#6986b8'),
      elevation: 0,
      title: Text(title, style: TextStyle(fontSize: fontSize, color: Colors.white)).tr());
}

BottomAppBar watheftyBottomBar(BuildContext context) {
  if (globalType == 'Individual') {
    return BottomAppBar(
        child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      SizedBox(width: 2),
      IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Get.offAll(() => HomePage());
          }),
      IconButton(
          icon: Icon(Icons.list_alt),
          onPressed: () {
            Get.to(() => IndividualMyJobsPage());
          }),
      Container(
          height: 35,
          width: 35,
          child: TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.blueGrey,
                  onSurface: Colors.grey,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(bottom: 1.0, left: 1),
                  shape: (CircleBorder(side: BorderSide(color: Colors.white)))),
              onPressed: () {
                Get.to(() => IndivSubMenu());
              },
              child: CircleAvatar(backgroundImage: NetworkImage(globalImage)))),
      SizedBox(width: 2)
    ]));
  } else if (globalType == 'Company') {
    return BottomAppBar(
        child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      SizedBox(width: 2),
      IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Get.to(() => CompanyHomePage());
          }),
      IconButton(
          icon: Icon(Icons.list_alt),
          onPressed: () {
            Get.offAll(() => CompanyJobListPage(jobType: 1));
          }),
      Container(
          height: 35,
          width: 35,
          child: TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.blueGrey,
                  onSurface: Colors.grey,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(bottom: 1.0, left: 1),
                  shape: (CircleBorder(side: BorderSide(color: Colors.white)))),
              onPressed: () {
                Get.to(() => CompanySubMenu());
              },
              child: CircleAvatar(backgroundImage: NetworkImage(globalImage)))),
      SizedBox(width: 2)
    ]));
  } else {
    return BottomAppBar(
        child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      SizedBox(width: 2),
      IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Get.offAll(() => StartPage());
          }),
      IconButton(
          icon: Icon(Icons.list_alt),
          onPressed: () {
            Get.to(() => GuestPage());
          }),
      IconButton(
          icon: Icon(Icons.people),
          onPressed: () {
            Get.to(() => People());
          }),
      SizedBox(width: 2)
    ]));
  }
}

Future commentDialog(BuildContext context, uType, type, lang, uid, tID, tType, Map? reviewData) async {
  final data = TextEditingController();
  var loading = false;
  var rate;
  String report = '';
  if (type == 'review' || type == 'company review' || type == "search review" || type == "CV search review") {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
    rate = 5;
  }
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text('  Add a ' + type).tr(),
            actions: [
              StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
                return !loading
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: hexStringToColor('#6986b8'),
                        ),
                        onPressed: () async {
                          if (data.text.isEmpty && type == 'comment') {
                            Get.snackbar(tr("Message can't be empty"), '',
                                duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.orange, leftBarIndicatorColor: Colors.orange);
                            return;
                          }
                          if ((data.text.isEmpty || report.isEmpty) && type == 'report') {
                            Get.snackbar(tr("Message can't be empty and you have to select a type"), '',
                                duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.orange, leftBarIndicatorColor: Colors.orange);
                            return;
                          }
                          if (type == "search review" || type == "CV search review") reviewData!["review_value"] = rate.toString();
                          _setState(() => loading = true);
                          var stt = await comment(uType, type, lang, uid, type != 'report' ? data.text : {'text': data.text, 'type': report}, tID, tType,
                              (type == "search review" || type == "CV search review") ? reviewData : rate);
                          _setState(() => loading = false);
                          if (stt['status'] == true) {
                            data.clear();
                            Get.back();
                            Get.snackbar(stt['msg'], '', duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.blue, leftBarIndicatorColor: Colors.blue);
                          }
                        },
                        child: Text('Continue', style: TextStyle(color: Colors.white)).tr())
                    : Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator());
              }),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    data.clear();
                  },
                  child: Text('Cancel').tr())
            ],
            content: IntrinsicHeight(
                child: SingleChildScrollView(
                    child: Container(
                        width: getWH(context, 2),
                        child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                          if (type == 'report')
                            Container(
                                padding: EdgeInsets.only(left: 15),
                                margin: EdgeInsets.only(bottom: 10, top: 20),
                                child: Text('Violation type', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                          if (type == 'report')
                            SelectFormField(
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return tr('Please select type of violatlion');
                                  }
                                  return null;
                                },
                                type: SelectFormFieldType.dropdown,
                                items: arrtoList(reportArr, lang, ''),
                                decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.arrow_drop_down),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                onChanged: (val) {
                                  report = val;
                                }),
                          if (type == 'review' || type == 'company review' || type == "search review" || type == "CV search review")
                            RatingBar.builder(
                              initialRating: 5,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemSize: 35,
                              itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                rate = rating.toString();
                              },
                            ),
                          SizedBox(height: 20),
                          if (type != "search review" && type != "CV search review")
                            TextField(
                                minLines: type == 'comment' ? 6 : 4,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                style: TextStyle(color: Colors.blueGrey),
                                controller: data),
                          SizedBox(height: 50),
                        ])))));
      });
}

Color hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}

double getWH(BuildContext context, i) {
  if (i == 1) {
    i = MediaQuery.of(context).size.height;
  } else {
    i = MediaQuery.of(context).size.width;
  }
  return i;
}

Future updatePrompt(BuildContext context, iType, lang, type) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uid = prefs.getString('uid') as String;
  bool loading = false;
  var valu;
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: StatefulBuilder(builder: (BuildContext context, StateSetter _ssetState) {
              return SingleChildScrollView(
                  child: Container(
                      height: getWH(context, 1) * 0.5,
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: getInfo(iType, lang, type),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.connectionState == ConnectionState.done && iType == 'skill') {
                              var skillAr = TextEditingController();
                              var skillEn = TextEditingController();
                              return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(color: Colors.black12)),
                                  alignment: Alignment.center,
                                  child: !loading
                                      ? Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          SelectFormField(
                                              decoration: InputDecoration(
                                                  hintText: tr('Select Skill'),
                                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                              type: SelectFormFieldType.dropdown,
                                              items: mp,
                                              onChanged: (val) => valu = (val),
                                              onSaved: (val) => valu = (val)),
                                          ExpandablePanel(
                                              header: Text("Can't find what you're looking for? Request it here", style: TextStyle(color: Colors.blueGrey, fontSize: 16)).tr(),
                                              collapsed: Text('Tap to expand', style: TextStyle(color: Colors.black, fontSize: 14), softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis).tr(),
                                              expanded: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                Text('Skill in Arabic', style: TextStyle(fontSize: 13)).tr(),
                                                Container(
                                                    margin: EdgeInsets.symmetric(vertical: 5),
                                                    height: getWH(context, 1) * 0.05,
                                                    child: TextField(
                                                        style: TextStyle(color: Colors.blueGrey),
                                                        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                                        controller: skillAr,
                                                        textDirection: ui.TextDirection.rtl)),
                                                Text('Skill in English', style: TextStyle(fontSize: 13)).tr(),
                                                Container(
                                                    margin: EdgeInsets.symmetric(vertical: 5),
                                                    height: getWH(context, 1) * 0.05,
                                                    child: TextField(
                                                        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                                        style: TextStyle(color: Colors.blueGrey),
                                                        controller: skillEn,
                                                        textDirection: ui.TextDirection.ltr))
                                              ])),
                                          StatefulBuilder(builder: (BuildContext context, StateSetter _ssetState) {
                                            return !loading
                                                ? TextButton(
                                                    style: ButtonStyle(
                                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                        minimumSize: MaterialStateProperty.all(Size(double.infinity, 44)),
                                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
                                                        backgroundColor: MaterialStateProperty.all(hexStringToColor('#6986b8'))),
                                                    onPressed: () async {
                                                      if (valu != null || (skillAr.text.isNotEmpty && skillEn.text.isNotEmpty)) {
                                                        _ssetState(() {
                                                          loading = true;
                                                        });
                                                        var tmp = await updateInfo('skill', lang, type, uid, valu, skillAr.text, skillEn.text);
                                                        _ssetState(() {
                                                          loading = false;
                                                        });
                                                        if (tmp != null && tmp['status']) {
                                                          Get.offAll(() => IndivProfilePage());
                                                        }
                                                      } else {
                                                        Get.snackbar(tr('Please select a value'), '',
                                                            duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.red, leftBarIndicatorColor: Colors.red);
                                                      }
                                                    },
                                                    child: Text('Add', style: TextStyle(color: Colors.white)).tr())
                                                : Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                                          })
                                        ])
                                      : Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                            } else if (snapshot.hasData && snapshot.connectionState == ConnectionState.done && iType == 'jsection') {
                              return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    border: Border.all(
                                      color: Colors.black12,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: !loading
                                      ? Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                          SelectFormField(
                                            type: SelectFormFieldType.dropdown,
                                            icon: Icon(Icons.arrow_right),
                                            labelText: tr('Select'),
                                            items: mp,
                                            onChanged: (val) => valu = (val),
                                            onSaved: (val) => valu = (val),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              if (valu != null) {
                                                // var  section = valu;
                                                Get.back();
                                              } else {
                                                Get.snackbar(tr('Please select a value'), '',
                                                    duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.red, leftBarIndicatorColor: Colors.red);
                                              }
                                            },
                                            icon: Icon(Icons.check),
                                            iconSize: 30,
                                          )
                                        ])
                                      : Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                            } else if (snapshot.hasData && snapshot.connectionState == ConnectionState.done && iType == 'jspecialty') {
                              return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    border: Border.all(
                                      color: Colors.black12,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: !loading
                                      ? Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                          SelectFormField(
                                            type: SelectFormFieldType.dropdown,
                                            icon: Icon(Icons.arrow_right),
                                            labelText: tr('Select'),
                                            items: mp,
                                            onChanged: (val) => valu = (val),
                                            onSaved: (val) => valu = (val),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              if (valu != null) {
                                                // specialty = valu;
                                                Get.back();
                                              } else {
                                                Get.snackbar(tr('Please select a value'), '',
                                                    duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.red, leftBarIndicatorColor: Colors.red);
                                              }
                                            },
                                            icon: Icon(Icons.check),
                                            iconSize: 30,
                                          )
                                        ])
                                      : Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                            } else if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                            } else {
                              return SizedBox();
                            }
                          })));
            }));
      });
}

Future certFormPrompt(BuildContext context, iType, lang, type) async {
  final courseAr = TextEditingController();
  final courseEn = TextEditingController();
  final orgAr = TextEditingController();
  final orgEn = TextEditingController();
  final orgAddAr = TextEditingController();
  final orgAddEn = TextEditingController();
  final start = TextEditingController();
  bool loading = false;
  final end = TextEditingController();
  ScrollController _scrollController = ScrollController();
  FilePickerResult? image;
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                height: getWH(context, 1) * 0.8,
                width: getWH(context, 2) * 0.8,
                child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(color: Colors.black12)),
                        alignment: Alignment.center,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                          Text('Course title En', style: TextStyle(fontSize: 13)).tr(),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              height: getWH(context, 1) * 0.05,
                              child: TextField(
                                style: TextStyle(color: Colors.blueGrey),
                                decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                controller: courseEn,
                                textDirection: ui.TextDirection.ltr,
                                onSubmitted: (value) {
                                  courseEn.text = value;
                                },
                              )),
                          Text('Course title Ar', style: TextStyle(fontSize: 13)).tr(),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              height: getWH(context, 1) * 0.05,
                              child: TextField(
                                decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                style: TextStyle(color: Colors.blueGrey),
                                controller: courseAr,
                                textDirection: ui.TextDirection.rtl,
                                onSubmitted: (value) {
                                  courseAr.text = value;
                                },
                              )),
                          Text('Organization name En', style: TextStyle(fontSize: 13)).tr(),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              height: getWH(context, 1) * 0.05,
                              child: TextField(
                                decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                style: TextStyle(color: Colors.blueGrey),
                                controller: orgEn,
                                textDirection: ui.TextDirection.ltr,
                                onSubmitted: (value) {
                                  orgEn.text = value;
                                },
                              )),
                          Text('Organization name Ar', style: TextStyle(fontSize: 13)).tr(),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              height: getWH(context, 1) * 0.05,
                              child: TextField(
                                decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                style: TextStyle(color: Colors.blueGrey),
                                controller: orgAr,
                                textDirection: ui.TextDirection.rtl,
                                onSubmitted: (value) {
                                  orgAr.text = value;
                                },
                              )),
                          Text('Organization address En', style: TextStyle(fontSize: 13)).tr(),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              height: getWH(context, 1) * 0.05,
                              child: TextField(
                                decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                style: TextStyle(color: Colors.blueGrey),
                                controller: orgAddEn,
                                onTap: () {
                                  Future.delayed(Duration(milliseconds: 300), () {
                                    _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.ease);
                                  });
                                },
                                textDirection: ui.TextDirection.ltr,
                                onSubmitted: (value) {
                                  orgAddEn.text = value;
                                },
                              )),
                          Text('Organization address Ar', style: TextStyle(fontSize: 13)).tr(),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              height: getWH(context, 1) * 0.05,
                              child: TextField(
                                decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                style: TextStyle(color: Colors.blueGrey),
                                controller: orgAddAr,
                                textDirection: ui.TextDirection.rtl,
                                onTap: () {
                                  Future.delayed(Duration(milliseconds: 300), () {
                                    _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.ease);
                                  });
                                },
                                onSubmitted: (value) {
                                  orgAddAr.text = value;
                                },
                              )),
                          SizedBox(height: 5),
                          StatefulBuilder(builder: (BuildContext context, StateSetter _setStart) {
                            return TextButton(
                                style: ButtonStyle(
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    minimumSize: MaterialStateProperty.all(Size(double.infinity, 44)),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
                                onPressed: () {
                                  var now = DateTime.now();
                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime(now.year - 60, now.month, now.day + 1),
                                      maxTime: DateTime(now.year + 1, now.month + 12),
                                      onChanged: (date) {}, onConfirm: (date) {
                                    _setStart(() {
                                      start.text = date.toString().substring(0, 10);
                                    });
                                  }, currentTime: DateTime.now(), locale: lang == 'ar' ? LocaleType.ar : LocaleType.en);
                                },
                                child: Text(start.text.isNotEmpty ? start.text : 'Choose a start date', style: TextStyle(color: Colors.white)).tr());
                          }),
                          SizedBox(height: 5),
                          StatefulBuilder(builder: (BuildContext context, StateSetter _setEnd) {
                            return TextButton(
                                style: ButtonStyle(
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    minimumSize: MaterialStateProperty.all(Size(double.infinity, 44)),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
                                    backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
                                onPressed: () {
                                  if (start.text.isEmpty) {
                                    Get.snackbar(tr('Please select a start date first'), '',
                                        duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.amber, leftBarIndicatorColor: Colors.amber);
                                    return;
                                  }
                                  var now = DateTime.now();
                                  DatePicker.showDatePicker(context, showTitleActions: true, minTime: DateTime(now.year - 60, now.month, now.day + 1), maxTime: DateTime(now.year + 1, now.month + 12),
                                      onChanged: (date) {
                                    DateTime st = DateTime.parse((start.text + ' 00:00:00'));
                                    if (st.isAfter(date)) {
                                      return Get.snackbar(tr("End date can't be before start date"), '',
                                          duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.amber, leftBarIndicatorColor: Colors.amber);
                                    }
                                  }, onConfirm: (date) {
                                    DateTime st = DateTime.parse((start.text + ' 00:00:00'));
                                    if (st.isAfter(date)) {
                                      return Get.snackbar(tr("End date can't be before start date"), '',
                                          duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.amber, leftBarIndicatorColor: Colors.amber);
                                    }
                                    _setEnd(() {
                                      end.text = date.toString().substring(0, 10);
                                    });
                                  }, currentTime: DateTime.now(), locale: lang == 'ar' ? LocaleType.ar : LocaleType.en);
                                },
                                child: Text(
                                  end.text.isNotEmpty ? end.text : 'Choose an end date',
                                  style: TextStyle(color: Colors.white),
                                ).tr());
                          }),
                          SizedBox(height: 5),
                          Text('Image', style: TextStyle(fontSize: 13)).tr(),
                          StatefulBuilder(builder: (BuildContext context, StateSetter setImage) {
                            return Row(children: [
                              Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      child: TextButton(
                                          onPressed: () async {
                                            image = await FilePicker.platform.pickFiles(type: FileType.image);
                                            setImage(() {});
                                          },
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                            Flexible(child: Text(image != null ? image!.files.first.name : '', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54))),
                                            Icon(Icons.file_upload_outlined, color: hexStringToColor('#6986b8'))
                                          ])))),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  height: 55,
                                  width: 55,
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 0.025),
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey[50],
                                      image: DecorationImage(fit: BoxFit.contain, image: image != null ? Image.file(File(image!.files.first.path!)).image : AssetImage('assets/logo.png'))))
                            ]);
                          }),
                          SizedBox(height: 20),
                          StatefulBuilder(builder: (BuildContext context, StateSetter _ssetState) {
                            return !loading
                                ? TextButton(
                                    style: ButtonStyle(
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        minimumSize: MaterialStateProperty.all(Size(double.infinity, 44)),
                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
                                        backgroundColor: MaterialStateProperty.all(hexStringToColor('#6986b8'))),
                                    onPressed: () async {
                                      _ssetState(() {
                                        loading = true;
                                      });
                                      Map inf = {
                                        'course_title_ar': courseAr.text,
                                        'course_title_en': courseEn.text,
                                        'organization_name_ar': orgAr.text,
                                        'organization_name_en': orgEn.text,
                                        'organization_address_ar': orgAddAr.text,
                                        'organization_address_en': orgAddEn.text,
                                        'start_date': start.text,
                                        'end_date': end.text,
                                        if (image != null) 'file': File(image!.files.first.path!)
                                      };
                                      var tmp = await addCourse(lang, inf);
                                      _ssetState(() {
                                        loading = false;
                                      });
                                      if (tmp['status'] != null && tmp['status']) {
                                        Get.offAll(() => IndivProfilePage());
                                        Get.snackbar(tr('Success'), '', duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.blue, leftBarIndicatorColor: Colors.blue);
                                        return;
                                      } else {
                                        Get.snackbar(tr('Check the fields and try again'), '',
                                            duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.red, leftBarIndicatorColor: Colors.red);
                                      }
                                    },
                                    child: Text('Add', style: TextStyle(color: Colors.white)).tr())
                                : Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                          }),
                        ])))));
      });
}

Future removePrompt(BuildContext context, iType, lang, type, iID) async {
  bool loading = false;
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(backgroundColor: Colors.transparent, actions: [
          StatefulBuilder(builder: (BuildContext context, StateSetter _ssetState) {
            return Container(
                height: getWH(context, 1) * 0.2,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(
                        color: Colors.black12,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: !loading
                        ? Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                            Text('Are you sure you want to remove this item?').tr(),
                            TextButton(
                                style: ButtonStyle(
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    minimumSize: MaterialStateProperty.all(Size(double.infinity, 44)),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
                                    backgroundColor: MaterialStateProperty.all(Colors.red[900])),
                                onPressed: () async {
                                  _ssetState(() {
                                    loading = true;
                                  });
                                  var tmp = await removeInfo(iType, lang, type, globalUid, iID);
                                  _ssetState(() {
                                    loading = false;
                                  });
                                  if (tmp != null && tmp['status']) {
                                    Get.offAll(() => IndivProfilePage());
                                    return;
                                  }
                                },
                                child: Text('Remove', style: TextStyle(color: Colors.white)).tr())
                          ])
                        : Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
          })
        ]);
      });
}

Future eduFormPrompt(BuildContext context, iType, lang, type) async {
  final academicDegreeId = TextEditingController();
  final majorNameEn = TextEditingController();
  final majorNameAr = TextEditingController();
  final avg = TextEditingController();
  final avgType = TextEditingController();
  final orgAr = TextEditingController();
  final orgEn = TextEditingController();
  final start = TextEditingController();
  bool loading = false;
  bool current = false;
  final end = TextEditingController();
  ScrollController _scrollController = ScrollController();
  FilePickerResult? image;
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                height: getWH(context, 1) * 0.8,
                width: getWH(context, 2) * 0.8,
                child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(color: Colors.black12)),
                        alignment: Alignment.center,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                          Text('Organization name En', style: TextStyle(fontSize: 13)).tr(),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              height: getWH(context, 1) * 0.05,
                              child: TextField(
                                style: TextStyle(color: Colors.blueGrey),
                                decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                controller: orgEn,
                                textDirection: ui.TextDirection.ltr,
                                onSubmitted: (value) {
                                  orgEn.text = value;
                                },
                              )),
                          Text('Organization name Ar', style: TextStyle(fontSize: 13)).tr(),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              height: getWH(context, 1) * 0.05,
                              child: TextField(
                                  style: TextStyle(color: Colors.blueGrey),
                                  decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                  controller: orgAr,
                                  textDirection: ui.TextDirection.rtl,
                                  onSubmitted: (value) {
                                    orgAr.text = value;
                                  })),
                          Text('Major title En', style: TextStyle(fontSize: 13)).tr(),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              height: getWH(context, 1) * 0.05,
                              child: TextField(
                                  style: TextStyle(color: Colors.blueGrey),
                                  decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                  controller: majorNameEn,
                                  textDirection: ui.TextDirection.ltr,
                                  onSubmitted: (value) {
                                    majorNameEn.text = value;
                                  })),
                          Text('Major title Ar', style: TextStyle(fontSize: 13)).tr(),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              height: getWH(context, 1) * 0.05,
                              child: TextField(
                                style: TextStyle(color: Colors.blueGrey),
                                decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                controller: majorNameAr,
                                textDirection: ui.TextDirection.ltr,
                                onSubmitted: (value) {
                                  majorNameAr.text = value;
                                },
                              )),
                          Text('Academic Degree', style: TextStyle(fontSize: 13)).tr(),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              height: getWH(context, 1) * 0.05,
                              child: SelectFormField(
                                  decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                  controller: academicDegreeId,
                                  type: SelectFormFieldType.dropdown,
                                  items: arrtoList(degreeArr, lang, ''),
                                  onSaved: (val) => (academicDegreeId.text = val!))),
                          Text('Average Type', style: TextStyle(fontSize: 13)).tr(),
                          DropdownSearch<Map>(
                            items: arrtoList(averageTypeArr, lang, ''),
                            maxHeight: 300,
                            popupItemBuilder: (context, item, isSelected) {
                              return Container(height: 50, child: Column(children: [Expanded(child: Text(item['label'])), Divider(thickness: 1, indent: 10, endIndent: 10)]));
                            },
                            dropdownBuilder: (context, selectedItem) {
                              if (selectedItem != null)
                                return Text(selectedItem['label']);
                              else
                                return Text('');
                            },
                            dropdownSearchDecoration: InputDecoration(
                                hintText: tr('Search'),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                            onChanged: (val) {
                              avgType.text = val!['value'].toString();
                            },
                            showSearchBox: true,
                          ),
                          Text('Average', style: TextStyle(fontSize: 13)).tr(),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              height: getWH(context, 1) * 0.05,
                              child: TextField(
                                  style: TextStyle(color: Colors.blueGrey),
                                  decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                  controller: avg,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  textDirection: ui.TextDirection.ltr,
                                  onTap: () {
                                    Future.delayed(Duration(milliseconds: 300), () {
                                      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.ease);
                                    });
                                  },
                                  onSubmitted: (value) {
                                    avg.text = value;
                                  })),
                          SizedBox(height: 5),
                          StatefulBuilder(builder: (BuildContext context, StateSetter _setStart) {
                            return TextButton(
                                style: ButtonStyle(
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    minimumSize: MaterialStateProperty.all(Size(double.infinity, 44)),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
                                onPressed: () {
                                  var now = DateTime.now();
                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime(now.year - 60, now.month, now.day + 1),
                                      maxTime: DateTime(now.year + 1, now.month + 12),
                                      onChanged: (date) {}, onConfirm: (date) {
                                    _setStart(() {
                                      start.text = date.toString().substring(0, 10);
                                    });
                                  }, currentTime: DateTime.now(), locale: lang == 'ar' ? LocaleType.ar : LocaleType.en);
                                },
                                child: Text(
                                  start.text.isNotEmpty ? start.text : 'Choose a start date',
                                  style: TextStyle(color: Colors.white),
                                ).tr());
                          }),
                          SizedBox(height: 5),
                          StatefulBuilder(builder: (BuildContext context, StateSetter setEnd) {
                            return Column(children: [
                              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                Checkbox(
                                    value: current,
                                    onChanged: (value) {
                                      setEnd(() {
                                        current = value!;
                                      });
                                    }),
                                Text('Ongoing').tr()
                              ]),
                              if (!current)
                                TextButton(
                                    style: ButtonStyle(
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        minimumSize: MaterialStateProperty.all(Size(double.infinity, 44)),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                                        ),
                                        backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
                                    onPressed: () {
                                      if (start.text.isEmpty) {
                                        Get.snackbar(tr('Please select a start date first'), '',
                                            duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.amber, leftBarIndicatorColor: Colors.amber);
                                        return;
                                      }
                                      var now = DateTime.now();
                                      DatePicker.showDatePicker(context,
                                          showTitleActions: true, minTime: DateTime(now.year - 60, now.month, now.day + 1), maxTime: DateTime(now.year + 1, now.month + 12), onChanged: (date) {
                                        DateTime st = DateTime.parse((start.text + ' 00:00:00'));
                                        if (st.isAfter(date)) {
                                          return Get.snackbar(tr("End date can't be before start date"), '',
                                              duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.amber, leftBarIndicatorColor: Colors.amber);
                                        }
                                      }, onConfirm: (date) {
                                        DateTime st = DateTime.parse((start.text + ' 00:00:00'));
                                        if (st.isAfter(date)) {
                                          return Get.snackbar(tr("End date can't be before start date"), '',
                                              duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.amber, leftBarIndicatorColor: Colors.amber);
                                        }
                                        setEnd(() {
                                          end.text = date.toString().substring(0, 10);
                                        });
                                      }, currentTime: DateTime.now(), locale: lang == 'ar' ? LocaleType.ar : LocaleType.en);
                                    },
                                    child: Text(
                                      end.text.isNotEmpty ? end.text : 'Choose an end date',
                                      style: TextStyle(color: Colors.white),
                                    ).tr())
                            ]);
                          }),
                          SizedBox(height: 5),
                          Text('Image', style: TextStyle(fontSize: 13)).tr(),
                          StatefulBuilder(builder: (BuildContext context, StateSetter setImage) {
                            return Row(children: [
                              Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      child: TextButton(
                                          onPressed: () async {
                                            image = await FilePicker.platform.pickFiles(type: FileType.image);
                                            setImage(() {});
                                          },
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                            Flexible(child: Text(image != null ? image!.files.first.name : '', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54))),
                                            Icon(Icons.file_upload_outlined, color: hexStringToColor('#6986b8'))
                                          ])))),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  height: 55,
                                  width: 55,
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 0.025),
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey[50],
                                      image: DecorationImage(fit: BoxFit.contain, image: image != null ? Image.file(File(image!.files.first.path!)).image : AssetImage('assets/logo.png'))))
                            ]);
                          }),
                          SizedBox(height: 20),
                          StatefulBuilder(builder: (BuildContext context, StateSetter _ssetState) {
                            return !loading
                                ? TextButton(
                                    style: ButtonStyle(
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        minimumSize: MaterialStateProperty.all(Size(double.infinity, 44)),
                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
                                        backgroundColor: MaterialStateProperty.all(hexStringToColor('#6986b8'))),
                                    onPressed: () async {
                                      _ssetState(() {
                                        loading = true;
                                      });
                                      Map inf = {
                                        'major_name_en': majorNameEn.text,
                                        'major_name_ar': majorNameAr.text,
                                        'average': avg.text,
                                        'average_type': avgType.text,
                                        'academec_degree_id': academicDegreeId.text,
                                        'organization_name_ar': orgAr.text,
                                        'organization_name_en': orgEn.text,
                                        'start_at': start.text,
                                        'until_now': current ? '1' : "2",
                                        if (!current) 'end_at': end.text,
                                        if (image != null) 'file': File(image!.files.first.path!)
                                      };
                                      var tmp = await addEducation(lang, inf);
                                      _ssetState(() {
                                        loading = false;
                                      });
                                      if (tmp['status'] != null && tmp['status'] != "false") {
                                        Get.offAll(() => IndivProfilePage());
                                        Get.snackbar(tmp['msg'], '', duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.blue, leftBarIndicatorColor: Colors.blue);
                                      } else {
                                        Get.snackbar(tr('Check the fields and try again'), '',
                                            duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.red, leftBarIndicatorColor: Colors.red);
                                      }
                                    },
                                    child: Text('Add', style: TextStyle(color: Colors.white)).tr())
                                : Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                          })
                        ])))));
      });
}

Future computerFormPrompt(BuildContext context) async {
  final skillEn = TextEditingController();
  final skillAr = TextEditingController();
  final programAr = TextEditingController();
  final programEn = TextEditingController();
  final version = TextEditingController();
  final lastUse = TextEditingController();
  final experience = TextEditingController();
  final months = TextEditingController();
  bool loading = false;
  ScrollController _scrollController = ScrollController();
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                height: getWH(context, 1) * 0.8,
                width: getWH(context, 2) * 0.8,
                child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(color: Colors.black12)),
                        alignment: Alignment.center,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                          Text('Skill name in Arabic', style: TextStyle(fontSize: 13)).tr(),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              height: getWH(context, 1) * 0.05,
                              child: TextField(
                                  style: TextStyle(color: Colors.blueGrey),
                                  decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                  controller: skillAr,
                                  textDirection: ui.TextDirection.rtl,
                                  onSubmitted: (value) {
                                    skillAr.text = value;
                                  })),
                          Text('Skill name in English', style: TextStyle(fontSize: 13)).tr(),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              height: getWH(context, 1) * 0.05,
                              child: TextField(
                                style: TextStyle(color: Colors.blueGrey),
                                decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                controller: skillEn,
                                textDirection: ui.TextDirection.ltr,
                                onSubmitted: (value) {
                                  skillEn.text = value;
                                },
                              )),
                          Text('Program in Arabic', style: TextStyle(fontSize: 13)).tr(),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              height: getWH(context, 1) * 0.05,
                              child: TextField(
                                  style: TextStyle(color: Colors.blueGrey),
                                  decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                  controller: programAr,
                                  textDirection: ui.TextDirection.rtl,
                                  onSubmitted: (value) {
                                    programAr.text = value;
                                  })),
                          Text('Program in English', style: TextStyle(fontSize: 13)).tr(),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              height: getWH(context, 1) * 0.05,
                              child: TextField(
                                style: TextStyle(color: Colors.blueGrey),
                                decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                controller: programEn,
                                textDirection: ui.TextDirection.ltr,
                                onSubmitted: (value) {
                                  programEn.text = value;
                                },
                              )),
                          Text('Version', style: TextStyle(fontSize: 13)).tr(),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              height: getWH(context, 1) * 0.05,
                              child: TextField(
                                style: TextStyle(color: Colors.blueGrey),
                                decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                controller: version,
                                textDirection: ui.TextDirection.ltr,
                                onSubmitted: (value) {
                                  version.text = value;
                                },
                              )),
                          Text('Experience in years', style: TextStyle(fontSize: 13)).tr(),
                          DropdownSearch<Map>(
                            items: numbers,
                            maxHeight: 300,
                            popupItemBuilder: (context, item, isSelected) {
                              return Container(height: 50, child: Column(children: [Expanded(child: Text(item['value'])), Divider(thickness: 1, indent: 10, endIndent: 10)]));
                            },
                            dropdownBuilder: (context, selectedItem) {
                              if (selectedItem != null)
                                return Text(selectedItem['value']);
                              else
                                return Text('');
                            },
                            dropdownSearchDecoration: InputDecoration(
                                hintText: tr('Search'),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                            onChanged: (val) {
                              experience.text = val!['value'].toString();
                            },
                            showSearchBox: true,
                          ),
                          Text('Experience in months', style: TextStyle(fontSize: 13)).tr(),
                          DropdownSearch<Map>(
                            items: numbers,
                            maxHeight: 300,
                            popupItemBuilder: (context, item, isSelected) {
                              return Container(height: 50, child: Column(children: [Expanded(child: Text(item['value'])), Divider(thickness: 1, indent: 10, endIndent: 10)]));
                            },
                            dropdownBuilder: (context, selectedItem) {
                              if (selectedItem != null)
                                return Text(selectedItem['value']);
                              else
                                return Text('');
                            },
                            dropdownSearchDecoration: InputDecoration(
                                hintText: tr('Search'),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                            onChanged: (val) {
                              months.text = val!['value'].toString();
                            },
                            showSearchBox: true,
                          ),
                          Text('Last year of use', style: TextStyle(fontSize: 13)).tr(),
                          SizedBox(height: 5),
                          StatefulBuilder(builder: (BuildContext context, StateSetter setYear) {
                            return TextButton(
                                style: ButtonStyle(
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    minimumSize: MaterialStateProperty.all(Size(double.infinity, 44)),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
                                onPressed: () {
                                  DatePicker.showPicker(context,
                                      showTitleActions: true,
                                      pickerModel: CustomPicker(minTime: DateTime(2011, 1, 1, 1, 1), maxTime: DateTime(DateTime.now().year + 1, 1, 1, 1, 1), currentTime: DateTime.now()),
                                      locale: lang == 'ar' ? LocaleType.ar : LocaleType.en, onConfirm: (date) {
                                    setYear(() {
                                      lastUse.text = date.toString().substring(0, 4);
                                    });
                                  });
                                },
                                child: Text(
                                  lastUse.text.isNotEmpty ? lastUse.text : tr('Choose a year'),
                                  style: TextStyle(color: Colors.white),
                                ).tr());
                          }),
                          SizedBox(height: 20),
                          StatefulBuilder(builder: (BuildContext context, StateSetter _ssetState) {
                            return !loading
                                ? TextButton(
                                    style: ButtonStyle(
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        minimumSize: MaterialStateProperty.all(Size(double.infinity, 44)),
                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
                                        backgroundColor: MaterialStateProperty.all(hexStringToColor('#6986b8'))),
                                    onPressed: () async {
                                      _ssetState(() {
                                        loading = true;
                                      });
                                      Map inf = {
                                        'skill_title_ar': skillAr.text,
                                        'skill_title_en': skillEn.text,
                                        'program_type_ar': programAr.text,
                                        'program_type_en': programEn.text,
                                        'version': version.text,
                                        'last_year_of_use': lastUse.text,
                                        'number_of_years_of_experience': experience.text,
                                        'number_of_months_of_experience': months.text,
                                      };
                                      var tmp = await addComputer(inf);
                                      _ssetState(() {
                                        loading = false;
                                      });
                                      if (tmp['status'] != null && tmp['status'] != "false") {
                                        Get.offAll(() => IndivProfilePage());
                                        Get.snackbar(tmp['msg'], '', duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.blue, leftBarIndicatorColor: Colors.blue);
                                      } else {
                                        Get.snackbar(tr('Check the fields and try again'), '',
                                            duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.red, leftBarIndicatorColor: Colors.red);
                                      }
                                    },
                                    child: Text('Add', style: TextStyle(color: Colors.white)).tr())
                                : Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                          })
                        ])))));
      });
}

Future expFormPrompt(BuildContext context, iType, lang, type) async {
  final posAr = TextEditingController();
  final posEn = TextEditingController();
  final compAr = TextEditingController();
  final compEn = TextEditingController();
  final start = TextEditingController();
  final end = TextEditingController();
  FilePickerResult? image;
  bool loading = false;
  bool current = false;
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: StatefulBuilder(builder: (BuildContext context, StateSetter _ssetState) {
              return Container(
                  height: getWH(context, 1) * 0.8,
                  width: getWH(context, 2) * 0.8,
                  child: SingleChildScrollView(
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(color: Colors.black12)),
                          alignment: Alignment.center,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                            Text('Company name Ar', style: TextStyle(fontSize: 13)).tr(),
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                height: getWH(context, 1) * 0.05,
                                child: TextField(
                                    style: TextStyle(color: Colors.blueGrey),
                                    decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                    controller: compAr,
                                    textDirection: ui.TextDirection.rtl,
                                    onSubmitted: (value) {
                                      compEn.text = value;
                                    })),
                            Text('Company name En', style: TextStyle(fontSize: 13)).tr(),
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                height: getWH(context, 1) * 0.05,
                                child: TextField(
                                    style: TextStyle(color: Colors.blueGrey),
                                    decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                    controller: compEn,
                                    textDirection: ui.TextDirection.ltr,
                                    onSubmitted: (value) {
                                      compAr.text = value;
                                    })),
                            Text('Position Ar', style: TextStyle(fontSize: 13)).tr(),
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                height: getWH(context, 1) * 0.05,
                                child: TextField(
                                  style: TextStyle(color: Colors.blueGrey),
                                  decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                  textDirection: ui.TextDirection.rtl,
                                  controller: posAr,
                                  onSubmitted: (value) {
                                    posAr.text = value;
                                  },
                                )),
                            Text('Position En', style: TextStyle(fontSize: 13)).tr(),
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                height: getWH(context, 1) * 0.05,
                                child: TextField(
                                    style: TextStyle(color: Colors.blueGrey),
                                    decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                    controller: posEn,
                                    textDirection: ui.TextDirection.ltr,
                                    onSubmitted: (value) {
                                      posEn.text = value;
                                    })),
                            SizedBox(height: 5),
                            StatefulBuilder(builder: (BuildContext context, StateSetter _setStart) {
                              return TextButton(
                                  style: ButtonStyle(
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      minimumSize: MaterialStateProperty.all(Size(double.infinity, 44)),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                                      ),
                                      backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
                                  onPressed: () {
                                    var now = DateTime.now();
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime(now.year - 60, now.month, now.day + 1),
                                        maxTime: DateTime(now.year + 1, now.month + 12),
                                        onChanged: (date) {}, onConfirm: (date) {
                                      _setStart(() {
                                        start.text = date.toString().substring(0, 10);
                                      });
                                    }, currentTime: DateTime.now(), locale: lang == 'ar' ? LocaleType.ar : LocaleType.en);
                                  },
                                  child: Text(
                                    start.text.isNotEmpty ? start.text : 'Choose a start date',
                                    style: TextStyle(color: Colors.white),
                                  ).tr());
                            }),
                            SizedBox(height: 5),
                            StatefulBuilder(builder: (BuildContext context, StateSetter _setEnd) {
                              return Column(children: [
                                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                  Checkbox(
                                      value: current,
                                      onChanged: (value) {
                                        _setEnd(() {
                                          current = value!;
                                        });
                                      }),
                                  Text('Ongoing').tr()
                                ]),
                                !current
                                    ? TextButton(
                                        style: ButtonStyle(
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            minimumSize: MaterialStateProperty.all(Size(double.infinity, 44)),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                                            ),
                                            backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
                                        onPressed: () {
                                          if (start.text.isEmpty) {
                                            Get.snackbar(tr('Please select a start date first'), '',
                                                duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.amber, leftBarIndicatorColor: Colors.amber);
                                            return;
                                          }
                                          var now = DateTime.now();
                                          DatePicker.showDatePicker(context,
                                              showTitleActions: true, minTime: DateTime(now.year - 60, now.month, now.day + 1), maxTime: DateTime(now.year + 1, now.month + 12), onChanged: (date) {
                                            DateTime st = DateTime.parse((start.text + ' 00:00:00'));
                                            if (st.isAfter(date)) {
                                              return Get.snackbar(tr("End date can't be before start date"), '',
                                                  duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.amber, leftBarIndicatorColor: Colors.amber);
                                            }
                                          }, onConfirm: (date) {
                                            DateTime st = DateTime.parse((start.text + ' 00:00:00'));
                                            if (st.isAfter(date)) {
                                              return Get.snackbar(tr("End date can't be before start date"), '',
                                                  duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.amber, leftBarIndicatorColor: Colors.amber);
                                            }
                                            _setEnd(() {
                                              end.text = date.toString().substring(0, 10);
                                            });
                                          }, currentTime: DateTime.now(), locale: lang == 'ar' ? LocaleType.ar : LocaleType.en);
                                        },
                                        child: Text(
                                          end.text.isNotEmpty ? end.text : 'Choose an end date',
                                          style: TextStyle(color: Colors.white),
                                        ).tr())
                                    : SizedBox(),
                                SizedBox(height: 5),
                                Text('Image', style: TextStyle(fontSize: 13)).tr(),
                                StatefulBuilder(builder: (BuildContext context, StateSetter setImage) {
                                  return Row(children: [
                                    Expanded(
                                        child: Container(
                                            decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            child: TextButton(
                                                onPressed: () async {
                                                  image = await FilePicker.platform.pickFiles(type: FileType.image);
                                                  setImage(() {});
                                                },
                                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                  Flexible(child: Text(image != null ? image!.files.first.name : '', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54))),
                                                  Icon(Icons.file_upload_outlined, color: hexStringToColor('#6986b8'))
                                                ])))),
                                    Container(
                                        margin: EdgeInsets.symmetric(horizontal: 15),
                                        height: 55,
                                        width: 55,
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 0.025),
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.grey[50],
                                            image: DecorationImage(fit: BoxFit.contain, image: image != null ? Image.file(File(image!.files.first.path!)).image : AssetImage('assets/logo.png'))))
                                  ]);
                                }),
                              ]);
                            }),
                            SizedBox(height: 20),
                            StatefulBuilder(builder: (BuildContext context, StateSetter _ssetState) {
                              return !loading
                                  ? TextButton(
                                      style: ButtonStyle(
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 44)),
                                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
                                          backgroundColor: MaterialStateProperty.all(hexStringToColor('#6986b8'))),
                                      onPressed: () async {
                                        _ssetState(() {
                                          loading = true;
                                        });
                                        Map inf = {
                                          'position_ar': posEn.text,
                                          'position_en': posAr.text,
                                          'company_name_ar': compAr.text,
                                          'company_name_en': compEn.text,
                                          'start_at': start.text,
                                          if (!current) 'end_at': end.text,
                                          if (current) 'until_now': '1',
                                          if (image != null) 'file': File(image!.files.first.path!)
                                        };
                                        var tmp = await addExperience(lang, inf);
                                        _ssetState(() {
                                          loading = false;
                                        });
                                        if (tmp['status'] != null && tmp['status']) {
                                          Get.offAll(() => IndivProfilePage());
                                        }
                                      },
                                      child: Text('Add', style: TextStyle(color: Colors.white)).tr())
                                  : Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                            })
                          ]))));
            }));
      });
}

Future projectFormPrompt(BuildContext context, iType, lang, type) async {
  final titleAr = TextEditingController();
  final titleEn = TextEditingController();
  final descAr = TextEditingController();
  final descEn = TextEditingController();
  FilePickerResult? image;
  final url = TextEditingController();
  bool loading = false;
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: StatefulBuilder(builder: (BuildContext context, StateSetter _ssetState) {
              return Container(
                  height: getWH(context, 1) * 0.8,
                  width: getWH(context, 2) * 0.8,
                  child: SingleChildScrollView(
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(color: Colors.black12)),
                          alignment: Alignment.center,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                            Text('Project title Ar', style: TextStyle(fontSize: 13)).tr(),
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                height: getWH(context, 1) * 0.05,
                                child: TextField(
                                    style: TextStyle(color: Colors.blueGrey),
                                    decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                    controller: titleAr,
                                    textDirection: ui.TextDirection.rtl)),
                            Text('Project title En', style: TextStyle(fontSize: 13)).tr(),
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                height: getWH(context, 1) * 0.05,
                                child: TextField(
                                    style: TextStyle(color: Colors.blueGrey),
                                    decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                    controller: titleEn,
                                    textDirection: ui.TextDirection.ltr)),
                            Text('Description Ar', style: TextStyle(fontSize: 13)).tr(),
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                height: getWH(context, 1) * 0.05,
                                child: TextField(
                                    style: TextStyle(color: Colors.blueGrey),
                                    decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                    textDirection: ui.TextDirection.rtl,
                                    controller: descAr)),
                            Text('Description En', style: TextStyle(fontSize: 13)).tr(),
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                height: getWH(context, 1) * 0.05,
                                child: TextField(
                                    style: TextStyle(color: Colors.blueGrey),
                                    decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                    controller: descEn,
                                    textDirection: ui.TextDirection.ltr)),
                            Text('Project URL', style: TextStyle(fontSize: 13)).tr(),
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                height: getWH(context, 1) * 0.05,
                                child: TextField(
                                    style: TextStyle(color: Colors.blueGrey),
                                    decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                    controller: url,
                                    textDirection: ui.TextDirection.ltr)),
                            SizedBox(height: 5),
                            Text('Image', style: TextStyle(fontSize: 13)).tr(),
                            StatefulBuilder(builder: (BuildContext context, StateSetter setImage) {
                              return Row(children: [
                                Expanded(
                                    child: Container(
                                        decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                        child: TextButton(
                                            onPressed: () async {
                                              image = await FilePicker.platform.pickFiles(type: FileType.image);
                                              setImage(() {});
                                            },
                                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                              Flexible(child: Text(image != null ? image!.files.first.name : '', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54))),
                                              Icon(Icons.file_upload_outlined, color: hexStringToColor('#6986b8'))
                                            ])))),
                                Container(
                                    margin: EdgeInsets.symmetric(horizontal: 15),
                                    height: 55,
                                    width: 55,
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 0.025),
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.grey[50],
                                        image: DecorationImage(fit: BoxFit.contain, image: image != null ? Image.file(File(image!.files.first.path!)).image : AssetImage('assets/logo.png'))))
                              ]);
                            }),
                            SizedBox(height: 20),
                            StatefulBuilder(builder: (BuildContext context, StateSetter _ssetState) {
                              return !loading
                                  ? TextButton(
                                      style: ButtonStyle(
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 44)),
                                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
                                          backgroundColor: MaterialStateProperty.all(hexStringToColor('#6986b8'))),
                                      onPressed: () async {
                                        if (titleAr.text.isEmpty || titleEn.text.isEmpty || descEn.text.isEmpty || descAr.text.isEmpty || image == null) {
                                          Get.snackbar(tr('All the fields are required'), '',
                                              duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.red, leftBarIndicatorColor: Colors.red);
                                          return;
                                        }
                                        _ssetState(() {
                                          loading = true;
                                        });
                                        Map inf = {
                                          'project_title_ar': titleAr.text,
                                          'project_title_en': titleEn.text,
                                          'project_description_ar': descAr.text,
                                          'project_description_en': descEn.text,
                                          'project_url': url.text.isNotEmpty ? url.text : '',
                                          if (image != null) 'project_image': File(image!.files.first.path!)
                                        };
                                        var tmp = await addProject(lang, inf);
                                        _ssetState(() {
                                          loading = false;
                                        });
                                        if (tmp['status'] != null && tmp['status']) {
                                          Get.offAll(() => IndivProfilePage());
                                          Get.snackbar(tr('Success'), '', duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.blue, leftBarIndicatorColor: Colors.blue);
                                        } else {
                                          Get.snackbar(tr('Check the fields and try again'), '',
                                              duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.red, leftBarIndicatorColor: Colors.red);
                                        }
                                      },
                                      child: Text('Add', style: TextStyle(color: Colors.white)).tr())
                                  : Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                            })
                          ]))));
            }));
      });
}

Future certificateFormPrompt(BuildContext context) async {
  final titleAr = TextEditingController();
  final titleEn = TextEditingController();
  final release = TextEditingController();
  final expire = TextEditingController();
  bool status = false;
  FilePickerResult? file;
  bool loading = false;
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: StatefulBuilder(builder: (BuildContext context, StateSetter _ssetState) {
              return Container(
                  height: getWH(context, 1) * 0.8,
                  width: getWH(context, 2) * 0.8,
                  child: SingleChildScrollView(
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(color: Colors.black12)),
                          alignment: Alignment.center,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                            Text('Certificate awarded in Arabic', style: TextStyle(fontSize: 13)).tr(),
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                height: getWH(context, 1) * 0.05,
                                child: TextField(
                                    style: TextStyle(color: Colors.blueGrey),
                                    decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                    controller: titleAr,
                                    textDirection: ui.TextDirection.rtl)),
                            Text('Certificate awarded in English', style: TextStyle(fontSize: 13)).tr(),
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                height: getWH(context, 1) * 0.05,
                                child: TextField(
                                    style: TextStyle(color: Colors.blueGrey),
                                    decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                    controller: titleEn,
                                    textDirection: ui.TextDirection.ltr)),
                            Text('Release Date', style: TextStyle(fontSize: 13)).tr(),
                            StatefulBuilder(builder: (BuildContext context, StateSetter setStart) {
                              return TextButton(
                                  style: ButtonStyle(
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      minimumSize: MaterialStateProperty.all(Size(double.infinity, 44)),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                                      ),
                                      backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
                                  onPressed: () {
                                    var now = DateTime.now();
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime(now.year - 60, now.month, now.day + 1),
                                        maxTime: DateTime(now.year + 1, now.month + 12),
                                        onChanged: (date) {}, onConfirm: (date) {
                                      setStart(() {
                                        release.text = date.toString().substring(0, 10);
                                      });
                                    }, currentTime: DateTime.now(), locale: lang == 'ar' ? LocaleType.ar : LocaleType.en);
                                  },
                                  child: Text(
                                    release.text.isNotEmpty ? release.text : tr('Choose a release date'),
                                    style: TextStyle(color: Colors.white),
                                  ).tr());
                            }),
                            SizedBox(height: 5),
                            Text('Expire Date', style: TextStyle(fontSize: 13)).tr(),
                            StatefulBuilder(builder: (BuildContext context, StateSetter setStatus) {
                              return Column(children: [
                                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                  Checkbox(
                                      value: status,
                                      onChanged: (value) {
                                        setStatus(() {
                                          status = value!;
                                        });
                                      }),
                                  Flexible(child: Text('This certificate does not have an expiration date').tr())
                                ]),
                                if (!status)
                                  StatefulBuilder(builder: (BuildContext context, StateSetter setExpire) {
                                    return TextButton(
                                        style: ButtonStyle(
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            minimumSize: MaterialStateProperty.all(Size(double.infinity, 44)),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                                            ),
                                            backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
                                        onPressed: () {
                                          var now = DateTime.now();
                                          DatePicker.showDatePicker(context,
                                              showTitleActions: true,
                                              minTime: DateTime(now.year - 60, now.month, now.day + 1),
                                              maxTime: DateTime(now.year + 1, now.month + 12),
                                              onChanged: (date) {}, onConfirm: (date) {
                                            setExpire(() {
                                              expire.text = date.toString().substring(0, 10);
                                            });
                                          }, currentTime: DateTime.now(), locale: lang == 'ar' ? LocaleType.ar : LocaleType.en);
                                        },
                                        child: Text(
                                          expire.text.isNotEmpty ? expire.text : tr('Choose an expiry date'),
                                          style: TextStyle(color: Colors.white),
                                        ).tr());
                                  }),
                              ]);
                            }),
                            SizedBox(height: 5),
                            Text('File', style: TextStyle(fontSize: 13)).tr(),
                            StatefulBuilder(builder: (BuildContext context, StateSetter setFile) {
                              return Container(
                                  height: getWH(context, 1) * 0.05,
                                  decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                  alignment: Alignment.bottomRight,
                                  child: TextButton(
                                    onPressed: () async {
                                      file = await FilePicker.platform.pickFiles(type: FileType.media);
                                      setFile(() {});
                                    },
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [Text(file != null ? file!.files.first.name : ''), Icon(Icons.file_upload_outlined, color: hexStringToColor('#6986b8'))]),
                                  ));
                            }),
                            SizedBox(height: 20),
                            StatefulBuilder(builder: (BuildContext context, StateSetter _ssetState) {
                              return !loading
                                  ? TextButton(
                                      style: ButtonStyle(
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 44)),
                                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
                                          backgroundColor: MaterialStateProperty.all(hexStringToColor('#6986b8'))),
                                      onPressed: () async {
                                        if (titleAr.text.isEmpty || titleEn.text.isEmpty || release.text.isEmpty || (!status && expire.text.isEmpty) || file == null) {
                                          Get.snackbar(tr('All the fields are required'), '',
                                              duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.red, leftBarIndicatorColor: Colors.red);
                                          return;
                                        }
                                        _ssetState(() {
                                          loading = true;
                                        });
                                        Map inf = {
                                          'certificate_title_ar': titleAr.text,
                                          'certificate_title_en': titleEn.text,
                                          'release_date': release.text,
                                          'expiry_date ': expire.text,
                                          'status': status ? 2 : 1,
                                          'file': File(file!.files.first.path!)
                                        };
                                        var tmp = await addCertificate(inf);
                                        _ssetState(() {
                                          loading = false;
                                        });
                                        if (tmp['status'] != null && tmp['status'] != "false") {
                                          Get.offAll(() => IndivProfilePage());
                                          Get.snackbar(tr('Success'), '', duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.blue, leftBarIndicatorColor: Colors.blue);
                                        } else {
                                          Get.snackbar(tr('Check the fields and try again'), '',
                                              duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.red, leftBarIndicatorColor: Colors.red);
                                        }
                                      },
                                      child: Text('Add', style: TextStyle(color: Colors.white)).tr())
                                  : Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                            })
                          ]))));
            }));
      });
}

Future languageFormPrompt(BuildContext context) async {
  final language = TextEditingController();
  final level = TextEditingController();
  bool write = false;
  bool read = false;
  bool speak = false;
  bool loading = false;
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: StatefulBuilder(builder: (BuildContext context, StateSetter _ssetState) {
              return Container(
                  height: getWH(context, 1) * 0.8,
                  width: getWH(context, 2) * 0.8,
                  child: SingleChildScrollView(
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(color: Colors.black12)),
                          alignment: Alignment.center,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                            Text('Choose a language', style: TextStyle(fontSize: 13)).tr(),
                            DropdownSearch<Map>(
                              items: arrtoList(languageArr, lang, ''),
                              maxHeight: 300,
                              popupItemBuilder: (context, item, isSelected) {
                                return Container(height: 50, child: Column(children: [Expanded(child: Text(item['label'])), Divider(thickness: 1, indent: 10, endIndent: 10)]));
                              },
                              dropdownBuilder: (context, selectedItem) {
                                if (selectedItem != null)
                                  return Text(selectedItem['label']);
                                else
                                  return Text('');
                              },
                              dropdownSearchDecoration: InputDecoration(
                                  hintText: tr('Search'),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                              onChanged: (val) {
                                language.text = val!['value'].toString();
                              },
                              showSearchBox: true,
                            ),
                            Text('Level', style: TextStyle(fontSize: 13)).tr(),
                            DropdownSearch<Map>(
                              items: arrtoList(levelArr, lang, ''),
                              maxHeight: 300,
                              popupItemBuilder: (context, item, isSelected) {
                                return Container(height: 50, child: Column(children: [Expanded(child: Text(item['label'])), Divider(thickness: 1, indent: 10, endIndent: 10)]));
                              },
                              dropdownBuilder: (context, selectedItem) {
                                if (selectedItem != null)
                                  return Text(selectedItem['label']);
                                else
                                  return Text('');
                              },
                              dropdownSearchDecoration: InputDecoration(
                                  hintText: tr('Search'),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                              onChanged: (val) {
                                level.text = val!['value'].toString();
                              },
                              showSearchBox: true,
                            ),
                            SizedBox(height: 5),
                            Text('I can:', style: TextStyle(fontSize: 13)).tr(),
                            StatefulBuilder(builder: (BuildContext context, StateSetter setStatus) {
                              return Column(children: [
                                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                  Checkbox(
                                      value: speak,
                                      onChanged: (value) {
                                        setStatus(() {
                                          speak = value!;
                                        });
                                      }),
                                  Flexible(child: Text('Speak').tr())
                                ]),
                                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                  Checkbox(
                                      value: read,
                                      onChanged: (value) {
                                        setStatus(() {
                                          read = value!;
                                        });
                                      }),
                                  Flexible(child: Text('Read').tr())
                                ]),
                                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                  Checkbox(
                                      value: write,
                                      onChanged: (value) {
                                        setStatus(() {
                                          write = value!;
                                        });
                                      }),
                                  Flexible(child: Text('Write').tr())
                                ])
                              ]);
                            }),
                            SizedBox(height: 20),
                            StatefulBuilder(builder: (BuildContext context, StateSetter setSubmit) {
                              return !loading
                                  ? TextButton(
                                      style: ButtonStyle(
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 44)),
                                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
                                          backgroundColor: MaterialStateProperty.all(hexStringToColor('#6986b8'))),
                                      onPressed: () async {
                                        if (language.text.isEmpty || level.text.isEmpty) {
                                          Get.snackbar(tr('All the fields are required'), '',
                                              duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.red, leftBarIndicatorColor: Colors.red);
                                          return;
                                        }
                                        setSubmit(() {
                                          loading = true;
                                        });
                                        Map inf = {
                                          'language_id': language.text,
                                          'level': level.text,
                                          'write': write ? "1" : "2",
                                          'speak': speak ? "1" : "2",
                                          'read': read ? "1" : "2",
                                        };
                                        var tmp = await addLanguage(inf);
                                        setSubmit(() {
                                          loading = false;
                                        });
                                        if (tmp['status'] != null && tmp['status'] != "false") {
                                          Get.offAll(() => IndivProfilePage());
                                          Get.snackbar(tmp["msg"] ?? tr('Success'), '',
                                              duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.blue, leftBarIndicatorColor: Colors.blue);
                                        } else {
                                          Get.snackbar(tr('Check the fields and try again'), '',
                                              duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.red, leftBarIndicatorColor: Colors.red);
                                        }
                                      },
                                      child: Text('Add', style: TextStyle(color: Colors.white)).tr())
                                  : Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                            })
                          ]))));
            }));
      });
}

List<Map<String, dynamic>> arrtoList(List arr, lang, String flag) {
  List<Map<String, dynamic>> data = [];
  if (flag.isNotEmpty && flag != 'multiselect') {
    for (var u in arr) {
      if (flag.replaceAll(' ', '') == (lang == 'ar' ? u['name_ar'].replaceAll(' ', '') : u['name_en'].replaceAll(' ', ''))) {
        data.add({'value': u['id']});
        return data;
      }
    }
  } else if (flag == 'multiselect') {
    for (var u in arr) {
      data.add({'value': u['id'], 'display': (lang == 'ar' ? u['name_ar'] : u['name_en'])});
    }
    return data;
  } else {
    for (var u in arr) {
      data.add({'value': u['id'], 'label': (lang == 'ar' ? u['name_ar'] : u['name_en'])});
    }
    return data;
  }
  return data;
}

Future<Map> jobEdit(uid, stat, jID, lang) async {
  if (stat) {
    var defaultValues = await getCompanyJobs(uid.toString(), 'Company', lang, null, jID, 1, null);
    return defaultValues;
  } else {
    return {};
  }
}

Future<Map> eventEdit(uid, stat, eID, lang) async {
  if (stat) {
    var defaultValues = await getCompanyEvents(uid, 'Company', lang, null, eID);
    return defaultValues;
  } else {
    return {};
  }
}

class CustomPicker extends DatePickerModel {
  CustomPicker({DateTime? currentTime, LocaleType? locale, DateTime? minTime, DateTime? maxTime}) : super(locale: locale, minTime: minTime, maxTime: maxTime) {
    this.currentTime = currentTime ?? DateTime.now();
    this.currentTime = minTime ?? DateTime(2011, 1, 1, 1, 1);
    this.currentTime = maxTime ?? DateTime(DateTime.now().year + 1, 1, 1, 1, 1);
  }
  @override
  List<int> layoutProportions() {
    return [1, 0, 0];
  }
}

Future courseSubscribeRequest(BuildContext context, lang, type) async {
  bool loading = false;
  final course = TextEditingController();
  FilePickerResult? file;
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                height: getWH(context, 1) * 0.4,
                padding: EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                alignment: Alignment.center,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: getInfo('pendingCourses', lang, type),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
                        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          SizedBox(height: 10),
                          Text('Request to add course to your profile', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)).tr(),
                          Divider(height: 15),
                          Text('   Select course', style: TextStyle(fontSize: 13)).tr(),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              height: getWH(context, 1) * 0.05,
                              child: SelectFormField(
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return tr('Please select course');
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                    suffixIcon: Icon(Icons.arrow_drop_down),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                type: SelectFormFieldType.dropdown,
                                labelText: tr('Course'),
                                items: snapshot.data,
                                controller: course,
                                onChanged: (val) {
                                  course.text = (val);
                                },
                              )),
                          SizedBox(height: 15),
                          Flexible(child: Text('   Certificate image', style: TextStyle(fontSize: 13)).tr()),
                          SizedBox(height: 5),
                          StatefulBuilder(builder: (BuildContext context, StateSetter setFile) {
                            return Container(
                                height: getWH(context, 1) * 0.05,
                                decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  onPressed: () async {
                                    file = await FilePicker.platform.pickFiles(type: FileType.image);
                                    setFile(() {});
                                  },
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [Text(file != null ? file!.files.first.name : ''), Icon(Icons.file_upload_outlined, color: hexStringToColor('#6986b8'))]),
                                ));
                          }),
                          SizedBox(height: 30),
                          StatefulBuilder(builder: (BuildContext context, StateSetter _ssetState) {
                            return !loading
                                ? TextButton(
                                    style: ButtonStyle(
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        minimumSize: MaterialStateProperty.all(Size(double.infinity, 44)),
                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
                                        backgroundColor: MaterialStateProperty.all(hexStringToColor('#6986b8'))),
                                    onPressed: () async {
                                      if (course.text.isEmpty || file == null) {
                                        Get.snackbar(tr('All the fields are required'), '',
                                            duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.orange, leftBarIndicatorColor: Colors.orange);
                                        return;
                                      }
                                      _ssetState(() {
                                        loading = true;
                                      });
                                      Map inf = {'course_id': course.text, 'file': File(file!.files.first.path!)};
                                      await subscribeRequest(lang, type, inf);
                                      _ssetState(() {
                                        loading = false;
                                      });
                                    },
                                    child: Text('Add', style: TextStyle(color: Colors.white)).tr())
                                : Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                          })
                        ]);
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: Container(margin: EdgeInsets.only(top: 10), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                      } else {
                        return Center(child: Text('You need to take a course first').tr());
                      }
                    })));
      });
}

Future biggerImage(BuildContext context, String image, String uid, String type, Map? images, String lang, bool owner, int requestType) async {
  bool loading = false;
  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setLoading) {
          return AlertDialog(
              actions: [
                !loading
                    ? IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back_ios_outlined))
                    : Center(child: Container(margin: EdgeInsets.only(top: 10), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())),
                !loading && owner
                    ? IconButton(
                        onPressed: () async {
                          setLoading(() => loading = true);
                          if (requestType == 1) {
                            await gallery(context, uid, lang, type, 3, images);
                          } else if (requestType == 2) {
                            var tmp = await personalSkills(uid, lang, type, 2, images);
                            if (tmp.isNotEmpty && tmp['status']) {
                              Navigator.pop(context, true);
                              Get.snackbar(tmp['msg'], '', duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.green, leftBarIndicatorColor: Colors.green);
                            }
                          }
                          setLoading(() => loading = false);
                        },
                        icon: Icon(Icons.delete, color: Colors.red))
                    : SizedBox()
              ],
              content: Container(
                  height: getWH(context, 1) * 0.5, width: getWH(context, 2), child: Container(decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.contain, image: NetworkImage(image))))));
        });
      });
}

Future uploadImages(BuildContext context, String uid, String type, String lang) async {
  bool loading = false;
  List<File> images = [];
  String text = tr('You can upload multiple pictures');
  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setLoading) {
          return AlertDialog(
              actions: [
                !loading
                    ? IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back_ios_outlined))
                    : Center(child: Container(margin: EdgeInsets.only(top: 10), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())),
                !loading
                    ? IconButton(
                        onPressed: () async {
                          if (images.isEmpty) {
                            return;
                          }
                          setLoading(() => loading = true);
                          var tmp = await gallery(context, uid, lang, type, 2, {'images': images});
                          if (tmp['status'] != null && !tmp['status']) {
                            setLoading(() => loading = false);
                          }
                        },
                        icon: Icon(Icons.upload_rounded, color: hexStringToColor('#6986b8')))
                    : SizedBox()
              ],
              content: StatefulBuilder(builder: (BuildContext context, StateSetter setImage) {
                return Row(children: [
                  Expanded(
                      child: Container(
                          decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                          child: TextButton(
                              onPressed: () async {
                                var tmp = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: true);
                                if (tmp != null) {
                                  setImage(() {
                                    images = tmp.paths.map((path) => File(path!)).toList();
                                    text = images.toString();
                                  });
                                }
                              },
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Flexible(child: Text(text, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54)).tr()),
                                Icon(Icons.add_a_photo_rounded, color: hexStringToColor('#6986b8'))
                              ]))))
                ]);
              }));
        });
      });
}

//Social media
//await FacebookAuth.instance.logOut();
Future loginFacebook(lang) async {
  final LoginResult result = await FacebookAuth.instance.login();
  if (result.status == LoginStatus.success) {
    // final AccessToken accessToken = result.accessToken!;
    final userData = await FacebookAuth.instance.getUserData();
    var rg = await register(userData['name'], '', '', userData['email'] ?? '', '', '', 'Individual', '', '', lang, '', '1', 'facebook', userData['id'], null);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('provider', 'facebook');
    return rg;
  } else {
    Get.snackbar(tr('Something went wrong'), result.message.toString(), duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.red, leftBarIndicatorColor: Colors.red);
  }
  return true;
}

Future loginApple() async {
  final credential = await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
  );
   var rg = await register((credential.givenName ?? "") + " " + (credential.familyName ?? ""), '', '', credential.email ?? '', '', '', 'Individual', '', '',
      lang, '', '1', 'apple', credential.userIdentifier, null);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('provider', 'apple');
  return rg;
}

Future loginGoogle(lang) async {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );
  var account;
  try {
    account = await _googleSignIn.signIn();
  } catch (error) {
    Get.snackbar(tr('Something went wrong'), tr('Please try again'), duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.red, leftBarIndicatorColor: Colors.red);
  }
  if (account != null) {
    var rg = await register(account.displayName, '', '', account.email ?? '', '', '', 'Individual', '', '', lang, '', '1', 'google', account.id, null);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('provider', 'google');
    return rg;
  } else {
    Get.snackbar(tr('Something went wrong'), tr('Please try again'), duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.red, leftBarIndicatorColor: Colors.red);
  }
  return true;
}

Future saveSearch(BuildContext context, Map data, int type) async {
  var loading = false;
  final name = TextEditingController();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text('Save your search filters').tr(),
            actions: [
              StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
                return !loading
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: hexStringToColor('#6986b8'),
                        ),
                        onPressed: () async {
                          if (name.text.isEmpty) {
                            Get.snackbar(tr("Name can't be empty"), '', duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.orange, leftBarIndicatorColor: Colors.orange);
                            return;
                          }
                          data['search_name'] = name.text;
                          _setState(() => loading = true);
                          Map stt;
                          if (type == 1) {
                            stt = await advancedSearch(data, 1);
                          } else {
                            stt = await advancedCVSearch(data, 1);
                          }
                          _setState(() => loading = false);
                          if (stt['status'] == true) {
                            Get.back();
                            Get.snackbar(stt['msg'], '', duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.blue, leftBarIndicatorColor: Colors.blue);
                          } else {
                            Get.snackbar(stt['msg'] ?? '', '', duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.blue, leftBarIndicatorColor: Colors.blue);
                          }
                        },
                        child: Text('Save', style: TextStyle(color: Colors.white)).tr())
                    : Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator());
              }),
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('Cancel').tr())
            ],
            content: IntrinsicHeight(
                child: Container(
                    width: getWH(context, 2),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      Container(child: Text('Saved search name', style: TextStyle(fontSize: 18.0, color: Colors.black)).tr()),
                      SizedBox(height: 20),
                      TextField(
                          decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                          style: TextStyle(color: Colors.blueGrey),
                          controller: name)
                    ]))));
      });
}

Future removeConversation(BuildContext context, String lang, String id) async {
  bool loading = false;
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(backgroundColor: Colors.transparent, actions: [
          StatefulBuilder(builder: (BuildContext context, StateSetter refresh) {
            return Container(
                height: getWH(context, 1) * 0.2,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(color: Colors.black12)),
                    alignment: Alignment.center,
                    child: !loading
                        ? Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                            Text('Are you sure you want to remove this conversation?').tr(),
                            TextButton(
                                style: ButtonStyle(
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    minimumSize: MaterialStateProperty.all(Size(double.infinity, 44)),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
                                    backgroundColor: MaterialStateProperty.all(Colors.red[900])),
                                onPressed: () async {
                                  refresh(() {
                                    loading = true;
                                  });
                                  Map tmp = await removeConversationAPI(lang, id);
                                  refresh(() {
                                    loading = false;
                                  });
                                  if (tmp.isNotEmpty) {
                                    userList.clear();
                                    Get.back();
                                    Get.back();
                                    Get.back();
                                    Get.snackbar(tr('Success'), '', duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.blue, leftBarIndicatorColor: Colors.blue);
                                    return;
                                  }
                                },
                                child: Text('Remove', style: TextStyle(color: Colors.white)).tr())
                          ])
                        : Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
          })
        ]);
      });
}

Future<String?> getID() async {
  await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
  var os = await OneSignal.shared.getDeviceState();
  return os!.userId;
}

editSelection(BuildContext context, Map? optional) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: Container(
                height: globalType == "Individual" ? 400 : 200,
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  GestureDetector(
                      onTap: () {
                        if (globalType == 'Company') {
                          Get.back();
                          Get.to(() => CompanySettingsPage());
                        } else {
                          Get.back();
                          Get.to(() => IndivSettingsPage());
                        }
                      },
                      child: Container(
                          decoration: BoxDecoration(color: hexStringToColor('#6986b8'), border: Border.all(width: 0.2), borderRadius: BorderRadius.all(Radius.circular(30))),
                          width: getWH(context, 2),
                          height: getWH(context, 1) * 0.07,
                          margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                          alignment: Alignment.center,
                          child: Text('Main Information', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)).tr())),
                  GestureDetector(
                      onTap: () {
                        if (globalType == 'Company') {
                          Get.back();
                          Get.to(() => CompanyInfoPage());
                        } else {
                          Get.back();
                          Get.to(() => IndivInfoPage());
                        }
                      },
                      child: Container(
                          decoration: BoxDecoration(color: hexStringToColor('#6986b8'), border: Border.all(width: 0.2), borderRadius: BorderRadius.all(Radius.circular(30))),
                          width: getWH(context, 2),
                          height: getWH(context, 1) * 0.07,
                          margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                          alignment: Alignment.center,
                          child: Text(globalType == 'Company' ? 'Other Information' : 'Personal Information', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)).tr())),
                  if (globalType == "Individual")
                    GestureDetector(
                        onTap: () {
                          Get.back();
                          Get.to(() => DisabilityPage());
                        },
                        child: Container(
                            decoration: BoxDecoration(color: hexStringToColor('#6986b8'), border: Border.all(width: 0.2), borderRadius: BorderRadius.all(Radius.circular(30))),
                            width: getWH(context, 2),
                            height: getWH(context, 1) * 0.07,
                            margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                            alignment: Alignment.center,
                            child: Text('Special Needs', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)).tr())),
                  if (globalType == "Individual")
                    GestureDetector(
                        onTap: () {
                          Get.back();
                          Get.to(() => PrivacyPage(public: optional?["visibility"], contact: optional?["contact"]));
                        },
                        child: Container(
                            decoration: BoxDecoration(color: hexStringToColor('#6986b8'), border: Border.all(width: 0.2), borderRadius: BorderRadius.all(Radius.circular(30))),
                            width: getWH(context, 2),
                            height: getWH(context, 1) * 0.07,
                            margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                            alignment: Alignment.center,
                            child: Text('Privacy', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)).tr()))
                ])));
      });
}

Future backDialog(BuildContext context) async {
  return await showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: Text('Any unsubmitted changes will be lost').tr(),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    return;
                  },
                  child: Text('Continue').tr()),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    return;
                  },
                  child: Text('Cancel').tr())
            ],
          ));
}

Future saveNotif(BuildContext context, Map data) async {
  var loading = false;
  final name = TextEditingController();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text('Notify me about new results').tr(),
            actions: [
              StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
                return !loading
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: hexStringToColor('#6986b8'),
                        ),
                        onPressed: () async {
                          if (name.text.isEmpty) {
                            Get.snackbar(tr("Name can't be empty"), '', duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.orange, leftBarIndicatorColor: Colors.orange);
                            return;
                          }
                          data['alert_name'] = name.text;
                          _setState(() => loading = true);
                          var stt = await saveAlert(2, data);
                          _setState(() => loading = false);
                          if (stt['status'] == true) {
                          } else {}
                        },
                        child: Text('Save', style: TextStyle(color: Colors.white)).tr())
                    : Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator());
              }),
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('Cancel').tr())
            ],
            content: IntrinsicHeight(
                child: Container(
                    width: getWH(context, 2),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      Container(child: Text('Saved alert name', style: TextStyle(fontSize: 18.0, color: Colors.black)).tr()),
                      SizedBox(height: 20),
                      TextField(
                          decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                          style: TextStyle(color: Colors.blueGrey),
                          controller: name)
                    ]))));
      });
}
