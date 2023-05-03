// import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:social_share/social_share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wathefty/Pages/individual/company_page.dart';
import '../../API.dart';
import '../../functions.dart';
import '../../main.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'dart:ui' as ui;
class IndividualJobPage extends StatefulWidget {
  @override
  _IndividualJobPageState createState() => _IndividualJobPageState();
  const IndividualJobPage({Key? key, required this.jobId, required this.jobType}) : super(key: key);
  final String jobId;
  final String jobType;
}

class _IndividualJobPageState extends State<IndividualJobPage> {
  @override
  void initState() {
    super.initState();
    seen();
  }

  void dispose() {
    super.dispose();
    loading = false;
    loadingButtons = false;
    loadingReviews = false;
  }

  bool loading = false;
  var lastseen = '0';
  Future seen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var lastid = prefs.getString(widget.jobId);
    if (lastid != null && lastid.isNotEmpty) {
      DateTime last = DateTime.parse(lastid);
      DateTime now = DateTime.now();
      if (last.isAfter(DateTime(now.year, now.month, now.day, now.hour - 1, now.minute, now.second)) &&
          last.isBefore(DateTime(now.year, now.month, now.day, now.hour + 1, now.minute + 1, now.second))) {
        lastseen = '2';
      } else {
        lastseen = '0';
      }
    }
    prefs.setString(widget.jobId, DateTime.now().toString());
  }

  
  var loadingReviews = false;
  var loadingButtons = false;
  var like;
  var share = '';
  var dflt = 1; //1 = comments 2 = reviews
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          var uid = snapshot.data!['uid'];
          loading = false;
          loadingReviews = false;
          loadingButtons = false;
          
          return StatefulBuilder(builder: (BuildContext context, StateSetter setRefresh) {
            return Scaffold(
                backgroundColor: Colors.grey[50],
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
                          child: Icon(Icons.share, color: Colors.blueGrey),
                          backgroundColor: Colors.white,
                          label: tr('Share'),
                          onTap: () {
                            SocialShare.shareOptions(share);
                          }),
                      SpeedDialChild(
                          child: Icon(Icons.star, color: Colors.blueGrey),
                          backgroundColor: Colors.white,
                          label: tr('Review'),
                          onTap: () async {
                            await commentDialog(context, 'Individual', 'review', lang, uid, widget.jobId.toString(), 'Normal Job', null);
                          }),
                      SpeedDialChild(
                          child: Icon(Icons.comment, color: Colors.blueGrey),
                          backgroundColor: Colors.white,
                          label: tr('Comment'),
                          onTap: () async {
                            var tmp = await commentDialog(context, 'Individual', 'comment', lang, uid, widget.jobId, 'Normal Job', null);
                            if (tmp != null && tmp) {
                              setRefresh(() {});
                            }
                          })
                    ]),
                appBar: watheftyBar(context, "Job Information", 18),
                bottomNavigationBar: watheftyBottomBar(context),
                body: FutureBuilder<Map>(
                    future: getJob(uid, 'Individual', lang, widget.jobId, lastseen, widget.jobType),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!.isNotEmpty) {
                        String professions = '';
                        if (snapshot.data!['professions'].isNotEmpty) {
                          for (var u in snapshot.data!['professions']) {
                            professions = professions + (lang == 'ar' ? u['profession_name_ar'] : u['profession_name_en']) + ', ';
                          }
                        } else {
                          professions = ' - ';
                        }
                        share = snapshot.data!['front_url'];
                        return SingleChildScrollView(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                          StatefulBuilder(builder: (BuildContext context, StateSetter setButtons) {
                            return !loadingButtons
                                ? Container(
                                    decoration:
                                        BoxDecoration(color: Colors.green, border: Border.all(width: 0.2), borderRadius: BorderRadius.all(Radius.circular(30))),
                                    width: getWH(context, 2),
                                    height: getWH(context, 1) * 0.07,
                                    margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                                    child: TextButton(
                                        onPressed: () async {
                                          setButtons(() {
                                            loadingButtons = true;
                                          });
                                          if (snapshot.data!['apply_type'] == '1' || snapshot.data!['apply_type'] == 1) {
                                            await jobAction('Individual', 'apply', lang, uid, widget.jobId, widget.jobType);
                                          } else if (snapshot.data!['apply_type'] == '2' && snapshot.data?['contact_url'] != null) {
                                            var _url = snapshot.data!['contact_url'];
                                            await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                          }
                                          setButtons(() {
                                            loadingButtons = false;
                                          });
                                        },
                                        child: Text(snapshot.data!['apply_type'] == '1' ? 'Direct Apply' : 'Apply',
                                                style: TextStyle(fontSize: 20.0, color: Colors.white))
                                            .tr()))
                                : Center(child: Container(margin: EdgeInsets.all(30), child: LinearProgressIndicator()));
                          }),
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white, border: Border.all(color: hexStringToColor('#eeeeee')), borderRadius: BorderRadius.all(Radius.zero)),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Container(
                                  margin: EdgeInsets.only(right: lang == 'ar' ? 0 : 15, left: lang == 'ar' ? 15 : 0),
                                  height: 110,
                                  width: 110,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: (snapshot.data!['job_image'] != null
                                              ? NetworkImage(snapshot.data!['job_image'])
                                              : AssetImage('assets/logo.png') as ImageProvider),
                                          fit: BoxFit.fill),
                                      color: Colors.white,
                                      border: Border.all(color: Colors.transparent),
                                      borderRadius: BorderRadius.all(Radius.zero)),
                                ),
                                Expanded(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(lang == 'ar' ? snapshot.data!['job_title_ar'] : snapshot.data!['job_title_en'],
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 5),
                                  Text(snapshot.data!['section'] + ' - ' + snapshot.data!['speciality'], style: TextStyle(fontSize: 13)),
                                  Divider(),
                                  Row(children: [
                                    Icon(Icons.location_pin, size: 20),
                                    SizedBox(width: 5),
                                    Text(snapshot.data!['country_name'] + ' - ' + snapshot.data!['region_name'])
                                  ]),
                                  SizedBox(height: 5),
                                  Row(children: [
                                    Icon(Icons.access_time, size: 20),
                                    SizedBox(width: 5),
                                    Flexible(child: Text(snapshot.data!['submission_deadline']))
                                  ])
                                ])),
                                Container(
                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(children: [
                                      Icon(Icons.remove_red_eye),
                                      Text(snapshot.data!['view_counter'] != null ? snapshot.data!['view_counter'].toString() : '0'),
                                      SizedBox(height: 60)
                                    ]))
                              ])),
                          Container(
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white, border: Border.all(color: hexStringToColor('#eeeeee')), borderRadius: BorderRadius.all(Radius.zero)),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                Stack(alignment: Alignment.center, children: <Widget>[
                                  Container(
                                      height: 20,
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                      width: getWH(context, 2),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          child: LinearProgressIndicator(
                                            value: double.parse('0.' + snapshot.data!['suitability'].toString()),
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                                            backgroundColor: Colors.grey[200],
                                          ))),
                                  Align(
                                      child: Text(snapshot.data!['suitability'].toString() + '% ' + tr('Suitability'),
                                          style: TextStyle(fontSize: 17, color: Colors.black)))
                                ]),
                                if (snapshot.data!['suitability_details'] != null && snapshot.data!['suitability_details'].isNotEmpty)
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      RichText(
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(text: tr('Section: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                            TextSpan(
                                                text: (snapshot.data!['suitability_details']['section'].toString() + '%'),
                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                          ])),
                                      RichText(
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(text: tr('Country: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                            TextSpan(
                                                text: (snapshot.data!['suitability_details']['country'].toString() + '%'),
                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                          ])),
                                      RichText(
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(text: tr('Degree: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                            TextSpan(
                                                text: (snapshot.data!['suitability_details']['academec_degree'].toString() + '%'),
                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                          ])),
                                      RichText(
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(text: tr('Nationality: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                            TextSpan(
                                                text: (snapshot.data!['suitability_details']['nationality'].toString() + '%'),
                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                          ])),
                                    ]),
                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      RichText(
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(text: tr('Specialty: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                            TextSpan(
                                                text: (snapshot.data!['suitability_details']['specialty'].toString() + '%'),
                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                          ])),
                                      RichText(
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(text: tr('Region: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                            TextSpan(
                                                text: (snapshot.data!['suitability_details']['region'].toString() + '%'),
                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                          ])),
                                      RichText(
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(text: tr('Experience: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                            TextSpan(
                                                text: (snapshot.data!['suitability_details']['experience_years'].toString() + '%'),
                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                          ])),
                                      RichText(
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(text: tr('Gender: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                            TextSpan(
                                                text: (snapshot.data!['suitability_details']['gender'].toString() + '%'),
                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                          ])),
                                    ])
                                  ]),
                              ])),
                          Container(
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white, border: Border.all(color: hexStringToColor('#eeeeee')), borderRadius: BorderRadius.all(Radius.zero)),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[50], border: Border.all(width: 0.2), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                    height: 140,
                                    width: getWH(context, 2),
                                    padding: EdgeInsets.all(15),
                                    child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Text(lang == 'ar' ? snapshot.data!['job_description_ar'] : snapshot.data!['job_description_en'],
                                            textAlign: TextAlign.start, style: TextStyle(fontSize: 14.0, height: 1.5, color: Colors.blueGrey)))),
                                Container(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                  snapshot.data?['company_id'] != null && snapshot.data!['show_company_info'].toString() == '1'
                                      ? GestureDetector(
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                            Divider(),
                                            Text(tr('Company:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                            Text(snapshot.data!['company_name'],
                                                style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 15)),
                                          ]),
                                          onTap: () {
                                            if (snapshot.data!['show_company_info'].toString() == '1') {
                                              Get.to(() => ViewCompany(companyId: snapshot.data!['company_id'].toString()));
                                            }
                                          })
                                      : SizedBox(),
                                  Divider(),
                                  Text(tr('Section:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(snapshot.data!['section'] + ' - ' + snapshot.data!['speciality'],
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Professions:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(professions, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Gender:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(snapshot.data!['gender'] ?? '', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Nationality:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(snapshot.data!['nationality_name'] ?? '',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Minimum education level:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(snapshot.data!['academic_Degree'] ?? '',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Experience:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(snapshot.data!['experience_years'] != null ? snapshot.data!['experience_years'].toString() + ' years' : ' - ',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Social security:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(snapshot.data?['social_security_subscription'] ?? ' - ',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Health insurance:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(snapshot.data?['health_insurance'] ?? ' - ',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Work nature:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(snapshot.data?['work_nature'] ?? ' - ',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Contract duration:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(snapshot.data?['contract_duration'] ?? ' - ',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Working hours:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(snapshot.data?['type_working_hours'] ?? ' - ',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Salary range:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  snapshot.data?['salary_determination'] == '1'
                                      ? Text(snapshot.data?['salary_from'] + ' - ' + snapshot.data!['salary_to'] + snapshot.data!['currency'],
                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))
                                      : Text(' - '),
                                  Divider(),
                                  Text(tr('Deadline:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(snapshot.data?['submission_deadline'] ?? ' - ',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Contact email:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(snapshot.data?['contact_email'] ?? ' - ',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Contact phone:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(snapshot.data?['contact_phone'] ?? ' - ',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Contact link:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  snapshot.data?['contact_url'] != null
                                      ? GestureDetector(
                                          child: Text(snapshot.data?['contact_url'] ?? ' - ',
                                              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15)),
                                          onTap: () async {
                                            var _url = snapshot.data!['contact_url'];
                                            await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                          })
                                      : Text(' - '),
                                  Divider(),
                                  Text(tr('Location:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text((snapshot.data?['country_name'] ?? '') + ' - ' + (snapshot.data?['region_name'] ?? ''),
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Attachments:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  snapshot.data?['job_file'] != null
                                      ? GestureDetector(
                                          child: Text('Open attachment', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15)).tr(),
                                          onTap: () async {
                                            if (snapshot.data?['job_file'] != null) {
                                              var _url = snapshot.data?['job_file'];
                                              await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                            } else {
                                              Get.snackbar(tr("Job doesn't have any attachments"), '',
                                                  duration: Duration(seconds: 5),
                                                  backgroundColor: Colors.white,
                                                  colorText: Colors.blueGrey,
                                                  leftBarIndicatorColor: Colors.blueGrey);
                                            }
                                          })
                                      : SizedBox()
                                ]))
                              ])),
                          Container(
                              color: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              height: 50,
                              child: StatefulBuilder(builder: (BuildContext context, StateSetter setButtons) {
                                return !loadingButtons
                                    ? Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                        IconButton(
                                            onPressed: () async {
                                              setButtons(() {
                                                loadingButtons = true;
                                              });
                                              var tmp = await jobAction('Individual', 'like', lang, uid, widget.jobId, 'Normal Job');
                                              if (tmp != null && tmp['status']) {
                                                if (snapshot.data?['jobLiked'] != null) {
                                                  snapshot.data?['jobLiked'] = null;
                                                } else {
                                                  snapshot.data?['jobLiked'] = [
                                                    {'id': 1}
                                                  ];
                                                }
                                                setButtons(() {
                                                  loadingButtons = false;
                                                });
                                              }
                                            },
                                            icon: Icon(Icons.thumb_up, color: snapshot.data?['jobLiked'] != null ? Colors.blue : Colors.black)),
                                        VerticalDivider(thickness: 1),
                                        IconButton(
                                            onPressed: () async {
                                              setButtons(() {
                                                loadingButtons = true;
                                              });
                                              var tmp = await jobAction('Individual', 'favorite', lang, uid, widget.jobId, 'Normal Job');
                                              if (tmp != null && tmp['status']) {
                                                if (snapshot.data?['jobWishlist'] != null) {
                                                  snapshot.data?['jobWishlist'] = null;
                                                } else {
                                                  snapshot.data?['jobWishlist'] = [
                                                    {'id': 1}
                                                  ];
                                                }
                                                setButtons(() {
                                                  loadingButtons = false;
                                                });
                                              }
                                            },
                                            icon: Icon(Icons.favorite, color: snapshot.data?['jobWishlist'] != null ? Colors.red : Colors.black)),
                                        VerticalDivider(thickness: 1),
                                        IconButton(
                                            onPressed: () async {
                                              setButtons(() {
                                                loadingButtons = true;
                                              });
                                              var tmp = await jobAction('Individual', 'save', lang, uid, widget.jobId, 'Normal Job');
                                              if (tmp != null && tmp['status']) {
                                                if (snapshot.data?['jobSaved'] != null) {
                                                  snapshot.data?['jobSaved'] = null;
                                                } else {
                                                  snapshot.data?['jobSaved'] = [
                                                    {'id': 1}
                                                  ];
                                                }
                                                setButtons(() {
                                                  loadingButtons = false;
                                                });
                                              }
                                            },
                                            icon: Icon(Icons.bookmark, color: snapshot.data?['jobSaved'] != null ? Colors.amber : Colors.black)),
                                        VerticalDivider(thickness: 1),
                                        IconButton(
                                            onPressed: () async {
                                              await commentDialog(context, 'Individual', 'report', lang, uid, widget.jobId, 'Normal Job', null);
                                            },
                                            icon: Icon(Icons.report, color: Colors.black)),
                                      ])
                                    : Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                              })),
                          Divider(thickness: 2, indent: 15, endIndent: 15),
                          StatefulBuilder(builder: (BuildContext context, StateSetter setReviews) {
                            return Column(children: [
                              Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  height: 50,
                                  child: !loadingReviews
                                      ? Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                          Flexible(
                                              child: TextButton(
                                                  style: TextButton.styleFrom(backgroundColor: Colors.white),
                                                  onPressed: () async {
                                                    setReviews(() {
                                                      if (snapshot.data?['jobComments'] == null || snapshot.data?['jobComments'].length < 1) {
                                                        Get.snackbar(tr("No comments yet."), tr('Be the first!'),
                                                            duration: Duration(seconds: 5),
                                                            backgroundColor: Colors.white,
                                                            colorText: Colors.orange,
                                                            leftBarIndicatorColor: Colors.orange);
                                                      }
                                                      dflt = 1;
                                                    });
                                                  },
                                                  child: Text('Comments', style: TextStyle(fontSize: 15.0, color: dflt == 1 ? Colors.blue : Colors.blueGrey))
                                                      .tr())),
                                          VerticalDivider(thickness: 1),
                                          Flexible(
                                              child: TextButton(
                                                  style: TextButton.styleFrom(backgroundColor: Colors.white),
                                                  onPressed: () async {
                                                    setReviews(() {
                                                      if (snapshot.data?['jobReviews'] == null || snapshot.data?['jobReviews'].length < 1) {
                                                        Get.snackbar(tr("No reviews yet."), tr('Be the first!'),
                                                            duration: Duration(seconds: 5),
                                                            backgroundColor: Colors.white,
                                                            colorText: Colors.orange,
                                                            leftBarIndicatorColor: Colors.orange);
                                                      }
                                                      dflt = 2;
                                                    });
                                                  },
                                                  child:
                                                      Text('Reviews', style: TextStyle(fontSize: 15.0, color: dflt == 2 ? Colors.blue : Colors.blueGrey)).tr()))
                                        ])
                                      : SizedBox(height: 100)),
                              dflt == 1
                                  ? Container(
                                      child: snapshot.data?['jobComments'] != null && snapshot.data?['jobComments'].isNotEmpty
                                          ? CarouselSlider(
                                              options: CarouselOptions(autoPlay: true, viewportFraction: 1),
                                              items: snapshot.data!['jobComments'].map<Widget>((i) {
                                                DateTime dt = DateTime.parse(i['created_at']);
                                                return Card(
                                                    elevation: 4.0,
                                                    child: SingleChildScrollView(
                                                        scrollDirection: Axis.vertical,
                                                        child: Column(
                                                          children: [
                                                            ListTile(
                                                              contentPadding: EdgeInsets.all(8),
                                                              title: Text(i['user_name']),
                                                              leading: CircleAvatar(
                                                                  radius: 50,
                                                                  backgroundImage: NetworkImage(i['profile_photo'] ??
                                                                      "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png")),
                                                              subtitle: Text(DateFormat('dd/MM/yyyy - hh:mm a').format(dt) + '\n' + tr(i['user_type'])),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.all(15),
                                                              child: Text(i['comment_details'],
                                                                  style: TextStyle(
                                                                    fontSize: 17.0,
                                                                    color: Colors.blueGrey,
                                                                  )),
                                                            ),
                                                          ],
                                                        )));
                                              }).toList(),
                                            )
                                          : SizedBox())
                                  : Container(
                                      child: snapshot.data?['jobReviews'] != null && snapshot.data?['jobReviews'].isNotEmpty
                                          ? CarouselSlider(
                                              options: CarouselOptions(autoPlay: true, viewportFraction: 1),
                                              items: snapshot.data!['jobReviews'].map<Widget>((i) {
                                                DateTime dt = DateTime.parse(i['created_at']);
                                                return Card(
                                                    elevation: 4.0,
                                                    child: new SingleChildScrollView(
                                                        scrollDirection: Axis.vertical,
                                                        child: Column(
                                                          children: [
                                                            ListTile(
                                                              contentPadding: EdgeInsets.all(8),
                                                              title: Text(i['user_name']),
                                                              leading: CircleAvatar(
                                                                  radius: 50,
                                                                  backgroundImage: NetworkImage(i['profile_photo'] ??
                                                                      "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png")),
                                                              subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                Text(DateFormat('dd/MM/yyyy - hh:mm a').format(dt)),
                                                                RatingBar.builder(
                                                                  initialRating: double.parse(i['review_value']),
                                                                  minRating: 1,
                                                                  direction: Axis.horizontal,
                                                                  allowHalfRating: false,
                                                                  itemCount: 5,
                                                                  ignoreGestures: true,
                                                                  itemSize: 15,
                                                                  itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                                                  itemBuilder: (context, _) => Icon(
                                                                    Icons.star,
                                                                    color: Colors.amber,
                                                                  ),
                                                                  onRatingUpdate: (double value) {},
                                                                )
                                                              ]),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.all(15),
                                                              child: Text((i?['review_note'] ?? ''),
                                                                  style: TextStyle(
                                                                    fontSize: 17.0,
                                                                    color: Colors.blueGrey,
                                                                  )),
                                                            ),
                                                          ],
                                                        )));
                                              }).toList(),
                                            )
                                          : SizedBox(height: 100))
                            ]);
                          }),
                        ]));
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        return Scaffold(
                            backgroundColor: Colors.white,
                            body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
                      } else {
                        return Scaffold(
                            backgroundColor: Colors.white,
                            body: Center(
                                child: Container(
                                    padding: EdgeInsets.all(50),
                                    child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                      Text(
                                        "Something went wrong, go back.",
                                        textAlign: TextAlign.center,
                                      ).tr(),
                                      TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text('Retry').tr())
                                    ]))));
                      }
                    }));
          });
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
