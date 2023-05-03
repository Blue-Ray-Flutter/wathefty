import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:wathefty/API.dart';
import 'package:wathefty/Pages/company/job_list.dart';
import 'package:wathefty/main.dart';
import '../../data.dart';
import '../../functions.dart';

class CompanyFilters extends StatefulWidget {
  const CompanyFilters({Key? key, required this.type}) : super(key: key);

  @override
  _CompanyFiltersState createState() => _CompanyFiltersState();
  final int type;
}

class _CompanyFiltersState extends State<CompanyFilters> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    filters.clear();
    section.dispose();
    specialty.dispose();
    professions.clear();
    education.dispose();
    country.dispose();
    region.dispose();
    nationality.dispose();
    gender.dispose();
    title.dispose();
    salaryF.dispose();
    salaryT.dispose();
    experienceF.dispose();
    experienceT.dispose();
    dateF.dispose();
    dateT.dispose();
    deadlineF.dispose();
    deadlineT.dispose();
    suitability.dispose();
    options1.clear();
    options2.clear();
    options3.clear();
    options4.clear();
  }

  
  final section = TextEditingController();
  final specialty = TextEditingController();
  List professions = [];
  final education = TextEditingController();
  final country = TextEditingController(text: '111');
  final region = TextEditingController();
  final nationality = TextEditingController();
  final gender = TextEditingController();
  final title = TextEditingController();
  final salaryF = TextEditingController();
  final salaryT = TextEditingController();
  final experienceF = TextEditingController();
  final experienceT = TextEditingController();
  final dateF = TextEditingController();
  final dateT = TextEditingController();
  var defaultTime1 = DateTime.now();
  var defaultTime2 = DateTime.now();
  var defaultTime3 = DateTime.now();
  var defaultTime4 = DateTime.now();
  final deadlineF = TextEditingController();
  final deadlineT = TextEditingController();
  final suitability = TextEditingController();
  List<Map<String, dynamic>> options1 = [];
  List<Map<String, dynamic>> options2 = [];
  List<Map<String, dynamic>> options3 = [];
  List<Map<String, dynamic>> options4 = [];

  Map filters = {};
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: watheftyBar(context, 'Advanced Search', 19),
              body: SingleChildScrollView(child: StatefulBuilder(builder: (BuildContext context, StateSetter setFields) {
                return Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(children: [
                      StatefulBuilder(builder: (BuildContext context, StateSetter setSection) {
                        return Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.only(top: 15, bottom: 30, right: 15, left: 15),
                            decoration:
                                BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.1), borderRadius: BorderRadius.all(Radius.circular(15))),
                            child: Column(children: [
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 5, top: 15),
                                  child: Text('Section', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                              FutureBuilder<List<Map<String, dynamic>>>(
                                  future: getInfo('jsection', lang, 'Individual'),
                                  builder: (context, snapshot) {
                                    if (options1.isNotEmpty || (snapshot.hasData && snapshot.connectionState == ConnectionState.done)) {
                                      options1 = mpJC;
                                      return SizedBox(
                                          height: getWH(context, 1) * 0.05,
                                          child: SelectFormField(
                                            decoration: InputDecoration(
                                                suffixIcon: Icon(Icons.arrow_drop_down),
                                                filled: true,
                                                fillColor: Colors.grey[50],
                                                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                                enabledBorder:
                                                    OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                            type: SelectFormFieldType.dropdown,
                                            labelText: tr('Job section'),
                                            items: options1,
                                            controller: section,
                                            onChanged: (val) {
                                              setSection(() {
                                                mpJS.clear();
                                                specialty.clear();
                                                options2.clear();
                                                options3.clear();
                                              });
                                            },
                                          ));
                                    } else {
                                      return Center(
                                          child: Container(
                                              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                              constraints: BoxConstraints.tightForFinite(),
                                              child: LinearProgressIndicator()));
                                    }
                                  }),
                              section.text.isNotEmpty
                                  ? Container(
                                      alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                      margin: EdgeInsets.only(bottom: 5, top: 15),
                                      child: Text('Specialty', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr())
                                  : SizedBox(),
                              section.text.isNotEmpty
                                  ? FutureBuilder<List<Map<String, dynamic>>>(
                                      future: getInfo('jspecialty', lang, section.text),
                                      builder: (context, snapshot) {
                                        if (options2.isNotEmpty || (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty)) {
                                          options2 = mpJS;
                                          return SizedBox(
                                              height: getWH(context, 1) * 0.05,
                                              child: SelectFormField(
                                                decoration: InputDecoration(
                                                    suffixIcon: Icon(Icons.arrow_drop_down),
                                                    filled: true,
                                                    fillColor: Colors.grey[50],
                                                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                                type: SelectFormFieldType.dropdown,
                                                items: options2,
                                                controller: specialty,
                                                onChanged: (val) {
                                                  setSection(() {
                                                    professions.clear();
                                                    options3.clear();
                                                  });
                                                },
                                              ));
                                        } else if (snapshot.connectionState == ConnectionState.waiting) {
                                          return Center(
                                              child: Container(
                                                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                                  constraints: BoxConstraints.tightForFinite(),
                                                  child: LinearProgressIndicator()));
                                        } else {
                                          return SizedBox();
                                        }
                                      })
                                  : SizedBox(),
                              specialty.text.isNotEmpty
                                  ? Container(
                                      alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                      margin: EdgeInsets.only(bottom: 5, top: 15),
                                      child: Text('Professions', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr())
                                  : SizedBox(),
                              specialty.text.isNotEmpty
                                  ? FutureBuilder<List<Map<String, dynamic>>>(
                                      future: getInfo('profession', lang, specialty.text),
                                      builder: (context, snapshot) {
                                        if (options3.isNotEmpty || (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty)) {
                                          options3 = mpPRF;
                                          return Container(
                                            margin: (EdgeInsets.symmetric(vertical: 10)),
                                            child: MultiSelectDialogField(
                                                  cancelText: Text('Cancel').tr(),
                                                  confirmText: Text('Confirm').tr(),
                                                  searchHint: tr('Search'),
                                                  title: Text('Select').tr(),
                                                  searchable: true,
                                                  buttonText: Text('Select').tr(),
                                                  items: options3.map((e) => MultiSelectItem(e['value'], e['display'])).toList(),
                                                  listType: MultiSelectListType.LIST,
                                                  chipDisplay: MultiSelectChipDisplay.none(),
                                                  initialValue: professions,
                                      buttonIcon: Icon(Icons.arrow_drop_down),
                                                  decoration:
                                                      BoxDecoration(color: Colors.grey[50], border: Border.all(color: Colors.black54, width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                                  onConfirm: (values) {
                                                    professions = values;
                                                  })
                                          );
                                        } else if (snapshot.connectionState == ConnectionState.waiting) {
                                          return Center(
                                              child: Container(
                                                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                                  constraints: BoxConstraints.tightForFinite(),
                                                  child: LinearProgressIndicator()));
                                        } else {
                                          return SizedBox();
                                        }
                                      })
                                  : SizedBox(),
                            ]));
                      }),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.only(top: 15, bottom: 30, right: 15, left: 15),
                          decoration:
                              BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.1), borderRadius: BorderRadius.all(Radius.circular(15))),
                          child: StatefulBuilder(builder: (BuildContext context, StateSetter setFields) {
                            return Column(children: [
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 5, top: 15),
                                  child: Text('Country', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                              SizedBox(
                                  height: getWH(context, 1) * 0.05,
                                  child: SelectFormField(
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.arrow_drop_down),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                          enabledBorder:
                                              OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                      type: SelectFormFieldType.dropdown,
                                      items: arrtoList(countryArr, lang, ''),
                                      controller: country,
                                      onChanged: (val) {
                                        setFields(() {});
                                        options4.clear();
                                      })),
                              country.text.isNotEmpty
                                  ? Container(
                                      alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                      margin: EdgeInsets.only(bottom: 5, top: 15),
                                      child: Text('Region', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr())
                                  : SizedBox(),
                              country.text.isNotEmpty
                                  ? FutureBuilder<List<Map<String, dynamic>>>(
                                      future: getInfo('region', lang, country.text),
                                      builder: (context, snapshot) {
                                        if (options4.isNotEmpty || (snapshot.hasData && snapshot.connectionState == ConnectionState.done)) {
                                          options4 = mpR;
                                          return SizedBox(
                                              height: getWH(context, 1) * 0.05,
                                              child: SelectFormField(
                                                  decoration: InputDecoration(
                                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                                      filled: true,
                                                      fillColor: Colors.grey[50],
                                                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                                  type: SelectFormFieldType.dropdown,
                                                  items: mpR,
                                                  controller: region));
                                        } else if (snapshot.connectionState == ConnectionState.waiting) {
                                          return Center(
                                              child: Container(
                                                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                                  constraints: BoxConstraints.tightForFinite(),
                                                  child: LinearProgressIndicator()));
                                        } else {
                                          return SizedBox();
                                        }
                                      })
                                  : SizedBox(),
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 5, top: 15),
                                  child: Text('Nationality', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                              SizedBox(
                                  height: getWH(context, 1) * 0.05,
                                  child: SelectFormField(
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.arrow_drop_down),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                          enabledBorder:
                                              OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                      type: SelectFormFieldType.dropdown,
                                      items: arrtoList(nationalityArr, lang, ''),
                                      controller: nationality)),
                            ]);
                          })),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.only(top: 15, bottom: 30, right: 15, left: 15),
                          decoration:
                              BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.1), borderRadius: BorderRadius.all(Radius.circular(15))),
                          child: Column(children: [
                            Container(
                                alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                margin: EdgeInsets.only(bottom: 5, top: 15),
                                child: Text('Education level', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                            SizedBox(
                                height: getWH(context, 1) * 0.05,
                                child: SelectFormField(
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(Icons.arrow_drop_down),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                        enabledBorder:
                                            OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                    type: SelectFormFieldType.dropdown,
                                    items: arrtoList(degreeArr, lang, ''),
                                    controller: education)),
                            Container(
                                alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                margin: EdgeInsets.only(bottom: 5, top: 15),
                                child: Text('Gender', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                            SizedBox(
                                height: getWH(context, 1) * 0.05,
                                child: SelectFormField(
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(Icons.arrow_drop_down),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                        enabledBorder:
                                            OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                    type: SelectFormFieldType.dropdown,
                                    items: arrtoList(genderArr, lang, ''),
                                    controller: gender)),
                            Container(
                                alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                margin: EdgeInsets.only(bottom: 5, top: 15),
                                child: Text('Minimum Suitability', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                            SizedBox(
                                height: getWH(context, 1) * 0.05,
                                child: SelectFormField(
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(Icons.arrow_drop_down),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                        enabledBorder:
                                            OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                    type: SelectFormFieldType.dropdown,
                                    items: arrtoList(fiveArr, lang, ''),
                                    controller: suitability)),
                          ])),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.only(top: 15, bottom: 30, right: 15, left: 15),
                          decoration:
                              BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.1), borderRadius: BorderRadius.all(Radius.circular(15))),
                          child: Column(children: [
                            Container(
                                alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                margin: EdgeInsets.only(bottom: 5, top: 15),
                                child: Text('Job title', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                            SizedBox(
                                height: getWH(context, 1) * 0.05,
                                child: TextField(
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(Icons.search),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                        enabledBorder:
                                            OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                    controller: title)),
                            Container(
                                alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                margin: EdgeInsets.only(bottom: 5, top: 15),
                                child: Text('Salary', style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.bold)).tr()),
                            Container(
                                alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text('From', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                            SizedBox(
                                height: getWH(context, 1) * 0.05,
                                child: TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(Icons.chevron_right),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                        enabledBorder:
                                            OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                    controller: salaryF)),
                            Container(
                                alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                margin: EdgeInsets.only(bottom: 5, top: 15),
                                child: Text('To', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                            SizedBox(
                                height: getWH(context, 1) * 0.05,
                                child: TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(Icons.chevron_left),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                        enabledBorder:
                                            OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                    controller: salaryT)),
                          ])),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.only(top: 15, bottom: 30, right: 15, left: 15),
                          decoration:
                              BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.1), borderRadius: BorderRadius.all(Radius.circular(15))),
                          child: StatefulBuilder(builder: (BuildContext context, StateSetter setDates) {
                            return Column(children: [
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 5, top: 15),
                                  child: Text('Deadline', style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.bold)).tr()),
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Text('From', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                              SizedBox(
                                  height: getWH(context, 1) * 0.05,
                                  child: TextButton(
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 20)),
                                          foregroundColor: MaterialStateProperty.all(Colors.grey[50]),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(side: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                          backgroundColor: MaterialStateProperty.all(Colors.grey[50])),
                                      onPressed: () {
                                        var now = DateTime.now();
                                        DatePicker.showDatePicker(context,
                                            showTitleActions: true, maxTime: DateTime(now.year + 1, now.month + 12), onChanged: (date) {}, onConfirm: (date) {
                                          setDates(() {
                                            deadlineF.text = date.toString().substring(0, 10);
                                          });
                                        }, currentTime: defaultTime1, locale: lang == 'ar' ? LocaleType.ar : LocaleType.en);
                                      },
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Text(deadlineF.text.isNotEmpty ? deadlineF.text : 'Choose a date', style: TextStyle(color: Colors.black54)).tr(),
                                        Icon(Icons.calendar_today, color: Colors.black54)
                                      ]))),
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 5, top: 10),
                                  child: Text('To', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                              SizedBox(
                                  height: getWH(context, 1) * 0.05,
                                  child: TextButton(
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 20)),
                                          foregroundColor: MaterialStateProperty.all(Colors.grey[50]),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(side: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                          backgroundColor: MaterialStateProperty.all(Colors.grey[50])),
                                      onPressed: () {
                                        var now = DateTime.now();
                                        DatePicker.showDatePicker(context,
                                            showTitleActions: true, maxTime: DateTime(now.year + 1, now.month + 12), onChanged: (date) {}, onConfirm: (date) {
                                          setDates(() {
                                            deadlineT.text = date.toString().substring(0, 10);
                                          });
                                        }, currentTime: defaultTime2, locale: lang == 'ar' ? LocaleType.ar : LocaleType.en);
                                      },
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Text(deadlineT.text.isNotEmpty ? deadlineT.text : 'Choose a date', style: TextStyle(color: Colors.black54)).tr(),
                                        Icon(Icons.calendar_today, color: Colors.black54)
                                      ]))),
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 5, top: 15),
                                  child: Text('Publish date', style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.bold)).tr()),
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Text('From', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                              SizedBox(
                                  height: getWH(context, 1) * 0.05,
                                  child: TextButton(
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 20)),
                                          foregroundColor: MaterialStateProperty.all(Colors.grey[50]),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(side: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                          backgroundColor: MaterialStateProperty.all(Colors.grey[50])),
                                      onPressed: () {
                                        var now = DateTime.now();
                                        DatePicker.showDatePicker(context,
                                            showTitleActions: true, maxTime: DateTime(now.year + 1, now.month + 12), onChanged: (date) {}, onConfirm: (date) {
                                          setDates(() {
                                            dateF.text = date.toString().substring(0, 10);
                                          });
                                        }, currentTime: defaultTime3, locale: lang == 'ar' ? LocaleType.ar : LocaleType.en);
                                      },
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Text(dateF.text.isNotEmpty ? dateF.text : 'Choose a date', style: TextStyle(color: Colors.black54)).tr(),
                                        Icon(Icons.calendar_today, color: Colors.black54)
                                      ]))),
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 5, top: 10),
                                  child: Text('To', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                              SizedBox(
                                  height: getWH(context, 1) * 0.05,
                                  child: TextButton(
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 20)),
                                          foregroundColor: MaterialStateProperty.all(Colors.grey[50]),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(side: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                          backgroundColor: MaterialStateProperty.all(Colors.grey[50])),
                                      onPressed: () {
                                        var now = DateTime.now();
                                        DatePicker.showDatePicker(context,
                                            showTitleActions: true, maxTime: DateTime(now.year + 1, now.month + 12), onChanged: (date) {}, onConfirm: (date) {
                                          setDates(() {
                                            dateT.text = date.toString().substring(0, 10);
                                          });
                                        }, currentTime: defaultTime4, locale: lang == 'ar' ? LocaleType.ar : LocaleType.en);
                                      },
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Text(dateT.text.isNotEmpty ? dateT.text : 'Choose a date', style: TextStyle(color: Colors.black54)).tr(),
                                        Icon(Icons.calendar_today, color: Colors.black54)
                                      ]))),
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 5, top: 15),
                                  child: Text('Experience', style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.bold)).tr()),
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Text('From', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                              SizedBox(
                                  height: getWH(context, 1) * 0.05,
                                  child: SelectFormField(
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.arrow_drop_down),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                          enabledBorder:
                                              OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                      type: SelectFormFieldType.dropdown,
                                      items: numbers,
                                      controller: experienceF)),
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 5, top: 15),
                                  child: Text('To', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                              SizedBox(
                                  height: getWH(context, 1) * 0.05,
                                  child: SelectFormField(
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.arrow_drop_down),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                          enabledBorder:
                                              OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                      type: SelectFormFieldType.dropdown,
                                      items: numbers,
                                      controller: experienceT))
                            ]);
                          })),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                              onPressed: () {
                                filters.clear();
                               Get.back();
                                Get.to(() => CompanyFilters(type: widget.type));
                              },
                              child: Text("Clear", style: TextStyle(color: Colors.black, fontSize: 16)).tr())),
                      GestureDetector(
                          onTap: () {
                            if (section.text.isNotEmpty) filters['job_section_id_searche'] = section.text;
                            if (specialty.text.isNotEmpty) filters['specialty_id_searche'] = specialty.text;
                            if (education.text.isNotEmpty) filters['public_academic_degree_id_searche'] = education.text;
                            if (country.text.isNotEmpty) filters['country_id_searche'] = country.text;
                            if (region.text.isNotEmpty) filters['region_id_searche'] = region.text;
                            if (nationality.text.isNotEmpty) filters['nationality_searche'] = nationality.text;
                            if (salaryF.text.isNotEmpty) filters['salary_from_searche'] = salaryF.text;
                            if (salaryT.text.isNotEmpty) filters['salary_to_searche'] = salaryT.text;
                            if (experienceF.text.isNotEmpty) filters['experience_years_from_searche'] = experienceF.text;
                            if (experienceT.text.isNotEmpty) filters['experience_years_to_searche'] = experienceT.text;
                            if (dateF.text.isNotEmpty) filters['created_at_from_searche'] = dateF.text;
                            if (dateT.text.isNotEmpty) filters['created_at_to_searche'] = dateT.text;
                            if (deadlineF.text.isNotEmpty) filters['submission_deadline_from_searche'] = deadlineF.text;
                            if (deadlineT.text.isNotEmpty) filters['submission_deadline_to_searche'] = deadlineT.text;
                            if (gender.text.isNotEmpty) filters['gender_searche'] = gender.text;
                            if (title.text.isNotEmpty) filters['job_title_searche'] = title.text;
                            if (professions.isNotEmpty) filters['professions_searche[]'] = professions.isNotEmpty ? professions.toString() : '';
                            if (suitability.text.isNotEmpty) filters['suitability_from_searche'] = suitability.text;
                            filters['type'] = '1';
                            filters['lang'] = lang;
                            // Get.to(() => CompanyResultsPage(filters: filters, jtype: widget.type));
                            Get.to(() => CompanyJobListPage(filters: filters, jobType: widget.type));
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: hexStringToColor('#6986b8'), border: Border.all(width: 0.2), borderRadius: BorderRadius.all(Radius.circular(30))),
                              width: getWH(context, 2),
                              height: getWH(context, 1) * 0.05,
                              margin: EdgeInsets.only(top: 10),
                              alignment: Alignment.center,
                              child: Text("Search", style: TextStyle(color: Colors.white, fontSize: 16)).tr()))
                    ]));
              })));
        } else if (!snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            Get.offAll(() => StartPage());
          });
          return SizedBox();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: Container(margin: EdgeInsets.all(35), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
        } else {
          return SizedBox();
        }
      });
}

//====================================================Results

// class CompanyResultsPage extends StatefulWidget {
//   const CompanyResultsPage({Key? key, required this.filters, required this.jtype}) : super(key: key);

//   @override
//   _CompanyResultsPageState createState() => _CompanyResultsPageState();
//   final Map filters;
//   final int jtype;
// }

// class _CompanyResultsPageState extends State<CompanyResultsPage> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   
//   List j = [];
//   Widget build(BuildContext context) {
//     
//     return Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//             centerTitle: true,
//             leading: IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back), color: Colors.white),
//             actions: [
//               Container(
//                   padding: EdgeInsets.symmetric(horizontal: 20),
//                   child: IconButton(
//                       icon: Icon(Icons.language, color: Colors.white),
//                       onPressed: () {
//                         selectLanguage(context);
//                       }))
//             ],
//             backgroundColor: hexStringToColor('#6986b8'),
//             elevation: 0,
//             title: Text('Search Results', style: TextStyle(fontSize: 18, color: Colors.white)).tr()),
//         body: SingleChildScrollView(
//             child: FutureBuilder<Map>(
//                 future: advancedSearch(widget.filters, 1),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!.isNotEmpty) {
//                     j = snapshot.data!['jobs'];
//                     return Column(children: [
//                       Container(
//                           margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
//                           width: getWH(context, 2),
//                           height: getWH(context, 1) * 0.68,
//                           child: ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: j.length,
//                               itemBuilder: (BuildContext context, int index) {
//                                 return GestureDetector(
//                                     onTap: () async {
//                                       Get.to(() => CompanyJobPage(jobId: j[index]['id'].toString(), jobImage: j[index]['job_image'], jobType: 1));
//                                     },
//                                     child: Column(children: [
//                                       Container(
//                                           alignment: Alignment.center,
//                                           margin: EdgeInsets.symmetric(vertical: 10),
//                                           decoration: BoxDecoration(
//                                               color: Colors.grey[50],
//                                               border: Border.all(color: hexStringToColor('#eeeeee')),
//                                               borderRadius: BorderRadius.all(Radius.zero)),
//                                           child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                                             Container(
//                                               margin: EdgeInsets.only(right: lang == 'ar' ? 0 : 15, left: lang == 'ar' ? 15 : 0),
//                                               height: 110,
//                                               width: 110,
//                                               decoration: BoxDecoration(
//                                                   image: DecorationImage(
//                                                       image: j[index]['job_image'] != null
//                                                           ? NetworkImage(j[index]['job_image'])
//                                                           : AssetImage('assets/logo.png') as ImageProvider,
//                                                       fit: BoxFit.fill),
//                                                   color: Colors.grey[50],
//                                                   border: Border.all(color: Colors.transparent),
//                                                   borderRadius: BorderRadius.all(Radius.zero)),
//                                             ),
//                                             Flexible(
//                                                 child: Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(lang == 'ar' ? j[index]['job_title_ar'] : j[index]['job_title_en'],
//                                                     style: TextStyle(fontWeight: FontWeight.bold)),
//                                                 SizedBox(height: 5),
//                                                 Text(
//                                                     lang == 'ar'
//                                                         ? (j[index]['job_section_name_ar'] + ' - ' + j[index]['specialty_name_ar'])
//                                                         : (j[index]['job_section_name_en'] + ' - ' + j[index]['specialty_name_en']),
//                                                     style: TextStyle(fontSize: 13)),
//                                                 Divider(),
//                                                 Row(children: [
//                                                   Icon(Icons.location_pin, size: 20),
//                                                   SizedBox(width: 5),
//                                                   Text(j[index]['country'] + ' - ' + j[index]['region'])
//                                                 ]),
//                                                 SizedBox(height: 5),
//                                                 Row(children: [Icon(Icons.access_time, size: 20), SizedBox(width: 5), Text(j[index]['submission_deadline'])])
//                                               ],
//                                             )),
//                                             Container(
//                                                 margin: EdgeInsets.symmetric(horizontal: 10),
//                                                 child:
//                                                     Column(children: [Icon(Icons.remove_red_eye), Text(j[index]['view_counter'] ?? '0'), SizedBox(height: 60)]))
//                                           ])),
//                                       globalType == 'Individual'
//                                           ? Stack(alignment: Alignment.center, children: <Widget>[
//                                               Container(
//                                                   height: 20,
//                                                   width: getWH(context, 2),
//                                                   child: ClipRRect(
//                                                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                                                       child: LinearProgressIndicator(
//                                                           value: double.parse(j[index]['suitability'].toString()) / 100,
//                                                           valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen)))),
//                                               Align(
//                                                   child: Text('Suitability - ' + j[index]['suitability'].toString() + '% ',
//                                                       style: TextStyle(fontSize: 14, color: Colors.black)))
//                                             ])
//                                           : SizedBox(),
//                                       SizedBox(height: 20)
//                                     ]));
//                               })),
//                     ]);
//                   } else if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(
//                         child: Container(margin: EdgeInsets.all(35), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
//                   } else {
//                     return Center(child: Container(margin: EdgeInsets.all(10), child: Text('No jobs match your criteria').tr()));
//                   }
//                 })));
//   }
// }
