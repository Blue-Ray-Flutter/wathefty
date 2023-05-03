import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:wathefty/Pages/company/job_page.dart';
import 'package:wathefty/main.dart';
import '../../API.dart';
import '../../data.dart';
import '../../functions.dart';
import '../public/filter_page.dart';
import '../../notifications.dart';
import '../public/selected_jobs.dart';

class CompanyHomePage extends StatefulWidget {
  @override
  _CompanyHomePageState createState() => _CompanyHomePageState();
}

class _CompanyHomePageState extends State<CompanyHomePage> {
  @override
  void initState() {
    super.initState();
    filters.clear();
    updateCheck(context);
  }

  final country = TextEditingController(text: '111');
  final search = TextEditingController();
  final sort = TextEditingController();

  Map filters = {};
  Map j = {};
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
         
          return Scaffold(
              floatingActionButton: SpeedDial(
                  animatedIcon: AnimatedIcons.menu_close,
                  animatedIconTheme: IconThemeData(size: 22.0),
                  curve: Curves.bounceIn,
                  overlayColor: Colors.black,
                  overlayOpacity: 0.5,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  buttonSize: const Size(50.0, 50.0),
                  label: Text('Selected Jobs', style: TextStyle(fontSize: 12)).tr(),
                  elevation: 8.0,
                  switchLabelPosition: lang == 'ar' ? true : false,
                  direction: SpeedDialDirection.up,
                  shape: CircleBorder(),
                  children: [
                    SpeedDialChild(
                        child: Icon(Icons.today_outlined),
                        backgroundColor: Colors.white,
                        label: tr("Today's Jobs"),
                        onTap: () {
                          Get.to(() => SelectedJobsPage(label: "Today's Jobs", type: '1'));
                        }),
                    SpeedDialChild(
                        child: Icon(Icons.language),
                        backgroundColor: Colors.white,
                        label: tr('Multinational Company Jobs'),
                        onTap: () {
                          Get.to(() => SelectedJobsPage(label: "Multinational Company Jobs", type: '2'));
                        }),
                    SpeedDialChild(
                        child: Icon(Icons.landscape),
                        backgroundColor: Colors.white,
                        label: tr('Gulf Jobs'),
                        onTap: () {
                          Get.to(() => SelectedJobsPage(label: "Gulf Jobs", type: '3'));
                        }),
                    SpeedDialChild(
                        child: Icon(Icons.military_tech),
                        backgroundColor: Colors.white,
                        label: tr('Military recruitment'),
                        onTap: () {
                          Get.to(() => SelectedJobsPage(label: "Military recruitment", type: '4'));
                        }),
                    SpeedDialChild(
                        child: Icon(Icons.location_city),
                        backgroundColor: Colors.white,
                        label: tr('Civil Service Bureau Jobs'),
                        onTap: () {
                          Get.to(() => SelectedJobsPage(label: "Civil Service Bureau Jobs", type: '5'));
                        })
                  ]),
              backgroundColor: Colors.white,
              appBar: AppBar(
                  centerTitle: true,
                  leading: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: FutureBuilder<Map>(
                          future: getNotifications(lang, globalType, '1'),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
                              return Stack(children: <Widget>[
                                IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(Icons.notifications, color: Colors.white),
                                    onPressed: () {
                                      Get.to(() => NotificationPage(uType: globalType));
                                    }),
                                Positioned(
                                    top: 0.0,
                                    right: 0.0,
                                    child:
                                        Text(snapshot.data!['msg'].toString(), style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold)))
                              ]);
                            } else if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator(color: Colors.white));
                            } else {
                              return IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(Icons.notifications, color: Colors.white),
                                  onPressed: () {
                                    Get.to(() => NotificationPage(uType: globalType));
                                  });
                            }
                          })),
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
                  title: Text('Jobs', style: TextStyle(fontSize: 20, color: Colors.white)).tr()),
              bottomNavigationBar: watheftyBottomBar(context),
              body: SingleChildScrollView(child: StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
                return Column(children: [
                  Container(
                      color: Colors.grey[50],
                      padding: EdgeInsets.only(top: 20, bottom: 10, right: 40, left: 40),
                      child: ExpandablePanel(
                          header: Text('    Filters', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 19)).tr(),
                          collapsed: Text('    Tap to expand', softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis).tr(),
                          expanded: Container(
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
                                            enabledBorder:
                                                OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                        controller: search)),
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
                                        controller: country)),
                                Container(
                                    alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 15),
                                    child: Text('Sort', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
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
                                      items: arrtoList(sortArr, lang, ''),
                                      controller: sort,
                                    )),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton(
                                        onPressed: () {
                                          _setState(() {
                                            search.clear();
                                            sort.clear();
                                            country.text = '111';
                                            filters.clear();
                                          });
                                        },
                                        child: Text("Clear", style: TextStyle(color: Colors.black, fontSize: 16)).tr())),
                                Container(
                                    decoration: BoxDecoration(
                                        color: hexStringToColor('#6986b8'),
                                        border: Border.all(width: 0.2),
                                        borderRadius: BorderRadius.all(Radius.circular(30))),
                                    width: getWH(context, 2),
                                    height: getWH(context, 1) * 0.05,
                                    margin: EdgeInsets.only(top: 10),
                                    alignment: Alignment.center,
                                    child: TextButton(
                                        onPressed: () {
                                          _setState(() {
                                            filters['search_key'] = search.text;
                                            filters['country_id'] = country.text;
                                            filters['sort'] = sort.text;
                                          });
                                        },
                                        child: Text("Search", style: TextStyle(color: Colors.white, fontSize: 16)).tr())),
                                TextButton(
                                    onPressed: () {
                                      Get.to(() => FilterPage());
                                    },
                                    child: Text("Advanced Search",
                                            style: TextStyle(decoration: TextDecoration.underline, color: hexStringToColor('#6986b8'), fontSize: 16))
                                        .tr()),
                              ])))),
                  FutureBuilder<Map>(
                      future: getAllJobs(lang, filters),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && (snapshot.data![0] != null || snapshot.data!['status'])) {
                          j = snapshot.data!;
                          return Column(children: [
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                                width: getWH(context, 2),
                                height: getWH(context, 1) * 0.68,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: j.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return GestureDetector(
                                          onTap: () async {
                                            Get.to(() => CompanyJobPage(jobId: j[index]['id'].toString(), jobType: 1));
                                          },
                                          child: Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.symmetric(vertical: 10),
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[50],
                                                  border: Border.all(color: hexStringToColor('#eeeeee')),
                                                  borderRadius: BorderRadius.all(Radius.zero)),
                                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                Container(
                                                  margin: EdgeInsets.only(right: lang == 'ar' ? 0 : 15, left: lang == 'ar' ? 15 : 0),
                                                  height: 110,
                                                  width: 110,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: j[index]['job_image'] != null
                                                              ? NetworkImage(j[index]['job_image'])
                                                              : AssetImage('assets/logo.png') as ImageProvider,
                                                          fit: BoxFit.fill),
                                                      color: Colors.grey[50],
                                                      border: Border.all(color: Colors.transparent),
                                                      borderRadius: BorderRadius.all(Radius.zero)),
                                                ),
                                                Flexible(
                                                    child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(j[index]['job_title'], style: TextStyle(fontWeight: FontWeight.bold)),
                                                    SizedBox(height: 5),
                                                    Text((j[index]['section'] ?? "") + ' - ' + (j[index]['speciality'] ?? ""), style: TextStyle(fontSize: 13)),
                                                    Divider(),
                                                    Row(children: [Icon(Icons.location_pin, size: 20), SizedBox(width: 5), Text(j[index]['location'])]),
                                                    SizedBox(height: 5),
                                                    Row(children: [
                                                      Icon(Icons.access_time, size: 20),
                                                      SizedBox(width: 5),
                                                      Text(j[index]['submission_deadline'])
                                                    ])
                                                  ],
                                                )),
                                                Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                                    child: Column(
                                                        children: [
                                                      Icon(Icons.remove_red_eye),
                                                      Text(j[index]['view_counter'] != null ? j[index]['view_counter'].toString() : '0'),
                                                      SizedBox(height: 60)
                                                    ]))
                                              ])));
                                    })),
                          ]);
                        } else if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                              child: Container(margin: EdgeInsets.all(35), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                        } else {
                          return Center(child: Container(margin: EdgeInsets.all(10), child: Text('No jobs match your criteria').tr()));
                        }
                      })
                ]);
              })));
        } else if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isEmpty) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            Get.offAll(() => StartPage());
          });
          return SizedBox();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              backgroundColor: Colors.white, body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
        } else {
          return SizedBox();
        }
      });
}
