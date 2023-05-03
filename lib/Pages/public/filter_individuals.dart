import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:wathefty/API.dart';
import 'package:wathefty/Pages/company/cv_search.dart';
import 'package:wathefty/Pages/individual/company_page.dart';
import '../../functions.dart';
import 'company.dart';
import 'individual_profile.dart';

class People extends StatefulWidget {
  @override
  _PeopleState createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    search.dispose();
  }

  List data = [];
  
  final search = TextEditingController();
  final type = TextEditingController(text: '1');
  Map filters = {};
  Widget build(BuildContext context) {
    
    filters['lang'] = lang;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: watheftyBar(context, 'Job Seekers & Companies', 16),
        body: SingleChildScrollView(child: StatefulBuilder(builder: (BuildContext context, StateSetter setRefresh) {
          return Column(children: [
            Container(
                color: Colors.grey[50],
                padding: EdgeInsets.only(top: 20, bottom: 10, right: 40, left: 40),
                child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.transparent), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Column(children: [
                      Container(
                          alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          margin: EdgeInsets.only(bottom: 5, top: 15),
                          child: Text('Search', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                      SizedBox(
                          height: getWH(context, 1) * 0.05,
                          child: TextField(
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.search),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                  focusedBorder:
                                      OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                              controller: search)),
                      Container(
                          alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          margin: EdgeInsets.only(bottom: 5, top: 15),
                          child: Text('User type', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                      SizedBox(
                          height: getWH(context, 1) * 0.05,
                          child: SelectFormField(
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                  focusedBorder:
                                      OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                              type: SelectFormFieldType.dropdown,
                              items: [
                                {'value': '1', 'label': tr('Individuals')},
                                {'value': '2', 'label': tr('Companies')}
                              ],
                              controller: type)),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                              onPressed: () {
                                setRefresh(() {
                                  search.clear();
                                });
                              },
                              child: Text("Clear", style: TextStyle(color: Colors.black, fontSize: 16)).tr())),
                      GestureDetector(
                          child: Container(
                              decoration: BoxDecoration(
                                  color: hexStringToColor('#6986b8'), border: Border.all(width: 0.2), borderRadius: BorderRadius.all(Radius.circular(30))),
                              width: getWH(context, 2),
                              height: getWH(context, 1) * 0.05,
                              margin: EdgeInsets.only(top: 10),
                              alignment: Alignment.center,
                              child: Text("Search", style: TextStyle(color: Colors.white, fontSize: 16)).tr()),
                          onTap: () {
                            setRefresh(() {
                              if (search.text.isNotEmpty) filters['search_key'] = search.text;
                            });
                          }),
                      if (globalType == "Company")
                        TextButton(
                            onPressed: () {
                              Get.to(() => CVFiltersPage());
                            },
                            child: Text("Advanced Search",
                                    style: TextStyle(decoration: TextDecoration.underline, color: hexStringToColor('#6986b8'), fontSize: 16))
                                .tr()),
                    ]))),
            FutureBuilder<Map>(
                future: jobSeekers(filters, 4),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!.isNotEmpty) {
                    if (type.text == '2') {
                      data = snapshot.data!['search_result']['companies'];
                    } else {
                      data = snapshot.data!['search_result']['individuals'];
                    }
                    return Column(children: [
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                          width: getWH(context, 2),
                          height: getWH(context, 1) * 0.68,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      if (type.text == '1') {
                                        Get.to(() => IndividualProfile(iid: data[index]['id'].toString()));
                                      } else if (type.text == '2') {
                                        if (globalType == 'Guest') {
                                          Get.to(() => GuestCompanyView(companyId: data[index]['id'].toString()));
                                        } else {
                                          Get.to(() => ViewCompany(companyId: data[index]['id'].toString()));
                                        }
                                      }
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.grey[50],
                                            border: Border.all(color: hexStringToColor('#eeeeee')),
                                            borderRadius: BorderRadius.all(Radius.zero)),
                                        child: Column(children: [
                                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                            Container(
                                                margin: EdgeInsets.only(right: lang == 'ar' ? 0 : 15, left: lang == 'ar' ? 15 : 0),
                                                height: 110,
                                                width: 110,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: data[index]['profile_photo_path'] != null
                                                            ? NetworkImage(data[index]['profile_photo_path'])
                                                            : AssetImage('assets/logo.png') as ImageProvider,
                                                        fit: BoxFit.contain),
                                                    color: Colors.grey[50],
                                                    border: Border.all(color: Colors.transparent),
                                                    borderRadius: BorderRadius.all(Radius.zero))),
                                            Flexible(
                                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                              Text(lang == 'ar' ? data[index]['name_ar'] : data[index]['name_en'],
                                                  style: TextStyle(fontWeight: FontWeight.bold)),
                                              SizedBox(height: 5),
                                              Text((data[index]['country_name'] ?? '') + ' - ' + (data[index]['region_name'] ?? ''),
                                                  style: TextStyle(fontSize: 13)),
                                              Divider(),
                                              Text(data[index]['email'], style: TextStyle(fontSize: 13)),
                                              SizedBox(height: 5),
                                              Row(children: [Icon(Icons.phone, size: 20), SizedBox(width: 5), Text(data[index]['phone'] ?? '')])
                                            ]))
                                          ]),
                                        ])));
                              })),
                    ]);
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Container(margin: EdgeInsets.all(35), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                  } else {
                    return Center(child: Container(margin: EdgeInsets.all(10), child: Text('No entities match your criteria').tr()));
                  }
                })
          ]);
        })));
  }
}
