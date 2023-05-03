import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
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

class IndividualDriverPage extends StatefulWidget {
  @override
  _IndividualDriverPageState createState() => _IndividualDriverPageState();
}

class _IndividualDriverPageState extends State<IndividualDriverPage> {
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
    carLicense = null;
    car = null;
    image = null;
    court = null;
    permit = null;
    driverLicense = null;
    loading = false;
    ownerName.dispose();
    licenseNumber.dispose();
    carBrand.dispose();
    insurance.dispose();
    salary.dispose();
    manuYear.dispose();
  }

  final ownerName = TextEditingController();
  bool loading = false;
  final licenseNumber = TextEditingController();
  final carBrand = TextEditingController();
  final insurance = TextEditingController();
  final salary = TextEditingController();
  final manuYear = TextEditingController();
  final fuelType = TextEditingController();
  final condition = TextEditingController();
  final workNow = TextEditingController(text: '2');
  final transportType = TextEditingController();
  FilePickerResult? carLicense;
  FilePickerResult? car;
  FilePickerResult? image;
  FilePickerResult? court;
  FilePickerResult? permit;
  FilePickerResult? driverLicense;

  var imgLink1;
  var imgLink2;
  var imgLink3;
  var imgLink4;
  var imgLink5;
  var imgLink6;
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          var uid = snapshot.data!['uid'];
          loading = false;
          var shrt;
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: watheftyBar(context, "Smart-App Driver Application", 14),
              bottomNavigationBar: watheftyBottomBar(context),
              body: FutureBuilder<Map>(
                  future: getExtra(uid, 'Individual', lang, 'driver'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData && snapshot.data?['status']) {
                        shrt = snapshot.data;
                        ownerName.text = shrt!['car_owner_name'];
                        licenseNumber.text = shrt['car_plate_number'].toString();
                        carBrand.text = shrt['car_type_id'].toString();
                        manuYear.text = shrt['year_of_manufacture'].toString();
                        salary.text = shrt['method_payment_wage_id'].toString();
                        insurance.text = shrt['car_insurance_type_id'].toString();
                        condition.text = shrt['car_condition_id'].toString();
                        fuelType.text = shrt['car_fuel_type_id'].toString();
                        transportType.text = shrt['transport_service_type_id'].toString();
                        workNow.text = shrt['start_working_immediately'] == "Yes" ? "1" : "2";
                        imgLink1 = NetworkImage(shrt['car_license_image']);
                        imgLink2 = NetworkImage(shrt['car_image']);
                        imgLink3 = NetworkImage(shrt['driver_image']);
                        imgLink4 = NetworkImage(shrt['image_no_criminal_record']);
                        imgLink5 = NetworkImage(shrt['smart_work_permit_applications_image']);
                        imgLink6 = NetworkImage(shrt['driver_license_image']);
                      } else {
                        imgLink1 = NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png");
                        imgLink2 = NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png");
                        imgLink3 = NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png");
                        imgLink4 = NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png");
                        imgLink5 = NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png");
                        imgLink6 = NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png");
                      }
                      return SingleChildScrollView(
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                Text('Apply for a smart-app driver position', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)).tr(),
                                SizedBox(height: 5),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 10),
                                    child: Text('Car license picture', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                StatefulBuilder(builder: (BuildContext context, StateSetter setImage) {
                                  return Row(children: [
                                    Expanded(
                                        child: Container(
                                            decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            child: TextButton(
                                                onPressed: () async {
                                                  carLicense = await FilePicker.platform.pickFiles(type: FileType.image);
                                                  setImage(() {});
                                                },
                                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                  Flexible(
                                                      child: Text(carLicense != null ? carLicense!.files.first.name : '', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54))),
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
                                            image: DecorationImage(fit: BoxFit.cover, image: carLicense != null ? Image.file(File(carLicense!.files.first.path!)).image : imgLink1)))
                                  ]);
                                }),
                                Divider(),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 5),
                                    child: Text('Car picture', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                StatefulBuilder(builder: (BuildContext context, StateSetter setImage) {
                                  return Row(children: [
                                    Expanded(
                                        child: Container(
                                            decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            child: TextButton(
                                                onPressed: () async {
                                                  car = await FilePicker.platform.pickFiles(type: FileType.image);
                                                  setImage(() {});
                                                },
                                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                  Flexible(child: Text(car != null ? car!.files.first.name : '', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54))),
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
                                            image: DecorationImage(fit: BoxFit.cover, image: car != null ? Image.file(File(car!.files.first.path!)).image : imgLink2)))
                                  ]);
                                }),
                                Divider(),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 5),
                                    child: Text('Driver picture', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
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
                                            image: DecorationImage(fit: BoxFit.cover, image: image != null ? Image.file(File(image!.files.first.path!)).image : imgLink3)))
                                  ]);
                                }),
                                Divider(),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 5),
                                    child: Text('Non-Criminal Certificate picture', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                StatefulBuilder(builder: (BuildContext context, StateSetter setImage) {
                                  return Row(children: [
                                    Expanded(
                                        child: Container(
                                            decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            child: TextButton(
                                                onPressed: () async {
                                                  court = await FilePicker.platform.pickFiles(type: FileType.image);
                                                  setImage(() {});
                                                },
                                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                  Flexible(child: Text(court != null ? court!.files.first.name : '', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54))),
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
                                            image: DecorationImage(fit: BoxFit.cover, image: court != null ? Image.file(File(court!.files.first.path!)).image : imgLink4)))
                                  ]);
                                }),
                                Divider(),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 5),
                                    child: Text('Smart-App permit', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                StatefulBuilder(builder: (BuildContext context, StateSetter setImage) {
                                  return Row(children: [
                                    Expanded(
                                        child: Container(
                                            decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            child: TextButton(
                                                onPressed: () async {
                                                  permit = await FilePicker.platform.pickFiles(type: FileType.image);
                                                  setImage(() {});
                                                },
                                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                  Flexible(child: Text(permit != null ? permit!.files.first.name : '', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54))),
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
                                            image: DecorationImage(fit: BoxFit.cover, image: permit != null ? Image.file(File(permit!.files.first.path!)).image : imgLink5)))
                                  ]);
                                }),
                                Divider(),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 5),
                                    child: Text('Driver license picture', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                StatefulBuilder(builder: (BuildContext context, StateSetter setImage) {
                                  return Row(children: [
                                    Expanded(
                                        child: Container(
                                            decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            child: TextButton(
                                                onPressed: () async {
                                                  driverLicense = await FilePicker.platform.pickFiles(type: FileType.image);
                                                  setImage(() {});
                                                },
                                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                  Flexible(
                                                      child:
                                                          Text(driverLicense != null ? driverLicense!.files.first.name : '', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54))),
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
                                            image: DecorationImage(fit: BoxFit.cover, image: driverLicense != null ? Image.file(File(driverLicense!.files.first.path!)).image : imgLink6)))
                                  ]);
                                }),
                                Divider(),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 15),
                                    child: Text('Car Brand', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                FutureBuilder<List<Map<String, dynamic>>>(
                                    future: getInfo('cars', lang, carBrand.text),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                                        return DropdownSearch<Map>(
                                          items: snapshot.data,
                                          maxHeight: 300,
                                          popupItemBuilder: (context, item, isSelected) {
                                            return Container(height: 50, child: Column(children: [Expanded(child: Text(item['label'])), Divider(thickness: 1, indent: 10, endIndent: 10)]));
                                          },
                                          dropdownBuilder: (context, selectedItem) {
                                            if (selectedItem != null)
                                              return Text(selectedItem['label']);
                                            else
                                              return Text(shrt["car_type_name"] ?? "");
                                          },
                                          dropdownSearchDecoration: InputDecoration(
                                              hintText: tr('Search'),
                                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                              filled: true,
                                              fillColor: Colors.grey[50],
                                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                          onChanged: (val) {
                                            carBrand.text = val!['value'].toString();
                                          },
                                          showSearchBox: true,
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    }),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 15),
                                    child: Text('Insurance type', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                SelectFormField(
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return tr('Please select insurance');
                                      }
                                      return null;
                                    },
                                    type: SelectFormFieldType.dropdown,
                                    labelText: tr('Insurance'),
                                    items: arrtoList(insuranceArr, lang, ''),
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(Icons.arrow_drop_down),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                    controller: insurance),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 15),
                                    child: Text('Salary method', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                SelectFormField(
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return tr('Please select salary method');
                                    }
                                    return null;
                                  },
                                  type: SelectFormFieldType.dropdown,
                                  labelText: tr('Salary type'),
                                  items: arrtoList(salaryArr, lang, ''),
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  controller: salary,
                                ),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 15),
                                    child: Text('Car Owner Name', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                TextField(
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  style: TextStyle(color: Colors.blueGrey),
                                  textDirection: lang == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                                  controller: ownerName,
                                ),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 15),
                                    child: Text('License Number', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                TextField(
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                    style: TextStyle(color: Colors.blueGrey),
                                    textDirection: lang == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                                    controller: licenseNumber,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                    ]),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 15),
                                    child: Text('Car Model', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                StatefulBuilder(builder: (BuildContext context, StateSetter _setManu) {
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
                                                pickerModel: CustomPicker(minTime: DateTime(2011, 1, 1, 1, 1), maxTime: DateTime(DateTime.now().year + 1, 1, 1, 1, 1), currentTime: DateTime.now()),
                                                locale: lang == 'ar' ? LocaleType.ar : LocaleType.en, onConfirm: (date) {
                                              _setManu(() {
                                                manuYear.text = date.toString().substring(0, 4);
                                              });
                                            });
                                          },
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                            Text(manuYear.text.isNotEmpty ? manuYear.text : '', style: TextStyle(color: Colors.black54)).tr(),
                                            Icon(Icons.calendar_today, color: Colors.black54)
                                          ])));
                                }),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 15),
                                    child: Text('Transport Service Type', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                DropdownSearch<Map>(
                                  items: arrtoList(transportServiceTypeArr, lang, ''),
                                  maxHeight: 300,
                                  popupItemBuilder: (context, item, isSelected) {
                                    return Container(height: 50, child: Column(children: [Expanded(child: Text(item['label'])), Divider(thickness: 1, indent: 10, endIndent: 10)]));
                                  },
                                  dropdownBuilder: (context, selectedItem) {
                                    if (selectedItem != null)
                                      return Text(selectedItem['label']);
                                    else
                                      return Text(shrt["transport_service_type"] ?? "");
                                  },
                                  dropdownSearchDecoration: InputDecoration(
                                      hintText: tr('Search'),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  onChanged: (val) {
                                    transportType.text = val!['value'].toString();
                                  },
                                  showSearchBox: true,
                                ),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 15),
                                    child: Text('Car Condition', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                DropdownSearch<Map>(
                                  items: arrtoList(conditionArr, lang, ''),
                                  maxHeight: 300,
                                  popupItemBuilder: (context, item, isSelected) {
                                    return Container(height: 50, child: Column(children: [Expanded(child: Text(item['label'])), Divider(thickness: 1, indent: 10, endIndent: 10)]));
                                  },
                                  dropdownBuilder: (context, selectedItem) {
                                    if (selectedItem != null)
                                      return Text(selectedItem['label']);
                                    else
                                      return Text(shrt["car_condition"] ?? "");
                                  },
                                  dropdownSearchDecoration: InputDecoration(
                                      hintText: tr('Search'),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  onChanged: (val) {
                                    condition.text = val!['value'].toString();
                                  },
                                  showSearchBox: true,
                                ),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 15),
                                    child: Text('Fuel Type', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                DropdownSearch<Map>(
                                  items: arrtoList(fuelTypeArr, lang, ''),
                                  maxHeight: 300,
                                  popupItemBuilder: (context, item, isSelected) {
                                    return Container(height: 50, child: Column(children: [Expanded(child: Text(item['label'])), Divider(thickness: 1, indent: 10, endIndent: 10)]));
                                  },
                                  dropdownBuilder: (context, selectedItem) {
                                    if (selectedItem != null)
                                      return Text(selectedItem['label']);
                                    else
                                      return Text(shrt["car_fuel_type"] ?? "");
                                  },
                                  dropdownSearchDecoration: InputDecoration(
                                      hintText: tr('Search'),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  onChanged: (val) {
                                    fuelType.text = val!['value'].toString();
                                  },
                                  showSearchBox: true,
                                ),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 15),
                                    child: Text('Can you start working immediately?', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                StatefulBuilder(builder: (BuildContext context, StateSetter setWork) {
                                  return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                    Expanded(
                                        child: ListTile(
                                            title: Text("Yes", style: TextStyle(color: workNow.text == '1' ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                            leading: Radio(
                                                value: '1',
                                                groupValue: workNow.text,
                                                onChanged: (value) {
                                                  setWork(() {
                                                    workNow.text = value.toString();
                                                  });
                                                },
                                                activeColor: hexStringToColor('#6986b8')))),
                                    Expanded(
                                        child: ListTile(
                                            title: Text("No", style: TextStyle(color: workNow.text == '2' ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                            leading: Radio(
                                                value: "2",
                                                groupValue: workNow.text,
                                                onChanged: (value) {
                                                  setWork(() {
                                                    workNow.text = value.toString();
                                                  });
                                                },
                                                activeColor: hexStringToColor('#6986b8'))))
                                  ]);
                                }),
                                SizedBox(height: 20),
                                StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
                                  return !loading
                                      ? Container(
                                          alignment: Alignment.center,
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                                            GestureDetector(
                                                onTap: () async {
                                               
                                                  if (ownerName.text.isEmpty ||
                                                      licenseNumber.text.isEmpty ||
                                                      carBrand.text.isEmpty ||
                                                      manuYear.text.isEmpty ||
                                                      salary.text.isEmpty ||
                                                      insurance.text.isEmpty ||
                                                      workNow.text.isEmpty ||
                                                      condition.text.isEmpty ||
                                                      transportType.text.isEmpty ||
                                                      fuelType.text.isEmpty) {
                                                    Get.snackbar(tr('All the fields are required'), tr('Please fill them and try again'),
                                                        duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.orange, leftBarIndicatorColor: Colors.orange);
                                                    return;
                                                  }
                                                  Map uInfo = {
                                                    'car_type_id': carBrand.text,
                                                    'car_owner_name': ownerName.text,
                                                    'car_plate_number': licenseNumber.text,
                                                    'car_insurance_type': insurance.text,
                                                    'method_payment_wage': salary.text,
                                                    'year_of_manufacture': manuYear.text,
                                                    'car_condition': condition.text,
                                                    'transport_service_type': transportType.text,
                                                    'car_fuel_type': fuelType.text,
                                                    'start_working_immediately': workNow.text
                                                  };
                                                  carLicense != null ? uInfo['car_license_image'] = File(carLicense!.files.first.path!) : carLicense = null;
                                                  car != null ? uInfo['car_image'] = File(car!.files.first.path!) : car = null;
                                                  image != null ? uInfo['driver_image'] = File(image!.files.first.path!) : image = null;
                                                  court != null ? uInfo['image_no_criminal_record'] = File(court!.files.first.path!) : court = null;
                                                  permit != null ? uInfo['smart_work_permit_applications_image'] = File(permit!.files.first.path!) : permit = null;
                                                  driverLicense != null ? uInfo['driver_license_image'] = File(driverLicense!.files.first.path!) : driverLicense = null;
                                                  _setState(() {
                                                    loading = true;
                                                  });
                                                  var tmp = await createDriver(lang, uid, 'Individual', uInfo);
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
                                                  var tmp = await removeExtra(lang, uid as String, 'Individual', 'driver');
                                                  _setState(() {
                                                    loading = false;
                                                  });
                                                  if (tmp['status'] == true) {
                                                    Get.offAll(() => IndivProfilePage());
                                                  }
                                                },
                                                child:
                                                    Text('Remove Request', style: TextStyle(decoration: TextDecoration.underline, color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15)).tr())
                                          ]))
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
