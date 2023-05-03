import 'dart:io';
import 'dart:ui' as ui;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wathefty/Pages/company/profile.dart';
import 'package:wathefty/data.dart';
import '../../API.dart';
import '../../functions.dart';
import '../../main.dart';
import '../auth/otp.dart';

class CompanySettingsPage extends StatefulWidget {
  @override
  _CompanySettingsPageState createState() => _CompanySettingsPageState();
}

class _CompanySettingsPageState extends State<CompanySettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  // GoogleMapController? controller;
  // void _onMapCreated(GoogleMapController controller) {
  //   this.controller = controller;
  // }

  FilePickerResult? result;
  var loading = false;
  final email = TextEditingController();
  final nameAr = TextEditingController();
  final nameEn = TextEditingController();
  final username = TextEditingController();
  final phone = TextEditingController();
  final countryId = TextEditingController(text: '111');
  final regionId = TextEditingController();
  final sectionId = TextEditingController();
  final password = TextEditingController();
  final passwordconfirm = TextEditingController();
  final specialtyId = TextEditingController();
  final photo = TextEditingController();
  final addressAr = TextEditingController();
  final addressEn = TextEditingController();
  var defaultPhone;
  String specialtyDefault = '';

  // _mapTapped(LatLng location) {
  //   googleMaps.text = location.toString();
  // }
  Map<String, dynamic>? profileData;
  List<Map<dynamic, dynamic>> sections = [];
  
  Widget build(BuildContext context) => FutureBuilder(
      future: getProfile('Company'),
      builder: (context, snapshot) {
        
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          loading = false;
          result = null;
          profileData = snapshot.data as Map<String, dynamic>?;
          if (profileData!['status'] == true) {
            profileData = profileData!['user'];
          }
          nameAr.text = profileData!['name_ar'];
          nameEn.text = profileData!['name_en'];
          username.text = profileData!['username'];
          email.text = profileData!['email'];
          phone.text = profileData?['phone'] ?? '';
          defaultPhone = profileData?['phone'];
          countryId.text = profileData!['country_id'].toString();
          regionId.text = profileData!['region_id'].toString();
          addressAr.text = profileData!['address_ar'] != null ? profileData!['address_ar'] : '';
          addressEn.text = profileData!['address_en'] != null ? profileData!['address_en'] : '';
          sectionId.text = profileData!['section_id'] != null ? profileData!['section_id'].toString() : '';
          specialtyId.text = profileData!['specialty_id'] != null ? profileData!['specialty_id'].toString() : '';
          specialtyDefault = profileData!['specialty'] != null ? profileData!['specialty'].toString() : '';
          photo.text = profileData!['profile_photo_path'] != null ? profileData!['profile_photo_path'] : '';
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
                    title: Text('Edit Profile', style: TextStyle(fontSize: 18, color: Colors.white)).tr()),
                bottomNavigationBar: watheftyBottomBar(context),
                body: StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
                  return Column(children: [
                    Expanded(
                      child: Container(
                        width: getWH(context, 2),
                        child: ListView(
                          children: [
                            Container(
                                margin: EdgeInsets.only(top: 25, bottom: 25),
                                child: StatefulBuilder(builder: (BuildContext context, StateSetter setImage) {
                                  return Column(children: [
                                    CircleAvatar(radius: 50, backgroundImage: result != null ? Image.file(File(result!.files.first.path!)).image : NetworkImage(profileData!['profile_photo_path'])),
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
                                })),
                            Container(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(alignment: Alignment.center, child: Text('Main required information', style: TextStyle(fontSize: 18.0, color: Colors.black87)).tr()),
                                    Container(
                                        padding: EdgeInsets.only(left: 15),
                                        margin: EdgeInsets.only(bottom: 10, top: 30),
                                        child: Text('Arabic Name', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                    TextField(
                                        textDirection: ui.TextDirection.rtl,
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                        style: TextStyle(color: Colors.blueGrey),
                                        controller: nameAr,
                                        onSubmitted: (value) async {
                                          nameAr.text = value;
                                        }),
                                    Container(
                                        padding: EdgeInsets.only(left: 15),
                                        margin: EdgeInsets.only(bottom: 10, top: 20),
                                        child: Text('English Name', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                    TextField(
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                        style: TextStyle(color: Colors.blueGrey),
                                        textDirection: ui.TextDirection.ltr,
                                        controller: nameEn,
                                        onSubmitted: (value) {
                                          nameEn.text = value;
                                        }),
                                    Container(
                                        padding: EdgeInsets.only(left: 15),
                                        margin: EdgeInsets.only(bottom: 10, top: 20),
                                        child: Text('Username', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                    TextField(
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                        style: TextStyle(color: Colors.blueGrey),
                                        textDirection: ui.TextDirection.ltr,
                                        controller: username,
                                        onSubmitted: (value) {
                                          username.text = value;
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
                                        child: Text('Section', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                    StatefulBuilder(builder: (BuildContext context, StateSetter _setSpecialty) {
                                      return Column(children: [
                                        FutureBuilder<List<Map<String, dynamic>>>(
                                            future: getInfo('jsection', lang, 'Company'),
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
                                                            padding: EdgeInsets.symmetric(horizontal: 5),
                                                            height: 60,
                                                            child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [Expanded(child: Text(item['label'], textAlign: TextAlign.center)), Divider(thickness: 1, indent: 10, endIndent: 10)]));
                                                      },
                                                      dropdownBuilder: (context, selectedItem) {
                                                        if (selectedItem != null)
                                                          return Text(selectedItem['label']);
                                                        else
                                                          return Text(profileData?['section'] ?? '');
                                                      },
                                                      dropdownSearchDecoration: InputDecoration(
                                                          hintText: tr('Search'),
                                                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                          filled: true,
                                                          fillColor: Colors.grey[50],
                                                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                      onChanged: (val) {
                                                        _setSpecialty(() {
                                                          sectionId.text = val!['value'].toString();
                                                          mpJS.clear();
                                                          specialtyId.clear();
                                                          specialtyDefault = '';
                                                        });
                                                      },
                                                      showSearchBox: true,
                                                    ));
                                              } else if (snapshot.connectionState == ConnectionState.waiting) {
                                                return Center(child: Container(margin: EdgeInsets.only(top: 10), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                                              } else {
                                                return SizedBox();
                                              }
                                            }),
                                        if (sectionId.text.isNotEmpty)
                                          Container(
                                              alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                              padding: EdgeInsets.only(left: 15),
                                              margin: EdgeInsets.only(bottom: 10, top: 20),
                                              child: Text('Specialty', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                        sectionId.text.isNotEmpty
                                            ? FutureBuilder<List<Map<String, dynamic>>>(
                                                future: getInfo('jspecialty', lang, sectionId.text),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
                                                    return Container(
                                                        margin: (EdgeInsets.symmetric(vertical: 5)),
                                                        child: DropdownSearch<Map>(
                                                          items: mpJS,
                                                          maxHeight: 300,
                                                          popupItemBuilder: (context, item, isSelected) {
                                                            return Container(
                                                                height: 50, child: Column(children: [Expanded(child: Text(item['label'])), Divider(thickness: 1, indent: 10, endIndent: 10)]));
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
                                                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                              filled: true,
                                                              fillColor: Colors.grey[50],
                                                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                          onChanged: (val) {
                                                            specialtyId.text = val!['value'].toString();
                                                            specialtyDefault = val['label'].toString();
                                                            _setSpecialty(() {
                                                              mpJS.clear();
                                                            });
                                                          },
                                                          showSearchBox: true,
                                                        ));
                                                  } else {
                                                    return SizedBox();
                                                  }
                                                })
                                            : SizedBox(),
                                      ]);
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
                                                child: Text('Country, region and address', style: TextStyle(fontSize: 15.0, color: Colors.black87)).tr()),
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
                                                  return Text(profileData?['country'] ?? '');
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
                                                  countryId.text = (val!['value'].toString());
                                                  regionId.text = '';
                                                  profileData?['region'] = '';
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
                                                                height: 50, child: Column(children: [Expanded(child: Text(item['label'])), Divider(thickness: 1, indent: 10, endIndent: 10)]));
                                                          },
                                                          dropdownBuilder: (context, selectedItem) {
                                                            if (selectedItem != null)
                                                              return Text(selectedItem['label']);
                                                            else
                                                              return Text(profileData!['region'] ?? '');
                                                          },
                                                          dropdownSearchDecoration: InputDecoration(
                                                              hintText: tr('Search'),
                                                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                                                              filled: true,
                                                              fillColor: Colors.white,
                                                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                          onChanged: (val) {
                                                            regionId.text = val!['value'].toString();
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
                                            Container(alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft, padding: EdgeInsets.only(left: 15), margin: EdgeInsets.only(bottom: 15)),
                                            TextField(
                                                textDirection: ui.TextDirection.rtl,
                                                decoration: InputDecoration(
                                                    hintText: tr('Arabic Address'),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                style: TextStyle(color: Colors.blueGrey),
                                                controller: addressAr,
                                                onSubmitted: (value) {
                                                  addressAr.text = value;
                                                }),
                                            Container(alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft, padding: EdgeInsets.only(left: 15), margin: EdgeInsets.only(bottom: 15)),
                                            TextField(
                                                decoration: InputDecoration(
                                                    hintText: tr('English Address'),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                style: TextStyle(color: Colors.blueGrey),
                                                controller: addressEn,
                                                textDirection: ui.TextDirection.ltr,
                                                onSubmitted: (value) {
                                                  addressEn.text = value;
                                                })
                                          ]));
                                    }),
                                    Container(
                                        margin: const EdgeInsets.only(top: 35),
                                        padding: const EdgeInsets.only(top: 15, bottom: 30, right: 15, left: 15),
                                        decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.1), borderRadius: BorderRadius.all(Radius.circular(15))),
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
                                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                              style: TextStyle(color: Colors.blueGrey),
                                              textDirection: ui.TextDirection.ltr,
                                              controller: password,
                                              onSubmitted: (value) {
                                                password.text = value;
                                              }),
                                          SizedBox(height: 15),
                                          TextField(
                                              obscureText: true,
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  hintText: tr('Password Confirmation'),
                                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                              style: TextStyle(color: Colors.blueGrey),
                                              textDirection: ui.TextDirection.ltr,
                                              controller: passwordconfirm)
                                        ])),
                                    // SizedBox
                                    //     height: 350,
                                    //     width: getWH(context, 2),
                                    //     child: GoogleMap(
                                    //       onTap: _mapTapped,
                                    //       compassEnabled: true,
                                    //       onMapCreated: _onMapCreated,
                                    //       initialCameraPosition: CameraPosition(
                                    //         target: LatLng(31.9539, 35.9106),
                                    //         zoom: 12.0,
                                    //       ),
                                    //     )),
                                    // TextField(
                                    //   decoration: InputDecoration(
                                    //       filled: true,
                                    //       fillColor: Colors.grey[50],
                                    //       enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                    //       focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                    //   style: TextStyle(color: Colors.blueGrey),
                                    //   controller: googleMaps,
                                    //   onSubmitted: (value) {
                                    //     googleMaps.text = value;
                                    //   },
                                    // ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Divider(
                                      thickness: 2,
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(top: 15),
                                        child: StatefulBuilder(builder: (BuildContext context, StateSetter setLoading) {
                                          return !loading
                                              ? GestureDetector(
                                                  onTap: () async {
                                                    if (nameAr.text.length < 1 ||
                                                        nameEn.text.length < 1 ||
                                                        username.text.length < 2 ||
                                                        email.text.length < 5 ||
                                                        countryId.text.length < 1 ||
                                                        regionId.text.length < 1 ||
                                                        phone.text.length < 7 ||
                                                        addressAr.text.length < 2 ||
                                                        addressEn.text.length < 2 ||
                                                        sectionId.text.length < 1 ||
                                                        specialtyId.text.length < 1) {
                                                      Get.snackbar(tr('All the fields are required'), tr('Please fill them and try again'),
                                                          duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.red, leftBarIndicatorColor: Colors.red);
                                                      return;
                                                    }
                                                    if (password.text.isNotEmpty && (password.text != passwordconfirm.text)) {
                                                      Get.snackbar(tr("Passwords don't match"), tr(''),
                                                          duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.red, leftBarIndicatorColor: Colors.red);
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
                                                      'address_en': addressEn.text,
                                                      'section_id': sectionId.text,
                                                      'specialty_id': specialtyId.text
                                                    };
                                                    if (password.text.isNotEmpty) {
                                                      uInfo['password'] = password.text;
                                                    }
                                                    result != null ? uInfo['profile_photo_path'] = File(result!.files.first.path!) : result = null;
                                                    if (phone.text != defaultPhone) {
                                                      uInfo['id'] = profileData!['id'].toString();
                                                      uInfo['type'] = 'Company';
                                                      Map tmp = await getOTP(phone.text, lang);
                                                      if (tmp.isNotEmpty && tmp['status']) {
                                                        Get.to(() => OTP(data: uInfo, type: 2));
                                                      }
                                                    } else {
                                                      uInfo['code'] = '';
                                                      var tmp = await updateProfile(lang, uInfo['id'], uInfo['type'], uInfo);
                                                      if (tmp['status'] == true) {
                                                        Get.offAll(() => CompanyProfilePage());
                                                      }
                                                    }
                                                    setLoading(() {
                                                      loading = false;
                                                    });
                                                  },
                                                  child: Container(
                                                      decoration:
                                                          BoxDecoration(color: hexStringToColor('#6986b8'), border: Border.all(width: 0.2), borderRadius: BorderRadius.all(Radius.circular(30))),
                                                      width: getWH(context, 2),
                                                      height: getWH(context, 1) * 0.07,
                                                      margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                                                      alignment: Alignment.center,
                                                      child: Text('Submit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)).tr()))
                                              : Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                                        }))
                                  ],
                                )),
                          ],
                        ),
                      ),
                    )
                  ]);
                }),
              ));
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

class CompanyInfoPage extends StatefulWidget {
  @override
  _CompanyInfoPageState createState() => _CompanyInfoPageState();
}

class _CompanyInfoPageState extends State<CompanyInfoPage> {
  @override
  void initState() {
    super.initState();
  }

  var loading = false;
  final companySize = TextEditingController();
  final companyCapacity = TextEditingController();
  final companyCategory = TextEditingController();
  final companyFax = TextEditingController();
  final landline = TextEditingController();
  final extraPhone = TextEditingController();
  final managerNameAr = TextEditingController();
  final managerNameEn = TextEditingController();
  final managerPhone = TextEditingController();
  final officerNameAr = TextEditingController();
  final officerNameEn = TextEditingController();
  final officerPhone = TextEditingController();
  final website = TextEditingController();
  final facebook = TextEditingController();
  final linkedin = TextEditingController();
  final whastapp = TextEditingController();
  final instagram = TextEditingController();
  final twitter = TextEditingController();
  final youtube = TextEditingController();
  final googleMaps = TextEditingController();
  final aboutAr = TextEditingController();
  final aboutEn = TextEditingController();
  Map<String, dynamic>? profileData;
  
  Widget build(BuildContext context) => FutureBuilder(
      future: getProfile('Company'),
      builder: (context, snapshot) {
        
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          loading = false;
          profileData = snapshot.data as Map<String, dynamic>?;
          if (profileData!['status'] == true) {
            profileData = profileData!['user'];
          }
          companySize.text = profileData!['company_size'] != null ? profileData!['company_size'].toString() : '';
          companyCapacity.text = profileData!['company_legal_capacity'] != null ? profileData!['company_legal_capacity'].toString() : '';
          companyCategory.text = profileData!['company_category'] != null ? profileData!['company_category'].toString() : '';
          var cpct = arrtoList(companyCapacityArr, lang, companyCapacity.text);
          companyCapacity.text = cpct[0]['value'].toString();
          var sz = arrtoList(companySizeArr, lang, companySize.text);
          companySize.text = sz[0]['value'].toString();
          var ctgr = arrtoList(companyCategoryArr, lang, companyCategory.text);
          companyCategory.text = ctgr[0]['value'].toString();
          companyFax.text = profileData!['company_fax'] != null ? profileData!['company_fax'] : '';
          landline.text = profileData!['landline_phone'] != null ? profileData!['landline_phone'] : '';
          extraPhone.text = profileData!['company_phone_extra'] != null ? profileData!['company_phone_extra'] : '';
          managerNameAr.text = profileData!['general_manager_name_ar'] != null ? profileData!['general_manager_name_ar'] : '';
          managerNameEn.text = profileData!['general_manager_name_en'] != null ? profileData!['general_manager_name_en'] : '';
          managerPhone.text = profileData!['general_manager_phone'] != null ? profileData!['general_manager_phone'] : '';
          officerNameAr.text = profileData!['officer_link_name_ar'] != null ? profileData!['officer_link_name_ar'] : '';
          officerNameEn.text = profileData!['officer_link_name_en'] != null ? profileData!['officer_link_name_en'] : '';
          officerPhone.text = profileData!['officer_link_phone'] != null ? profileData!['officer_link_phone'] : '';
          website.text = profileData!['company_website_url'] != null ? profileData!['company_website_url'] : '';
          facebook.text = profileData!['company_facebook_url'] != null ? profileData!['company_facebook_url'] : '';
          linkedin.text = profileData!['company_linkedin_url'] != null ? profileData!['company_linkedin_url'] : '';
          whastapp.text = profileData!['company_whatsapp_url'] != null ? profileData!['company_whatsapp_url'] : '';
          instagram.text = profileData!['company_instagram_url'] != null ? profileData!['company_instagram_url'] : '';
          twitter.text = profileData!['company_twitter_url'] != null ? profileData!['company_twitter_url'] : '';
          youtube.text = profileData!['company_youtube_url'] != null ? profileData!['company_youtube_url'] : '';
          googleMaps.text = profileData!['company_location_url'] != null ? profileData!['company_location_url'] : '';
          aboutAr.text = profileData!['company_overview_ar'] != null ? profileData!['company_overview_ar'] : '';
          aboutEn.text = profileData!['company_overview_en'] != null ? profileData!['company_overview_en'] : '';
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
                                  return Column(
                                    children: [
                                      Container(
                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Align(alignment: Alignment.center, child: Text('Other Information', style: TextStyle(fontSize: 18.0, color: Colors.black87)).tr()),
                                              Container(
                                                  padding: EdgeInsets.only(left: 15),
                                                  margin: EdgeInsets.only(bottom: 10, top: 20),
                                                  child: Text('Company size', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                              SelectFormField(
                                                type: SelectFormFieldType.dropdown,
                                                decoration: InputDecoration(
                                                    suffixIcon: Icon(Icons.arrow_drop_down),
                                                    filled: true,
                                                    fillColor: Colors.grey[50],
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                items: arrtoList(companySizeArr, lang, ''),
                                                controller: companySize,
                                                onChanged: (val) {
                                                  companySize.text = (val);
                                                },
                                                onSaved: (val) => companySize.text = (val)!,
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(left: 15),
                                                  margin: EdgeInsets.only(bottom: 10, top: 20),
                                                  child: Text('Company capacity', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                              SelectFormField(
                                                  type: SelectFormFieldType.dropdown,
                                                  decoration: InputDecoration(
                                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                                      filled: true,
                                                      fillColor: Colors.grey[50],
                                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                  labelText: tr('Company capacity'),
                                                  items: arrtoList(companyCapacityArr, lang, ''),
                                                  controller: companyCapacity,
                                                  onChanged: (val) {
                                                    companyCapacity.text = (val);
                                                  },
                                                  onSaved: (val) => companyCapacity.text = (val)!),
                                              Container(
                                                  padding: EdgeInsets.only(left: 15),
                                                  margin: EdgeInsets.only(bottom: 10, top: 20),
                                                  child: Text('Company category', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                              SelectFormField(
                                                type: SelectFormFieldType.dropdown,
                                                decoration: InputDecoration(
                                                    suffixIcon: Icon(Icons.arrow_drop_down),
                                                    filled: true,
                                                    fillColor: Colors.grey[50],
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                items: arrtoList(companyCategoryArr, lang, ''),
                                                controller: companyCategory,
                                                onChanged: (val) {
                                                  companyCategory.text = (val);
                                                },
                                                onSaved: (val) => companyCategory.text = (val)!,
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(left: 15),
                                                  margin: EdgeInsets.only(bottom: 10, top: 20),
                                                  child: Text('Extra phone number', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                              InternationalPhoneNumberInput(
                                                inputDecoration: InputDecoration(
                                                  hintText: extraPhone.text,
                                                    fillColor: Colors.grey[50],
                                                    filled: true,
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                spaceBetweenSelectorAndTextField: 1,
                                                onInputChanged: (PhoneNumber number) {
                                                  extraPhone.text = number.phoneNumber!;
                                                },
                                                selectorConfig: SelectorConfig(leadingPadding: 15, selectorType: PhoneInputSelectorType.BOTTOM_SHEET, setSelectorButtonAsPrefixIcon: true),
                                                autoValidateMode: AutovalidateMode.onUserInteraction,
                                                hintText: extraPhone.text,
                                                initialValue: PhoneNumber(isoCode: 'JO'),
                                                errorMessage: tr('Invalid phone number'),
                                                selectorTextStyle: TextStyle(color: Colors.black),
                                                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(left: 15),
                                                  margin: EdgeInsets.only(bottom: 10, top: 20),
                                                  child: Text('General Manager name Ar', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                              TextField(
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey[50],
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                style: TextStyle(color: Colors.blueGrey),
                                                textDirection: ui.TextDirection.rtl,
                                                controller: managerNameAr,
                                                onSubmitted: (value) {
                                                  managerNameAr.text = value;
                                                },
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(left: 15),
                                                  margin: EdgeInsets.only(bottom: 10, top: 20),
                                                  child: Text('General Manager name En', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                              TextField(
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey[50],
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                style: TextStyle(color: Colors.blueGrey),
                                                textDirection: ui.TextDirection.ltr,
                                                controller: managerNameEn,
                                                onSubmitted: (value) {
                                                  managerNameEn.text = value;
                                                },
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(left: 15),
                                                  margin: EdgeInsets.only(bottom: 10, top: 20),
                                                  child: Text('General Manager phone', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                              InternationalPhoneNumberInput(
                                                inputDecoration: InputDecoration(
                                                    fillColor: Colors.grey[50],
                                                    hintText: managerPhone.text,
                                                    filled: true,
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                spaceBetweenSelectorAndTextField: 1,
                                                onInputChanged: (PhoneNumber number) {
                                                  managerPhone.text = number.phoneNumber!;
                                                },
                                                selectorConfig: SelectorConfig(leadingPadding: 15, selectorType: PhoneInputSelectorType.BOTTOM_SHEET, setSelectorButtonAsPrefixIcon: true),
                                                autoValidateMode: AutovalidateMode.onUserInteraction,
                                                hintText: managerPhone.text,
                                                initialValue: PhoneNumber(isoCode: 'JO'),
                                                errorMessage: tr('Invalid phone number'),
                                                selectorTextStyle: TextStyle(color: Colors.black),
                                                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(left: 15),
                                                  margin: EdgeInsets.only(bottom: 10, top: 20),
                                                  child: Text('Officer name Ar', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                              TextField(
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey[50],
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                style: TextStyle(color: Colors.blueGrey),
                                                textDirection: ui.TextDirection.rtl,
                                                controller: officerNameAr,
                                                onSubmitted: (value) {
                                                  officerNameAr.text = value;
                                                },
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(left: 15),
                                                  margin: EdgeInsets.only(bottom: 10, top: 20),
                                                  child: Text('Officer name En', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                              TextField(
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey[50],
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                style: TextStyle(color: Colors.blueGrey),
                                                textDirection: ui.TextDirection.ltr,
                                                controller: officerNameEn,
                                                onSubmitted: (value) {
                                                  officerNameEn.text = value;
                                                },
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(left: 15),
                                                  margin: EdgeInsets.only(bottom: 10, top: 20),
                                                  child: Text('Officer phone', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                              InternationalPhoneNumberInput(
                                                inputDecoration: InputDecoration(
                                                  hintText: officerPhone.text,
                                                    fillColor: Colors.grey[50],
                                                    filled: true,
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                spaceBetweenSelectorAndTextField: 1,
                                                onInputChanged: (PhoneNumber number) {
                                                  officerPhone.text = number.phoneNumber!;
                                                },
                                                selectorConfig: SelectorConfig(leadingPadding: 15, selectorType: PhoneInputSelectorType.BOTTOM_SHEET, setSelectorButtonAsPrefixIcon: true),
                                                autoValidateMode: AutovalidateMode.onUserInteraction,
                                                hintText: officerPhone.text,
                                                initialValue: PhoneNumber(isoCode: 'JO'),
                                                errorMessage: tr('Invalid phone number'),
                                                selectorTextStyle: TextStyle(color: Colors.black),
                                                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(left: 15),
                                                  margin: EdgeInsets.only(bottom: 10, top: 20),
                                                  child: Text('Landline', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                              TextField(
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey[50],
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                style: TextStyle(color: Colors.blueGrey),
                                                controller: landline,
                                                keyboardType: TextInputType.number,
                                                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                                onSubmitted: (value) {
                                                  landline.text = value;
                                                },
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(left: 15),
                                                  margin: EdgeInsets.only(bottom: 10, top: 20),
                                                  child: Text('Fax', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                              TextField(
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey[50],
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                style: TextStyle(color: Colors.blueGrey),
                                                controller: companyFax,
                                                keyboardType: TextInputType.number,
                                                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                                onSubmitted: (value) {
                                                  companyFax.text = value;
                                                },
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(left: 15),
                                                  margin: EdgeInsets.only(bottom: 10, top: 20),
                                                  child: Text('About company Ar', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                              TextField(
                                                controller: aboutAr,
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey[50],
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                minLines: 4,
                                                keyboardType: TextInputType.multiline,
                                                maxLines: null,
                                                onSubmitted: (value) {
                                                  aboutAr.text = value;
                                                },
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(left: 15),
                                                  margin: EdgeInsets.only(bottom: 10, top: 20),
                                                  child: Text('About company En', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                              TextField(
                                                controller: aboutEn,
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey[50],
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                minLines: 4,
                                                keyboardType: TextInputType.multiline,
                                                maxLines: null,
                                                onSubmitted: (value) {
                                                  aboutEn.text = value;
                                                },
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(left: 15),
                                                  margin: EdgeInsets.only(bottom: 10, top: 20),
                                                  child: Text('Website', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                              TextField(
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey[50],
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                style: TextStyle(color: Colors.blueGrey),
                                                controller: website,
                                                textDirection: ui.TextDirection.ltr,
                                                onSubmitted: (value) {
                                                  website.text = value;
                                                },
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(left: 15),
                                                  margin: EdgeInsets.only(bottom: 10, top: 20),
                                                  child: Text('Facebook', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                              TextField(
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey[50],
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                style: TextStyle(color: Colors.blueGrey),
                                                controller: facebook,
                                                textDirection: ui.TextDirection.ltr,
                                                onSubmitted: (value) {
                                                  facebook.text = value;
                                                },
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(left: 15),
                                                  margin: EdgeInsets.only(bottom: 10, top: 20),
                                                  child: Text('LinkedIn', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                              TextField(
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey[50],
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                style: TextStyle(color: Colors.blueGrey),
                                                controller: linkedin,
                                                textDirection: ui.TextDirection.ltr,
                                                onSubmitted: (value) {
                                                  linkedin.text = value;
                                                },
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(left: 15),
                                                  margin: EdgeInsets.only(bottom: 10, top: 20),
                                                  child: Text('Whatsapp', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                              TextField(
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey[50],
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                style: TextStyle(color: Colors.blueGrey),
                                                controller: whastapp,
                                                textDirection: ui.TextDirection.ltr,
                                                onSubmitted: (value) {
                                                  whastapp.text = value;
                                                },
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(left: 15),
                                                  margin: EdgeInsets.only(bottom: 10, top: 20),
                                                  child: Text('Instagram', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                              TextField(
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey[50],
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                style: TextStyle(color: Colors.blueGrey),
                                                controller: instagram,
                                                textDirection: ui.TextDirection.ltr,
                                                onSubmitted: (value) {
                                                  instagram.text = value;
                                                },
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(left: 15),
                                                  margin: EdgeInsets.only(bottom: 10, top: 20),
                                                  child: Text('Twitter', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                              TextField(
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey[50],
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                style: TextStyle(color: Colors.blueGrey),
                                                textDirection: ui.TextDirection.ltr,
                                                controller: twitter,
                                                onSubmitted: (value) {
                                                  twitter.text = value;
                                                },
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(left: 15),
                                                  margin: EdgeInsets.only(bottom: 10, top: 20),
                                                  child: Text('Youtube', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                              TextField(
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.grey[50],
                                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                  style: TextStyle(color: Colors.blueGrey),
                                                  textDirection: ui.TextDirection.ltr,
                                                  controller: youtube,
                                                  onSubmitted: (value) {
                                                    youtube.text = value;
                                                  }),
                                              Container(
                                                  padding: EdgeInsets.only(left: 15),
                                                  margin: EdgeInsets.only(bottom: 10, top: 20),
                                                  child: Text('Google Maps', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                              TextField(
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.grey[50],
                                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                  style: TextStyle(color: Colors.blueGrey),
                                                  textDirection: ui.TextDirection.ltr,
                                                  controller: googleMaps,
                                                  onSubmitted: (value) {
                                                    googleMaps.text = value;
                                                  }),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Divider(
                                                thickness: 2,
                                              ),
                                              Container(
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(top: 15),
                                                  child: StatefulBuilder(builder: (BuildContext context, StateSetter setLoading) {
                                                    return !loading
                                                        ? GestureDetector(
                                                            onTap: () async {
                                                              setLoading(() {
                                                                loading = true;
                                                              });
                                                              Map uInfo = {
                                                                'company_size': companySize.text,
                                                                'company_legal_capacity': companyCapacity.text,
                                                                'company_category': companyCategory.text,
                                                                'company_fax': companyFax.text,
                                                                'landline_phone': landline.text,
                                                                'company_phone_extra': extraPhone.text,
                                                                'general_manager_phone': managerPhone.text,
                                                                    'general_manager_name_ar': managerNameAr.text,
                                                                'general_manager_name_en': managerNameEn.text,
                                                                'officer_link_name_ar': officerNameAr.text,
                                                                'officer_link_name_en': officerNameEn.text,
                                                                    'officer_link_phone': officerPhone.text,
                                                                'company_website_url': website.text,
                                                                'company_facebook_url': facebook.text,
                                                                'company_linkedin_url': linkedin.text,
                                                                'company_whatsapp_url': whastapp.text,
                                                                'company_instagram_url': instagram.text,
                                                                'company_twitter_url': twitter.text,
                                                                'company_youtube_url': youtube.text,
                                                                    'company_overview_ar': aboutAr.text,
                                                                'company_overview_en': aboutEn.text,
                                                                  };
                                                              var tmp = await updateInformation(lang, globalUid, 'Company', uInfo);
                                                              if (tmp['status'] == true) {
                                                                Get.offAll(() => CompanyProfilePage());
                                                              }
                                                              setLoading(() {
                                                                loading = false;
                                                              });
                                                            },
                                                          child: Container(
                                                                decoration: BoxDecoration(
                                                                    color: hexStringToColor('#6986b8'), border: Border.all(width: 0.2), borderRadius: BorderRadius.all(Radius.circular(30))),
                                                                width: getWH(context, 2),
                                                                height: getWH(context, 1) * 0.07,
                                                                margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                                                                alignment: Alignment.center,
                                                                child: Text('Submit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)).tr()))
                                                        : Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                                                  }))
                                            ],
                                          )),
                                    ],
                                  );
                                }),
                              )
                            ])))
                  ]);
                }),
              ));
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
