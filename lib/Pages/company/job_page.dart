// import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable/expandable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:social_share/social_share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wathefty/Pages/individual/company_page.dart';
import '../../API.dart';
import '../../functions.dart';
import '../../main.dart';
import 'applicants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../public/individual_profile.dart';

// import 'dart:ui' as ui;
class CompanyJobPage extends StatefulWidget {
  @override
  _CompanyJobPageState createState() => _CompanyJobPageState();
  const CompanyJobPage({Key? key, required this.jobId, required this.jobType}) : super(key: key);
  final String jobId;
  final int jobType;
}

class _CompanyJobPageState extends State<CompanyJobPage> {
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
    loading = false;
  }

  var share = '';

  bool loading = false;

  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          loading = false;
          String uid = snapshot.data!['uid'];
          return Scaffold(
              backgroundColor: Colors.white,
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
                          if (share.isNotEmpty) {
                            SocialShare.shareOptions(share);
                          } else {
                            Get.snackbar(tr('Company does not allow sharing'), '',
                                duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.orange, leftBarIndicatorColor: Colors.orange);
                          }
                        }),
                    SpeedDialChild(
                        child: Icon(Icons.comment, color: Colors.blueGrey),
                        backgroundColor: Colors.white,
                        label: tr('Comment'),
                        onTap: () async {
                          var tmp = await commentDialog(context, 'Company', 'comment', lang, uid, widget.jobId, 'Normal Job', null);
                          if (tmp != null && tmp) {
                            setState(() {});
                          }
                        }),
                  ]),
              appBar: watheftyBar(context, "Job Information", 18),
              bottomNavigationBar: watheftyBottomBar(context),
              body: FutureBuilder<Map>(
                  future: getCompanyJobs(uid, 'Company', lang, null, widget.jobId, widget.jobType, null),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!.isNotEmpty) {
                      var company = snapshot.data!['company_id'].toString();
                      String professions = '';
                      if (snapshot.data!['professions'].isNotEmpty) {
                        for (var u in snapshot.data!['professions']) {
                          professions = professions + (lang == 'ar' ? u['profession_name_ar'] : u['profession_name_en']) + ', ';
                        }
                      } else {
                        professions = ' - ';
                      }
                      return SingleChildScrollView(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
                                        image: NetworkImage(snapshot.data!['job_image'].isNotEmpty
                                            ? snapshot.data!['job_image']
                                            : 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png'),
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
                                Text(snapshot.data!['job_section'] + ' - ' + snapshot.data!['job_specialty'], style: TextStyle(fontSize: 13)),
                                Divider(),
                                Row(children: [
                                  Icon(Icons.location_pin, size: 20),
                                  SizedBox(width: 5),
                                  Text(snapshot.data!['country'] + ' - ' + snapshot.data!['region'])
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
                                  child: Column(children: [Icon(Icons.remove_red_eye), Text(snapshot.data!['view_counter'].toString()), SizedBox(height: 60)]))
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
                                Text(snapshot.data!['job_section'] + ' - ' + snapshot.data!['job_specialty'],
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                Divider(),
                                Text(tr('Professions:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                Text(professions, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                Divider(),
                                Text(tr('Gender:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                Text(snapshot.data!['gender'] ?? '', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                Divider(),
                                Text(tr('Nationality:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                Text(snapshot.data!['nationality'] ?? '', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                Divider(),
                                Text(tr('Minimum education level:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                Text(snapshot.data!['public_academic_degree'] ?? '',
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                Divider(),
                                Text(tr('Experience:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                if (snapshot.data!['experience_years_to'] != null)
                                  Text(
                                      (snapshot.data!['experience_years_from'].toString() +
                                          " " +
                                          snapshot.data!['experience_years_to'].toString() +
                                          tr(' years')),
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                if (snapshot.data!['experience_years'] == null)
                                  Text(('-'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                Divider(),
                                Text(tr('Salary range:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                Text(
                                    snapshot.data?['salary_determination'] != null
                                        ? (snapshot.data?['salary_from'] + ' - ' + snapshot.data!['salary_to'] + " " + snapshot.data!['currency'])
                                        : ' - ',
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
                                Text(snapshot.data?['work_nature'] ?? ' - ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                Divider(),
                                Text(tr('Contract duration:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                Text(snapshot.data?['contract_duration'] ?? ' - ',
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                Divider(),
                                Text(tr('Working hours:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                Text(snapshot.data?['type_working_hours'] ?? ' - ',
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                Divider(),
                                Text(tr('Deadline:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                Text(snapshot.data?['submission_deadline'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
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
                                    : SizedBox(),
                                Divider(),
                                Text(tr('Location:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                Text((snapshot.data?['country'] ?? '') + ' - ' + (snapshot.data?['region'] ?? ''),
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
                        Divider(),
                        company == uid
                            ? Container(
                                margin: EdgeInsets.all(30),
                                child: ExpandablePanel(
                                    header: Text('Applicants', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 19)).tr(),
                                    collapsed: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Text('Tap to expand', softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis).tr(),
                                      GestureDetector(
                                          onTap: () {
                                            Get.to(() => CompanyRelevantPeople(uid: uid, id: widget.jobId, type: 'Normal Job', pType: 1));
                                          },
                                          child: Text('See All', style: TextStyle(color: Colors.blue)).tr())
                                    ]),
                                    expanded: FutureBuilder<Map>(
                                        future: getRelevantPeople(
                                            uid, 'Company', lang, widget.jobId, (widget.jobType == 1 ? 'Normal Job' : 'Special Job'), null, 1),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!.isNotEmpty) {
                                            var data = snapshot.data!['individuals'];
                                            return Container(
                                                margin: EdgeInsets.symmetric(vertical: 25),
                                                width: getWH(context, 2),
                                                height: getWH(context, 1) * 0.3,
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: data!.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return GestureDetector(
                                                          onTap: () {
                                                            Get.to(() => IndividualProfile(
                                                                iid: data[index]['id'].toString(),
                                                                jobId: widget.jobId,
                                                                jobType: widget.jobType,
                                                                companyID: company));
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
                                                                  Text(
                                                                      lang == 'ar'
                                                                          ? ((data[index]['section_name_ar'] ?? '') +
                                                                              ' - ' +
                                                                              (data[index]['specialty_name_ar'] ?? ''))
                                                                          : ((data[index]['section_name_en'] ?? '') +
                                                                              ' - ' +
                                                                              (data[index]['specialty_name_en'] ?? '')),
                                                                      style: TextStyle(fontSize: 13)),
                                                                  Divider(),
                                                                  Text(data[index]['email'], style: TextStyle(fontSize: 13)),
                                                                  SizedBox(height: 5),
                                                                  Row(children: [
                                                                    Icon(Icons.phone, size: 20),
                                                                    SizedBox(width: 5),
                                                                    Text(data[index]['phone'] ?? '')
                                                                  ])
                                                                ]))
                                                              ])));
                                                    }));
                                          } else {
                                            return Text('No applicants');
                                          }
                                        })))
                            : SizedBox(),
                        Divider(),
                        snapshot.data!['company_id'].toString() == uid
                            ? Container(
                                margin: EdgeInsets.all(30),
                                child: ExpandablePanel(
                                    header:
                                        Text('Suitable Individuals', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 19)).tr(),
                                    collapsed: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Text('Tap to expand', softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis).tr(),
                                      GestureDetector(
                                          onTap: () {
                                            Get.to(() => CompanyRelevantPeople(uid: uid, id: widget.jobId, type: 'Normal Job', pType: 2));
                                          },
                                          child: Text('See All', style: TextStyle(color: Colors.blue)).tr())
                                    ]),
                                    expanded: FutureBuilder<Map>(
                                        future: getRelevantPeople(
                                            uid, 'Company', lang, widget.jobId, (widget.jobType == 1 ? 'Normal Job' : 'Special Job'), null, 2),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.done && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                            var data = snapshot.data!['individuals'];
                                            return Container(
                                                margin: EdgeInsets.symmetric(vertical: 25),
                                                width: getWH(context, 2),
                                                height: getWH(context, 1) * 0.5,
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: data!.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return GestureDetector(
                                                          onTap: () {
                                                            Get.to(() => IndividualProfile(iid: data[index]['id'].toString()));
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
                                                                    Text(
                                                                        lang == 'ar'
                                                                            ? ((data[index]['section_name_ar'] ?? '') +
                                                                                ' - ' +
                                                                                (data[index]['specialty_name_ar'] ?? ''))
                                                                            : ((data[index]['section_name_en'] ?? '') +
                                                                                ' - ' +
                                                                                (data[index]['specialty_name_en'] ?? '')),
                                                                        style: TextStyle(fontSize: 13)),
                                                                    Divider(),
                                                                    Text(data[index]['email'], style: TextStyle(fontSize: 13)),
                                                                    SizedBox(height: 5),
                                                                    Row(children: [
                                                                      Icon(Icons.phone, size: 20),
                                                                      SizedBox(width: 5),
                                                                      Text(data[index]['phone'] ?? '')
                                                                    ])
                                                                  ]))
                                                                ]),
                                                                Stack(alignment: Alignment.center, children: <Widget>[
                                                                  Container(
                                                                      height: 20,
                                                                      width: getWH(context, 2),
                                                                      child: ClipRRect(
                                                                          borderRadius: BorderRadius.all(Radius.circular(0)),
                                                                          child: LinearProgressIndicator(
                                                                              value: double.parse(data[index]['suitability'].toString()) / 100,
                                                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen)))),
                                                                  Align(
                                                                      child: Text(tr('Suitability - ') + data[index]['suitability'].toString() + '% ',
                                                                          style: TextStyle(fontSize: 14, color: Colors.black)))
                                                                ]),
                                                              ])));
                                                    }));
                                          } else if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                                          } else {
                                            return Center(
                                                child: Container(
                                                    padding: EdgeInsets.all(50),
                                                    child: Text("No suitable individuals found.", textAlign: TextAlign.center).tr()));
                                          }
                                        })))
                            : SizedBox(),
                        SizedBox(
                            width: getWH(context, 2) * 0.6,
                            child: Row(children: [
                              const Expanded(child: Divider(thickness: 2)),
                              const Text(" Comments ", style: TextStyle(fontSize: 19.0, color: Colors.blueGrey)).tr(),
                              const Expanded(child: Divider(thickness: 2))
                            ])),
                        Container(
                            child: snapshot.data?['jobComments'] != null && snapshot.data?['jobComments'].isNotEmpty
                                ? CarouselSlider(
                                    options: CarouselOptions(autoPlay: true, viewportFraction: 1),
                                    items: snapshot.data!['jobComments'].map<Widget>((i) {
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
                                : Center(child: Text('No comments').tr())),
                        SizedBox(height: 100)
                      ]));
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Scaffold(
                          backgroundColor: Colors.white,
                          body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
                    } else {
                      return Center(
                          child: Container(
                              padding: EdgeInsets.all(50),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                Text(
                                  "Something went wrong, please check your internet and try to log in again.",
                                  textAlign: TextAlign.center,
                                ).tr(),
                                TextButton(
                                    onPressed: () async {
                                      Get.back();
                                    },
                                    child: Text('Retry').tr())
                              ])));
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
