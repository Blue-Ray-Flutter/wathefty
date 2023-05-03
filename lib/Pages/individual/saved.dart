import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:wathefty/API.dart';
import 'package:wathefty/Pages/individual/alerts.dart';
import 'package:wathefty/Pages/public/filter_page.dart';
import 'package:wathefty/main.dart';
import '../../functions.dart';

class SavedSearches extends StatefulWidget {
  @override
  _SavedSearchesState createState() => _SavedSearchesState();
}

class _SavedSearchesState extends State<SavedSearches> {
  @override
  void initState() {
    super.initState();
  }

  
  var j;
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          var uid = snapshot.data!['uid'];
          
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: watheftyBar(context, "Saved Searches", 18),
              bottomNavigationBar: watheftyBottomBar(context),
              floatingActionButton: SpeedDial(
                  animatedIcon: AnimatedIcons.menu_close,
                  animatedIconTheme: IconThemeData(size: 22.0),
                  curve: Curves.bounceIn,
                  overlayColor: Colors.black,
                  overlayOpacity: 0.5,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 8.0,
                  direction: SpeedDialDirection.up,
                  switchLabelPosition: lang == 'ar' ? true : false,
                  shape: CircleBorder(),
                  children: [
                    SpeedDialChild(
                        child: Icon(Icons.notifications),
                        backgroundColor: Colors.white,
                        label: tr('Saved Alerts'),
                        onTap: () {
                          Get.to(() => AlertsPage());
                        }),
                  ]),
              body: StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
                return FutureBuilder<Map>(
                    future: advancedSearch({'lang': lang, 'individual_id': uid}, 2),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!['saved_searches'].isNotEmpty) {
                        j = snapshot.data!['saved_searches'];
                        return Container(
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                            width: getWH(context, 2),
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: j.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                      onTap: () {
                                        Get.to(() => ResultsPage(filters: {'individual_id': uid, 'lang': lang, 'type': '3', 'saved_searche_id': j[index]['id'].toString()}, saved: 2));
                                      },
                                      child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                          padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 5),
                                          decoration: BoxDecoration(border: Border.all(width: 0.025), borderRadius: BorderRadius.circular(20), color: Colors.grey[50]),
                                          child: Column(children: [
                                            Container(
                                                margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                                                child: Text(j![index]['search_name'], style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 18))),
                                            Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                              j![index]['image'] != null && j![index]['image'].isNotEmpty ? CircleAvatar(radius: 55, backgroundImage: NetworkImage(j![index]['image'])) : SizedBox(),
                                              SizedBox(width: 15),
                                              Expanded(
                                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                RichText(
                                                    text: TextSpan(children: <TextSpan>[
                                                  TextSpan(text: tr('Gender: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                  TextSpan(text: j[index]['gender_searche'] ?? ' - ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                ])),
                                                Divider(height: 3),
                                                RichText(
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(children: <TextSpan>[
                                                      TextSpan(text: tr('Company name: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                      TextSpan(text: j[index]['company_name_searche'] ?? ' - ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                    ])),
                                                Divider(height: 3),
                                                RichText(
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(children: <TextSpan>[
                                                      TextSpan(text: tr('Suitability: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                      TextSpan(text: j[index]['suitability_from_searche'].toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                    ])),
                                                Divider(height: 3),
                                                RichText(
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(children: <TextSpan>[
                                                      TextSpan(text: tr('Section: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                      TextSpan(text: j[index]['job_section_name'] ?? ' - ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                    ])),
                                                Divider(height: 3),
                                                RichText(
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(children: <TextSpan>[
                                                      TextSpan(text: tr('Specialtiy: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                      TextSpan(text: j[index]['specialty_name'] ?? ' - ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                    ])),
                                                Divider(height: 3),
                                                RichText(
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(children: <TextSpan>[
                                                      TextSpan(text: tr('Degree: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                      TextSpan(text: j[index]['academic_degrees'] ?? ' - ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                    ])),
                                                Divider(height: 3),
                                                RichText(
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(children: <TextSpan>[
                                                      TextSpan(text: tr('Location: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                      TextSpan(
                                                          text: (j[index]['country'] ?? ' - ') + (j[index]['region'] ?? ' - '),
                                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                    ])),
                                                Divider(height: 3),
                                                RichText(
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(children: <TextSpan>[
                                                      TextSpan(text: tr('Nationality: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                      TextSpan(text: j[index]['nationality'] ?? ' - ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                    ])),
                                                // Divider(height: 3),
                                                // RichText(
                                                //     overflow: TextOverflow.ellipsis,
                                                //     text: TextSpan(children: <TextSpan>[
                                                //       TextSpan(text: tr('Date: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                //       TextSpan(
                                                //           text: DateFormat('yyyy-MM-dd').format(DateTime.parse(j[index]['created_at'])),
                                                //           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                //     ])),
                                              ]))
                                            ]),
                                            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                              Container(
                                                  alignment: lang == 'ar' ? Alignment.centerLeft : Alignment.centerRight,
                                                  child: IconButton(
                                                      icon: Icon(Icons.delete, color: Colors.red[900]),
                                                      onPressed: () async {
                                                        var remove = await advancedSearch({'lang': lang, 'individual_id': uid, 'saved_searche_id': j[index]['id'].toString()}, 3);
                                                        if (remove['status'] == true) {
                                                          _setState(() {});
                                                        }
                                                      })),
                                              Container(
                                                  alignment: lang == 'ar' ? Alignment.centerLeft : Alignment.centerRight,
                                                  child: IconButton(
                                                      icon: Icon(Icons.notification_add, color: Colors.blue[900]),
                                                      onPressed: () async {
                                                        var create = await saveNotif(context, {"saved_searche_id": j[index]['id'].toString()});
                                                        if (create != null && create['status'] == true) {
                                                          _setState(() {});
                                                        }
                                                      }))
                                            ])
                                          ])));
                                }));
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: Container(margin: EdgeInsets.all(35), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                      } else {
                        return Container(alignment: Alignment.center, margin: EdgeInsets.all(40), child: Text('No saved searches found', style: TextStyle(color: Colors.black)).tr());
                      }
                    });
              }));
        } else if (!snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            Get.offAll(() => StartPage());
          });
          return SizedBox();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(backgroundColor: Colors.white, body: Center(child: Container(margin: EdgeInsets.all(35), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
        } else {
          return Center(child: Text("No results").tr());
        }
      });
}
