import 'package:better_player/better_player.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../API.dart';
import '../../functions.dart';
import '../../main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoursePage extends StatefulWidget {
  @override
  _CoursePageState createState() => _CoursePageState();
  const CoursePage({Key? key, required this.courseId}) : super(key: key);
  final String courseId;
}

class _CoursePageState extends State<CoursePage> {
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
    loading = false;
  }

  var loadingButtons = false;
  bool loading = false;

  
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var uid;
          if (snapshot.data!.isNotEmpty) {
            uid = snapshot.data!['uid'];
          } else {
            uid = '0';
          }
          loading = false;
          loadingButtons = false;
          
          return StatefulBuilder(builder: (BuildContext context, StateSetter setRefresh) {
            return Scaffold(
                backgroundColor: Colors.white,
                appBar: watheftyBar(context, "Course", 20),
                bottomNavigationBar: watheftyBottomBar(context),
                body: FutureBuilder<Map>(
                    future: getCourse(uid, 'Individual', lang, widget.courseId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!['status']) {
                        return SingleChildScrollView(
                            child: Column(children: [
                          snapshot.data!['video'] != null
                              ? BetterPlayer.network(snapshot.data!['video'],
                                  betterPlayerConfiguration: BetterPlayerConfiguration(
                                      autoPlay: false, fit: BoxFit.scaleDown, controlsConfiguration: BetterPlayerControlsConfiguration(enableSkips: false)))
                              : SizedBox(),
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
                                            image: NetworkImage(snapshot.data!['image'] != null
                                                ? snapshot.data!['image']
                                                : "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png"),
                                            fit: BoxFit.fill),
                                        color: Colors.white,
                                        border: Border.all(color: Colors.transparent),
                                        borderRadius: BorderRadius.all(Radius.zero))),
                                Expanded(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(lang == 'ar' ? snapshot.data!['course_name_ar'] : snapshot.data!['course_name_en'],
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 5),
                                  Text(
                                      snapshot.data!['course_granting_entity'] != null
                                          ? (lang == 'ar'
                                                  ? snapshot.data!['course_granting_entity']['name_ar']
                                                  : snapshot.data!['course_granting_entity']['name_en']) ??
                                              ' - '
                                          : ' - ',
                                      style: TextStyle(fontSize: 13)),
                                  Divider(),
                                  Row(children: [Icon(Icons.access_time, size: 20), SizedBox(width: 5), Flexible(child: Text(snapshot.data!['course_start']))])
                                ])),
                                Container(
                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(children: [
                                      Icon(Icons.people),
                                      Text(snapshot.data!['number_participant'] != null ? snapshot.data!['number_participant'].toString() : '0'),
                                      SizedBox(height: 60)
                                    ]))
                              ])),
                          if (globalType == 'Individual')
                            Container(
                                color: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                height: getWH(context, 1) * 0.1,
                                child: StatefulBuilder(builder: (BuildContext context, StateSetter setButtons) {
                                  return !loadingButtons
                                      ? Container(
                                          decoration: BoxDecoration(
                                              color: Colors.green, border: Border.all(width: 0.2), borderRadius: BorderRadius.all(Radius.circular(30))),
                                          width: getWH(context, 2),
                                          margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                                          child: TextButton(
                                              onPressed: () async {
                                                setButtons(() {
                                                  loadingButtons = true;
                                                });
                                                if (snapshot.data!['applicant_status'] != 1) {
                                                  var tmp = await jobAction('Individual', 'subscribe', lang, uid, widget.courseId, '');
                                                  if (tmp['status']) {
                                                    snapshot.data!['applicant_status'] = 2;
                                                  }
                                                }
                                                setButtons(() {
                                                  loadingButtons = false;
                                                });
                                              },
                                              child: Text(snapshot.data!['applicant_status'] != 1 ? 'Subscribe to course' : "You're already subscribed",
                                                      style: TextStyle(fontSize: 18.0, color: Colors.white))
                                                  .tr()))
                                      : Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                                })),
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
                                        child: Text(lang == 'ar' ? snapshot.data!['course_description_ar'] : snapshot.data!['course_description_en'],
                                            textAlign: TextAlign.start, style: TextStyle(fontSize: 14.0, height: 1.5, color: Colors.blueGrey)))),
                                Container(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                  Divider(),
                                  Text(tr('Program name:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(lang == 'ar' ? snapshot.data!['program_name_ar'] : snapshot.data!['program_name_en'],
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Training entity:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(
                                      snapshot.data!['training_entity'] != null
                                          ? (lang == 'ar' ? snapshot.data!['training_entity']['name_ar'] : snapshot.data!['training_entity']['name_en']) ??
                                              ' - '
                                          : ' - ',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Course specialty:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(
                                      snapshot.data!['course_specialty'] != null
                                          ? (lang == 'ar'
                                                  ? snapshot.data!['course_specialty']['course_specialty_name_ar']
                                                  : snapshot.data!['course_specialty']['course_specialty_name_en']) ??
                                              ' - '
                                          : ' - ',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Academic degree:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(
                                      snapshot.data!['public_academic_degree'] != null
                                          ? (lang == 'ar'
                                                  ? snapshot.data!['public_academic_degree']['name_ar']
                                                  : snapshot.data!['public_academic_degree']['name_en']) ??
                                              ' - '
                                          : ' - ',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Entry cost:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(snapshot.data!['subscription_price'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Address:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(lang == 'ar' ? (snapshot.data?['course_address_ar'] ?? '') : (snapshot.data?['course_address_en'] ?? ''),
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Duration:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(snapshot.data!['course_start'] + ' - ' + snapshot.data!['course_end'],
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Schedule:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(
                                      snapshot.data!['course_hour'].toString() + ' hours, ' + snapshot.data!['course_number_day_per_week'].toString() + ' days',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Term:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(lang == 'ar' ? snapshot.data!['course_term_ar'] : snapshot.data!['course_term_en'],
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Age:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(snapshot.data!['course_age_from'].toString() + ' - ' + snapshot.data!['course_age_to'].toString(),
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Gender:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(snapshot.data!['gender'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Identification:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(lang == 'ar' ? snapshot.data!['identification_paper_ar'] : snapshot.data!['identification_paper_en'],
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Promissory:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(
                                      (snapshot.data?['course_promissory'] +
                                          (snapshot.data?['course_promissory'] == 'Yes' ? ', ' + snapshot.data!['course_promissory_val'] : '')),
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Transporation allowance:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(snapshot.data!['transportation_allowance_val'] ?? '',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Fee allowance:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(lang == 'ar' ? snapshot.data!['fee_allowance_val'] : snapshot.data!['fee_allowance_val'],
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Certificate granted:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text((lang == 'ar' ? snapshot.data!['certificate_granted_ar'] : snapshot.data!['certificate_granted_en']) ?? ' - ',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Social security:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(snapshot.data!['social_security_subscription'],
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Job opportunity:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(snapshot.data!['job_opportunity'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Number of participants:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(snapshot.data!['number_participant'].toString(),
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Start:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(snapshot.data!['course_start'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('End:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  Text(snapshot.data!['course_end'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Divider(),
                                  Text(tr('Attachments:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                  snapshot.data!['file'] != null
                                      ? GestureDetector(
                                          child: Text(snapshot.data!['file'] ?? '',
                                              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15)),
                                          onTap: () async {
                                            if (snapshot.data!['file'] != null) {
                                              var _url = snapshot.data!['file'];
                                              await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                            } else {
                                              Get.snackbar(tr("No attachments"), '',
                                                  duration: Duration(seconds: 5),
                                                  backgroundColor: Colors.white,
                                                  colorText: Colors.blueGrey,
                                                  leftBarIndicatorColor: Colors.blueGrey);
                                            }
                                          })
                                      : SizedBox()
                                ]))
                              ])),
                        ]));
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        return Scaffold(
                            backgroundColor: Colors.white,
                            body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
                      } else {
                        return SizedBox();
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
