import 'dart:io';
import 'package:file_picker/file_picker.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wathefty/Pages/company/profile.dart';
import 'package:wathefty/Pages/individual/profile.dart';
import '../../API.dart';
import '../../data.dart';
import '../../functions.dart';
import '../../main.dart';
import 'dart:ui' as ui;

class AddServicePage extends StatefulWidget {
  @override
  _AddServicePageState createState() => _AddServicePageState();
  const AddServicePage({Key? key, required this.status, required this.id}) : super(key: key);
  final int status;
  final int id;
}

class _AddServicePageState extends State<AddServicePage> {
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
    loading = false;
  }

  var defaultpicked = ' ';
  bool loading = false;
  var defaultvid = ' ';
  var imgLnk;
  final section = TextEditingController();
  final price = TextEditingController();
  final titleAr = TextEditingController();
  final titleEn = TextEditingController();
  final descriptionAr = TextEditingController();
  final descriptionEn = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final url = TextEditingController();
  final completion = TextEditingController();
  final totalExperience = TextEditingController();
  FilePickerResult? image;
  FilePickerResult? video;
  FilePickerResult? file;

  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          var uid = snapshot.data!['uid'];
          var type = snapshot.data!['type'];
          loading = false;

          return Scaffold(
              backgroundColor: Colors.white,
              appBar: watheftyBar(context, widget.id == 0 ? 'Create a new service' : "Edit service", 18),
              bottomNavigationBar: watheftyBottomBar(context),
              body: FutureBuilder<Map>(
                  future: getServices(uid, 'edit', lang, widget.status, widget.id, type),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      loading = false;
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        var shrt = snapshot.data;
                        section.text = shrt!['service_section_id'].toString();
                        price.text = shrt['price'];
                        titleAr.text = shrt['service_title_ar'];
                        titleEn.text = shrt['service_title_en'];
                        descriptionAr.text = shrt['service_description_ar'];
                        descriptionEn.text = shrt['service_description_en'];
                        email.text = shrt['contact_email'];
                        completion.text = shrt['service_completion_time'];
                        phone.text = shrt['contact_phone'];
                        url.text = shrt['contact_url'];
                        address.text = shrt['contact_address'];
                        totalExperience.text = shrt['total_experience'];
                        var tmpp = shrt['file'] != null ? shrt['file'].split("/") : null;
                        var tmpv = shrt['video'] != null ? shrt['video'].split("/") : null;
                        defaultpicked = tmpp != null ? tmpp[tmpp.length - 1] : '';
                        defaultvid = tmpv != null ? tmpv[tmpv.length - 1] : '';
                        imgLnk = shrt['main_image'] != null ? NetworkImage(shrt['main_image']) : AssetImage('assets/logo.png');
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
                                    child: Text('Service image', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
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
                                            image: DecorationImage(fit: BoxFit.contain, image: image != null ? Image.file(File(image!.files.first.path!)).image : imgLnk)))
                                  ]);
                                }),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Section', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                StatefulBuilder(builder: (BuildContext context, StateSetter _setSpecialty) {
                                  return Column(children: [
                                    FutureBuilder<List<Map<String, dynamic>>>(
                                        future: getInfo('serviceSection', lang, uid),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                            return Container(
                                                margin: (EdgeInsets.symmetric(vertical: 5)),
                                                child: SelectFormField(
                                                  validator: (val) {
                                                    if (val!.isEmpty) {
                                                      return tr('Please select a section');
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                                      filled: true,
                                                      fillColor: Colors.grey[50],
                                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                  type: SelectFormFieldType.dropdown,
                                                  items: snapshot.data,
                                                  controller: section,
                                                ));
                                          } else if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Center(child: Container(margin: EdgeInsets.only(top: 10), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                                          } else {
                                            return SizedBox();
                                          }
                                        })
                                  ]);
                                }),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Arabic Service Title', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                TextField(
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  style: TextStyle(color: Colors.blueGrey),
                                  textDirection: ui.TextDirection.rtl,
                                  controller: titleAr,
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('English Service Title', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                TextField(
                                  textDirection: ui.TextDirection.ltr,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  style: TextStyle(color: Colors.blueGrey),
                                  controller: titleEn,
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Price', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                TextField(
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  style: TextStyle(color: Colors.blueGrey),
                                  textDirection: lang == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                                  controller: price,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  ],
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Service completion time', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                TextField(
                                  textDirection: ui.TextDirection.ltr,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      hintText: tr('ex: 1 day, 5 months, 2 years'),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  style: TextStyle(color: Colors.blueGrey),
                                  controller: completion,
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Arabic Description', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                TextField(
                                  minLines: 4,
                                  keyboardType: TextInputType.multiline,
                                  textDirection: ui.TextDirection.rtl,
                                  maxLines: null,
                                  controller: descriptionAr,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
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
                                  controller: descriptionEn,
                                  textDirection: ui.TextDirection.ltr,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Experience', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                SelectFormField(
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  type: SelectFormFieldType.dropdown,
                                  items: numbers,
                                  controller: totalExperience,
                                  // onChanged: (val) => exp.text = val,
                                ),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Add Video', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                StatefulBuilder(builder: (BuildContext context, StateSetter setVideo) {
                                  return Container(
                                      decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      alignment: Alignment.bottomRight,
                                      child: TextButton(
                                        onPressed: () async {
                                          video = await FilePicker.platform.pickFiles(type: FileType.video);
                                          setVideo(() {});
                                        },
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [Text(video != null ? video!.files.first.name : defaultvid.toString()), Icon(Icons.file_upload_outlined, color: hexStringToColor('#6986b8'))]),
                                      ));
                                }),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Add File', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                StatefulBuilder(builder: (BuildContext context, StateSetter setFile) {
                                  return Container(
                                      decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      alignment: Alignment.bottomRight,
                                      child: TextButton(
                                        onPressed: () async {
                                          file = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['docx', 'pdf']);
                                          setFile(() {});
                                        },
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [Text(file != null ? file!.files.first.name : defaultpicked.toString()), Icon(Icons.file_upload_outlined, color: hexStringToColor('#6986b8'))]),
                                      ));
                                }),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Contact phone', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                InternationalPhoneNumberInput(
                                  inputDecoration: InputDecoration(
                                      fillColor: Colors.grey[50],
                                      filled: true,
                                      hintText: phone.text,
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  spaceBetweenSelectorAndTextField: 1,
                                  // textFieldController: phone,
                                  onInputChanged: (PhoneNumber number) {
                                    phone.text = number.phoneNumber!;
                                  },
                                  selectorConfig: SelectorConfig(leadingPadding: 15, selectorType: PhoneInputSelectorType.BOTTOM_SHEET, setSelectorButtonAsPrefixIcon: true),
                                  autoValidateMode: AutovalidateMode.onUserInteraction,
                                  hintText: phone.text,
                                  initialValue: PhoneNumber(isoCode: 'JO'),
                                  errorMessage: tr('Invalid phone number'),
                                  selectorTextStyle: TextStyle(color: Colors.black),
                                  keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Contact Email', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                TextField(
                                  controller: email,
                                  textDirection: ui.TextDirection.ltr,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Contact URL', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                TextField(
                                  controller: url,
                                  textDirection: ui.TextDirection.ltr,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Contact address', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                TextField(
                                  controller: address,
                                  textDirection: ui.TextDirection.ltr,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                                SizedBox(height: 10),
                                StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
                                  return !loading
                                      ? Container(
                                          decoration: BoxDecoration(color: hexStringToColor('#6986b8'), border: Border.all(width: 0.2), borderRadius: BorderRadius.all(Radius.circular(30))),
                                          width: getWH(context, 2),
                                          height: getWH(context, 1) * 0.07,
                                          margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                                          child: TextButton(
                                              onPressed: () async {
                                                if (section.text.isEmpty ||
                                                    price.text.isEmpty ||
                                                    titleAr.text.isEmpty ||
                                                    titleEn.text.isEmpty ||
                                                    totalExperience.text.isEmpty ||
                                                    completion.text.isEmpty) {
                                                  Get.snackbar(tr('All the fields are required'), tr('Please fill them and try again'),
                                                      duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.red, leftBarIndicatorColor: Colors.red);
                                                  return;
                                                }
                                                Map uInfo = {
                                                  'service_section_id': section.text,
                                                  'price': price.text,
                                                  'service_title_ar': titleAr.text,
                                                  'service_title_en': titleEn.text,
                                                  'service_description_ar': descriptionAr.text,
                                                  'service_description_en': descriptionEn.text,
                                                  'contact_email': email.text,
                                                  'contact_phone': phone.text,
                                                  'contact_address': address.text,
                                                  'contact_url': url.text,
                                                  'service_completion_time': completion.text,
                                                  'total_experience': totalExperience.text
                                                };
                                                if (widget.id != 0) {
                                                  uInfo['service_id'] = widget.id;
                                                }
                                                image != null ? uInfo['main_image'] = File(image!.files.first.path!) : image = null;
                                                file != null ? uInfo['file'] = File(file!.files.first.path!) : file = null;
                                                video != null ? uInfo['video'] = File(video!.files.first.path!) : video = null;
                                                _setState(() {
                                                  loading = true;
                                                });
                                                var tmp = await createService(lang, uid, type, uInfo, widget.id.toString());
                                                _setState(() {
                                                  loading = false;
                                                });
                                                if (tmp['status'] == true) {
                                                  if (globalType == "Individual")
                                                    Get.offAll(() => IndivProfilePage());
                                                  else
                                                    Get.offAll(() => CompanyProfilePage());
                                                }
                                              },
                                              child:
                                                  Text(widget.id != 0 ? tr('Edit Service') : tr('Add Service'), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)).tr()))
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
