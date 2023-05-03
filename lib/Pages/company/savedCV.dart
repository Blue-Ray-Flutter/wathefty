import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:wathefty/API.dart';
import 'package:wathefty/Pages/company/cv_search.dart';
import 'package:wathefty/Pages/public/individual_profile.dart';
import 'package:wathefty/main.dart';
import '../../functions.dart';

class SavedCVSearches extends StatefulWidget {
  @override
  _SavedCVSearchesState createState() => _SavedCVSearchesState();
}

class _SavedCVSearchesState extends State<SavedCVSearches> {
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
                  icon: Icons.favorite,
                  buttonSize: const Size(50.0, 50.0),
                  label: Text("Liked CVs").tr(),
                  animatedIconTheme: IconThemeData(size: 22.0),
                  curve: Curves.bounceIn,
                  overlayColor: Colors.black,
                  overlayOpacity: 0.5,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  elevation: 8.0,
                  direction: SpeedDialDirection.up,
                  switchLabelPosition: lang == 'ar' ? true : false,
                  shape: CircleBorder(),
                  onPress: () {
                    Get.to(() => LikedCVs());
                  }),
              body: StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
                return FutureBuilder<Map>(
                    future: advancedCVSearch({'lang': lang, 'company_id': globalUid}, 2),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!['saved_search_cvs'].isNotEmpty) {
                        j = snapshot.data!['saved_search_cvs'];
                        return Container(
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                            width: getWH(context, 2),
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: j.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                      onTap: () {
                                        Get.to(() => CVResultsPage(
                                            filters: {'company_id': globalUid, 'lang': lang, 'type': globalType, 'saved_searche_id': j[index]['id'].toString()},
                                            saved: 2));
                                      },
                                      child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                          padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 5),
                                          decoration:
                                              BoxDecoration(border: Border.all(width: 0.025), borderRadius: BorderRadius.circular(20), color: Colors.grey[50]),
                                          child: Column(children: [
                                            Container(
                                                margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                                                child: Text(j![index]['search_name'],
                                                    style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 18))),
                                            Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                              // j![index]['image'] != null && j![index]['image'].isNotEmpty
                                              //     ? CircleAvatar(radius: 55, backgroundImage: NetworkImage(j![index]['image']))
                                              //     : SizedBox(),
                                              SizedBox(width: 15),
                                              Expanded(
                                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                RichText(
                                                    text: TextSpan(children: <TextSpan>[
                                                  TextSpan(text: tr('Gender: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                  TextSpan(
                                                      text: j[index]['gender_searche'] ?? ' - ',
                                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                ])),
                                                Divider(height: 3),
                                                RichText(
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(children: <TextSpan>[
                                                      TextSpan(text: tr('Company name: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                      TextSpan(
                                                          text: j[index]['company_name_searche'] ?? ' - ',
                                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                    ])),
                                                Divider(height: 3),
                                                RichText(
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(children: <TextSpan>[
                                                      TextSpan(text: tr('Social status: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                      TextSpan(
                                                          text: j[index]['social_status'],
                                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                    ])),
                                                Divider(height: 3),
                                                RichText(
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(children: <TextSpan>[
                                                      TextSpan(text: tr('Section: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                      TextSpan(
                                                          text: j[index]['job_section_name'] ?? ' - ',
                                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                    ])),
                                                Divider(height: 3),
                                                RichText(
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(children: <TextSpan>[
                                                      TextSpan(text: tr('Specialtiy: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                      TextSpan(
                                                          text: j[index]['specialty_name'] ?? ' - ',
                                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                    ])),
                                                Divider(height: 3),
                                                RichText(
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(children: <TextSpan>[
                                                      TextSpan(text: tr('Degree: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                      TextSpan(
                                                          text: j[index]['academic_degrees'] ?? ' - ',
                                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
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
                                                      TextSpan(text: tr('Experience: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                      j[index]['experience_years_from_searche'] != null
                                                          ? TextSpan(
                                                              text: (j[index]['experience_years_from_searche'].toString()) +
                                                                  ' - ' +
                                                                  (j[index]['experience_years_to_searche'].toString()),
                                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                          : TextSpan(
                                                              text: " - ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                    ])),
                                              ]))
                                            ]),
                                            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                              Container(
                                                  alignment: lang == 'ar' ? Alignment.centerLeft : Alignment.centerRight,
                                                  child: IconButton(
                                                      icon: Icon(Icons.delete, color: Colors.red[900]),
                                                      onPressed: () async {
                                                        var remove =
                                                            await advancedCVSearch({'lang': lang, 'company_id': uid, 'id': j[index]['id'].toString()}, 3);
                                                        if (remove['status'] == true) {
                                                            Get.snackbar(remove["msg"], '',
                                                              duration: Duration(seconds: 5),
                                                              backgroundColor: Colors.white,
                                                              colorText: Colors.blue,
                                                              leftBarIndicatorColor: Colors.blue);
                                                          _setState(() {});
                                                        }
                                                      }))
                                            ])
                                          ])));
                                }));
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: Container(margin: EdgeInsets.all(35), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                      } else {
                        return Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.all(40),
                            child: Text('No saved searches found', style: TextStyle(color: Colors.black)).tr());
                      }
                    });
              }));
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
          return Center(child: Text("No results").tr());
        }
      });
}

class LikedCVs extends StatefulWidget {
  @override
  _LikedCVsState createState() => _LikedCVsState();
}

class _LikedCVsState extends State<LikedCVs> {
  @override
  void initState() {
    super.initState();
  }

  var j;
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: watheftyBar(context, "Saved CVs", 17),
        bottomNavigationBar: watheftyBottomBar(context),
        body: StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
          return FutureBuilder<Map>(
              future: advancedCVSearch({"lang": lang, "company_id": globalUid}, 4),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty && snapshot.data!['individuals_data'].isNotEmpty) {
                  j = snapshot.data!['individuals_data'];
                  return Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                      width: getWH(context, 2),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: j.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                                onTap: () {
                                  Get.to(() => IndividualProfile(iid: j[index]["id"].toString()));
                                },
                                child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                    padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 5),
                                    decoration:
                                        BoxDecoration(border: Border.all(width: 0.025), borderRadius: BorderRadius.circular(20), color: Colors.grey[50]),
                                    child: Column(children: [
                                      Container(
                                          margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                                          child: Text(lang == "ar" ? j![index]['name_ar'] : j![index]['name_en'],
                                              style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 18))),
                                      Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        j![index]['profile_photo_path'] != null && j![index]['profile_photo_path'].isNotEmpty
                                            ? CircleAvatar(radius: 55, backgroundImage: NetworkImage(j![index]['profile_photo_path']))
                                            : SizedBox(),
                                        SizedBox(width: 15),
                                        Expanded(
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          RichText(
                                              text: TextSpan(children: <TextSpan>[
                                            TextSpan(text: tr('email: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                            TextSpan(
                                                text: j[index]['email'] ?? ' - ',
                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                          ])),
                                          Divider(height: 3),
                                          RichText(
                                              overflow: TextOverflow.ellipsis,
                                              text: TextSpan(children: <TextSpan>[
                                                TextSpan(text: tr('phone: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                TextSpan(
                                                    text: j[index]['phone'] ?? ' - ',
                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                              ])),
                                          Divider(height: 3),
                                          RichText(
                                              overflow: TextOverflow.ellipsis,
                                              text: TextSpan(children: <TextSpan>[
                                                TextSpan(text: tr('Section: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                TextSpan(
                                                    text: lang == "ar" ? (j[index]['section_name_ar'] ?? ' - ') : ((j[index]['section_name_en'] ?? ' - ')),
                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                              ])),
                                          Divider(height: 3),
                                          RichText(
                                              overflow: TextOverflow.ellipsis,
                                              text: TextSpan(children: <TextSpan>[
                                                TextSpan(text: tr('Specialtiy: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                TextSpan(
                                                    text: lang == "ar" ? (j[index]['specialty_name_ar'] ?? ' - ') : ((j[index]['specialty_name_en'] ?? ' - ')),
                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                              ])),
                                          Divider(height: 3),
                                          RichText(
                                              overflow: TextOverflow.ellipsis,
                                              text: TextSpan(children: <TextSpan>[
                                                TextSpan(text: tr('Location: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                TextSpan(
                                                    text: lang == "ar"
                                                        ? (j[index]['country_ar'] ?? ' - ') + " - " + (j[index]['region_ar'] ?? ' - ')
                                                        : (j[index]['country_en'] ?? ' - ') + " - " + (j[index]['region_en'] ?? ' - '),
                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                              ])),
                                          Divider(height: 3),
                                          RichText(
                                              overflow: TextOverflow.ellipsis,
                                              text: TextSpan(children: <TextSpan>[
                                                TextSpan(text: tr('Experience: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                j[index]['total_experience'] != null
                                                    ? TextSpan(
                                                        text: j[index]['total_experience'].toString(),
                                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                    : TextSpan(text: " - ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                              ])),
                                        ]))
                                      ]),
                                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                        IconButton(
                                            onPressed: () async {
                                              Map like = await likeCV(j[index]["id"].toString());
                                              _setState(() {
                                                if (like.isNotEmpty && like["status"]) {
                                                  j[index]["cvLiked"] == "no" ? j[index]["cvLiked"] = "yes" : j[index]["cvLiked"] = "no";
                                                }
                                              });
                                            },
                                            icon: Icon(j[index]["cvLiked"] == "no" ? Icons.favorite_border : Icons.favorite),
                                            color: Colors.red)
                                      ])
                                    ])));
                          }));
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Container(margin: EdgeInsets.all(35), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                } else {
                  return Container(
                      alignment: Alignment.center, margin: EdgeInsets.all(40), child: Text('No results', style: TextStyle(color: Colors.black)).tr());
                }
              });
        }));
  }
}
