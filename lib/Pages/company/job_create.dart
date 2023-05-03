import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wathefty/Pages/company/job_list.dart';
import '../../API.dart';
import '../../data.dart';
import '../../functions.dart';
import '../../main.dart';
import 'job_list.dart';
import 'dart:ui' as ui;

class CompanyCreateJobPage extends StatefulWidget {
  @override
  _CompanyCreateJobPageState createState() => _CompanyCreateJobPageState();
  const CompanyCreateJobPage({
    Key? key,
    required this.jobEdit,
    required this.jobId,
  }) : super(key: key);
  final bool jobEdit;
  final String jobId;
}

class _CompanyCreateJobPageState extends State<CompanyCreateJobPage> {
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

  final jobTitleAr = TextEditingController();
  final jobTitleEn = TextEditingController();
  final expf = TextEditingController();
  final expt = TextEditingController();
  final salaryfrom = TextEditingController();
  final salaryto = TextEditingController();
  final sectionId = TextEditingController();
  final specialtyId = TextEditingController();
  final deadline = TextEditingController();
  final discriminationDeadline = TextEditingController();
  final currency = TextEditingController();
  final jobDescriptionAr = TextEditingController();
  final jobDescriptionEn = TextEditingController();
  final degree = TextEditingController();
  final countryId = TextEditingController(text: '111');
  final regionId = TextEditingController();
  final nationality = TextEditingController(text: '111');
  final companyEmail = TextEditingController();
  final companyPhone = TextEditingController();
  final companySite = TextEditingController();
  final category = TextEditingController();
  final socialsec = TextEditingController(text: '1');
  final worknature = TextEditingController();
  final contractduration = TextEditingController();
  final healthInsurance = TextEditingController();
  final workinghours = TextEditingController();
  final gender = TextEditingController();
  final socialStatus = TextEditingController();
  FilePickerResult? result;
  FilePickerResult? resultfile;
  var defaultpicked = ' ';
  int showInfo = 1;
  int socialSecInt = 1;
  int healthInsuranceInt = 1;
  int applyType = 1;
  int discrimination = 2;
  int selectedJobs = 2;
  int salaryint = 2;
  var defaultTime;
  var text, action;
  List professionSelection = [];
  
  var imgLnk;
  bool loading = false;

  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          loading = false;
          

          return Scaffold(
              backgroundColor: Colors.white,
              appBar: watheftyBar(context, widget.jobEdit ? 'Edit job' : 'Create a new job', 20),
              bottomNavigationBar: watheftyBottomBar(context),
              body: FutureBuilder<Map>(
                  future: jobEdit(snapshot.data!["uid"], widget.jobEdit, widget.jobId, lang),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (widget.jobEdit && snapshot.data!['job_status'] != '6') {
                        text = tr('Edit job');
                        action = 2;
                      } else if (!widget.jobEdit) {
                        text = tr('Create a new job');
                        action = 1;
                      } else if (widget.jobEdit && snapshot.data!['job_status'] == '6') {
                        text = tr('Repost job');
                        action = 3;
                      }
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        var shrt = snapshot.data;
                        for (var u in shrt!['professions']) {
                          professionSelection.add(u['profession_id']);
                        }
                        // if (shrt['job_status'] == '6') {}
                        jobTitleAr.text = shrt['job_title_ar'];
                        jobTitleEn.text = shrt['job_title_en'];
                        sectionId.text = shrt['job_section_id'].toString();
                        defaultTime = DateTime.parse(shrt['submission_deadline']);
                        specialtyId.text = shrt['job_specialty_id'].toString();
                        // selectedJobs = int.parse(shrt['selected_job']);
                        // if (shrt.containsKey('category_selected_job') && shrt['category_selected_job'] != null) {
                        //   category.text = shrt['category_selected_job'];
                        // }
                        discrimination = shrt['discrimination_status'];
                        discriminationDeadline.text = shrt['discrimination_deadline'] != null ? shrt['discrimination_deadline'] : '';
                        expf.text = shrt['experience_years_from'].toString();
                        expt.text = shrt['experience_years_to'].toString();
                        salaryint = shrt['salary_determination'];
                        salaryfrom.text = shrt['salary_from'];
                        salaryto.text = shrt['salary_to'];
                        currency.text = shrt['currency'];
                        jobDescriptionEn.text = shrt['job_description_en'];
                        jobDescriptionAr.text = shrt['job_description_ar'];
                        if (shrt['job_file'] != null) {
                          var tmpp = shrt['job_file'].split("/");
                          defaultpicked = tmpp[tmpp.length - 1];
                        }
                        companyPhone.text = shrt['contact_phone'] ?? '';
                        companyEmail.text = shrt['contact_email'] ?? '';
                        companySite.text = shrt['contact_url'] ?? '';
                        countryId.text = shrt['country_id'].toString();
                        regionId.text = shrt['region_id'].toString();
                        deadline.text = shrt['submission_deadline'];
                        showInfo = shrt['show_company_info'];
                        applyType = shrt['apply_type'];
                        nationality.text = shrt['nationality_id'].toString();
                        degree.text = shrt['public_academic_degree_id'].toString();
                        gender.text = shrt['gender_id'].toString();
                        if (shrt['job_image'] != null && shrt['job_image'].isNotEmpty) {
                          imgLnk = NetworkImage(shrt['job_image']);
                        } else {
                          imgLnk = AssetImage('assets/logo.png');
                        }
                        workinghours.text = shrt['type_working_hours_id'].toString();
                        contractduration.text = shrt['contract_duration_id'].toString();
                        worknature.text = shrt['work_nature_id'].toString();
                        healthInsurance.text = shrt['health_insurance_id'].toString();
                        socialsec.text = shrt['social_security_subscription_id'].toString();
                        socialSecInt = shrt['social_security_subscription_id'];
                        healthInsuranceInt = shrt['health_insurance_id'];
                        socialStatus.text = shrt['social_status_id'].toString();
                      } else {
                        defaultTime = DateTime.now();
                        imgLnk = AssetImage('assets/logo.png');
                      }
                      return SingleChildScrollView(
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Job image', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
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
                                StatefulBuilder(builder: (BuildContext context, StateSetter _setSpecialty) {
                                  return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                    Container(
                                        padding: EdgeInsets.only(left: 15),
                                        margin: EdgeInsets.only(bottom: 10, top: 20),
                                        child: Text('Section', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                    FutureBuilder<List<Map<String, dynamic>>>(
                                        future: getInfo('jsection', lang, 'Company'),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                                            return Container(
                                                margin: (EdgeInsets.symmetric(vertical: 5)),
                                                child: SelectFormField(
                                                  validator: (val) {
                                                    if (val!.isEmpty) {
                                                      return tr('Please select job section');
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                                      filled: true,
                                                      fillColor: Colors.grey[50],
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                  type: SelectFormFieldType.dropdown,
                                                  labelText: tr('Job section'),
                                                  items: mpJC,
                                                  controller: sectionId,
                                                  // initialValue: sectionId.text,
                                                  onChanged: (val) {
                                                    _setSpecialty(() {
                                                      mpJS.clear();
                                                      // sectionId.text = (val);
                                                      specialtyId.clear();
                                                    });
                                                  },
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
                                    if (sectionId.text.isNotEmpty)
                                      Container(
                                          padding: EdgeInsets.only(left: 15),
                                          margin: EdgeInsets.only(bottom: 10, top: 20),
                                          child: Text('Specaility', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                    sectionId.text.isNotEmpty
                                        ? FutureBuilder<List<Map<String, dynamic>>>(
                                            future: getInfo('jspecialty', lang, sectionId.text),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                                                return Container(
                                                    margin: (EdgeInsets.symmetric(vertical: 5)),
                                                    child: SelectFormField(
                                                      decoration: InputDecoration(
                                                          suffixIcon: Icon(Icons.arrow_drop_down),
                                                          filled: true,
                                                          fillColor: Colors.grey[50],
                                                          enabledBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                          focusedBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black54),
                                                              borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                      validator: (val) {
                                                        if (val!.isEmpty) {
                                                          return tr('Please select specialty');
                                                        }
                                                        return null;
                                                      },
                                                      type: SelectFormFieldType.dropdown,
                                                      items: mpJS,
                                                      controller: specialtyId,
                                                      // initialValue: specialtyId.text,
                                                      onChanged: (val) {
                                                        _setSpecialty(() {
                                                          mpJS.clear();
                                                          // specialtyId.text = (val);
                                                          professionSelection.clear();
                                                        });
                                                      },
                                                    ));
                                              } else {
                                                return SizedBox();
                                              }
                                            })
                                        : SizedBox(),
                                    if (specialtyId.text.isNotEmpty)
                                      Container(
                                          padding: EdgeInsets.only(left: 15),
                                          margin: EdgeInsets.only(bottom: 10, top: 20),
                                          child: Text('Professions', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                    specialtyId.text.isNotEmpty
                                        ? FutureBuilder<List<Map<String, dynamic>>>(
                                            future: getInfo('profession', lang, specialtyId.text),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                                                return Container(
                                                    margin: (EdgeInsets.symmetric(vertical: 10)),
                                                    child: MultiSelectDialogField(
                                                        cancelText: Text('Cancel').tr(),
                                                        confirmText: Text('Confirm').tr(),
                                                        searchHint: tr('Search'),
                                                        title: Text('Select').tr(),
                                                        searchable: true,
                                                        buttonText: Text('Select').tr(),
                                                        items: mpPRF.map((e) => MultiSelectItem(e['value'], e['display'])).toList(),
                                                        listType: MultiSelectListType.LIST,
                                                        validator: (values) {
                                                          if (values == null) {
                                                            return tr('Please select one or more option(s)');
                                                          }
                                                          return null;
                                                        },
                                                        chipDisplay: MultiSelectChipDisplay.none(),
                                                        initialValue: professionSelection,
                                                        buttonIcon: Icon(Icons.arrow_drop_down),
                                                        decoration: BoxDecoration(
                                                            color: Colors.grey[50],
                                                            border: Border.all(color: Colors.black54, width: 0.4),
                                                            borderRadius: BorderRadius.all(Radius.circular(10))),
                                                        onConfirm: (values) {
                                                          professionSelection = values;
                                                        }));
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
                                    child: Text('Arabic Job Title', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
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
                                  controller: jobTitleAr,
                                  onChanged: (value) {
                                    // jobTitleAr.text = value;
                                  },
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('English Job Title', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
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
                                  controller: jobTitleEn,
                                  onChanged: (value) {
                                    // jobTitleEn.text = value;
                                  },
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Submission deadline', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),

                                StatefulBuilder(builder: (BuildContext context, StateSetter _setDeadline) {
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
                                                minTime: DateTime(now.year, now.month, now.day + 1),
                                                maxTime: DateTime(now.year + 1, now.month + 12),
                                                onChanged: (date) {}, onConfirm: (date) {
                                              _setDeadline(() {
                                                deadline.text = date.toString().substring(0, 10);
                                              });
                                            }, currentTime: defaultTime, locale: lang == 'ar' ? LocaleType.ar : LocaleType.en);
                                          },
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                            Text(deadline.text.isNotEmpty ? deadline.text : 'Choose a date', style: TextStyle(color: Colors.black54)).tr(),
                                            Icon(Icons.calendar_today, color: Colors.black54)
                                          ])));
                                }),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Experience - From', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                SelectFormField(
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder:
                                          OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  type: SelectFormFieldType.dropdown,
                                  items: numbers,
                                  controller: expf,
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('To', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                SelectFormField(
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder:
                                          OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  type: SelectFormFieldType.dropdown,
                                  items: numbers,
                                  controller: expt,
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Add file', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),

                                StatefulBuilder(builder: (BuildContext context, StateSetter setFile) {
                                  return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[50], border: Border.all(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      alignment: Alignment.bottomRight,
                                      child: TextButton(
                                        onPressed: () async {
                                          resultfile = await FilePicker.platform.pickFiles(type: FileType.image);
                                          setFile(() {});
                                        },
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          Text(resultfile != null ? resultfile!.files.first.name : defaultpicked.toString(),
                                              style: TextStyle(color: Colors.black54)),
                                          Icon(Icons.file_upload_outlined, color: hexStringToColor('#6986b8'))
                                        ]),
                                      ));
                                }),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Country', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                StatefulBuilder(builder: (BuildContext context, StateSetter _setRegion) {
                                  return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                    Container(
                                        child: SelectFormField(
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return tr('Please select country and region');
                                        }
                                        return null;
                                      },
                                      type: SelectFormFieldType.dropdown,
                                      items: arrtoList(countryArr, lang, ''),
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.arrow_drop_down),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          enabledBorder:
                                              OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                      controller: countryId,
                                      onChanged: (val) {
                                        _setRegion(() {
                                          // countryId.text = (val);
                                          regionId.clear();
                                        });
                                      },
                                    )),
                                    Container(
                                        padding: EdgeInsets.only(left: 15),
                                        margin: EdgeInsets.only(bottom: 10, top: 20),
                                        child: Text('Region', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                    countryId.text.isNotEmpty
                                        ? FutureBuilder<List<Map<String, dynamic>>>(
                                            future: getInfo('region', lang, countryId.text),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                                                return SelectFormField(
                                                  decoration: InputDecoration(
                                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                                      filled: true,
                                                      fillColor: Colors.grey[50],
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                  validator: (val) {
                                                    if (val!.isEmpty) {
                                                      return tr('Please select region');
                                                    }
                                                    return null;
                                                  },
                                                  type: SelectFormFieldType.dropdown,
                                                  items: mpR,
                                                  controller: regionId,
                                                  // onChanged: (val) => regionId.text = (val),
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
                                        : SizedBox()
                                  ]);
                                }),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Show company information', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                StatefulBuilder(builder: (BuildContext context, StateSetter setInfo) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                          child: ListTile(
                                        title: Text("Yes", style: TextStyle(color: showInfo == 1 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                        leading: Radio(
                                          value: 1,
                                          groupValue: showInfo,
                                          onChanged: (value) {
                                            setInfo(() {
                                              showInfo = value as int;
                                            });
                                          },
                                          activeColor: hexStringToColor('#6986b8'),
                                        ),
                                      )),
                                      Expanded(
                                          child: ListTile(
                                        title: Text("No", style: TextStyle(color: showInfo == 2 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                        leading: Radio(
                                          value: 2,
                                          groupValue: showInfo,
                                          onChanged: (value) {
                                            setInfo(() {
                                              showInfo = value as int;
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
                                    child: Text('Social Security', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                StatefulBuilder(builder: (BuildContext context, StateSetter setSec) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                          child: ListTile(
                                        title: Text("Yes", style: TextStyle(color: socialSecInt == 1 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                        leading: Radio(
                                          value: 1,
                                          groupValue: socialSecInt,
                                          onChanged: (value) {
                                            setSec(() {
                                              socialSecInt = value as int;
                                              socialsec.text = value.toString();
                                            });
                                          },
                                          activeColor: hexStringToColor('#6986b8'),
                                        ),
                                      )),
                                      Expanded(
                                          child: ListTile(
                                        title: Text("No", style: TextStyle(color: socialSecInt == 2 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                        leading: Radio(
                                          value: 2,
                                          groupValue: socialSecInt,
                                          onChanged: (value) {
                                            setSec(() {
                                              socialSecInt = value as int;
                                              socialsec.text = value.toString();
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
                                    child: Text('Health Insurance', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),

                                StatefulBuilder(builder: (BuildContext context, StateSetter setSec) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                          child: ListTile(
                                        title: Text("Yes", style: TextStyle(color: healthInsuranceInt == 1 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                        leading: Radio(
                                          value: 1,
                                          groupValue: healthInsuranceInt,
                                          onChanged: (value) {
                                            setSec(() {
                                              healthInsuranceInt = value as int;
                                              healthInsurance.text = value.toString();
                                            });
                                          },
                                          activeColor: hexStringToColor('#6986b8'),
                                        ),
                                      )),
                                      Expanded(
                                          child: ListTile(
                                        title: Text("No", style: TextStyle(color: healthInsuranceInt == 2 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                        leading: Radio(
                                          value: 2,
                                          groupValue: healthInsuranceInt,
                                          onChanged: (value) {
                                            setSec(() {
                                              healthInsuranceInt = value as int;
                                              healthInsurance.text = value.toString();
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
                                    child: Text('Work Nature', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),

                                SelectFormField(
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return tr('Please select nature of work');
                                    }
                                    return null;
                                  },
                                  type: SelectFormFieldType.dropdown,
                                  items: arrtoList(workNatureArr, lang, ''),
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder:
                                          OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  controller: worknature,
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Type / Working Hours', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),

                                SelectFormField(
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return tr('Please select working hours');
                                    }
                                    return null;
                                  },
                                  type: SelectFormFieldType.dropdown,
                                  items: arrtoList(workingHoursArr, lang, ''),
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder:
                                          OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  controller: workinghours,
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Contract Duration', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),

                                SelectFormField(
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return tr('Please select contract duration');
                                    }
                                    return null;
                                  },
                                  type: SelectFormFieldType.dropdown,
                                  items: arrtoList(contractDurationArr, lang, ''),
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder:
                                          OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  controller: contractduration,
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Social status', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                DropdownSearch<Map>(
                                  items: arrtoList(maritalStatusArr, lang, ''),
                                  maxHeight: 300,
                                  popupItemBuilder: (context, item, isSelected) {
                                    return Container(
                                        height: 50,
                                        child: Column(children: [Expanded(child: Text(item['label'])), Divider(thickness: 1, indent: 10, endIndent: 10)]));
                                  },
                                  dropdownBuilder: (context, selectedItem) {
                                    if (selectedItem != null)
                                      return Text(selectedItem['label']);
                                    else
                                      return Text(snapshot.data?["social_status"] ?? "");
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
                                    socialStatus.text = val!['value'].toString();
                                  },
                                  showSearchBox: true,
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Apply through', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),

                                StatefulBuilder(builder: (BuildContext context, StateSetter setType) {
                                  return Column(children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                            child: ListTile(
                                          title: Text("Wathefty", style: TextStyle(color: applyType == 1 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                          leading: Radio(
                                            value: 1,
                                            groupValue: applyType,
                                            onChanged: (value) {
                                              setType(() {
                                                applyType = value as int;
                                              });
                                            },
                                            activeColor: hexStringToColor('#6986b8'),
                                          ),
                                        )),
                                        Expanded(
                                            child: ListTile(
                                          title: Text("Company's website", style: TextStyle(color: applyType == 2 ? hexStringToColor('#6986b8') : Colors.black))
                                              .tr(),
                                          leading: Radio(
                                            value: 2,
                                            groupValue: applyType,
                                            onChanged: (value) {
                                              setType(() {
                                                applyType = value as int;
                                              });
                                            },
                                            activeColor: hexStringToColor('#6986b8'),
                                          ),
                                        )),
                                      ],
                                    ),
                                    applyType == 2
                                        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            Text(
                                              "Company phone number",
                                              style: TextStyle(fontSize: 15, color: Colors.black),
                                            ).tr(),
                                            InternationalPhoneNumberInput(
                                              inputDecoration: InputDecoration(
                                                  fillColor: Colors.grey[50],
                                                  filled: true,
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                              spaceBetweenSelectorAndTextField: 1,
                                              onInputChanged: (PhoneNumber number) {
                                                companyPhone.text = number.phoneNumber!;
                                              },
                                              selectorConfig: SelectorConfig(
                                                  leadingPadding: 15, selectorType: PhoneInputSelectorType.BOTTOM_SHEET, setSelectorButtonAsPrefixIcon: true),
                                              autoValidateMode: AutovalidateMode.onUserInteraction,
                                              initialValue: companyPhone.text.isNotEmpty
                                                  ? PhoneNumber(isoCode: 'JO', phoneNumber: companyPhone.text)
                                                  : PhoneNumber(isoCode: 'JO'),
                                              errorMessage: tr('Invalid phone number'),
                                              selectorTextStyle: TextStyle(color: Colors.black),
                                              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                            ),
                                            Container(
                                                padding: EdgeInsets.only(left: 15),
                                                margin: EdgeInsets.only(bottom: 10, top: 20),
                                                child: Text('Company email', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                            TextField(
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.grey[50],
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                              style: TextStyle(color: Colors.blueGrey),
                                              textDirection: ui.TextDirection.ltr,
                                              controller: companyEmail,
                                            ),
                                            Container(
                                                padding: EdgeInsets.only(left: 15),
                                                margin: EdgeInsets.only(bottom: 10, top: 20),
                                                child: Text('Company website', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                            TextField(
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.grey[50],
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                              style: TextStyle(color: Colors.blueGrey),
                                              controller: companySite,
                                              textDirection: ui.TextDirection.ltr,
                                            ),
                                          ])
                                        : SizedBox()
                                  ]);
                                }),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Nationality', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),

                                SelectFormField(
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return tr('Please select nationality');
                                    }
                                    return null;
                                  },
                                  type: SelectFormFieldType.dropdown,
                                  labelText: tr('Nationality'),
                                  items: arrtoList(nationalityArr, lang, ''),
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder:
                                          OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  controller: nationality,
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Academic Degree', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),

                                SelectFormField(
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return tr('Please select academic level');
                                    }
                                    return null;
                                  },
                                  type: SelectFormFieldType.dropdown,
                                  labelText: tr('Academic Degree'),
                                  items: arrtoList(degreeArr, lang, ''),
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder:
                                          OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  controller: degree,
                                  // onChanged: (val) => degree.text = (val),
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Gender', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                SelectFormField(
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return tr('Please select gender');
                                    }
                                    return null;
                                  },
                                  type: SelectFormFieldType.dropdown,
                                  items: arrtoList(genderArr, lang, ''),
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder:
                                          OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  controller: gender,
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Set salary', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                StatefulBuilder(builder: (BuildContext context, StateSetter setType) {
                                  return Column(children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                            child: ListTile(
                                          title: Text("Yes", style: TextStyle(color: salaryint == 1 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                          leading: Radio(
                                            value: 1,
                                            groupValue: salaryint,
                                            onChanged: (value) {
                                              setType(() {
                                                salaryint = value as int;
                                              });
                                            },
                                            activeColor: hexStringToColor('#6986b8'),
                                          ),
                                        )),
                                        Expanded(
                                            child: ListTile(
                                          title: Text("No", style: TextStyle(color: salaryint == 2 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                          leading: Radio(
                                            value: 2,
                                            groupValue: salaryint,
                                            onChanged: (value) {
                                              setType(() {
                                                salaryint = value as int;
                                              });
                                            },
                                            activeColor: hexStringToColor('#6986b8'),
                                          ),
                                        )),
                                      ],
                                    ),
                                    salaryint == 1
                                        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            Container(
                                                padding: EdgeInsets.only(left: 15),
                                                margin: EdgeInsets.only(bottom: 10, top: 20),
                                                child: Text('From', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                            TextField(
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.grey[50],
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                                              style: TextStyle(color: Colors.blueGrey),
                                              controller: salaryfrom,
                                              textDirection: ui.TextDirection.ltr,
                                              onChanged: (value) async {
                                                // salaryfrom.text = value;
                                              },
                                            ),
                                            Container(
                                                padding: EdgeInsets.only(left: 15),
                                                margin: EdgeInsets.only(bottom: 10, top: 20),
                                                child: Text('To', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                            TextField(
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.grey[50],
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                                              style: TextStyle(color: Colors.blueGrey),
                                              textDirection: ui.TextDirection.ltr,
                                              controller: salaryto,
                                              onChanged: (value) async {
                                                // salaryto.text = value;
                                              },
                                            ),
                                            Container(
                                                padding: EdgeInsets.only(left: 15),
                                                margin: EdgeInsets.only(bottom: 10, top: 20),
                                                child: Text('Currency', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                            FutureBuilder<List<Map<String, dynamic>>>(
                                                future: getCurrencies(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!.isNotEmpty) {
                                                    return Container(
                                                        margin: (EdgeInsets.symmetric(vertical: 5)),
                                                        child: DropdownSearch<Map>(
                                                          items: snapshot.data,
                                                          maxHeight: 300,
                                                          popupItemBuilder: (context, item, isSelected) {
                                                            return Container(
                                                                padding: EdgeInsets.symmetric(horizontal: 5),
                                                                height: 60,
                                                                child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Expanded(child: Text(item['label'], textAlign: TextAlign.center)),
                                                                      Divider(thickness: 1, indent: 10, endIndent: 10)
                                                                    ]));
                                                          },
                                                          dropdownBuilder: (context, selectedItem) {
                                                            if (selectedItem != null)
                                                              return Text(selectedItem['label']);
                                                            else
                                                              return Text(currency.text.isNotEmpty ? currency.text : "");
                                                          },
                                                          dropdownSearchDecoration: InputDecoration(
                                                              hintText: tr('Search'),
                                                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                              filled: true,
                                                              fillColor: Colors.grey[50],
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(color: Colors.black54),
                                                                  borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                          onChanged: (val) {
                                                            currency.text = val!['value'].toString();
                                                          },
                                                          showSearchBox: true,
                                                        ));
                                                  } else {
                                                    return SizedBox();
                                                  }
                                                })

                                            // SelectFormField(
                                            //   validator: (val) {
                                            //     if (val!.isEmpty) {
                                            //       return tr('Please select currency');
                                            //     }
                                            //   },
                                            //   type: SelectFormFieldType.dropdown,
                                            //   labelText: tr('Currency'),
                                            //   controller: currency,
                                            //   items: arrtoList(currencyArr, lang, ''),
                                            //   decoration: InputDecoration(
                                            //       suffixIcon: Icon(Icons.arrow_drop_down),
                                            //       filled: true,
                                            //       fillColor: Colors.grey[50],
                                            //       enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            //       focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                            //   // initialValue: currency.text.isNotEmpty ? currency.text : 'JOD',
                                            //   // onChanged: (val) => currency.text = (val),
                                            // ),
                                          ])
                                        : SizedBox()
                                  ]);
                                }),

                                // Container(
                                //         padding: EdgeInsets.only(left: 15),
                                //         margin: EdgeInsets.only(bottom: 10, top: 20),
                                //         child: Text('Distinguish', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),

                                // StatefulBuilder(builder: (BuildContext context, StateSetter setType) {
                                //   return Column(children: [
                                //     Row(
                                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //       children: [
                                //         Expanded(
                                //             child: ListTile(
                                //           title: Text("Yes"),
                                //           leading: Radio(
                                //             value: 1,
                                //             groupValue: discrimination,
                                //             onChanged: (value) {
                                //               setType(() {
                                //                 discrimination = value as int;
                                //               });
                                //             },
                                //             activeColor: hexStringToColor('#6986b8'),
                                //           ),
                                //         )),
                                //         Expanded(
                                //             child: ListTile(
                                //           title: Text("No"),
                                //           leading: Radio(
                                //             value: 2,
                                //             groupValue: discrimination,
                                //             onChanged: (value) {
                                //               setType(() {
                                //                 discrimination = value as int;
                                //               });
                                //             },
                                //             activeColor: hexStringToColor('#6986b8'),
                                //           ),
                                //         )),
                                //       ],
                                //     ),
                                //     discrimination == 1
                                //         ? FutureBuilder<List<Map<String, dynamic>>>(
                                //             future: getInfo('distinction', lang, ''),
                                //             builder: (context, snapshot) {
                                //               if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                                //                 return SelectFormField(
                                //                   decoration: InputDecoration(hintText: tr('Select distinction'), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                //                   type: SelectFormFieldType.dropdown,
                                //                   labelText: tr('Distintction'),
                                //                   items: mpDSC,
                                //                   controller: discriminationDeadline,
                                //                   // onChanged: (val) => discriminationDeadline.text = (val),
                                //                 );
                                //               } else if (snapshot.connectionState == ConnectionState.waiting) {
                                //                 return Center(child: Container(margin: EdgeInsets.only(top: 10), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                                //               } else {
                                //                 return SizedBox();
                                //               }
                                //             })
                                //         : SizedBox()
                                //   ]);
                                // }),
                                // Text(
                                //   'Add to category',
                                //   style: TextStyle(fontSize: 17.0, color: Colors.black),
                                // ).tr(),
                                // StatefulBuilder(builder: (BuildContext context, StateSetter setType) {
                                //   return Column(children: [
                                //     Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                //       Expanded(
                                //           child: ListTile(
                                //         title: Text("Yes"),
                                //         leading: Radio(
                                //           value: 1,
                                //           groupValue: selectedJobs,
                                //           onChanged: (value) {
                                //             setType(() {
                                //               selectedJobs = value as int;
                                //             });
                                //           },
                                //           activeColor: hexStringToColor('#6986b8'),
                                //         ),
                                //       )),
                                //       Expanded(
                                //           child: ListTile(
                                //         title: Text("No"),
                                //         leading: Radio(
                                //           value: 2,
                                //           groupValue: selectedJobs,
                                //           onChanged: (value) {
                                //             setType(() {
                                //               selectedJobs = value as int;
                                //             });
                                //           },
                                //           activeColor: hexStringToColor('#6986b8'),
                                //         ),
                                //       )),
                                //     ]),
                                //     selectedJobs == 1
                                //         ? FutureBuilder<List<Map<String, dynamic>>>(
                                //             future: getInfo('selection', lang, ''),
                                //             builder: (context, snapshot) {
                                //               if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                                //                 return SelectFormField(
                                //                   decoration: InputDecoration(hintText: tr('Select category'), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                //                   validator: (val) {
                                //                     if (val!.isEmpty) {
                                //                       return tr('Please select category');
                                //                     }
                                //                   },
                                //                   type: SelectFormFieldType.dropdown,
                                //                   labelText: tr('Category'),
                                //                   items: mpSL,
                                //                   controller: category,
                                //                   // onChanged: (val) => category.text = (val),
                                //                 );
                                //               } else if (snapshot.connectionState == ConnectionState.waiting) {
                                //                 return Center(child: Container(margin: EdgeInsets.only(top: 10), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                                //               } else {
                                //                 return SizedBox();
                                //               }
                                //             })
                                //         : SizedBox()
                                //   ]);
                                // }),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Description in Arabic', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),

                                TextField(
                                  minLines: 4,
                                  keyboardType: TextInputType.multiline,
                                  textDirection: ui.TextDirection.rtl,
                                  maxLines: null,
                                  controller: jobDescriptionAr,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder:
                                          OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  style: TextStyle(color: Colors.blueGrey),
                                  onChanged: (value) async {
                                    // jobDescriptionAr.text = value;
                                  },
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 15),
                                    margin: EdgeInsets.only(bottom: 10, top: 20),
                                    child: Text('Description in English', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                TextField(
                                  minLines: 4,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  controller: jobDescriptionEn,
                                  textDirection: ui.TextDirection.ltr,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      enabledBorder:
                                          OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  style: TextStyle(color: Colors.blueGrey),
                                  onChanged: (value) async {
                                    // jobDescriptionEn.text = value;
                                  },
                                ),
                                StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
                                  return !loading
                                      ? GestureDetector(
                                          onTap: () async {
                                            if (jobTitleAr.text.isEmpty ||
                                                jobTitleEn.text.isEmpty ||
                                                deadline.text.isEmpty ||
                                                expf.text.isEmpty ||
                                                expt.text.isEmpty ||
                                                countryId.text.isEmpty ||
                                                regionId.text.isEmpty ||
                                                gender.text.isEmpty ||
                                                specialtyId.text.isEmpty ||
                                                sectionId.text.isEmpty ||
                                                nationality.text.isEmpty ||
                                                degree.text.isEmpty ||
                                                (salaryint == 1 && (salaryfrom.text.isEmpty || salaryto.text.isEmpty || currency.text.isEmpty)) ||
                                                jobDescriptionAr.text.isEmpty ||
                                                jobDescriptionEn.text.isEmpty ||
                                                professionSelection.isEmpty ||
                                                socialStatus.text.isEmpty ||
                                                // workinghours.text.isEmpty ||
                                                // contractduration.text.isEmpty ||
                                                // worknature.text.isEmpty ||
                                                // socialsec.text.isEmpty ||
                                                // healthInsurance.text.isEmpty ||
                                                (applyType == 2 && (companyPhone.text.isEmpty || companyEmail.text.isEmpty || companySite.text.isEmpty)) ||
                                                (discrimination == 1 && discriminationDeadline.text.isEmpty)) {
                                              Get.snackbar(tr('All the fields are required'), tr('Please fill them and try again'),
                                                  duration: Duration(seconds: 5),
                                                  backgroundColor: Colors.white,
                                                  colorText: Colors.red,
                                                  leftBarIndicatorColor: Colors.red);
                                              return;
                                            }
                                            socialsec.text = socialSecInt.toString();
                                            healthInsurance.text = healthInsuranceInt.toString();
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            var uid = prefs.getString('uid');
                                            Map uInfo = {
                                              'job_title_ar': jobTitleAr.text,
                                              'job_title_en': jobTitleEn.text,
                                              'submission_deadline': deadline.text,
                                              'experience_years_from': expf.text,
                                              'experience_years_to': expt.text,
                                              'country_id': countryId.text,
                                              'region_id': regionId.text,
                                              'specialty_id': specialtyId.text,
                                              'job_section_id': sectionId.text,
                                              'nationality': nationality.text,
                                              'show_company_info': showInfo.toString(),
                                              'apply_type': applyType.toString(),
                                              'public_academic_degree_id': degree.text,
                                              'salary_determination': salaryint.toString(),
                                              'salary_from': salaryfrom.text,
                                              'salary_to': salaryto.text,
                                              'currency': currency.text,
                                              'job_description_ar': jobDescriptionAr.text,
                                              'job_description_en': jobDescriptionEn.text,
                                              'discrimination_status': discrimination.toString(),
                                              'professions': professionSelection,
                                              'health_insurance': healthInsurance.text,
                                              'social_security_subscription': socialsec.text,
                                              'work_nature': worknature.text,
                                              'type_working_hours': workinghours.text,
                                              'contract_duration': contractduration.text,
                                              'selected_job': selectedJobs.toString(),
                                              'gender': gender.text,
                                              'social_status': socialStatus.text,
                                              'contact_phone': '',
                                              'contact_email': '',
                                              'contact_url': '',
                                              'discrimination_deadline': ''
                                            };
                                            if (applyType == 2) {
                                              uInfo['contact_phone'] = companyPhone.text;
                                              uInfo['contact_email'] = companyEmail.text;
                                              uInfo['contact_url'] = companySite.text;
                                            }
                                            if (discrimination == 1) {
                                              uInfo['discrimination_deadline'] = discriminationDeadline.text;
                                            }
                                            result != null ? uInfo['job_image'] = File(result!.files.first.path!) : result = null;
                                            resultfile != null ? uInfo['job_file'] = File(resultfile!.files.first.path!) : resultfile = null;
                                            _setState(() {
                                              loading = true;
                                            });
                                            if (widget.jobEdit && snapshot.data!['job_status'] == '6') {}
                                            var tmp = await createJob(lang, uid, 'Company', uInfo, widget.jobId, action);
                                            _setState(() {
                                              loading = false;
                                            });
                                            if (tmp['status'] == true) {
                                              Get.offAll(() => CompanyJobListPage(jobType: 1));
                                            }
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
                                              child: Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)).tr()))
                                      : Center(
                                          child: Container(
                                              margin: EdgeInsets.all(30), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
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
