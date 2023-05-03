import 'package:expandable/expandable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../API.dart';
import '../../data.dart';
import '../../functions.dart';
import '../public/individual_profile.dart';

List professions = [];
List<Map<String, dynamic>> options1 = [];
List<Map<String, dynamic>> options2 = [];
List<Map<String, dynamic>> options3 = [];
List<Map<String, dynamic>> options4 = [];
Map filters = {};

class CompanyRelevantPeople extends StatefulWidget {
  const CompanyRelevantPeople({Key? key, required this.type, required this.id, required this.uid, required this.pType}) : super(key: key);

  @override
  _CompanyRelevantPeopleState createState() => _CompanyRelevantPeopleState();
  final String type;
  final int pType;
  final String id;
  final String uid;
}

class _CompanyRelevantPeopleState extends State<CompanyRelevantPeople> {
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
    loading = false;
    options1.clear();
    options2.clear();
    options3.clear();
    options4.clear();
  }

  bool loading = false;

  var country = '111';
  var region;
  var section;
  var specialty;
  

  Widget build(BuildContext context) {
    
    loading = false;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: watheftyBar(context, widget.pType == 1 ? 'Applicants' : 'Suitable Individuals', 18),
        bottomNavigationBar: watheftyBottomBar(context),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              color: Colors.grey[50],
              padding: EdgeInsets.only(top: 20, bottom: 10, right: 40, left: 40),
              child: ExpandablePanel(
                  header: Text('    Filters', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 19)).tr(),
                  collapsed: Text('    Tap to filter or export to Excel', softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis).tr(),
                  expanded: Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.transparent), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      child: Column(children: [
                        StatefulBuilder(builder: (BuildContext context, StateSetter setFilters) {
                          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Container(
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
                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                    type: SelectFormFieldType.dropdown,
                                    items: arrtoList(countryArr, lang, ''),
                                    initialValue: country,
                                    onChanged: (val) {
                                      setFilters(() {});
                                      country = (val);
                                      filters['country_id'] = val;
                                      options1.clear();
                                    })),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                margin: EdgeInsets.only(bottom: 5, top: 15),
                                child: Text('Region', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                            country.isNotEmpty
                                ? FutureBuilder(
                                    future: getInfo('region', lang, country),
                                    builder: (context, snapshot) {
                                      if (options1.isNotEmpty || snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                                        options1 = mpR;
                                        return SizedBox(
                                            height: getWH(context, 1) * 0.05,
                                            child: SelectFormField(
                                              decoration: InputDecoration(
                                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                                  filled: true,
                                                  fillColor: Colors.grey[50],
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                              type: SelectFormFieldType.dropdown,
                                              labelText: tr('Region'),
                                              items: options1,
                                              initialValue: region,
                                              onChanged: (val) {
                                                filters['region_id'] = val;
                                                region = (val);
                                              },
                                            ));
                                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Center(child: Container(margin: EdgeInsets.only(top: 10), constraints: BoxConstraints.tightForFinite(), child: LinearProgressIndicator()));
                                      } else {
                                        return SizedBox();
                                      }
                                    })
                                : SizedBox()
                          ]);
                        }),
                        StatefulBuilder(builder: (BuildContext context, StateSetter setSpecialty) {
                          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                margin: EdgeInsets.only(bottom: 5, top: 15),
                                child: Text('Section', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                            FutureBuilder<List<Map<String, dynamic>>>(
                                future: getInfo('jsection', lang, 'Company'),
                                builder: (context, snapshot) {
                                  if (options2.isNotEmpty || snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                                    options2 = mpJC;
                                    return SizedBox(
                                        height: getWH(context, 1) * 0.05,
                                        child: SelectFormField(
                                          decoration: InputDecoration(
                                              suffixIcon: Icon(Icons.arrow_drop_down),
                                              filled: true,
                                              fillColor: Colors.grey[50],
                                              contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                          type: SelectFormFieldType.dropdown,
                                          items: options2,
                                          initialValue: section,
                                          onChanged: (val) {
                                            section = val;
                                            filters['job_section_id'] = val;
                                            filters.remove('specialty_id');
                                            filters.remove('professions[]');
                                            setSpecialty(() {
                                              mpJS.clear();
                                              options3.clear();
                                              options4.clear();
                                              specialty = null;
                                            });
                                          },
                                        ));
                                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: Container(margin: EdgeInsets.only(top: 10), constraints: BoxConstraints.tightForFinite(), child: LinearProgressIndicator()));
                                  } else {
                                    return SizedBox();
                                  }
                                }),
                            section != null
                                ? Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 15),
                                    child: Text('Specialty', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr())
                                : SizedBox(),
                            section != null
                                ? FutureBuilder<List<Map<String, dynamic>>>(
                                    future: getInfo('jspecialty', lang, section),
                                    builder: (context, snapshot) {
                                      if (options3.isNotEmpty || (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty)) {
                                        options3 = mpJS;
                                        return SizedBox(
                                            height: getWH(context, 1) * 0.05,
                                            child: SelectFormField(
                                              decoration: InputDecoration(
                                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                                  filled: true,
                                                  fillColor: Colors.grey[50],
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                              type: SelectFormFieldType.dropdown,
                                              items: options3,
                                              initialValue: specialty,
                                              onChanged: (val) {
                                                setSpecialty(() {
                                                  options4.clear();
                                                  specialty = val;
                                                  filters['specialty_id'] = val;
                                                  mpJS.clear();
                                                  professions.clear();
                                                  filters.remove('professions[]');
                                                });
                                              },
                                            ));
                                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Center(child: Container(margin: EdgeInsets.only(top: 10), constraints: BoxConstraints.tightForFinite(), child: LinearProgressIndicator()));
                                      } else {
                                        return SizedBox();
                                      }
                                    })
                                : SizedBox(),
                            specialty != null
                                ? Container(
                                    alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 15),
                                    child: Text('Professions', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr())
                                : SizedBox(),
                            specialty != null
                                ? FutureBuilder<List<Map<String, dynamic>>>(
                                    future: getInfo('profession', lang, specialty),
                                    builder: (context, snapshot) {
                                      if (options4.isNotEmpty || snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
                                        options4 = mpPRF;
                                        return Container(
                                            margin: (EdgeInsets.symmetric(vertical: 10)),
                                            child: MultiSelectDialogField(
                                                cancelText: Text('Cancel').tr(),
                                                confirmText: Text('Confirm').tr(),
                                                searchHint: tr('Search'),
                                                title: Text('Select').tr(),
                                                searchable: true,
                                                buttonText: Text('Select').tr(),
                                                items: options4.map((e) => MultiSelectItem(e['value'], e['display'])).toList(),
                                                listType: MultiSelectListType.LIST,
                                                chipDisplay: MultiSelectChipDisplay.none(),
                                                initialValue: professions,
                                                buttonIcon: Icon(Icons.arrow_drop_down),
                                                decoration:
                                                    BoxDecoration(color: Colors.grey[50], border: Border.all(color: Colors.black54, width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                                onConfirm: (values) {
                                                  setSpecialty(() {
                                                    if (values.isNotEmpty) {
                                                      professions = values;
                                                      filters['professions[]'] = values;
                                                    } else {
                                                      filters.remove('professions[]');
                                                      professions.clear();
                                                    }
                                                  });
                                                }));
                                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Center(child: Container(margin: EdgeInsets.only(top: 10), constraints: BoxConstraints.tightForFinite(), child: LinearProgressIndicator()));
                                      } else {
                                        return SizedBox();
                                      }
                                    })
                                : SizedBox(),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                margin: EdgeInsets.only(bottom: 5, top: 15),
                                child: Text('Experience', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                            SizedBox(
                                height: getWH(context, 1) * 0.05,
                                child: SelectFormField(
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(Icons.arrow_drop_down),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                    type: SelectFormFieldType.dropdown,
                                    onChanged: (val) {
                                      val != '0' ? filters['experience_years'] = val : filters.remove('experience_years');
                                    },
                                    items: numbers)),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                margin: EdgeInsets.only(bottom: 5, top: 15),
                                child: Text('Academic Degree', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                            SizedBox(
                                height: getWH(context, 1) * 0.05,
                                child: SelectFormField(
                                  type: SelectFormFieldType.dropdown,
                                  items: arrtoList(degreeArr, lang, ''),
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                  onChanged: (val) {
                                    filters['public_academic_degree_id'] = val;
                                  },
                                )),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                margin: EdgeInsets.only(bottom: 5, top: 15),
                                child: Text('Minimum suitability', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                            SizedBox(
                                height: getWH(context, 1) * 0.05,
                                child: SelectFormField(
                                  type: SelectFormFieldType.dropdown,
                                  items: arrtoList(fiveArr, lang, ''),
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                  onChanged: (val) {
                                    filters['suitability_from'] = val;
                                  },
                                )),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        filters.clear();
                                        options1.clear();
                                        options2.clear();
                                        options3.clear();
                                        options4.clear();
                                      });
                                    },
                                    child: Text("Clear", style: TextStyle(color: Colors.black, fontSize: 16)).tr())),
                            Container(
                                decoration: BoxDecoration(color: hexStringToColor('#6986b8'), border: Border.all(width: 0.2), borderRadius: BorderRadius.all(Radius.circular(30))),
                                width: getWH(context, 2),
                                height: getWH(context, 1) * 0.05,
                                margin: EdgeInsets.only(top: 10),
                                alignment: Alignment.center,
                                child: TextButton(
                                    onPressed: () {
                                      setState(() {});
                                    },
                                    child: Text("Search", style: TextStyle(color: Colors.white, fontSize: 16)).tr())),
                            Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                    onPressed: () async {
                                      filters['export'] = '2';
                                      var tmp = await getRelevantPeople(widget.uid, 'Company', context.locale.toString(), widget.id, widget.type, filters, widget.pType);
                                      String url = tmp['url'] ?? '';
                                      if (url.isNotEmpty) {
                                        await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
                                      }
                                      filters['export'] = '1';
                                    },
                                    child: Text("Export to Excel", style: TextStyle(decoration: TextDecoration.underline, color: Colors.green, fontSize: 16)).tr()))
                          ]);
                        })
                      ])))),
          Container(
              margin: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              width: getWH(context, 2),
              child: FutureBuilder<Map>(
                  future: getRelevantPeople(widget.uid, 'Company', context.locale.toString(), widget.id, widget.type, filters, widget.pType),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.data != null && snapshot.data!.isNotEmpty && snapshot.data!['individuals'].isNotEmpty) {
                      var data = snapshot.data!['individuals'];
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: data!.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            var appStatus;
                            var buttons = 0;
                            if (data[index]['applicant_status'].toString() == '1') {
                              appStatus = tr('Pending');
                            } else if (data[index]['applicant_status'].toString() == '2') {
                              appStatus = tr('Accept');
                              buttons = 3;
                            } else if (data[index]['applicant_status'].toString() == '3') {
                              appStatus = tr('Rejected');
                              buttons = 3;
                            } else if (data[index]['applicant_status'].toString() == '4') {
                              appStatus = tr('Preliminary match');
                              buttons = 2;
                            }
                            return GestureDetector(
                                onTap: () {
                                  Get.to(() => IndividualProfile(iid: data[index]['id'].toString()));
                                },
                                child: Column(children: [
                                  Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(top: 10, bottom: 5),
                                      decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(color: hexStringToColor('#eeeeee')), borderRadius: BorderRadius.all(Radius.zero)),
                                      child: Column(children: [
                                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          Container(
                                              margin: EdgeInsets.only(right: lang == 'ar' ? 0 : 15, left: lang == 'ar' ? 15 : 0),
                                              height: 110,
                                              width: 110,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image:
                                                          data[index]['profile_photo_path'] != null ? NetworkImage(data[index]['profile_photo_path']) : AssetImage('assets/logo.png') as ImageProvider,
                                                      fit: BoxFit.contain),
                                                  color: Colors.grey[50],
                                                  border: Border.all(color: Colors.transparent),
                                                  borderRadius: BorderRadius.all(Radius.zero))),
                                          Flexible(
                                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                              Text(lang == 'ar' ? data[index]['name_ar'] : data[index]['name_en'], style: TextStyle(fontWeight: FontWeight.bold)),
                                              Container(
                                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                                  child: Text(tr(appStatus ?? "" + (buttons == 3 ? tr('ed') : '')),
                                                      style: TextStyle(color: hexStringToColor('#6986b8'), fontWeight: FontWeight.bold, fontSize: 15))),
                                            ]),
                                            SizedBox(height: 5),
                                            Text(
                                                lang == 'ar'
                                                    ? ((data[index]['section_name_ar'] ?? '') + ' - ' + (data[index]['specialty_name_ar'] ?? ''))
                                                    : ((data[index]['section_name_en'] ?? '') + ' - ' + (data[index]['specialty_name_en'] ?? '')),
                                                style: TextStyle(fontSize: 13)),
                                            Divider(),
                                            Text(data[index]['email'], style: TextStyle(fontSize: 13)),
                                            SizedBox(height: 5),
                                            Row(children: [Icon(Icons.phone, size: 20), SizedBox(width: 5), Text(data[index]['phone'] ?? '')])
                                          ])),
                                        ]),
                                        Stack(alignment: Alignment.center, children: <Widget>[
                                          Container(
                                              height: 20,
                                              width: getWH(context, 2),
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.all(Radius.circular(0)),
                                                  child: LinearProgressIndicator(
                                                      value: double.parse(data[index]['suitability'].toString()) / 100, valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen)))),
                                          Align(child: Text(tr('Suitability - ') + data[index]['suitability'].toString() + '% ', style: TextStyle(fontSize: 14, color: Colors.black)).tr())
                                        ])
                                      ])),
                                  widget.pType != 2 && buttons != 3
                                      ? StatefulBuilder(builder: (BuildContext context, StateSetter setActions) {
                                          return !loading
                                              ? Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                  buttons == 1
                                                      ? TextButton(
                                                          style: TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 10), alignment: Alignment.topCenter),
                                                          onPressed: () async {
                                                            setActions(() => loading = true);
                                                            var tmp =
                                                                await applicantActions(lang, data[index]['job_id'].toString(), data[index]['id'].toString(), data[index]['job_type'], '4', widget.uid);
                                                            if (tmp.isNotEmpty && tmp['status']) {
                                                              setState(() {});
                                                            }
                                                            setActions(() => loading = false);
                                                          },
                                                          child: Text('Preliminary Approval', style: TextStyle(color: hexStringToColor('#6986b8'), fontWeight: FontWeight.bold)).tr())
                                                      : SizedBox(),
                                                  IconButton(
                                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                                      constraints: BoxConstraints(),
                                                      onPressed: () async {
                                                        setActions(() => loading = true);
                                                        var tmp =
                                                            await applicantActions(lang, data[index]['job_id'].toString(), data[index]['id'].toString(), data[index]['job_type'], '2', widget.uid);
                                                        if (tmp.isNotEmpty && tmp['status']) {
                                                          setState(() {});
                                                        }
                                                        setActions(() => loading = false);
                                                      },
                                                      icon: Icon(Icons.check, color: hexStringToColor('#6986b8'))),
                                                  IconButton(
                                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                                      constraints: BoxConstraints(),
                                                      onPressed: () async {
                                                        setActions(() => loading = true);
                                                        var tmp =
                                                            await applicantActions(lang, data[index]['job_id'].toString(), data[index]['id'].toString(), data[index]['job_type'], '3', widget.uid);
                                                        if (tmp.isNotEmpty && tmp['status']) {
                                                          setState(() {});
                                                        }
                                                        setActions(() => loading = false);
                                                      },
                                                      icon: Icon(Icons.cancel, color: Colors.red))
                                                ])
                                              : SizedBox(height: 24, width: 60, child: Center(child: LinearProgressIndicator()));
                                        })
                                      : SizedBox(),
                                  SizedBox(height: 10)
                                ]));
                          });
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                    } else {
                      return Center(
                          child: Container(
                              padding: EdgeInsets.all(50),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                Text("No results.", textAlign: TextAlign.center).tr(),
                                TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text('Go back').tr())
                              ])));
                    }
                  }))
        ])));
  }
}
