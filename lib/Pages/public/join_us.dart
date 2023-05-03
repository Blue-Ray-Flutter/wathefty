import 'dart:io';
import 'dart:ui' as ui;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wathefty/API.dart';
import '../../../functions.dart';
import '../../data.dart';
import '../../main.dart';

class JoinUsPage extends StatefulWidget {
  @override
  _JoinUsPageState createState() => _JoinUsPageState();
}

class _JoinUsPageState extends State<JoinUsPage> {
  @override
  void initState() {
    super.initState();
  }

  final name = TextEditingController();
  final email = TextEditingController();
  final subject = TextEditingController();
  final phone = TextEditingController();
  final country = TextEditingController();
  final region = TextEditingController();
  final academic = TextEditingController();
  final experience = TextEditingController();
  final gender = TextEditingController();
  int genderint = 1;
  final birth = TextEditingController();
  FilePickerResult? cv;
  bool loading = false;
  final globalFormKey = GlobalKey<FormState>();
  
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        loading = false;
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: watheftyBar(context, "Join Us", 20),
              bottomNavigationBar: watheftyBottomBar(context),
              body: StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
                return Column(children: [
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.all(30),
                          width: getWH(context, 2),
                          child: SingleChildScrollView(
                              child: Form(
                                  key: globalFormKey,
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                    Container(
                                        margin: EdgeInsets.only(bottom: 30, left: 15, right: 15),
                                        child: Text('Join our team', textAlign: TextAlign.start, style: TextStyle(fontSize: 23.0, color: Colors.black87)).tr()),
                                    Container(
                                        padding: EdgeInsets.only(left: 15),
                                        margin: EdgeInsets.only(bottom: 10, top: 30),
                                        child: Text('Name', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                    TextField(
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                        style: TextStyle(color: Colors.blueGrey),
                                        controller: name,
                                        onSubmitted: (value) async {
                                          name.text = value;
                                        }),
                                    Container(
                                        padding: EdgeInsets.only(left: 15),
                                        margin: EdgeInsets.only(bottom: 10, top: 20),
                                        child: Text('Email', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                    TextField(
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                        style: TextStyle(color: Colors.blueGrey),
                                        controller: email,
                                        textDirection: ui.TextDirection.ltr,
                                        onSubmitted: (value) {
                                          email.text = value;
                                        }),
                                    Container(
                                        padding: EdgeInsets.only(left: 15),
                                        margin: EdgeInsets.only(bottom: 10, top: 20),
                                        child: Text('Phone number', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                    InternationalPhoneNumberInput(
                                        spaceBetweenSelectorAndTextField: 1,
                                        inputDecoration: InputDecoration(
                                            fillColor: Colors.grey[50],
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                        selectorConfig: SelectorConfig(leadingPadding: 15, selectorType: PhoneInputSelectorType.BOTTOM_SHEET, setSelectorButtonAsPrefixIcon: true),
                                        autoValidateMode: AutovalidateMode.onUserInteraction,
                                        initialValue: PhoneNumber(isoCode: 'JO'),
                                        errorMessage: tr('Invalid phone number'),
                                        selectorTextStyle: TextStyle(color: Colors.black),
                                        keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                        onInputChanged: (PhoneNumber number) {
                                          phone.text = number.phoneNumber!;
                                        }),
                                    Container(
                                        padding: EdgeInsets.only(left: 15),
                                        margin: EdgeInsets.only(bottom: 10, top: 20),
                                        child: Text('Academic Degree', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                    DropdownSearch<Map>(
                                        items: arrtoList(degreeArr, lang, ''),
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
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                        onChanged: (val) {
                                          academic.text = val!['value'].toString();
                                        },
                                        showSearchBox: true),
                                    Container(
                                        padding: EdgeInsets.only(left: 15),
                                        margin: EdgeInsets.only(bottom: 10, top: 20),
                                        child: Row(children: [Text('Gender', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()])),
                                    StatefulBuilder(builder: (BuildContext context, StateSetter setGender) {
                                      return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                        Expanded(
                                            child: ListTile(
                                                title: Text("Male", style: TextStyle(color: genderint == 1 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                                leading: Radio(
                                                    value: 1,
                                                    groupValue: genderint,
                                                    activeColor: hexStringToColor('#6986b8'),
                                                    onChanged: (value) {
                                                      setGender(() {
                                                        genderint = value as int;
                                                        gender.text = genderint.toString();
                                                      });
                                                    }))),
                                        Expanded(
                                            child: ListTile(
                                                title: Text("Female", style: TextStyle(color: genderint == 2 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                                leading: Radio(
                                                    value: 2,
                                                    groupValue: genderint,
                                                    activeColor: hexStringToColor('#6986b8'),
                                                    onChanged: (value) {
                                                      setGender(() {
                                                        genderint = value as int;
                                                        gender.text = genderint.toString();
                                                      });
                                                    })))
                                      ]);
                                    }),
                                    Container(
                                        padding: EdgeInsets.only(left: 15),
                                        margin: EdgeInsets.only(bottom: 10, top: 20),
                                        child: Row(children: [Text('Birth date', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()])),
                                    StatefulBuilder(builder: (BuildContext context, StateSetter setBirth) {
                                      return SizedBox(
                                          width: getWH(context, 2),
                                          child: TextButton(
                                              style: ButtonStyle(
                                                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 18, horizontal: 20)),
                                                  foregroundColor: MaterialStateProperty.all(Colors.grey[50]),
                                                  shape:
                                                      MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(25), side: BorderSide(width: 0.4))),
                                                  backgroundColor: MaterialStateProperty.all(Colors.grey[50])),
                                              onPressed: () {
                                                var now = DateTime.now();
                                                DatePicker.showDatePicker(context,
                                                    showTitleActions: true,
                                                    minTime: DateTime(now.year - 80, now.month, now.day + 1),
                                                    maxTime: DateTime(now.year + -10),
                                                    onChanged: (date) {}, onConfirm: (date) {
                                                  setBirth(() {
                                                    birth.text = date.toString().substring(0, 10);
                                                  });
                                                }, currentTime: DateTime.now(), locale: lang == 'ar' ? LocaleType.ar : LocaleType.en);
                                              },
                                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                Text(birth.text.isNotEmpty ? birth.text : 'Birth date', style: TextStyle(color: Colors.black54)).tr(),
                                                Icon(Icons.calendar_today, color: Colors.black54)
                                              ])));
                                    }),
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
                                        controller: experience),
                                    Container(
                                        padding: EdgeInsets.symmetric(horizontal: 15),
                                        margin: EdgeInsets.only(bottom: 10, top: 20),
                                        child: Row(children: [Text('Upload CV', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()])),
                                    StatefulBuilder(builder: (BuildContext context, StateSetter setFile) {
                                      return Container(
                                          decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                          alignment: Alignment.bottomRight,
                                          child: TextButton(
                                              onPressed: () async {
                                                cv = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['docx', 'pdf', 'doc']);
                                                setFile(() {});
                                              },
                                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                Text(cv != null ? cv!.files.first.name : "", style: TextStyle(color: Colors.black54)),
                                                Icon(Icons.file_upload_outlined, color: hexStringToColor('#6986b8'))
                                              ])));
                                    }),
                                    StatefulBuilder(builder: (BuildContext context, StateSetter _setRegion) {
                                      return Container(
                                          margin: const EdgeInsets.only(top: 35),
                                          padding: const EdgeInsets.only(top: 15, bottom: 30, right: 15, left: 15),
                                          decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.1), borderRadius: BorderRadius.all(Radius.circular(15))),
                                          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                                            Container(
                                                padding: EdgeInsets.only(left: 15),
                                                alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                                margin: EdgeInsets.only(bottom: 10, top: 20),
                                                child: Text('Country. region and address', style: TextStyle(fontSize: 15.0, color: Colors.black87)).tr()),
                                            DropdownSearch<Map>(
                                              items: arrtoList(countryArr, lang, ''),
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
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                              onChanged: (val) {
                                                _setRegion(() {
                                                  country.text = (val!['value'].toString());
                                                  region.text = '';
                                                });
                                              },
                                              showSearchBox: true,
                                            ),
                                            SizedBox(height: 15),
                                            country.text.isNotEmpty
                                                ? FutureBuilder<List<Map<String, dynamic>>>(
                                                    future: getInfo('region', lang, country.text),
                                                    builder: (context, snapshot) {
                                                      if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                                                        return DropdownSearch<Map>(
                                                          items: mpR,
                                                          maxHeight: 300,
                                                          popupItemBuilder: (context, item, isSelected) {
                                                            return Container(
                                                                height: 50, child: Column(children: [Expanded(child: Text(item['label'])), Divider(thickness: 1, indent: 10, endIndent: 10)]));
                                                          },
                                                          dropdownBuilder: (context, selectedItem) {
                                                            if (selectedItem != null)
                                                              return Text(selectedItem['label']);
                                                            else
                                                              return Text('');
                                                          },
                                                          dropdownSearchDecoration: InputDecoration(
                                                              hintText: tr('Search'),
                                                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                                                              filled: true,
                                                              fillColor: Colors.white,
                                                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                          onChanged: (val) {
                                                            region.text = val!['value'].toString();
                                                          },
                                                          showSearchBox: true,
                                                        );
                                                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                                                        return Center(
                                                            child: Container(margin: EdgeInsets.only(top: 10), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                                                      } else {
                                                        return SizedBox();
                                                      }
                                                    })
                                                : SizedBox(),
                                          ]));
                                    }),
                                    !loading
                                        ? GestureDetector(
                                            onTap: () async {
                                              if (name.text.isEmpty || email.text.isEmpty) {
                                                Get.snackbar(tr("Missing info"), '',
                                                    duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.red, leftBarIndicatorColor: Colors.red);
                                              }
                                              if (globalFormKey.currentState!.validate()) {
                                                _setState(() {
                                                  loading = true;
                                                });
                                                Map info = {
                                                  'email': email.text,
                                                  'name': name.text,
                                                  'phone': phone.text,
                                                  'country_id': name.text,
                                                  'region_id': name.text,
                                                  'academic_id': name.text,
                                                  'experience_years': name.text,
                                                  'gender': name.text,
                                                  'birth_date': name.text,
                                                  'cv_file': ""
                                                };
                                                cv != null ? info['cv_file'] = File(cv!.files.first.path!) : cv = null;
                                                await joinUs(info);
                                                _setState(() {
                                                  loading = false;
                                                });
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(color: hexStringToColor('#6986b8'), border: Border.all(width: 0.2), borderRadius: BorderRadius.all(Radius.circular(30))),
                                              width: getWH(context, 2),
                                              height: getWH(context, 1) * 0.07,
                                              margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                                              alignment: Alignment.center,
                                              child: Text("Submit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)).tr(),
                                            ))
                                        : Container(
                                            margin: EdgeInsets.symmetric(horizontal: 30), alignment: Alignment.center, constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())
                                  ])))))
                ]);
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
                        Text("Something went wrong, please check your internet and try to log in again.", textAlign: TextAlign.center).tr(),
                        TextButton(
                            child: Text('Retry').tr(),
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.clear();
                              Get.offAll(() => StartPage());
                            })
                      ]))));
        }
      });
}
