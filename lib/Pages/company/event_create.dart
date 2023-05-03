import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wathefty/Pages/company/event_list.dart';
import '../../API.dart';
import '../../functions.dart';
import '../../main.dart';
import 'dart:ui' as ui;

class CompanyCreateEventPage extends StatefulWidget {
  @override
  _CompanyCreateEventPageState createState() => _CompanyCreateEventPageState();
  const CompanyCreateEventPage({
    Key? key,
    required this.eventEdit,
    required this.eventId,
  }) : super(key: key);
  final bool eventEdit;
  final String eventId;
}

class _CompanyCreateEventPageState extends State<CompanyCreateEventPage> {
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
    result = null;
    resultfile = null;
    loading = false;
  }

  var defaultpicked = ' ';
  var defaultvid = ' ';
  bool loading = false;
  var imgLnk;
  final eventTitleAr = TextEditingController();
  final eventTitleEn = TextEditingController();
  final eventDescriptionAr = TextEditingController();
  final eventDescriptionEn = TextEditingController();
  FilePickerResult? result;
  FilePickerResult? resultvid;
  FilePickerResult? resultfile;
  int status = 1;
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          var uid = snapshot.data!['uid'];
          loading = false;
         

          return Scaffold(
              backgroundColor: Colors.white,
              appBar: watheftyBar(context, widget.eventEdit ? 'Edit service' : 'Create a new service', 20),
              bottomNavigationBar: watheftyBottomBar(context),
              body: FutureBuilder<Map>(
                  future: eventEdit(uid, widget.eventEdit, widget.eventId, lang),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      loading = false;
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        var shrt = snapshot.data;
                        eventTitleAr.text = shrt!['event_title_ar'];
                        eventTitleEn.text = shrt['event_title_en'];
                        eventDescriptionAr.text = shrt['event_des_ar'];
                        eventDescriptionEn.text = shrt['event_des_en'];
                        var tmpp = shrt['event_file'] != null ? shrt['event_file'].split("/") : null;
                        var tmpv = shrt['event_video'] != null ? shrt['event_video'].split("/") : null;
                        defaultpicked = tmpp != null ? tmpp[tmpp.length - 1] : '';
                        defaultvid = tmpv != null ? tmpv[tmpv.length - 1] : '';
                        status = shrt['event_status'];
                        imgLnk = shrt['event_image'] != null ? NetworkImage(shrt['event_image']) : AssetImage('assets/logo.png');
                      } else {
                        imgLnk = AssetImage('assets/logo.png');
                      }
                      return SingleChildScrollView(
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Event image', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                StatefulBuilder(builder: (BuildContext context, StateSetter setImage) {
                                  return Row(children: [
                                    Expanded(
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey[50], border: Border.all(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            child: TextButton(
                                                onPressed: () async {
                                                  result = await FilePicker.platform.pickFiles(type: FileType.image);
                                                  setImage(() {});
                                                },
                                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                  Flexible(
                                                      child: Text(result != null ? result!.files.first.name : '',
                                                          overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54))),
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
                                            image: DecorationImage(
                                                fit: BoxFit.contain, image: result != null ? Image.file(File(result!.files.first.path!)).image : imgLnk)))
                                  ]);
                                }),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Arabic Event Title', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                TextField(
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder:
                                          OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  style: TextStyle(color: Colors.blueGrey),
                                  textDirection: ui.TextDirection.rtl,
                                  controller: eventTitleAr,
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('English Event Title', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                TextField(
                                  textDirection: ui.TextDirection.ltr,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder:
                                          OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  style: TextStyle(color: Colors.blueGrey),
                                  controller: eventTitleEn,
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Video (Optional)', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                StatefulBuilder(builder: (BuildContext context, StateSetter setVideo) {
                                  return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[50], border: Border.all(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      alignment: Alignment.bottomRight,
                                      child: TextButton(
                                        onPressed: () async {
                                          resultvid = await FilePicker.platform
                                              .pickFiles(type: FileType.video);
                                          setVideo(() {});
                                        },
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          Text(resultvid != null ? resultvid!.files.first.name : defaultvid.toString()),
                                          Icon(Icons.file_upload_outlined, color: hexStringToColor('#6986b8'))
                                        ]),
                                      ));
                                }),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('File (Optional)', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                StatefulBuilder(builder: (BuildContext context, StateSetter setFile) {
                                  return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[50], border: Border.all(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      alignment: Alignment.bottomRight,
                                      child: TextButton(
                                        onPressed: () async {
                                          resultfile = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['docx', 'pdf']);
                                          setFile(() {});
                                        },
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          Text(resultfile != null ? resultfile!.files.first.name : defaultpicked.toString()),
                                          Icon(Icons.file_upload_outlined, color: hexStringToColor('#6986b8'))
                                        ]),
                                      ));
                                }),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Status', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                StatefulBuilder(builder: (BuildContext context, StateSetter setStatus) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                          child: ListTile(
                                        title: Text("Active", style: TextStyle(color: status == 1 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                        leading: Radio(
                                          value: 1,
                                          groupValue: status,
                                          onChanged: (value) {
                                            setStatus(() {
                                              status = value as int;
                                            });
                                          },
                                          activeColor: hexStringToColor('#6986b8'),
                                        ),
                                      )),
                                      Expanded(
                                          child: ListTile(
                                        title: Text("Inactive", style: TextStyle(color: status == 2 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                        leading: Radio(
                                          value: 2,
                                          groupValue: status,
                                          onChanged: (value) {
                                            setStatus(() {
                                              status = value as int;
                                            });
                                          },
                                          activeColor: hexStringToColor('#6986b8'),
                                        ),
                                      )),
                                    ],
                                  );
                                }),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Arabic Description', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                TextField(
                                  minLines: 4,
                                  keyboardType: TextInputType.multiline,
                                  textDirection: ui.TextDirection.rtl,
                                  maxLines: null,
                                  controller: eventDescriptionAr,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder:
                                          OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('English Description', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                TextField(
                                  minLines: 4,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  controller: eventDescriptionEn,
                                  textDirection: ui.TextDirection.ltr,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder:
                                          OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                                SizedBox(height: 15),
                                StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
                                  return !loading
                                      ? Container(
                                          decoration: BoxDecoration(
                                              color: hexStringToColor('#6986b8'),
                                              border: Border.all(width: 0.2),
                                              borderRadius: BorderRadius.all(Radius.circular(30))),
                                          width: getWH(context, 2),
                                          height: getWH(context, 1) * 0.07,
                                          margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                                          child: TextButton(
                                              onPressed: () async {
                                                if (eventTitleAr.text.isEmpty ||
                                                    eventTitleEn.text.isEmpty ||
                                                    eventDescriptionAr.text.isEmpty ||
                                                    eventDescriptionEn.text.isEmpty) {
                                                  Get.snackbar(tr('All the fields are required'), tr('Please fill them and try again'),
                                                      duration: Duration(seconds: 5),
                                                      backgroundColor: Colors.white,
                                                      colorText: Colors.red,
                                                      leftBarIndicatorColor: Colors.red);
                                                  return;
                                                }
                                                Map uInfo = {
                                                  'company_event_title_ar': eventTitleAr.text,
                                                  'company_event_title_en': eventTitleEn.text,
                                                  'company_event_status': status.toString(),
                                                  'company_event_des_ar': eventDescriptionAr.text,
                                                  'company_event_des_en': eventDescriptionEn.text,
                                                  'company_event_main_image': null,
                                                  'company_event_main_file': null,
                                                  'company_event_main_video': null,
                                                };
                                                result != null ? uInfo['company_event_main_image'] = File(result!.files.first.path!) : result = null;
                                                resultfile != null ? uInfo['company_event_main_file'] = File(resultfile!.files.first.path!) : resultfile = null;
                                                resultvid != null ? uInfo['company_event_main_video'] = File(resultvid!.files.first.path!) : resultvid = null;
                                                _setState(() {
                                                  loading = true;
                                                });
                                                var tmp = await createEvent(lang, uid, 'Company', uInfo, widget.eventId);
                                                _setState(() {
                                                  loading = false;
                                                });
                                                if (tmp['status']) {
                                                  Get.off(() => CompanyEventListPage());
                                                }
                                              },
                                              child: Text(widget.eventEdit ? tr('Edit Event') : tr('Add Event'),
                                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))
                                                  .tr()))
                                      : Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                                }),
                              ])));
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Scaffold(
                          backgroundColor: Colors.white,
                          body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
                    } else {
                      return SizedBox();
                    }
                  }));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              backgroundColor: Colors.white, body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
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
