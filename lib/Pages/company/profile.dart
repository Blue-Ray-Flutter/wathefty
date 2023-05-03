import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wathefty/Pages/company/event_create.dart';
import 'package:wathefty/Pages/company/event_list.dart';
import 'package:wathefty/Pages/company/job_create.dart';
import '../../API.dart';
import '../../functions.dart';
import '../../main.dart';
import 'job_list.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../notifications.dart';

class CompanyProfilePage extends StatefulWidget {
  @override
  _CompanyProfilePageState createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends State<CompanyProfilePage> {
  @override
  void initState() {
    super.initState();
    updateCheck(context);
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
    setState(() {});
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  Map<String, dynamic>? profileData;
  
  Widget build(BuildContext context) => FutureBuilder(
      future: getProfile('Company'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          profileData = snapshot.data as Map<String, dynamic>?;
          if (profileData!['status'] == true) {
            profileData = profileData!['user'];

            
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
                        child: Icon(Icons.event),
                        backgroundColor: Colors.white,
                        label: tr('Add event'),
                        onTap: () {
                          Get.to(() => CompanyCreateEventPage(eventEdit: false, eventId: ''));
                        }),
                    SpeedDialChild(
                        child: Icon(Icons.all_inbox),
                        backgroundColor: Colors.white,
                        label: tr('Events'),
                        onTap: () {
                          Get.to(() => CompanyEventListPage());
                        }),
                    SpeedDialChild(
                        child: Icon(Icons.work),
                        backgroundColor: Colors.white,
                        label: tr('Add job'),
                        onTap: () {
                          Get.to(() => CompanyCreateJobPage(jobEdit: false, jobId: ''));
                        }),
                    SpeedDialChild(
                        child: Icon(Icons.folder_special),
                        backgroundColor: Colors.white,
                        label: tr('Private jobs'),
                        onTap: () {
                          Get.to(() => CompanyJobListPage(jobType: 2));
                        }),
                    SpeedDialChild(
                        child: Icon(Icons.all_inbox),
                        backgroundColor: Colors.white,
                        label: tr('Jobs'),
                        onTap: () {
                          Get.to(() => CompanyJobListPage(jobType: 1));
                        }),
                  ],
                ),
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
                                      child: Text(snapshot.data!['msg'].toString(),
                                          style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold)))
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
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: IconButton(
                              icon: Icon(
                                Icons.language,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                selectLanguage(context);
                              }))
                    ],
                    backgroundColor: hexStringToColor('#6986b8'),
                    elevation: 0,
                    title: Text('Profile', style: TextStyle(color: Colors.white)).tr()),
                bottomNavigationBar: watheftyBottomBar(context),
                body: SmartRefresher(
                    enablePullDown: true,
                    header: WaterDropHeader(),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: SingleChildScrollView(child: StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
                      return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: [
                        SizedBox(height: 15),
                        Stack(children: [
                          Center(
                              child: Column(children: [
                            CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(profileData?['profile_photo_path'] ??
                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png')),
                            Container(
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                decoration: BoxDecoration(color: Colors.white),
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Text(profileData!['email'], style: Theme.of(context).textTheme.bodyText1),
                                  Text(lang == 'ar' ? profileData!['name_ar'] : profileData!['name_en'],
                                      style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 22))
                                ]))
                          ])),
                          Align(
                              alignment: lang == 'ar' ? Alignment.centerLeft : Alignment.centerRight,
                              child: IconButton(
                                  icon: Icon(Icons.edit, color: Colors.black),
                                  onPressed: () {
                                    editSelection(context, null);
                                  }))
                        ]),
                        Stack(alignment: Alignment.center, children: <Widget>[
                          Container(
                              height: 20,
                              width: 220,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  child: LinearProgressIndicator(
                                      value: double.parse(profileData!['complete_profile_percentage'].toString()) / 100,
                                      valueColor: AlwaysStoppedAnimation<Color>(hexStringToColor('#6986b8'))))),
                          Align(
                              child: Text('Profile completion - ' + profileData!['complete_profile_percentage'].toString() + '% ',
                                  style: TextStyle(fontSize: 14, color: Colors.black)))
                        ]),
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(color: Colors.white),
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text('Information', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 20)).tr(),
                              SizedBox(height: 15),
                              Divider(),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                  width: getWH(context, 2),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                    Container(child: Text(tr('Brief:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15))),
                                    Container(
                                        width: getWH(context, 2),
                                        height: getWH(context, 1) * 0.2,
                                        margin: EdgeInsets.symmetric(vertical: 15),
                                        decoration:
                                            BoxDecoration(border: Border.all(width: 0.025), borderRadius: BorderRadius.circular(20), color: Colors.grey[50]),
                                        padding: EdgeInsets.all(20),
                                        child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Text(
                                                lang == 'ar' ? (profileData!['company_overview_ar'] ?? '') : (profileData!['company_overview_en'] ?? ''),
                                                style: TextStyle(color: Colors.black, fontSize: 18)))),
                                    Divider(),
                                    Text(tr('Ad balance:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(profileData!['advertising_balance'] != null ? profileData!['advertising_balance'].toString() : '0',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Location:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(profileData!['country'] + ' - ' + profileData!['region'],
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Phone:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    GestureDetector(
                                        onTap: () async {
                                          if (profileData?['phone'] != null) {
                                            var phone = 'tel:' + profileData!['phone'];
                                            await canLaunch(phone) ? await launch(phone) : throw 'Could not launch $phone';
                                          }
                                        },
                                        child: Text(profileData?['phone'] ?? ' - ',
                                            style: TextStyle(color: hexStringToColor('#6986b8'), fontWeight: FontWeight.bold, fontSize: 15))),
                                    Divider(),
                                    Text(tr('Address:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(lang == 'ar' ? (profileData!['address_ar'] ?? ' - ') : (profileData!['address_en'] ?? ' - '),
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Section:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(profileData!['section'] ?? ' - ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Specialty:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(profileData!['specialty'] ?? ' - ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Company size:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(profileData!['company_size'] ?? ' - ',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Company legal type:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(profileData!['company_legal_capacity'] ?? ' - ',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Company category:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(profileData!['company_category'] ?? ' - ',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Fax:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(profileData!['company_fax'] ?? ' - ',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Landline:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(profileData!['landline_phone'] ?? ' - ',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Extra phone:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(profileData!['company_phone_extra'] ?? ' - ',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('General manager:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(lang == 'ar' ? (profileData!['general_manager_name_ar'] ?? ' - ') : (profileData!['general_manager_name_en'] ?? ' - '),
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('General manager phone:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(profileData!['general_manager_phone'] ?? ' - ',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Officer name:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(lang == 'ar' ? (profileData!['officer_link_name_ar'] ?? ' - ') : (profileData!['officer_link_name_en'] ?? ' - '),
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Officer phone:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(profileData!['officer_link_phone'] ?? ' - ',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Website:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    GestureDetector(
                                        child: Text(profileData?['company_website_url'] ?? ' - ',
                                            style: TextStyle(color: hexStringToColor('#6986b8'), fontWeight: FontWeight.bold, fontSize: 15)),
                                        onTap: () async {
                                          if (profileData?['company_website_url'] != null) {
                                            var _url = profileData!['company_website_url'];
                                            await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                          }
                                        }),
                                    Divider(),
                                    Text(tr('Facebook:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    GestureDetector(
                                        child: Text(profileData?['company_facebook_url'] ?? ' - ',
                                            style: TextStyle(color: hexStringToColor('#6986b8'), fontWeight: FontWeight.bold, fontSize: 15)),
                                        onTap: () async {
                                          if (profileData?['company_facebook_url'] != null) {
                                            var _url = profileData!['company_facebook_url'];
                                            await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                          }
                                        }),
                                    Divider(),
                                    Text(tr('LinkedIn:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                       GestureDetector(
                                        child: Text(profileData?['company_linkedin_url'] ?? ' - ',
                                            style: TextStyle(color: hexStringToColor('#6986b8'), fontWeight: FontWeight.bold, fontSize: 15)),
                                        onTap: () async {
                                          if (profileData?['company_linkedin_url'] != null) {
                                            var _url = profileData!['company_linkedin_url'];
                                            await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                          }
                                        }),
                                    Divider(),
                                    Text(tr('Instagram:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                      GestureDetector(
                                        child: Text(profileData?['company_instagram_url'] ?? ' - ',
                                            style: TextStyle(color: hexStringToColor('#6986b8'), fontWeight: FontWeight.bold, fontSize: 15)),
                                        onTap: () async {
                                          if (profileData?['company_instagram_url'] != null) {
                                            var _url = profileData!['company_instagram_url'];
                                            await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                          }
                                        }),
                                    Divider(),
                                    Text(tr('Whatsapp:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                     GestureDetector(
                                        child: Text(profileData?['company_whatsapp_url'] ?? ' - ',
                                            style: TextStyle(color: hexStringToColor('#6986b8'), fontWeight: FontWeight.bold, fontSize: 15)),
                                        onTap: () async {
                                          if (profileData?['company_whatsapp_url'] != null) {
                                            var _url = profileData!['company_whatsapp_url'];
                                            await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                          }
                                        }),
                                    Divider(),
                                    Text(tr('Twitter:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                     GestureDetector(
                                        child: Text(profileData?['company_twitter_url'] ?? ' - ',
                                            style: TextStyle(color: hexStringToColor('#6986b8'), fontWeight: FontWeight.bold, fontSize: 15)),
                                        onTap: () async {
                                          if (profileData?['company_twitter_url'] != null) {
                                            var _url = profileData!['company_twitter_url'];
                                            await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                          }
                                        }),
                                    Divider(),
                                    Text(tr('Youtube:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                     GestureDetector(
                                        child: Text(profileData?['company_youtube_url'] ?? ' - ',
                                            style: TextStyle(color: hexStringToColor('#6986b8'), fontWeight: FontWeight.bold, fontSize: 15)),
                                        onTap: () async {
                                          if (profileData?['company_youtube_url'] != null) {
                                            var _url = profileData!['company_youtube_url'];
                                            await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                          }
                                        }),
                                    Divider(),
                                    Text(tr('Google Maps:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    GestureDetector(
                                        child: Text(profileData?['company_location_url'] ?? ' - ',
                                            style: TextStyle(color: hexStringToColor('#6986b8'), fontWeight: FontWeight.bold, fontSize: 15)),
                                        onTap: () async {
                                          if (profileData?['company_location_url'] != null) {
                                            var _url = profileData!['company_location_url'];
                                            await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                          }
                                        }),
                                    Divider()
                                  ]))
                            ]))
                      ]);
                    }))));
          } else {
            return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                    child: Container(
                        padding: EdgeInsets.all(50),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                          Text(profileData!['msg'], textAlign: TextAlign.center).tr(),
                          TextButton(onPressed: () async {}, child: Text('Retry').tr())
                        ]))));
          }
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
                        Text("Something went wrong, please try again.", textAlign: TextAlign.center).tr(),
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
