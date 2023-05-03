// import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../../../API.dart';
import '../../../../functions.dart';
import 'company.dart';

class GuestJobPage extends StatefulWidget {
  @override
  _GuestJobPageState createState() => _GuestJobPageState();
  const GuestJobPage({Key? key, required this.jobId}) : super(key: key);
  final String jobId;
}

class _GuestJobPageState extends State<GuestJobPage> {
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
    loading = false;
    loadingButtons = false;
    loadingReviews = false;
  }

  bool loading = false;

  var loadingReviews = false;
  var loadingButtons = false;
  
  var dflt = 1;
  Widget build(BuildContext context) {
    loading = false;
    loadingReviews = false;
    loadingButtons = false;
    
    return StatefulBuilder(builder: (BuildContext context, StateSetter setRefresh) {
      return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
              leading: IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back), color: Colors.white),
              centerTitle: true,
              actions: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: IconButton(
                      icon: Icon(
                        Icons.language,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        selectLanguage(context);
                      },
                    )),
              ],
              backgroundColor: hexStringToColor('#6986b8'),
              elevation: 0,
              title: Text('Job Information', style: TextStyle(fontSize: 18, color: Colors.white)).tr()),
          body: FutureBuilder<Map>(
              future: getCompanyJobs('0', 'Guest', lang, null, widget.jobId, 1, null),
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
                              child: TextButton(onPressed: () {}, child: Text('Sign up to apply!', style: TextStyle(fontSize: 20.0, color: Colors.white)).tr()))
                          : Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
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
                                    image: (snapshot.data!['job_image'] != null && snapshot.data!['job_image'].isNotEmpty
                                        ? NetworkImage(snapshot.data!['job_image'])
                                        : AssetImage('assets/logo.png') as ImageProvider),
                                    fit: BoxFit.fill),
                                color: Colors.white,
                                border: Border.all(color: Colors.transparent),
                                borderRadius: BorderRadius.all(Radius.zero)),
                          ),
                          Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(lang == 'ar' ? snapshot.data!['job_title_ar'] : snapshot.data!['job_title_en'], style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            Text(snapshot.data!['job_section'] + ' - ' + snapshot.data!['job_specialty'], style: TextStyle(fontSize: 13)),
                            Divider(),
                            Row(children: [
                              Icon(Icons.location_pin, size: 20),
                              SizedBox(width: 5),
                              Text(snapshot.data!['country'] + ' - ' + snapshot.data!['region'])
                            ]),
                            SizedBox(height: 5),
                            Row(children: [Icon(Icons.access_time, size: 20), SizedBox(width: 5), Flexible(child: Text(snapshot.data!['submission_deadline']))])
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
                          Container(
                              decoration:
                                  BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.2), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              height: 140,
                              width: getWH(context, 2),
                              padding: EdgeInsets.all(15),
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text(lang == 'ar' ? snapshot.data!['job_description_ar'] : snapshot.data!['job_description_en'],
                                      textAlign: TextAlign.start, style: TextStyle(fontSize: 14.0, height: 1.5, color: Colors.blueGrey)))),
                          Container(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                            snapshot.data?['company_id'] != null
                                ? GestureDetector(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                      Divider(),
                                      Text(tr('Company:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                      Text(snapshot.data!['company_name'],
                                          style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 15)),
                                    ]),
                                    onTap: () {
                                  Get.to(() => GuestCompanyView(companyId: snapshot.data!['company_id'].toString()));
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
                            Text((snapshot.data!['experience_years'].toString() + tr(' years')),
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                            Divider(),
                            Text(tr('Social security:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                            Text(snapshot.data?['social_security_subscription'] ?? ' - ',
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                            Divider(),
                            Text(tr('Health insurance:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                            Text(snapshot.data?['health_insurance'] ?? ' - ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
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
                            Text(snapshot.data?['contact_email'] ?? ' - ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                            Divider(),
                            Text(tr('Contact phone:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                            Text(snapshot.data?['contact_phone'] ?? ' - ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                            Divider(),
                            Text(tr('Contact link:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                            snapshot.data?['contact_url'] != null
                                ? GestureDetector(
                                    child: Text(snapshot.data?['contact_url'] ?? '',
                                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15)),
                                    onTap: () {
                                      Get.snackbar(tr("Sign up to access files!"), '',
                                          duration: Duration(seconds: 5),
                                          backgroundColor: Colors.white,
                                          colorText: Colors.blueGrey,
                                          leftBarIndicatorColor: Colors.blueGrey);
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
                                    child: Text(snapshot.data?['Open link'] ?? '',
                                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15)),
                                    onTap: () {
                                      Get.snackbar(tr("Sign up to access files!"), '',
                                          duration: Duration(seconds: 5),
                                          backgroundColor: Colors.white,
                                          colorText: Colors.blueGrey,
                                          leftBarIndicatorColor: Colors.blueGrey);
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
                                      onPressed: () {
                                        Get.snackbar(tr("Sign up to access jobs!"), '',
                                            duration: Duration(seconds: 5),
                                            backgroundColor: Colors.white,
                                            colorText: Colors.blueGrey,
                                            leftBarIndicatorColor: Colors.blueGrey);
                                      },
                                      icon: Icon(Icons.thumb_up, color: Colors.blue)),
                                  VerticalDivider(thickness: 1),
                                  IconButton(
                                      onPressed: () {
                                        Get.snackbar(tr("Sign up to access jobs!"), '',
                                            duration: Duration(seconds: 5),
                                            backgroundColor: Colors.white,
                                            colorText: Colors.blueGrey,
                                            leftBarIndicatorColor: Colors.blueGrey);
                                      },
                                      icon: Icon(Icons.favorite, color: Colors.red)),
                                  VerticalDivider(thickness: 1),
                                  IconButton(
                                      onPressed: () {
                                        Get.snackbar(tr("Sign up to access jobs!"), '',
                                            duration: Duration(seconds: 5),
                                            backgroundColor: Colors.white,
                                            colorText: Colors.blueGrey,
                                            leftBarIndicatorColor: Colors.blueGrey);
                                      },
                                      icon: Icon(Icons.bookmark, color: Colors.amber)),
                                  VerticalDivider(thickness: 1),
                                  IconButton(
                                      onPressed: () {
                                        Get.snackbar(tr("Sign up to access jobs!"), '',
                                            duration: Duration(seconds: 5),
                                            backgroundColor: Colors.white,
                                            colorText: Colors.blueGrey,
                                            leftBarIndicatorColor: Colors.blueGrey);
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
                                                  Get.snackbar(tr("No comments yet."), tr('Sign up to comment!'),
                                                      duration: Duration(seconds: 5),
                                                      backgroundColor: Colors.white,
                                                      colorText: Colors.orange,
                                                      leftBarIndicatorColor: Colors.orange);
                                                }
                                                dflt = 1;
                                              });
                                            },
                                            child: Text('Comments', style: TextStyle(fontSize: 15.0, color: dflt == 1 ? Colors.blue : Colors.blueGrey)).tr())),
                                    VerticalDivider(thickness: 1),
                                    Flexible(
                                        child: TextButton(
                                            style: TextButton.styleFrom(backgroundColor: Colors.white),
                                            onPressed: () async {
                                              setReviews(() {
                                                if (snapshot.data?['jobReviews'] == null || snapshot.data?['jobReviews'].length < 1) {
                                                  Get.snackbar(tr("No reviews yet."), tr('Sign up to review!'),
                                                      duration: Duration(seconds: 5),
                                                      backgroundColor: Colors.white,
                                                      colorText: Colors.orange,
                                                      leftBarIndicatorColor: Colors.orange);
                                                }
                                                dflt = 2;
                                              });
                                            },
                                            child: Text('Reviews', style: TextStyle(fontSize: 15.0, color: dflt == 2 ? Colors.blue : Colors.blueGrey)).tr()))
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
                  return Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                } else {
                  return Center(child: Text("No results").tr());
                }
              }));
    });
  }
}
