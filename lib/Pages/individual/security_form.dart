import 'dart:io';
import 'package:file_picker/file_picker.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wathefty/Pages/individual/profile.dart';
import '../../API.dart';
import '../../data.dart';
import '../../functions.dart';
import '../../main.dart';
import 'dart:ui' as ui;

class IndividualSecurityPage extends StatefulWidget {
  @override
  _IndividualSecurityPageState createState() => _IndividualSecurityPageState();
}

class _IndividualSecurityPageState extends State<IndividualSecurityPage> {
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
    image = null;
    loading = false;
    athletic.dispose();
    martial.dispose();
    servedYears.dispose();
    work.dispose();
    service.dispose();
    rank.dispose();
    retireYear.dispose();
  }

  bool loading = false;
  final athletic = TextEditingController(text: "2");
  final martial = TextEditingController(text: "2");
  final servedYears = TextEditingController();
  final work = TextEditingController();
  final service = TextEditingController();
  final rank = TextEditingController();
  final retireYear = TextEditingController();
  FilePickerResult? image;

  var imgLink;
  var shrt;
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          var uid = snapshot.data!['uid'];
          loading = false;
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: watheftyBar(context, "Security Application", 16),
              bottomNavigationBar: watheftyBottomBar(context),
              body: FutureBuilder<Map>(
                  future: getExtra(uid, 'Individual', lang, 'security'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData && snapshot.data?['status']) {
                        shrt = snapshot.data;
                        martial.text = shrt!['do_you_have_combat_skills'] == "Yes" ? "1" : "2";
                        athletic.text = shrt['do_you_have_fitness'] == "Yes" ? "1" : "2";
                        service.text = shrt['previous_work_id'];
                        work.text = shrt['type_work_id'].toString();
                        retireYear.text = shrt['retirement_year'].toString();
                        servedYears.text = shrt['duration_working_years'].toString();
                        rank.text = shrt['rank_degree_id'].toString();
                        imgLink = NetworkImage(shrt['personal_image']);
                      } else {
                        imgLink = NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png");
                      }
                      return SingleChildScrollView(
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                Text('Apply for a security position\n(Retired from Military)',
                                        textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87))
                                    .tr(),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 10),
                                    child: Text('Up to date personal picture', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
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
                                            image: DecorationImage(fit: BoxFit.cover, image: image != null ? Image.file(File(image!.files.first.path!)).image : imgLink)))
                                  ]);
                                }),
                                Divider(),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 5),
                                    child: Text('Retirement Year', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                StatefulBuilder(builder: (BuildContext context, StateSetter setRetire) {
                                  return SizedBox(
                                      width: getWH(context, 2),
                                      child: TextButton(
                                          style: ButtonStyle(
                                              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 18, horizontal: 20)),
                                              foregroundColor: MaterialStateProperty.all(Colors.grey[50]),
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(25), side: BorderSide(width: 0.4))),
                                              backgroundColor: MaterialStateProperty.all(Colors.grey[50])),
                                          onPressed: () {
                                            DatePicker.showPicker(context,
                                                showTitleActions: true,
                                                pickerModel: CustomPicker(currentTime: DateTime.now(), minTime: DateTime(2000, 1, 1, 1, 1), maxTime: DateTime.now()),
                                                locale: lang == 'ar' ? LocaleType.ar : LocaleType.en, onConfirm: (date) {
                                              setRetire(() {
                                                retireYear.text = date.toString().substring(0, 4);
                                              });
                                            });
                                          },
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                            Text(retireYear.text.isNotEmpty ? retireYear.text : '', style: TextStyle(color: Colors.black54)).tr(),
                                            Icon(Icons.calendar_today, color: Colors.black54)
                                          ])));
                                }),
                                Divider(),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 15),
                                    child: Text('Rank', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                SelectFormField(
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return tr('Please select your rank');
                                    }
                                    return null;
                                  },
                                  type: SelectFormFieldType.dropdown,
                                  labelText: tr('Rank'),
                                  items: arrtoList(rankArr, lang, ''),
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  controller: rank,
                                ),
                                Divider(),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 5),
                                    child: Text('Service Entity', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                SelectFormField(
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return tr('Please select the place you served');
                                    }
                                    return null;
                                  },
                                  type: SelectFormFieldType.dropdown,
                                  labelText: tr('Service'),
                                  items: arrtoList(previousWorkArr, lang, ''),
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  controller: service,
                                ),
                                Divider(),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 5),
                                    child: Text('Type of work', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                SelectFormField(
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return tr('Please select a type of work');
                                    }
                                    return null;
                                  },
                                  type: SelectFormFieldType.dropdown,
                                  items: arrtoList(workTypeArr, lang, ''),
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  controller: work,
                                ),
                                Divider(),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 5),
                                    child: Text('Years served', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                TextField(
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(Icons.arrow_drop_down),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                    style: TextStyle(color: Colors.blueGrey),
                                    textDirection: lang == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                                    controller: servedYears,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))]),
                                Divider(),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 5),
                                    child: Text('Do you have combat or martial art skills', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                StatefulBuilder(builder: (BuildContext context, StateSetter setmartialart) {
                                  return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                    Expanded(
                                        child: ListTile(
                                      title: Text("Yes", style: TextStyle(color: martial.text == "1" ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                      leading: Radio(
                                        value: "1",
                                        groupValue: martial.text,
                                        onChanged: (value) {
                                          setmartialart(() {
                                            martial.text = value.toString();
                                          });
                                        },
                                        activeColor: hexStringToColor('#6986b8'),
                                      ),
                                    )),
                                    Expanded(
                                        child: ListTile(
                                            title: Text("No", style: TextStyle(color: martial.text == "2" ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                            leading: Radio(
                                                value: "2",
                                                groupValue: martial.text,
                                                onChanged: (value) {
                                                  setmartialart(() {
                                                     
                                                    martial.text = value.toString();
                                                  });
                                                },
                                                activeColor: hexStringToColor('#6986b8'))))
                                  ]);
                                }),
                                Divider(),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 5),
                                    child: Text('Are you fit', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                StatefulBuilder(builder: (BuildContext context, StateSetter setathletic) {
                                  return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                    Expanded(
                                        child: ListTile(
                                            title: Text("Yes", style: TextStyle(color: athletic.text == "1" ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                            leading: Radio(
                                              value: "1",
                                              groupValue: athletic.text,
                                              onChanged: (value) {
                                                setathletic(() {
                                                  athletic.text = value.toString();
                                                });
                                              },
                                              activeColor: hexStringToColor('#6986b8'),
                                            ))),
                                    Expanded(
                                        child: ListTile(
                                            title: Text("No", style: TextStyle(color: athletic.text == "2" ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                            leading: Radio(
                                                value: "2",
                                                groupValue: athletic.text,
                                                onChanged: (value) {
                                                  setathletic(() {
                                                    athletic.text = value.toString();
                                                  });
                                                },
                                                activeColor: hexStringToColor('#6986b8'))))
                                  ]);
                                }),
                                StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
                                  return !loading
                                      ? Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                                          GestureDetector(
                                              onTap: () async {
                                            
                                                if (servedYears.text.isEmpty ||
                                                    work.text.isEmpty ||
                                                    service.text.isEmpty ||
                                                    retireYear.text.isEmpty ||
                                                    rank.text.isEmpty ||
                                                    athletic.text.isEmpty ||
                                                    martial.text.isEmpty ||
                                                    (image == null && shrt['personal_image'] == null)) {
                                                  Get.snackbar(tr('All the fields are required'), tr('Please fill them and try again'),
                                                      duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.orange, leftBarIndicatorColor: Colors.orange);
                                                  return;
                                                }
                                                _setState(() {
                                                  loading = true;
                                                });
                                                Map uInfo = {
                                                  'retirement_year': retireYear.text,
                                                  'duration_working_years': servedYears.text,
                                                  'rank_degree': rank.text,
                                                  'previous_work': service.text,
                                                  'type_work': work.text,
                                                  'do_you_have_fitness': athletic.text,
                                                  'do_you_have_combat_skills': martial.text,
                                                };
                                                image != null ? uInfo['personal_image'] = File(image!.files.first.path!) : image = null;
                                                var tmp = await createSecurity(lang, uid, 'Individual', uInfo);
                                                _setState(() {
                                                  loading = false;
                                                });
                                                if (tmp['status'] == true) {
                                                  Get.offAll(() => IndivProfilePage());
                                                }
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(color: hexStringToColor('#6986b8'), border: Border.all(width: 0.2), borderRadius: BorderRadius.all(Radius.circular(30))),
                                                  width: getWH(context, 2),
                                                  height: getWH(context, 1) * 0.07,
                                                  margin: EdgeInsets.only(top: 25),
                                                  alignment: Alignment.center,
                                                  child: Text(snapshot.data!['status'] ? tr('Edit Information') : tr('Add Request'),
                                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))
                                                      .tr())),
                                          TextButton(
                                              onPressed: () async {
                                                _setState(() {
                                                  loading = true;
                                                });
                                                var tmp = await removeExtra(lang, uid as String, 'Individual', 'security');
                                                _setState(() {
                                                  loading = false;
                                                });
                                                if (tmp['status'] == true) {
                                                  Get.offAll(() => IndivProfilePage());
                                                }
                                              },
                                              child: Text('Remove Request', style: TextStyle(decoration: TextDecoration.underline, color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15)).tr())
                                        ])
                                      : Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                                }),
                              ])));
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Scaffold(backgroundColor: Colors.white, body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
                    } else {
                      return SizedBox();
                    }
                  }));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(backgroundColor: Colors.white, body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
        } else {
          return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                  child: Container(
                      padding: EdgeInsets.all(50),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Text(
                          "Something went wrong, please check your internet and try to log in again.",
                          textAlign: TextAlign.center,
                        ).tr(),
                        TextButton(
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.clear();
                              Get.offAll(() => StartPage());
                            },
                            child: Text('Retry').tr())
                      ]))));
        }
      });
}
