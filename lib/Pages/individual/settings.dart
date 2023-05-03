import 'dart:io';
import 'dart:ui' as ui;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wathefty/Pages/individual/profile.dart';
import 'package:wathefty/Pages/auth/otp.dart';
import '../../API.dart';
import '../../data.dart';
import '../../functions.dart';
import '../../main.dart';
// import '../auth/password_page.dart';

class IndivSettingsPage extends StatefulWidget {
  @override
  _IndivSettingsPageState createState() => _IndivSettingsPageState();
}

class _IndivSettingsPageState extends State<IndivSettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  FilePickerResult? result, cv;

  final email = TextEditingController();
  final nameAr = TextEditingController();
  final nameEn = TextEditingController();
  final password = TextEditingController();
  final passwordconfirm = TextEditingController();
  final username = TextEditingController();
  final phone = TextEditingController();
  final countryId = TextEditingController(text: '111');
  final regionId = TextEditingController();
  final addressAr = TextEditingController();
  final addressEn = TextEditingController();
  final photo = TextEditingController();
  var defaultPhone;
  bool loading = false;
  Map? profileData;

  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: getProfile('Individual'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          loading = false;
          result = null;
          profileData = snapshot.data;
          if (profileData!['status'] == true) {
            profileData = profileData!['user_info'];
          }
          nameAr.text = profileData?['name_ar'] ?? '';
          nameEn.text = profileData?['name_en'] ?? '';
          username.text = profileData?['username'] ?? '';
          email.text = profileData!['email'];
          countryId.text = profileData?['country_id'] != null && double.tryParse(profileData!['country_id'].toString()) != null
              ? profileData!['country_id'].toString()
              : '111';
          regionId.text = profileData!['region_id'].toString();
          addressAr.text = profileData!['address_ar'] ?? '';
          addressEn.text = profileData!['address_en'] ?? '';
          phone.text = profileData!['phone'] ?? '';
          defaultPhone = profileData!['phone'] ?? '';
          photo.text = profileData?['profile_photo_path'] ??
              "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png";

          return WillPopScope(
              onWillPop: () async {
                // show the confirm back dialog
                bool leave = await backDialog(context);
                return leave;
              },
              child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                      centerTitle: true,
                      leading: IconButton(
                          onPressed: () async {
                            bool leave = await backDialog(context);
                            if (leave) {
                              Get.back();
                            }
                          },
                          icon: Icon(Icons.arrow_back),
                          color: Colors.white),
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
                      title: Text('Edit Profile', style: TextStyle(fontSize: 18, color: Colors.white)).tr()),
                  bottomNavigationBar: watheftyBottomBar(context),
                  body: StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
                    return Column(children: [
                      Expanded(
                          child: Container(
                              width: getWH(context, 2),
                              child: ListView(children: [
                                Container(
                                  margin: EdgeInsets.only(top: 25, bottom: 25),
                                  child: StatefulBuilder(builder: (BuildContext context, StateSetter setImage) {
                                    return Column(children: [
                                      CircleAvatar(
                                          radius: 50,
                                          backgroundImage: result != null
                                              ? Image.file(File(result!.files.first.path!)).image
                                              : NetworkImage(profileData!['profile_photo_path'])),
                                      TextButton(
                                          onPressed: () async {
                                            result = await FilePicker.platform.pickFiles(type: FileType.image);
                                            setImage(() {});
                                          },
                                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                            Icon(Icons.file_upload_outlined, color: hexStringToColor('#6986b8')),
                                            Text('Upload', style: TextStyle(color: hexStringToColor('#6986b8'))).tr()
                                          ]))
                                    ]);
                                  }),
                                ),
                                Container(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Align(
                                          alignment: Alignment.center,
                                          child: Text('Main required information', style: TextStyle(fontSize: 18.0, color: Colors.black87)).tr()),
                                      Container(
                                          padding: EdgeInsets.only(left: 15),
                                          margin: EdgeInsets.only(bottom: 10, top: 30),
                                          child: Text('Arabic Name', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                      TextField(
                                        textDirection: ui.TextDirection.rtl,
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                            enabledBorder:
                                                OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                        style: TextStyle(color: Colors.blueGrey),
                                        controller: nameAr,
                                        onSubmitted: (value) async {
                                          nameAr.text = value;
                                        },
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(left: 15),
                                          margin: EdgeInsets.only(bottom: 10, top: 20),
                                          child: Text('English Name', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                      TextField(
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                            enabledBorder:
                                                OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                        style: TextStyle(color: Colors.blueGrey),
                                        textDirection: ui.TextDirection.ltr,
                                        controller: nameEn,
                                        onSubmitted: (value) {
                                          nameEn.text = value;
                                        },
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(left: 15),
                                          margin: EdgeInsets.only(bottom: 10, top: 20),
                                          child: Text('Username', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                      TextField(
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                            enabledBorder:
                                                OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                        style: TextStyle(color: Colors.blueGrey),
                                        textDirection: ui.TextDirection.ltr,
                                        controller: username,
                                        onSubmitted: (value) {
                                          username.text = value;
                                        },
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(left: 15),
                                          margin: EdgeInsets.only(bottom: 10, top: 20),
                                          child: Text('Email', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                      TextField(
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                            enabledBorder:
                                                OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                        style: TextStyle(color: Colors.blueGrey),
                                        controller: email,
                                        textDirection: ui.TextDirection.ltr,
                                        onSubmitted: (value) {
                                          email.text = value;
                                        },
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(left: 15),
                                          margin: EdgeInsets.only(bottom: 10, top: 20),
                                          child: Text('Phone number', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                      InternationalPhoneNumberInput(
                                        spaceBetweenSelectorAndTextField: 1,
                                        inputDecoration: InputDecoration(
                                            fillColor: Colors.grey[50],
                                            filled: true,
                                            hintText: phone.text,
                                            enabledBorder:
                                                OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                        onInputChanged: (PhoneNumber number) {
                                          phone.text = number.phoneNumber!;
                                        },
                                        selectorConfig: SelectorConfig(
                                            leadingPadding: 15, selectorType: PhoneInputSelectorType.BOTTOM_SHEET, setSelectorButtonAsPrefixIcon: true),
                                        autoValidateMode: AutovalidateMode.onUserInteraction,
                                        hintText: phone.text,
                                        initialValue: PhoneNumber(isoCode: 'JO'),
                                        errorMessage: tr('Invalid phone number'),
                                        selectorTextStyle: TextStyle(color: Colors.black),
                                        keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(top: 35),
                                          padding: const EdgeInsets.only(top: 15, bottom: 30, right: 15, left: 15),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[50], border: Border.all(width: 0.1), borderRadius: BorderRadius.all(Radius.circular(15))),
                                          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                                            Container(
                                                alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                                padding: EdgeInsets.only(left: 15),
                                                margin: EdgeInsets.only(bottom: 10, top: 20),
                                                child: Text('Password (Optional)', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                            TextField(
                                              obscureText: true,
                                              decoration: InputDecoration(
                                                  hintText: tr('Password'),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                              style: TextStyle(color: Colors.blueGrey),
                                              textDirection: ui.TextDirection.ltr,
                                              controller: password,
                                              onSubmitted: (value) {
                                                password.text = value;
                                              },
                                            ),
                                            SizedBox(height: 15),
                                            TextField(
                                                obscureText: true,
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    hintText: tr('Password Confirmation'),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                style: TextStyle(color: Colors.blueGrey),
                                                textDirection: ui.TextDirection.ltr,
                                                controller: passwordconfirm)
                                          ])),
                                      StatefulBuilder(builder: (BuildContext context, StateSetter _setRegion) {
                                        return Container(
                                            margin: const EdgeInsets.only(top: 35),
                                            padding: const EdgeInsets.only(top: 15, bottom: 30, right: 15, left: 15),
                                            decoration: BoxDecoration(
                                                color: Colors.grey[50], border: Border.all(width: 0.1), borderRadius: BorderRadius.all(Radius.circular(15))),
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
                                                  return Container(
                                                      height: 50,
                                                      child: Column(
                                                          children: [Expanded(child: Text(item['label'])), Divider(thickness: 1, indent: 10, endIndent: 10)]));
                                                },
                                                dropdownBuilder: (context, selectedItem) {
                                                  if (selectedItem != null)
                                                    return Text(selectedItem['label']);
                                                  else
                                                    return Text(profileData?['country_name'] ?? '');
                                                },
                                                dropdownSearchDecoration: InputDecoration(
                                                    hintText: tr('Search'),
                                                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                onChanged: (val) {
                                                  _setRegion(() {
                                                    countryId.text = (val!['value'].toString());
                                                    regionId.text = '';
                                                    profileData?['region_name'] = '';
                                                  });
                                                },
                                                showSearchBox: true,
                                              ),
                                              SizedBox(height: 15),
                                              countryId.text.isNotEmpty
                                                  ? FutureBuilder<List<Map<String, dynamic>>>(
                                                      future: getInfo('region', lang, countryId.text),
                                                      builder: (context, snapshot) {
                                                        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                                                          return DropdownSearch<Map>(
                                                            items: mpR,
                                                            maxHeight: 300,
                                                            popupItemBuilder: (context, item, isSelected) {
                                                              return Container(
                                                                  height: 50,
                                                                  child: Column(children: [
                                                                    Expanded(child: Text(item['label'])),
                                                                    Divider(thickness: 1, indent: 10, endIndent: 10)
                                                                  ]));
                                                            },
                                                            dropdownBuilder: (context, selectedItem) {
                                                              if (selectedItem != null)
                                                                return Text(selectedItem['label']);
                                                              else
                                                                return Text(profileData!['region_name'] ?? '');
                                                            },
                                                            // selectedItem: {'value': regionId.text, 'label': profileData!['region_name']},
                                                            dropdownSearchDecoration: InputDecoration(
                                                                hintText: tr('Search'),
                                                                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                                                                filled: true,
                                                                fillColor: Colors.white,
                                                                enabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                                focusedBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(color: Colors.black54),
                                                                    borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                            onChanged: (val) {
                                                              regionId.text = val!['value'].toString();
                                                            },
                                                            showSearchBox: true,
                                                          );
                                                        } else if (snapshot.connectionState == ConnectionState.waiting) {
                                                          return Center(
                                                              child: Container(
                                                                  margin: EdgeInsets.only(top: 10),
                                                                  constraints: BoxConstraints.tightForFinite(),
                                                                  child: CircularProgressIndicator()));
                                                        } else {
                                                          return SizedBox();
                                                        }
                                                      })
                                                  : SizedBox(),
                                              Container(
                                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                                  padding: EdgeInsets.only(left: 15),
                                                  margin: EdgeInsets.only(bottom: 15)),
                                              TextField(
                                                textDirection: ui.TextDirection.rtl,
                                                decoration: InputDecoration(
                                                    hintText: tr('Arabic Address'),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                style: TextStyle(color: Colors.blueGrey),
                                                controller: addressAr,
                                                onSubmitted: (value) {
                                                  addressAr.text = value;
                                                },
                                              ),
                                              Container(
                                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                                  padding: EdgeInsets.only(left: 15),
                                                  margin: EdgeInsets.only(bottom: 15)),
                                              TextField(
                                                decoration: InputDecoration(
                                                    hintText: tr('English Address'),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                style: TextStyle(color: Colors.blueGrey),
                                                controller: addressEn,
                                                onSubmitted: (value) {
                                                  addressEn.text = value;
                                                },
                                              ),
                                            ]));
                                      }),
                                      SizedBox(height: 5),
                                      Divider(thickness: 2),
                                      StatefulBuilder(builder: (BuildContext context, StateSetter setLoading) {
                                        return !loading
                                            ? GestureDetector(
                                                onTap: () async {
                                                  if (nameAr.text.isEmpty ||
                                                      nameEn.text.isEmpty ||
                                                      username.text.isEmpty ||
                                                      email.text.isEmpty ||
                                                      countryId.text.isEmpty ||
                                                      regionId.text.isEmpty ||
                                                      phone.text.isEmpty ||
                                                      addressAr.text.isEmpty ||
                                                      addressEn.text.isEmpty) {
                                                    Get.snackbar(tr('All the fields are required'), tr('Please fill them and try again'),
                                                        duration: Duration(seconds: 5),
                                                        backgroundColor: Colors.white,
                                                        colorText: Colors.red,
                                                        leftBarIndicatorColor: Colors.red);
                                                    return;
                                                  }
                                                  if (password.text.isNotEmpty && (password.text != passwordconfirm.text)) {
                                                    Get.snackbar(tr("Passwords don't match"), tr(''),
                                                        duration: Duration(seconds: 5),
                                                        backgroundColor: Colors.white,
                                                        colorText: Colors.red,
                                                        leftBarIndicatorColor: Colors.red);
                                                    return;
                                                  }
                                                  setLoading(() {
                                                    loading = true;
                                                  });
                                                  Map uInfo = {
                                                    'name_ar': nameAr.text,
                                                    'name_en': nameEn.text,
                                                    'username': username.text,
                                                    'email': email.text,
                                                    'phone': phone.text,
                                                    'country_id': countryId.text,
                                                    'region_id': regionId.text,
                                                    'address_ar': addressAr.text,
                                                    'address_en': addressEn.text
                                                  };
                                                  if (password.text.isNotEmpty) {
                                                    uInfo['password'] = password.text;
                                                  }
                                                  result != null ? uInfo['profile_photo_path'] = File(result!.files.first.path!) : result = null;
                                                  uInfo['id'] = profileData!['id'].toString();
                                                  uInfo['type'] = 'Individual';
                                                  if (phone.text != defaultPhone) {
                                                    Map tmp = await getOTP(phone.text, lang);
                                                    if (tmp.isNotEmpty && tmp['status']) {
                                                      Get.to(() => OTP(data: uInfo, type: 2));
                                                    }
                                                  } else {
                                                    uInfo['code'] = '';
                                                    var tmp = await updateProfile(lang, uInfo['id'], uInfo['type'], uInfo);
                                                    if (tmp['status'] == true) {
                                                      Get.offAll(() => IndivProfilePage());
                                                    }
                                                  }
                                                  setLoading(() {
                                                    loading = false;
                                                  });
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: hexStringToColor('#6986b8'),
                                                        border: Border.all(width: 0.2),
                                                        borderRadius: BorderRadius.all(Radius.circular(30))),
                                                    width: getWH(context, 2),
                                                    height: getWH(context, 1) * 0.07,
                                                    margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                                                    alignment: Alignment.center,
                                                    child:
                                                        Text('Submit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)).tr()))
                                            : Center(
                                                child: Container(
                                                    margin: EdgeInsets.only(bottom: 100),
                                                    constraints: BoxConstraints.tightForFinite(),
                                                    child: CircularProgressIndicator()));
                                      })
                                    ]))
                              ])))
                    ]);
                  })));
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
                        Text("Something went wrong, please check your internet and try to log in again.", textAlign: TextAlign.center).tr(),
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

class IndivInfoPage extends StatefulWidget {
  @override
  _IndivInfoPageState createState() => _IndivInfoPageState();
}

class _IndivInfoPageState extends State<IndivInfoPage> {
  @override
  void initState() {
    super.initState();
  }

  FilePickerResult? cv;

  final nationalityId = TextEditingController();
  final individualPhoneExtra = TextEditingController();
  final whatsapp = TextEditingController();
  final academicDegreeId = TextEditingController();
  final currentStatus = TextEditingController();
  final english = TextEditingController();
  final computer = TextEditingController();
  final sectionId = TextEditingController();
  final specialtyId = TextEditingController();
  final individualNationalNumber = TextEditingController();
  final individualSocialStatus = TextEditingController();
  final individualGender = TextEditingController(text: '1');
  final individualBirthDate = TextEditingController();
  final individualOverview = TextEditingController();
  final facebook = TextEditingController();
  List professionSelection = [];
  // List languageSelection = [];
  String specialtyDefault = '';
  var defaultpicked = ' ';
  int gender = 1;
  bool loading = false;
  List<Map<dynamic, dynamic>> sections = [];
  List<Map<dynamic, dynamic>> specialties = [];
  List<Map<dynamic, dynamic>> professions = [];
  Map? profileData;

  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: getProfile('Individual'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          loading = false;
          profileData = snapshot.data;
          if (profileData!['status'] == true) {
            profileData = profileData!['user_info'];
          }
          if (profileData!['user_profile'] != null) {
            individualNationalNumber.text = profileData!['user_profile']['individual_national_number'] ?? '';
            professionSelection = profileData?["individual_profession_ids"];
            if (profileData?['user_profile']["individual_cv_file"] != null)
              defaultpicked = profileData!['user_profile']["individual_cv_file"].split('/').last ?? " ";
            nationalityId.text = (profileData!['user_profile']['individual_nationality'] ?? '').toString();
            specialtyId.text = profileData!['user_profile']['specialty_id'].toString();
            sectionId.text = profileData!['user_profile']['section_id'].toString();
            // if (profileData!['user_profile']['individual_languages'] != null) languageSelection = profileData!['user_profile']['individual_languages'].split(',').toList();
            individualPhoneExtra.text = profileData!['user_profile']['individual_phone_extra'] ?? '';
            whatsapp.text = profileData!['user_profile']['whatsapp_number'] ?? '';
            gender = profileData?['user_profile']['individual_gender'] != null && profileData?['user_profile']['individual_gender'] == 'Female' ? 2 : 1;
            individualGender.text = gender.toString();
            individualBirthDate.text = profileData!['user_profile']['individual_birth_date'] ?? '';
            individualSocialStatus.text = profileData!['user_profile']['social_status_id'].toString();
            academicDegreeId.text = profileData!['user_profile']['academec_degree_id'].toString();
            currentStatus.text = profileData!['user_profile']['current_status_id'].toString();
            english.text = profileData!['user_profile']['english_level_id'].toString();
            computer.text = profileData!['user_profile']['computer_skills_id'].toString();
            individualOverview.text = profileData!['user_profile']['individual_overview'] ?? '';
            facebook.text = profileData!['user_profile']['individual_facebook_url'] ?? '';
            specialtyDefault = profileData?['user_profile']['specialty_name'] ?? '';
          }

          return WillPopScope(
              onWillPop: () async {
                bool leave = await backDialog(context);
                return leave;
              },
              child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                      centerTitle: true,
                      leading: IconButton(
                          onPressed: () async {
                            bool leave = await backDialog(context);
                            if (leave) {
                              Get.back();
                            }
                          },
                          icon: Icon(Icons.arrow_back),
                          color: Colors.white),
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
                      title: Text('Personal Information', style: TextStyle(fontSize: 18, color: Colors.white)).tr()),
                  bottomNavigationBar: watheftyBottomBar(context),
                  body: StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
                    return Column(children: [
                      Expanded(
                          child: Container(
                              width: getWH(context, 2),
                              child: ListView(children: [
                                Container(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Container(
                                          padding: EdgeInsets.only(left: 15),
                                          margin: EdgeInsets.only(bottom: 10, top: 20),
                                          child: Row(children: [
                                            Text('Gender', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr(),
                                            Text(' *', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red))
                                          ])),
                                      StatefulBuilder(builder: (BuildContext context, StateSetter setGender) {
                                        return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                          Expanded(
                                              child: ListTile(
                                            title: Text("Male", style: TextStyle(color: gender == 1 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                            leading: Radio(
                                              value: 1,
                                              groupValue: gender,
                                              onChanged: (value) {
                                                setGender(() {
                                                  gender = value as int;
                                                  individualGender.text = gender.toString();
                                                });
                                              },
                                              activeColor: hexStringToColor('#6986b8'),
                                            ),
                                          )),
                                          Expanded(
                                              child: ListTile(
                                                  title: Text("Female", style: TextStyle(color: gender == 2 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                                  leading: Radio(
                                                      value: 2,
                                                      groupValue: gender,
                                                      onChanged: (value) {
                                                        setGender(() {
                                                          gender = value as int;
                                                          individualGender.text = gender.toString();
                                                        });
                                                      },
                                                      activeColor: hexStringToColor('#6986b8'))))
                                        ]);
                                      }),
                                      Container(
                                          padding: EdgeInsets.only(left: 15),
                                          margin: EdgeInsets.only(bottom: 10, top: 20),
                                          child: Row(children: [
                                            Text('Nationality', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr(),
                                            Text(' *', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red))
                                          ])),
                                      DropdownSearch<Map>(
                                        items: arrtoList(nationalityArr, lang, ''),
                                        maxHeight: 300,
                                        popupItemBuilder: (context, item, isSelected) {
                                          return Container(
                                              height: 50,
                                              child:
                                                  Column(children: [Expanded(child: Text(item['label'])), Divider(thickness: 1, indent: 10, endIndent: 10)]));
                                        },
                                        dropdownBuilder: (context, selectedItem) {
                                          if (selectedItem != null)
                                            return Text(selectedItem['label']);
                                          else
                                            return Text(profileData?["user_profile"]["nationality_name"] ?? '');
                                        },
                                        dropdownSearchDecoration: InputDecoration(
                                            hintText: tr('Search'),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                            enabledBorder:
                                                OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                        onChanged: (val) {
                                          nationalityId.text = val!['value'].toString();
                                        },
                                        showSearchBox: true,
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(left: 15),
                                          margin: EdgeInsets.only(bottom: 10, top: 20),
                                          child: Row(children: [
                                            Text('Birth date', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr(),
                                            Text(' *', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red))
                                          ])),
                                      StatefulBuilder(builder: (BuildContext context, StateSetter setBirth) {
                                        return SizedBox(
                                            width: getWH(context, 2),
                                            child: TextButton(
                                                style: ButtonStyle(
                                                    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 18, horizontal: 20)),
                                                    foregroundColor: MaterialStateProperty.all(Colors.grey[50]),
                                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(25), side: BorderSide(width: 0.4))),
                                                    backgroundColor: MaterialStateProperty.all(Colors.grey[50])),
                                                onPressed: () {
                                                  var now = DateTime.now();
                                                  DatePicker.showDatePicker(context,
                                                      showTitleActions: true,
                                                      minTime: DateTime(now.year - 80, now.month, now.day + 1),
                                                      maxTime: DateTime(now.year + -10),
                                                      onChanged: (date) {}, onConfirm: (date) {
                                                    setBirth(() {
                                                      individualBirthDate.text = date.toString().substring(0, 10);
                                                    });
                                                  }, currentTime: DateTime.now(), locale: lang == 'ar' ? LocaleType.ar : LocaleType.en);
                                                },
                                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                  Text(individualBirthDate.text.isNotEmpty ? individualBirthDate.text : 'Birth date',
                                                          style: TextStyle(color: Colors.black54))
                                                      .tr(),
                                                  Icon(Icons.calendar_today, color: Colors.black54)
                                                ])));
                                      }),
                                      Container(
                                          padding: EdgeInsets.only(left: 15),
                                          margin: EdgeInsets.only(bottom: 10, top: 20),
                                          child: Text('Extra phone', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                      InternationalPhoneNumberInput(
                                        inputDecoration: InputDecoration(
                                            fillColor: Colors.grey[50],
                                            filled: true,
                                            hintText: individualPhoneExtra.text,
                                            enabledBorder:
                                                OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                        spaceBetweenSelectorAndTextField: 1,
                                        onInputChanged: (PhoneNumber number) {
                                          individualPhoneExtra.text = number.phoneNumber!;
                                        },
                                        selectorConfig: SelectorConfig(
                                            leadingPadding: 15, selectorType: PhoneInputSelectorType.BOTTOM_SHEET, setSelectorButtonAsPrefixIcon: true),
                                        autoValidateMode: AutovalidateMode.onUserInteraction,
                                        hintText: individualPhoneExtra.text,
                                        initialValue: PhoneNumber(isoCode: 'JO'),
                                        errorMessage: tr('Invalid phone number'),
                                        selectorTextStyle: TextStyle(color: Colors.black),
                                        keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(left: 15),
                                          margin: EdgeInsets.only(bottom: 10, top: 20),
                                          child: Text('Whatsapp', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                      InternationalPhoneNumberInput(
                                        inputDecoration: InputDecoration(
                                            fillColor: Colors.grey[50],
                                            hintText: whatsapp.text,
                                            filled: true,
                                            enabledBorder:
                                                OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                        spaceBetweenSelectorAndTextField: 1,
                                        onInputChanged: (PhoneNumber number) {
                                          whatsapp.text = number.phoneNumber!;
                                        },
                                        selectorConfig: SelectorConfig(
                                            leadingPadding: 15, selectorType: PhoneInputSelectorType.BOTTOM_SHEET, setSelectorButtonAsPrefixIcon: true),
                                        autoValidateMode: AutovalidateMode.onUserInteraction,
                                        hintText: whatsapp.text,
                                        initialValue: PhoneNumber(isoCode: 'JO'),
                                        errorMessage: tr('Invalid phone number'),
                                        selectorTextStyle: TextStyle(color: Colors.black),
                                        keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(left: 15),
                                          margin: EdgeInsets.only(bottom: 10, top: 20),
                                          child: Row(children: [
                                            Text('Academic Degree', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr(),
                                            Text(' *', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red))
                                          ])),
                                      DropdownSearch<Map>(
                                        items: arrtoList(degreeArr, lang, ''),
                                        maxHeight: 300,
                                        popupItemBuilder: (context, item, isSelected) {
                                          return Container(
                                              height: 50,
                                              child:
                                                  Column(children: [Expanded(child: Text(item['label'])), Divider(thickness: 1, indent: 10, endIndent: 10)]));
                                        },
                                        dropdownBuilder: (context, selectedItem) {
                                          if (selectedItem != null)
                                            return Text(selectedItem['label']);
                                          else
                                            return Text(profileData?['user_profile']['academic_degree_name'] ?? '');
                                        },
                                        dropdownSearchDecoration: InputDecoration(
                                            hintText: tr('Search'),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                            enabledBorder:
                                                OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                        onChanged: (val) {
                                          academicDegreeId.text = val!['value'].toString();
                                        },
                                        showSearchBox: true,
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(left: 15),
                                          margin: EdgeInsets.only(bottom: 10, top: 20),
                                          child: Row(children: [
                                            Text('Section, specialty, and professions', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr(),
                                            Text(' *', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red))
                                          ])),
                                      StatefulBuilder(builder: (BuildContext context, StateSetter _setSpecialty) {
                                        return Column(children: [
                                          FutureBuilder<List<Map<String, dynamic>>>(
                                              future: getInfo('jsection', lang, 'Individual'),
                                              builder: (context, snapshot) {
                                                if (sections.isNotEmpty || (snapshot.connectionState == ConnectionState.done && snapshot.hasData)) {
                                                  if (sections.isEmpty) {
                                                    sections = mpJC;
                                                  }
                                                  return Container(
                                                      margin: (EdgeInsets.symmetric(vertical: 5)),
                                                      child: DropdownSearch<Map>(
                                                        items: sections,
                                                        maxHeight: 300,
                                                        popupItemBuilder: (context, item, isSelected) {
                                                          return Container(
                                                              height: 50,
                                                              child: Column(children: [
                                                                Expanded(child: Text(item['label'])),
                                                                Divider(thickness: 1, indent: 10, endIndent: 10)
                                                              ]));
                                                        },
                                                        dropdownBuilder: (context, selectedItem) {
                                                          if (selectedItem != null)
                                                            return Text(selectedItem['label']);
                                                          else
                                                            return Text(profileData?['user_profile']['section_name'] ?? '');
                                                        },
                                                        dropdownSearchDecoration: InputDecoration(
                                                            hintText: tr('Search'),
                                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                                                            filled: true,
                                                            fillColor: Colors.grey[50],
                                                            enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.black54),
                                                                borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                        onChanged: (val) {
                                                          _setSpecialty(() {
                                                            sectionId.text = val!['value'].toString();
                                                            mpJS.clear();
                                                            specialtyId.clear();
                                                            specialtyDefault = '';
                                                            specialties.clear();
                                                            professions.clear();
                                                          });
                                                        },
                                                        showSearchBox: true,
                                                      ));
                                                } else if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return Center(
                                                      child: Container(
                                                          margin: EdgeInsets.only(top: 10),
                                                          constraints: BoxConstraints.tightForFinite(),
                                                          child: CircularProgressIndicator()));
                                                } else {
                                                  return SizedBox();
                                                }
                                              }),
                                          if (sectionId.text.isNotEmpty && sectionId.text != "null")
                                            FutureBuilder<List<Map<String, dynamic>>>(
                                                future: getInfo('jspecialty', lang, sectionId.text),
                                                builder: (context, snapshot) {
                                                  if (specialties.isNotEmpty || snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
                                                    if (specialties.isEmpty) {
                                                      specialties = mpJS;
                                                    }
                                                    return Container(
                                                        margin: (EdgeInsets.symmetric(vertical: 5)),
                                                        child: DropdownSearch<Map>(
                                                          items: specialties,
                                                          maxHeight: 300,
                                                          popupItemBuilder: (context, item, isSelected) {
                                                            return Container(
                                                                height: 50,
                                                                child: Column(children: [
                                                                  Expanded(child: Text(item['label'])),
                                                                  Divider(thickness: 1, indent: 10, endIndent: 10)
                                                                ]));
                                                          },
                                                          dropdownBuilder: (context, selectedItem) {
                                                            if (selectedItem != null) {
                                                              return Text(selectedItem['label']);
                                                            } else {
                                                              return Text(specialtyDefault);
                                                            }
                                                          },
                                                          dropdownSearchDecoration: InputDecoration(
                                                              hintText: tr('Search'),
                                                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                                                              filled: true,
                                                              fillColor: Colors.grey[50],
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(color: Colors.black54),
                                                                  borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                          onChanged: (val) {
                                                            specialtyId.text = val!['value'].toString();
                                                            specialtyDefault = val['label'].toString();
                                                            _setSpecialty(() {
                                                              mpJS.clear();
                                                              professionSelection.clear();
                                                              professions.clear();
                                                            });
                                                          },
                                                          showSearchBox: true,
                                                        ));
                                                  } else {
                                                    return SizedBox();
                                                  }
                                                }),
                                          if (specialtyId.text.isNotEmpty && specialtyId.text != "null")
                                            FutureBuilder<List<Map<String, dynamic>>>(
                                                future: getInfo('profession', lang, specialtyId.text),
                                                builder: (context, snapshot) {
                                                  if (professions.isNotEmpty || snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
                                                    if (professions.isEmpty) {
                                                      professions = mpPRF;
                                                    }
                                                    return Container(
                                                        margin: (EdgeInsets.symmetric(vertical: 5)),
                                                        padding: EdgeInsets.all(9),
                                                        decoration: BoxDecoration(
                                                            color: Colors.grey[50],
                                                            border: Border.all(width: 0.4),
                                                            borderRadius: BorderRadius.all(Radius.circular(25))),
                                                        child: MultiSelectDialogField(
                                                            cancelText: Text('Cancel').tr(),
                                                            confirmText: Text('Confirm').tr(),
                                                            searchHint: tr('Search'),
                                                            title: Text('Select').tr(),
                                                            searchable: true,
                                                            buttonText: Text(professionSelection.length.toString() + tr(' professions selected')),
                                                            items: professions.map((e) => MultiSelectItem(e['value'], e['display'])).toList(),
                                                            listType: MultiSelectListType.LIST,
                                                            initialValue: professionSelection,
                                                            chipDisplay: MultiSelectChipDisplay.none(),
                                                            buttonIcon: Icon(Icons.arrow_drop_down),
                                                            decoration: BoxDecoration(color: Colors.transparent),
                                                            onConfirm: (values) {
                                                              _setSpecialty(() {
                                                                professionSelection = values;
                                                              });
                                                            }));
                                                  } else {
                                                    return SizedBox();
                                                  }
                                                })
                                        ]);
                                      }),
                                      Container(
                                          padding: EdgeInsets.only(left: 15),
                                          margin: EdgeInsets.only(bottom: 10, top: 20),
                                          child: Row(children: [
                                            Text('National Number', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr(),
                                            Text(' *', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red))
                                          ])),
                                      TextField(
                                        decoration: InputDecoration(
                                            hintText: tr('National Number'),
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                            enabledBorder:
                                                OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                        style: TextStyle(color: Colors.blueGrey),
                                        textDirection: ui.TextDirection.ltr,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                        ],
                                        controller: individualNationalNumber,
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(left: 15),
                                          margin: EdgeInsets.only(bottom: 10, top: 20),
                                          child: Row(children: [
                                            Text('Social status', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr(),
                                            Text(' *', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red))
                                          ])),
                                      DropdownSearch<Map>(
                                        items: arrtoList(maritalStatusArr, lang, ''),
                                        maxHeight: 300,
                                        popupItemBuilder: (context, item, isSelected) {
                                          return Container(
                                              height: 50,
                                              child:
                                                  Column(children: [Expanded(child: Text(item['label'])), Divider(thickness: 1, indent: 10, endIndent: 10)]));
                                        },
                                        dropdownBuilder: (context, selectedItem) {
                                          if (selectedItem != null)
                                            return Text(selectedItem['label']);
                                          else
                                            return Text(profileData?['user_profile']['individual_social_status'] ?? '');
                                        },
                                        dropdownSearchDecoration: InputDecoration(
                                            hintText: tr('Search'),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                            enabledBorder:
                                                OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                        onChanged: (val) {
                                          individualSocialStatus.text = val!['value'].toString();
                                        },
                                        showSearchBox: true,
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(left: 15),
                                          margin: EdgeInsets.only(bottom: 10, top: 20),
                                          child: Row(children: [
                                            Text('Employment Status', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr(),
                                            Text(' *', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red))
                                          ])),
                                      DropdownSearch<Map>(
                                        items: arrtoList(currentStatusArr, lang, ''),
                                        maxHeight: 300,
                                        popupItemBuilder: (context, item, isSelected) {
                                          return Container(
                                              height: 50,
                                              child:
                                                  Column(children: [Expanded(child: Text(item['label'])), Divider(thickness: 1, indent: 10, endIndent: 10)]));
                                        },
                                        dropdownBuilder: (context, selectedItem) {
                                          if (selectedItem != null)
                                            return Text(selectedItem['label']);
                                          else
                                            return Text(profileData?['user_profile']['current_status'] ?? '');
                                        },
                                        dropdownSearchDecoration: InputDecoration(
                                            hintText: tr('Search'),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                            enabledBorder:
                                                OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                        onChanged: (val) {
                                          currentStatus.text = val!['value'].toString();
                                        },
                                        showSearchBox: true,
                                      ),
                                      // Container(
                                      //     padding: EdgeInsets.only(left: 15),
                                      //     margin: EdgeInsets.only(bottom: 10, top: 20),
                                      //     child: Row(children: [
                                      //       Text('Languages', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr(),
                                      //       Text(' *', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red))
                                      //     ])),
                                      // Container(
                                      //     margin: EdgeInsets.symmetric(vertical: 10),
                                      //     child: MultiSelectDialogField(
                                      //         cancelText: Text('Cancel').tr(),
                                      //         confirmText: Text('Confirm').tr(),
                                      //         searchHint: tr('Search'),
                                      //         title: Text('Select').tr(),
                                      //         searchable: true,
                                      //         buttonText: Text('Select').tr(),
                                      //         items: arrtoList(languageArr, lang, 'multiselect').map((e) => MultiSelectItem(e['value'], e['display'])).toList(),
                                      //         listType: MultiSelectListType.LIST,
                                      //         initialValue: languageSelection,
                                      //         buttonIcon: Icon(Icons.arrow_drop_down),
                                      //         decoration:
                                      //             BoxDecoration(color: Colors.grey[50], border: Border.all(color: Colors.black54, width: 0.5), borderRadius: BorderRadius.all(Radius.circular(15))),
                                      //         onConfirm: (values) {
                                      //           languageSelection = values;
                                      //         })),
                                      Container(
                                          padding: EdgeInsets.only(left: 15),
                                          margin: EdgeInsets.only(bottom: 10, top: 20),
                                          child: Row(children: [
                                            Text('English level', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr(),
                                            Text(' *', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red))
                                          ])),
                                      DropdownSearch<Map>(
                                        items: arrtoList(englishLevelArr, lang, ''),
                                        maxHeight: 300,
                                        popupItemBuilder: (context, item, isSelected) {
                                          return Container(
                                              height: 50,
                                              child:
                                                  Column(children: [Expanded(child: Text(item['label'])), Divider(thickness: 1, indent: 10, endIndent: 10)]));
                                        },
                                        dropdownBuilder: (context, selectedItem) {
                                          if (selectedItem != null)
                                            return Text(selectedItem['label']);
                                          else
                                            return Text(profileData?['user_profile']['english_level'] ?? '');
                                        },
                                        dropdownSearchDecoration: InputDecoration(
                                            hintText: tr('Search'),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                            enabledBorder:
                                                OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                        onChanged: (val) {
                                          english.text = val!['value'].toString();
                                        },
                                        showSearchBox: true,
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(left: 15),
                                          margin: EdgeInsets.only(bottom: 10, top: 20),
                                          child: Row(children: [
                                            Text('Computer skills', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr(),
                                            Text(' *', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red))
                                          ])),
                                      DropdownSearch<Map>(
                                        items: arrtoList(computerSkillsArr, lang, ''),
                                        maxHeight: 300,
                                        popupItemBuilder: (context, item, isSelected) {
                                          return Container(
                                              height: 50,
                                              child:
                                                  Column(children: [Expanded(child: Text(item['label'])), Divider(thickness: 1, indent: 10, endIndent: 10)]));
                                        },
                                        dropdownBuilder: (context, selectedItem) {
                                          if (selectedItem != null)
                                            return Text(selectedItem['label']);
                                          else
                                            return Text(profileData?['user_profile']['computer_skills_level'] ?? '');
                                        },
                                        dropdownSearchDecoration: InputDecoration(
                                            hintText: tr('Search'),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                            enabledBorder:
                                                OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                        onChanged: (val) {
                                          computer.text = val!['value'].toString();
                                        },
                                        showSearchBox: true,
                                      ),
                                      Container(
                                          padding: EdgeInsets.symmetric(horizontal: 15),
                                          margin: EdgeInsets.only(bottom: 10, top: 20),
                                          child: Row(children: [
                                            Text('Summary', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr(),
                                            Text(' *', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red))
                                          ])),
                                      Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[50], border: Border.all(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                          child: TextField(
                                              decoration: InputDecoration(
                                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent))),
                                              minLines: 4,
                                              keyboardType: TextInputType.multiline,
                                              maxLines: null,
                                              style: TextStyle(color: Colors.black54),
                                              controller: individualOverview,
                                              onSubmitted: (value) {
                                                individualOverview.text = value;
                                              })),
                                      Container(
                                          padding: EdgeInsets.only(left: 15),
                                          margin: EdgeInsets.only(bottom: 10, top: 20),
                                          child: Text('Facebook', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                      TextField(
                                        decoration: InputDecoration(
                                            filled: true,
                                            hintText: tr('Facebook'),
                                            fillColor: Colors.grey[50],
                                            enabledBorder:
                                                OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                        style: TextStyle(color: Colors.blueGrey),
                                        controller: facebook,
                                        onSubmitted: (value) {
                                          facebook.text = value;
                                        },
                                      ),
                                      Container(
                                          padding: EdgeInsets.symmetric(horizontal: 15),
                                          margin: EdgeInsets.only(bottom: 10, top: 20),
                                          child: Row(children: [
                                            Text('Upload CV', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr(),
                                            Text(' *', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red))
                                          ])),
                                      StatefulBuilder(builder: (BuildContext context, StateSetter setFile) {
                                        return Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey[50], border: Border.all(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            alignment: Alignment.bottomRight,
                                            child: TextButton(
                                              onPressed: () async {
                                                cv = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['docx', 'pdf', 'doc']);
                                                setFile(() {});
                                              },
                                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                Text(cv != null ? cv!.files.first.name : defaultpicked.toString(), style: TextStyle(color: Colors.black54)),
                                                Icon(Icons.file_upload_outlined, color: hexStringToColor('#6986b8'))
                                              ]),
                                            ));
                                      }),
                                      SizedBox(height: 5),
                                      Divider(thickness: 2),
                                      StatefulBuilder(builder: (BuildContext context, StateSetter setLoading) {
                                        return !loading
                                            ? GestureDetector(
                                                onTap: () async {
                                                  if (sectionId.text.isEmpty ||
                                                      specialtyId.text.isEmpty ||
                                                      nationalityId.text.isEmpty ||
                                                      academicDegreeId.text.isEmpty ||
                                                      professionSelection.isEmpty ||
                                                      // languageSelection.isEmpty ||
                                                      individualNationalNumber.text.isEmpty ||
                                                      individualSocialStatus.text.isEmpty ||
                                                      currentStatus.text.isEmpty ||
                                                      computer.text.isEmpty ||
                                                      english.text.isEmpty ||
                                                      individualSocialStatus.text.isEmpty ||
                                                      individualOverview.text.isEmpty ||
                                                      individualGender.text.isEmpty ||
                                                      individualBirthDate.text.isEmpty ||
                                                      ((cv == null || (cv != null && cv!.files.isEmpty)) && defaultpicked.isEmpty)) {
                                                    Get.snackbar(tr('All the fields are required'), tr('Please fill them and try again'),
                                                        duration: Duration(seconds: 5),
                                                        backgroundColor: Colors.white,
                                                        colorText: Colors.red,
                                                        leftBarIndicatorColor: Colors.red);
                                                    return;
                                                  }
                                                  setLoading(() {
                                                    loading = true;
                                                  });
                                                  Map uInfo = {
                                                    'individual_nationality': nationalityId.text,
                                                    'individual_phone_extra': individualPhoneExtra.text,
                                                    'whatsapp_number': whatsapp.text,
                                                    'academec_degree_id': academicDegreeId.text,
                                                    'section_id': sectionId.text,
                                                    'specialty_id': specialtyId.text,
                                                    'individual_professions': professionSelection,
                                                    // 'individual_languages': languageSelection,
                                                    'individual_national_number': individualNationalNumber.text,
                                                    'social_status_id': individualSocialStatus.text,
                                                    'current_status_id': currentStatus.text,
                                                    'english_level_id': english.text,
                                                    'computer_skills_id': computer.text,
                                                    'individual_gender': individualGender.text,
                                                    'individual_birth_date': individualBirthDate.text,
                                                    'individual_overview': individualOverview.text,
                                                    'individual_facebook_url': facebook.text,
                                                  };
                                                  cv != null ? uInfo['individual_cv_file'] = File(cv!.files.first.path!) : cv = null;
                                                  uInfo['id'] = profileData!['id'].toString();
                                                  uInfo['type'] = 'Individual';
                                                  var tmp = await updateInformation(lang, uInfo['id'], uInfo['type'], uInfo);
                                                  if (tmp['status'] == true) {
                                                    Get.offAll(() => IndivProfilePage());
                                                  }
                                                  setLoading(() {
                                                    loading = false;
                                                  });
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: hexStringToColor('#6986b8'),
                                                        border: Border.all(width: 0.2),
                                                        borderRadius: BorderRadius.all(Radius.circular(30))),
                                                    width: getWH(context, 2),
                                                    height: getWH(context, 1) * 0.07,
                                                    margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                                                    alignment: Alignment.center,
                                                    child:
                                                        Text('Submit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)).tr()))
                                            : Center(
                                                child: Container(
                                                    margin: EdgeInsets.only(bottom: 100),
                                                    constraints: BoxConstraints.tightForFinite(),
                                                    child: CircularProgressIndicator()));
                                      })
                                    ]))
                              ])))
                    ]);
                  })));
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

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({Key? key, required this.contact, required this.public}) : super(key: key);

  @override
  _PrivacyPageState createState() => _PrivacyPageState();
  final int contact;
  final int public;
}

class _PrivacyPageState extends State<PrivacyPage> {
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
    loading = false;
  }

  bool loading = false;
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        int public = widget.public;
        int contact = widget.contact;
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          loading = false;
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: watheftyBar(context, "Privacy Settings", 16),
              bottomNavigationBar: watheftyBottomBar(context),
              body: FutureBuilder<Map>(
                  future: disabilities(1, null),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data!.isNotEmpty) {}
                      return SingleChildScrollView(
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 5),
                                    child:
                                        Text('Make your profile public to improve employment chances', style: TextStyle(fontSize: 15.0, color: Colors.black54))
                                            .tr()),
                                StatefulBuilder(builder: (BuildContext context, StateSetter setpublic) {
                                  return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                    Expanded(
                                        child: ListTile(
                                            title: Text("Yes", style: TextStyle(color: public == 1 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                            leading: Radio(
                                                value: 1,
                                                groupValue: public,
                                                onChanged: (value) {
                                                  setpublic(() {
                                                    public = value as int;
                                                  });
                                                },
                                                activeColor: hexStringToColor('#6986b8')))),
                                    Expanded(
                                        child: ListTile(
                                            title: Text("No", style: TextStyle(color: public == 2 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                            leading: Radio(
                                                value: 2,
                                                groupValue: public,
                                                onChanged: (value) {
                                                  setpublic(() {
                                                    public = value as int;
                                                  });
                                                },
                                                activeColor: hexStringToColor('#6986b8'))))
                                  ]);
                                }),
                                Divider(),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 5),
                                    child: Text('Show your contact information to companies (Phone number and Email)',
                                            style: TextStyle(fontSize: 15.0, color: Colors.black54))
                                        .tr()),
                                StatefulBuilder(builder: (BuildContext context, StateSetter setcontact) {
                                  return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                    Expanded(
                                        child: ListTile(
                                            title: Text("Yes", style: TextStyle(color: contact == 1 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                            leading: Radio(
                                                value: 1,
                                                groupValue: contact,
                                                onChanged: (value) {
                                                  setcontact(() {
                                                    contact = value as int;
                                                  });
                                                },
                                                activeColor: hexStringToColor('#6986b8')))),
                                    Expanded(
                                        child: ListTile(
                                            title: Text("No", style: TextStyle(color: contact == 2 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                            leading: Radio(
                                                value: 2,
                                                groupValue: contact,
                                                onChanged: (value) {
                                                  setcontact(() {
                                                    contact = value as int;
                                                  });
                                                },
                                                activeColor: hexStringToColor('#6986b8'))))
                                  ]);
                                }),
                                Divider(),
                                StatefulBuilder(builder: (BuildContext context, StateSetter setSubmit) {
                                  return !loading
                                      ? GestureDetector(
                                          onTap: () async {
                                            Map uInfo = {'contact_info_visibility': contact.toString(), 'show_info_status': public.toString()};
                                            setSubmit(() {
                                              loading = true;
                                            });
                                            var tmp = await privacy(2, uInfo);
                                            setSubmit(() {
                                              loading = false;
                                            });
                                            if (tmp['status'] == true) {
                                              Get.offAll(() => IndivProfilePage());
                                            }
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: hexStringToColor('#6986b8'),
                                                  border: Border.all(width: 0.2),
                                                  borderRadius: BorderRadius.all(Radius.circular(30))),
                                              width: getWH(context, 2),
                                              height: getWH(context, 1) * 0.07,
                                              margin: EdgeInsets.only(top: 25),
                                              alignment: Alignment.center,
                                              child: Text('Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)).tr()))
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
                              Get.offAll(() => StartPage());
                            },
                            child: Text('Retry').tr())
                      ]))));
        }
      });
}
