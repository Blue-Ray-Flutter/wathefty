import 'package:expandable/expandable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wathefty/notifications.dart';
import '../../API.dart';
import '../../functions.dart';
import '../../main.dart';
import 'followed_jobs.dart';
import 'followed_companies.dart';

class IndivProfilePage extends StatefulWidget {
  @override
  _IndivProfilePageState createState() => _IndivProfilePageState();
}

class _IndivProfilePageState extends State<IndivProfilePage> {
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
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: getProfile('Individual'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!.isNotEmpty) {
          profileData = snapshot.data as Map<String, dynamic>?;
          if (profileData!['status'] == true) {
            profileData = profileData!['user_info'];
            return Container(
                child: Scaffold(
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
                            child: Icon(Icons.maps_home_work),
                            backgroundColor: Colors.white,
                            label: tr('Followed Companies'),
                            onTap: () {
                              Get.to(() => IndividualFollowersPage());
                            }),
                        SpeedDialChild(
                            child: Icon(Icons.feed_outlined),
                            backgroundColor: Colors.white,
                            label: tr('Followed Company Jobs'),
                            onTap: () {
                              Get.to(() => IndividualFollowedCopmanyJobs());
                            }),
                        SpeedDialChild(
                            child: Icon(Icons.auto_awesome),
                            backgroundColor: Colors.white,
                            label: tr('Create CV'),
                            onTap: () async {
                              Map tmp = await getPDF(lang);
                              var _url = tmp['pdf_url'];
                              if (tmp.isNotEmpty && tmp['status'] && _url != null) {
                                await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                Get.back();
                              } else {
                                Get.snackbar(tr("Not available"), '',
                                    duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.red, leftBarIndicatorColor: Colors.red);
                              }
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
                                      Text(
                                        profileData!['email'],
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),
                                      Text(lang == 'ar' ? profileData!['name_ar'] : profileData!['name_en'],
                                          style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 22))
                                    ]))
                              ])),
                              Align(
                                  alignment: lang == 'ar' ? Alignment.centerLeft : Alignment.centerRight,
                                  child: IconButton(
                                      icon: Icon(Icons.edit, color: hexStringToColor('#6986b8')),
                                      onPressed: () {
                                        editSelection(
                                            context, {"contact": profileData?["contact_info_visibility"] ?? 1, "visibility": profileData?["show_info"] ?? 1});
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
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen)))),
                              Align(
                                  child: Text('Profile completion - ' + profileData!['complete_profile_percentage'].toString() + '% ',
                                      style: TextStyle(fontSize: 14, color: Colors.black)))
                            ]),
                            if (profileData!['user_profile'] != null)
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
                                        child:
                                            Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                          Container(child: Text(tr('Summary:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15))),
                                          Container(
                                              width: getWH(context, 2),
                                              height: getWH(context, 1) * 0.2,
                                              margin: EdgeInsets.symmetric(vertical: 15),
                                              decoration: BoxDecoration(
                                                  border: Border.all(width: 0.025), borderRadius: BorderRadius.circular(20), color: Colors.grey[50]),
                                              padding: EdgeInsets.all(20),
                                              child: SingleChildScrollView(
                                                  scrollDirection: Axis.vertical,
                                                  child: Text(profileData!['user_profile']['individual_overview'] ?? '',
                                                      style: TextStyle(color: Colors.black, fontSize: 18)))),
                                          Divider(),
                                          Text(tr('Username:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                          Text(profileData!['username'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                          Divider(),
                                          Text(tr('Location:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                          Text((profileData?['country_name'] ?? '') + ' - ' + (profileData?['region_name'] ?? ''),
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                          Divider(),
                                          Text(tr('Phone:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                          Text(profileData?['phone'] ?? ' - ',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                          Divider(),
                                          Text(tr('Address:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                          Text(lang == 'ar' ? (profileData?['address_ar'] ?? ' - ') : (profileData?['address_en'] ?? ''),
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                          Divider(),
                                          Text(tr('Extra phone:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                          Text(profileData?['user_profile']['individual_phone_extra'] ?? ' - ',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                          Divider(),
                                          Text(tr('National number:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                          Text(profileData?['user_profile']['individual_national_number'] ?? ' - ',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                          Divider(),
                                          Text(tr('Social status:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                          Text(profileData?['user_profile']['individual_social_status'] ?? ' - ',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                          Divider(),
                                          Text(tr('Gender:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                          Text(profileData?['user_profile']['individual_gender'] ?? ' - ',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                          Divider(),
                                          Text(tr('Nationality:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                          Text(profileData?['user_profile']['nationality_name'] ?? ' - ',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                          Divider(),
                                          Text(tr('Birth date:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                          Text(profileData?['user_profile']['individual_birth_date'] ?? ' - ',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                          Divider(),
                                          Text(tr('Academic degree:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                          Text(profileData?['user_profile']['academic_degree_name'] ?? ' - ',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                          Divider(),
                                          Text(tr('Experience:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                          Text((profileData?['user_profile']['individual_total_experience'] ?? '0') + tr(' years'),
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                          Divider(),
                                          Text(tr('Section:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                          Text(profileData?['user_profile']['section_name'] ?? ' - ',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                          Divider(),
                                          Text(tr('Specialty:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                          Text(profileData?['user_profile']['specialty_name'] ?? ' - ',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                          Divider(),
                                          Text(tr('Whatsapp:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                          Text(profileData?['user_profile']['whatsapp_number'] ?? ' - ',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                          Divider(),
                                          Text(tr('English level:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                          Text(profileData?['user_profile']['english_level'] ?? ' - ',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                          Divider(),
                                          Text(tr('Languages:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                          Text(profileData?['user_profile']['individual_languages'] ?? ' - ',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                          Divider(),
                                          Text(tr('Computer skills:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                          Text(profileData!['user_profile']['computer_skills_level'] ?? ' - ',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                          Divider(),
                                          Text(tr('Employment status:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                          Text(profileData!['user_profile']['current_status'] ?? ' - ',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                          Divider(),
                                           if (profileData?["individual_professions"] != null && profileData!["individual_professions"].isNotEmpty)
                                            Text(tr('Professions:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                          if (profileData?["individual_professions"] != null && profileData!["individual_professions"].isNotEmpty)
                                            for (var u in profileData!["individual_professions"])
                                              Text(u ?? ' - ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                          Divider(),
                                          if (profileData?['user_profile']['individual_cv_file'] != null)
                                            GestureDetector(
                                                child: Text('Open CV', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15)).tr(),
                                                onTap: () async {
                                                  if (profileData?['user_profile']['individual_cv_file'] != null) {
                                                    var _url = profileData?['user_profile']['individual_cv_file'];
                                                    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                                  } else {
                                                    Get.snackbar(tr("Job doesn't have any attachments"), '',
                                                        duration: Duration(seconds: 5),
                                                        backgroundColor: Colors.white,
                                                        colorText: Colors.blueGrey,
                                                        leftBarIndicatorColor: Colors.blueGrey);
                                                  }
                                                }),
                                          if (profileData?['user_profile']['individual_cv_file'] != null)
                                            GestureDetector(
                                                child: Text('Delete CV', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15)).tr(),
                                                onTap: () async {
                                                  if (profileData?['user_profile']['individual_cv_file'] != null) {
                                                    await removePrompt(context, 'CV', lang, 'Individual', "");
                                                  }
                                                })
                                        ]))
                                  ])),
                            Container(
                                margin: EdgeInsets.all(30),
                                child: ExpandablePanel(
                                  header: Text('Courses', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 19)).tr(),
                                  collapsed: Text(profileData!['courses'] != null && profileData?['courses'].isNotEmpty ? 'Tap to expand ' : 'No information',
                                          softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis)
                                      .tr(),
                                  expanded: Column(children: [
                                    Divider(),
                                    profileData!['courses'] != null && profileData?['courses'].isNotEmpty
                                        ? Container(
                                            margin: EdgeInsets.symmetric(vertical: 10),
                                            height: profileData!['courses'].length > 1 ? 300 : 250,
                                            width: getWH(context, 2),
                                            child: ListView.builder(
                                                itemCount: profileData!['courses'].length,
                                                scrollDirection: Axis.vertical,
                                                itemBuilder: (ctx, index) {
                                                  return Container(
                                                      margin: EdgeInsets.symmetric(vertical: 10),
                                                      height: 240,
                                                      width: getWH(context, 2),
                                                      padding: EdgeInsets.all(15),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(width: 0.1), borderRadius: BorderRadius.circular(20), color: Colors.grey[100]),
                                                      alignment: Alignment.center,
                                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                        Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              Text(tr('Title:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                              Text(
                                                                  lang == 'ar'
                                                                      ? profileData!['courses'][index]['course_title_ar']
                                                                      : profileData!['courses'][index]['course_title_en'],
                                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                              Text(tr('Organization:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                              Text(
                                                                  lang == 'ar'
                                                                      ? profileData!['courses'][index]['organization_name_ar']
                                                                      : profileData!['courses'][index]['organization_name_en'],
                                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                              Text(tr('Address:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                              Text(
                                                                  lang == 'ar'
                                                                      ? profileData!['courses'][index]['organization_address_ar']
                                                                      : profileData!['courses'][index]['organization_address_en'],
                                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                              Text(tr('Date:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                              Text(
                                                                  profileData!['courses'][index]['start_at'] + ' - ' + profileData!['courses'][index]['end_at'],
                                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                              if (profileData!['courses'][index]['file'] != null)
                                                                Text(tr('Attachment:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                              if (profileData!['courses'][index]['file'] != null)
                                                                GestureDetector(
                                                                    child: SizedBox(
                                                                        width: 200,
                                                                        child: Text(profileData!['courses'][index]['file'],
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                                color: hexStringToColor('#6986b8'),
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 15))),
                                                                    onTap: () async {
                                                                      var _url = profileData!['courses'][index]['file'];
                                                                      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                                                    })
                                                            ]),
                                                        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                          profileData!['courses'][index]['course_type'] == '2' ? Text('Certified') : SizedBox(),
                                                          IconButton(
                                                              onPressed: () async {
                                                                await removePrompt(
                                                                    context, 'courses', lang, 'Individual', profileData!['courses'][index]['id'].toString());
                                                              },
                                                              icon: Icon(Icons.remove_circle, color: Colors.red, size: 30))
                                                        ])
                                                      ]));
                                                }),
                                          )
                                        : SizedBox(),
                                    TextButton(
                                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                          Icon(Icons.add_circle_outline, color: Colors.blueGrey),
                                          SizedBox(width: 10),
                                          Text('Add Course', style: TextStyle(color: Colors.blueGrey, fontSize: 16)).tr()
                                        ]),
                                        onPressed: () async {
                                          var tmp = await certFormPrompt(context, 'courses', lang, 'Individual');
                                          if (tmp != null && tmp) {
                                            setState(() {});
                                          }
                                        })
                                  ]),
                                )),
                            Container(
                                margin: EdgeInsets.all(30),
                                child: ExpandablePanel(
                                    header: Text('Education', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 19)).tr(),
                                    collapsed: Text(
                                            profileData!['educations'] != null && profileData?['educations'].isNotEmpty ? 'Tap to expand ' : 'No information',
                                            softWrap: true,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis)
                                        .tr(),
                                    expanded: Column(children: [
                                      Divider(),
                                      profileData?['educations'] != null && profileData!['educations'].isNotEmpty
                                          ? Container(
                                              margin: EdgeInsets.symmetric(vertical: 10),
                                              height: profileData!['educations'].length > 1 ? 310 : 270,
                                              width: getWH(context, 2),
                                              child: ListView.builder(
                                                  itemCount: profileData!['educations'].length,
                                                  scrollDirection: Axis.vertical,
                                                  itemBuilder: (ctx, index) {
                                                    return Container(
                                                        margin: EdgeInsets.symmetric(vertical: 10),
                                                        height: 260,
                                                        width: getWH(context, 2),
                                                        padding: EdgeInsets.all(15),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(width: 0.1), borderRadius: BorderRadius.circular(20), color: Colors.grey[100]),
                                                        alignment: Alignment.center,
                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                          Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                Text(tr('Major:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                                Text(
                                                                    lang == 'ar'
                                                                        ? profileData!['educations'][index]['major_name_ar']
                                                                        : profileData!['educations'][index]['major_name_en'],
                                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                                Text(tr('Organization:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                                Text(
                                                                    lang == 'ar'
                                                                        ? profileData!['educations'][index]['organization_name_ar']
                                                                        : profileData!['educations'][index]['organization_name_en'],
                                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                                Text(tr('Degree:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                                Text(profileData!['educations'][index]['academec_degree_name'],
                                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                                Text(tr('Date:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                                Text(
                                                                    profileData!['educations'][index]['start_at'] +
                                                                        (' - ' + (profileData!['educations'][index]['end_at'] ?? " ")),
                                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                                if (profileData!['educations'][index]['file'] != null)
                                                                  Text(tr('Attachment:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                                if (profileData!['educations'][index]['file'] != null)
                                                                  GestureDetector(
                                                                      child: SizedBox(
                                                                          width: 200,
                                                                          child: Text(profileData!['educations'][index]['file'],
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                  color: hexStringToColor('#6986b8'),
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: 15))),
                                                                      onTap: () async {
                                                                        var _url = profileData!['educations'][index]['file'];
                                                                        await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                                                      })
                                                              ]),
                                                          IconButton(
                                                              onPressed: () async {
                                                                var tmp = await removePrompt(context, 'education', lang, 'Individual',
                                                                    profileData!['educations'][index]['id'].toString());
                                                                if (tmp != null && tmp) {
                                                                  setState(() {});
                                                                }
                                                              },
                                                              icon: Icon(Icons.remove_circle, color: Colors.red, size: 30))
                                                        ]));
                                                  }))
                                          : SizedBox(),
                                      // arrtoList(degreeArr, lang, '')[int.parse(profileData!['educations'][index]['academec_degree_id'])]['label'],
                                      TextButton(
                                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                            Icon(Icons.add_circle_outline, color: Colors.blueGrey),
                                            SizedBox(width: 10),
                                            Text('Add Education', style: TextStyle(color: Colors.blueGrey, fontSize: 16)).tr()
                                          ]),
                                          onPressed: () async {
                                            var tmp = await eduFormPrompt(context, 'education', lang, 'Individual');
                                            if (tmp != null && tmp) {
                                              setState(() {});
                                            }
                                          })
                                    ]))),
                            Container(
                                margin: EdgeInsets.all(30),
                                child: ExpandablePanel(
                                    header: Text('Experience', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 19)).tr(),
                                    collapsed: Text(
                                            profileData!['experiences'] != null && profileData?['experiences'].isNotEmpty ? 'Tap to expand ' : 'No information',
                                            softWrap: true,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis)
                                        .tr(),
                                    expanded: Column(children: [
                                      Divider(),
                                      profileData?['experiences'] != null && profileData!['experiences'].isNotEmpty
                                          ? Container(
                                              margin: EdgeInsets.symmetric(vertical: 10),
                                              height: profileData!['experiences'].length > 1 ? 300 : 250,
                                              width: getWH(context, 2),
                                              child: ListView.builder(
                                                  itemCount: profileData!['experiences'].length,
                                                  scrollDirection: Axis.vertical,
                                                  itemBuilder: (ctx, index) {
                                                    return Container(
                                                        margin: EdgeInsets.symmetric(vertical: 10),
                                                        height: 200,
                                                        width: getWH(context, 2),
                                                        padding: EdgeInsets.all(15),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(width: 0.1), borderRadius: BorderRadius.circular(20), color: Colors.grey[100]),
                                                        alignment: Alignment.center,
                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                          Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                Text(tr('Position:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                                Text(
                                                                    lang == 'ar'
                                                                        ? profileData!['experiences'][index]['position_ar']
                                                                        : profileData!['experiences'][index]['position_en'],
                                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                                Text(tr('Organization:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                                Text(
                                                                    lang == 'ar'
                                                                        ? profileData!['experiences'][index]['company_name_ar']
                                                                        : profileData!['experiences'][index]['company_name_en'],
                                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                                Text(tr('Date:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                                Text(
                                                                    profileData!['experiences'][index]['start_at'] +
                                                                        ' - ' +
                                                                        (profileData!['experiences'][index]['end_at'] ?? tr('present')),
                                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                                if (profileData!['experiences'][index]['file'] != null)
                                                                  Text(tr('Attachment:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                                if (profileData!['experiences'][index]['file'] != null)
                                                                  GestureDetector(
                                                                      child: SizedBox(
                                                                          width: 200,
                                                                          child: Text(profileData!['experiences'][index]['file'],
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                  color: hexStringToColor('#6986b8'),
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: 15))),
                                                                      onTap: () async {
                                                                        var _url = profileData!['experiences'][index]['file'];
                                                                        await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                                                      })
                                                              ]),
                                                          IconButton(
                                                              onPressed: () async {
                                                                var tmp = await removePrompt(context, 'experience', lang, 'Individual',
                                                                    profileData!['experiences'][index]['id'].toString());
                                                                if (tmp != null && tmp) {
                                                                  setState(() {});
                                                                }
                                                              },
                                                              icon: Icon(Icons.remove_circle, color: Colors.red, size: 30))
                                                        ]));
                                                  }),
                                            )
                                          : SizedBox(),
                                      TextButton(
                                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                            Icon(Icons.add_circle_outline, color: Colors.blueGrey),
                                            SizedBox(width: 10),
                                            Text('Add Experience', style: TextStyle(color: Colors.blueGrey, fontSize: 16)).tr()
                                          ]),
                                          onPressed: () async {
                                            var tmp = await expFormPrompt(context, 'experience', lang, 'Individual');
                                            if (tmp != null && tmp) {
                                              setState(() {});
                                            }
                                          })
                                    ]))),
                            Container(
                                margin: EdgeInsets.all(30),
                                child: ExpandablePanel(
                                    header: Text('Skills', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 19)).tr(),
                                    collapsed: Text(profileData!['skills'] != null && profileData?['skills'].isNotEmpty ? 'Tap to expand ' : 'No information',
                                            softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis)
                                        .tr(),
                                    expanded: Column(children: [
                                      Divider(),
                                      profileData!['skills'] != null && profileData?['skills'].isNotEmpty
                                          ? Container(
                                              margin: EdgeInsets.symmetric(vertical: 10),
                                              height: profileData!['skills'].length > 1 ? 300 : 180,
                                              width: getWH(context, 2),
                                              child: ListView.builder(
                                                  itemCount: profileData!['skills'].length,
                                                  scrollDirection: Axis.vertical,
                                                  itemBuilder: (ctx, index) {
                                                    return Container(
                                                        margin: EdgeInsets.symmetric(vertical: 10),
                                                        height: 150,
                                                        width: getWH(context, 2),
                                                        padding: EdgeInsets.all(15),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(width: 0.1), borderRadius: BorderRadius.circular(20), color: Colors.grey[100]),
                                                        alignment: Alignment.center,
                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                          Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                Text(tr('Title:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                                Text(
                                                                    lang == 'ar'
                                                                        ? profileData!['skills'][index]['skill_title_ar']
                                                                        : profileData!['skills'][index]['skill_title_en'],
                                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                                Text(tr('Date added:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                                Text(
                                                                    DateFormat('yyyy-MM-dd')
                                                                        .format(DateTime.parse(profileData!['skills'][index]['created_at'])),
                                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                              ]),
                                                          IconButton(
                                                              onPressed: () async {
                                                                var tmp = await removePrompt(
                                                                    context, 'skill', lang, 'Individual', profileData!['skills'][index]['id'].toString());
                                                                if (tmp != null && tmp) {
                                                                  setState(() {});
                                                                }
                                                              },
                                                              icon: Icon(Icons.remove_circle, color: Colors.red, size: 30))
                                                        ]));
                                                  }),
                                            )
                                          : SizedBox(),
                                      TextButton(
                                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                            Icon(Icons.add_circle_outline, color: Colors.blueGrey),
                                            SizedBox(width: 10),
                                            Text('Add Skills', style: TextStyle(color: Colors.blueGrey, fontSize: 16)).tr()
                                          ]),
                                          onPressed: () async {
                                            var tmp = await updatePrompt(context, 'skill', lang, 'Individual');
                                            if (tmp != null && tmp) {
                                              setState(() {});
                                            }
                                          })
                                    ]))),
                            Container(
                                margin: EdgeInsets.all(30),
                                child: ExpandablePanel(
                                  header: Text('Professional Certificates', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 19))
                                      .tr(),
                                  collapsed: Text(
                                          profileData!['individual_professional_certificates'] != null &&
                                                  profileData?['individual_professional_certificates'].isNotEmpty
                                              ? 'Tap to expand '
                                              : 'No information',
                                          softWrap: true,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis)
                                      .tr(),
                                  expanded: Column(children: [
                                    Divider(),
                                    profileData!['individual_professional_certificates'] != null &&
                                            profileData?['individual_professional_certificates'].isNotEmpty
                                        ? Container(
                                            margin: EdgeInsets.symmetric(vertical: 10),
                                            height: 340,
                                            width: getWH(context, 2),
                                            child: ListView.builder(
                                                itemCount: profileData!['individual_professional_certificates'].length,
                                                scrollDirection: Axis.vertical,
                                                itemBuilder: (ctx, index) {
                                                  return Container(
                                                      margin: EdgeInsets.symmetric(vertical: 10),
                                                      height: 320,
                                                      width: getWH(context, 2),
                                                      padding: EdgeInsets.all(15),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(width: 0.1), borderRadius: BorderRadius.circular(20), color: Colors.grey[100]),
                                                      alignment: Alignment.center,
                                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                        Expanded(
                                                            child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                              Text(tr('Certificate:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                              Text(
                                                                  profileData!['individual_professional_certificates'][index]
                                                                      [lang == "ar" ? 'certificate_title_ar' : "certificate_title_en"],
                                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                              Text(tr('Release date:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                              Text(profileData!['individual_professional_certificates'][index]['release_date'],
                                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                              if (profileData!['individual_professional_certificates'][index]['expiry_date'] != null)
                                                                Text(tr('Expire date:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                              if (profileData!['individual_professional_certificates'][index]['expiry_date'] != null)
                                                                Text(profileData!['individual_professional_certificates'][index]['expiry_date'],
                                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                              if (profileData!['individual_professional_certificates'][index]['file'] != null)
                                                                Text(tr('Attachment:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                              if (profileData!['individual_professional_certificates'][index]['file'] != null)
                                                                GestureDetector(
                                                                    child: SizedBox(
                                                                        width: 200,
                                                                        child: Text(profileData!['individual_professional_certificates'][index]['file'],
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                                color: hexStringToColor('#6986b8'),
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 15))),
                                                                    onTap: () async {
                                                                      var _url = profileData!['individual_professional_certificates'][index]['file'];
                                                                      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                                                    })
                                                            ])),
                                                        IconButton(
                                                            onPressed: () async {
                                                              var tmp = await removePrompt(context, 'certificate', lang, 'Individual',
                                                                  profileData!['individual_professional_certificates'][index]['id'].toString());
                                                              if (tmp != null && tmp) {
                                                                setState(() {});
                                                              }
                                                            },
                                                            icon: Icon(Icons.remove_circle, color: Colors.red, size: 30))
                                                      ]));
                                                }))
                                        : SizedBox(),
                                    TextButton(
                                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                          Icon(Icons.add_circle_outline, color: Colors.blueGrey),
                                          SizedBox(width: 10),
                                          Text('Add Certificate', style: TextStyle(color: Colors.blueGrey, fontSize: 16)).tr()
                                        ]),
                                        onPressed: () async {
                                          var tmp = await certificateFormPrompt(context);
                                          if (tmp != null && tmp) {
                                            setState(() {});
                                          }
                                        })
                                  ]),
                                )),
                            Container(
                                margin: EdgeInsets.all(30),
                                child: ExpandablePanel(
                                  header: Text('Projects', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 19)).tr(),
                                  collapsed: Text(profileData!['projects'] != null && profileData?['projects'].isNotEmpty ? 'Tap to expand ' : 'No information',
                                          softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis)
                                      .tr(),
                                  expanded: Column(children: [
                                    Divider(),
                                    profileData!['projects'] != null && profileData?['projects'].isNotEmpty
                                        ? Container(
                                            margin: EdgeInsets.symmetric(vertical: 10),
                                            height: 340,
                                            width: getWH(context, 2),
                                            child: ListView.builder(
                                                itemCount: profileData!['projects'].length,
                                                scrollDirection: Axis.vertical,
                                                itemBuilder: (ctx, index) {
                                                  return Container(
                                                      margin: EdgeInsets.symmetric(vertical: 10),
                                                      height: 320,
                                                      width: getWH(context, 2),
                                                      padding: EdgeInsets.all(15),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(width: 0.1), borderRadius: BorderRadius.circular(20), color: Colors.grey[100]),
                                                      alignment: Alignment.center,
                                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                        Expanded(
                                                            child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                              Text(tr('Title:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                              Text(profileData!['projects'][index]['project_title'],
                                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                              Text(tr('Description:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                              Text(profileData!['projects'][index]['project_description'],
                                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                              if (profileData?['projects'][index]['project_url'] != null)
                                                                GestureDetector(
                                                                    child: Text(tr('Project URL:'), style: TextStyle(color: Colors.blue, fontSize: 15)),
                                                                    onTap: () async {
                                                                      if (profileData?['projects'][index]['project_url'] != null) {
                                                                        var _url = profileData?['projects'][index]['project_url'];
                                                                        await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                                                      }
                                                                    }),
                                                              if (profileData?['projects'][index]['project_image'] != null)
                                                                SizedBox(
                                                                    height: 120,
                                                                    child:
                                                                        Image.network(profileData?['projects'][index]['project_image'], fit: BoxFit.contain)),
                                                            ])),
                                                        IconButton(
                                                            onPressed: () async {
                                                              var tmp = await removePrompt(
                                                                  context, 'project', lang, 'Individual', profileData!['projects'][index]['id'].toString());
                                                              if (tmp != null && tmp) {
                                                                setState(() {});
                                                              }
                                                            },
                                                            icon: Icon(Icons.remove_circle, color: Colors.red, size: 30))
                                                      ]));
                                                }))
                                        : SizedBox(),
                                    TextButton(
                                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                          Icon(Icons.add_circle_outline, color: Colors.blueGrey),
                                          SizedBox(width: 10),
                                          Text('Add Project', style: TextStyle(color: Colors.blueGrey, fontSize: 16)).tr()
                                        ]),
                                        onPressed: () async {
                                          var tmp = await projectFormPrompt(context, 'project', lang, 'Individual');
                                          if (tmp != null && tmp) {
                                            setState(() {});
                                          }
                                        })
                                  ]),
                                )),
                            Container(
                                margin: EdgeInsets.all(30),
                                child: ExpandablePanel(
                                    header: Text('Computer Skills', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 19)).tr(),
                                    collapsed: Text(
                                            profileData!['user_computer_skills'] != null && profileData?['user_computer_skills'].isNotEmpty
                                                ? 'Tap to expand '
                                                : 'No information',
                                            softWrap: true,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis)
                                        .tr(),
                                    expanded: Column(children: [
                                      Divider(),
                                      profileData?['user_computer_skills'] != null && profileData!['user_computer_skills'].isNotEmpty
                                          ? Container(
                                              margin: EdgeInsets.symmetric(vertical: 10),
                                              height: profileData!['user_computer_skills'].length > 1 ? 310 : 270,
                                              width: getWH(context, 2),
                                              child: ListView.builder(
                                                  itemCount: profileData!['user_computer_skills'].length,
                                                  scrollDirection: Axis.vertical,
                                                  itemBuilder: (ctx, index) {
                                                    return Container(
                                                        margin: EdgeInsets.symmetric(vertical: 10),
                                                        height: 260,
                                                        width: getWH(context, 2),
                                                        padding: EdgeInsets.all(15),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(width: 0.1), borderRadius: BorderRadius.circular(20), color: Colors.grey[100]),
                                                        alignment: Alignment.center,
                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                          Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                Text(tr('Skill:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                                Text(
                                                                    lang == 'ar'
                                                                        ? profileData!['user_computer_skills'][index]['skill_title_ar']
                                                                        : profileData!['user_computer_skills'][index]['skill_title_en'],
                                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                                Text(tr('Program Type:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                                Text(
                                                                    lang == 'ar'
                                                                        ? profileData!['user_computer_skills'][index]['program_type_ar']
                                                                        : profileData!['user_computer_skills'][index]['program_type_en'],
                                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                                Text(tr('Version:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                                Text(profileData!['user_computer_skills'][index]['version'],
                                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                                Text(tr('Last year used:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                                Text(profileData!['user_computer_skills'][index]['last_year_of_use'].toString(),
                                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                                Text(tr('Experience:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                                Text(profileData!['user_computer_skills'][index]['number_of_years_of_experience'].toString(),
                                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                              ]),
                                                          IconButton(
                                                              onPressed: () async {
                                                                var tmp = await removePrompt(context, 'computer', lang, 'Individual',
                                                                    profileData!['user_computer_skills'][index]['id'].toString());
                                                                if (tmp != null && tmp) {
                                                                  setState(() {});
                                                                }
                                                              },
                                                              icon: Icon(Icons.remove_circle, color: Colors.red, size: 30))
                                                        ]));
                                                  }))
                                          : SizedBox(),
                                      TextButton(
                                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                            Icon(Icons.add_circle_outline, color: Colors.blueGrey),
                                            SizedBox(width: 10),
                                            Text('Add Computer Skill', style: TextStyle(color: Colors.blueGrey, fontSize: 16)).tr()
                                          ]),
                                          onPressed: () async {
                                            var tmp = await computerFormPrompt(context);
                                            if (tmp != null && tmp) {
                                              setState(() {});
                                            }
                                          })
                                    ]))),
                            Container(
                                margin: EdgeInsets.all(30),
                                child: ExpandablePanel(
                                  header: Text('Languages', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 19)).tr(),
                                  collapsed: Text(
                                          profileData!['individual_languages'] != null && profileData?['individual_languages'].isNotEmpty
                                              ? 'Tap to expand '
                                              : 'No information',
                                          softWrap: true,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis)
                                      .tr(),
                                  expanded: Column(children: [
                                    Divider(),
                                    profileData!['individual_languages'] != null && profileData?['individual_languages'].isNotEmpty
                                        ? Container(
                                            margin: EdgeInsets.symmetric(vertical: 10),
                                            height: 340,
                                            width: getWH(context, 2),
                                            child: ListView.builder(
                                                itemCount: profileData!['individual_languages'].length,
                                                scrollDirection: Axis.vertical,
                                                itemBuilder: (ctx, index) {
                                                  return Container(
                                                      margin: EdgeInsets.symmetric(vertical: 10),
                                                      height: 320,
                                                      width: getWH(context, 2),
                                                      padding: EdgeInsets.all(15),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(width: 0.1), borderRadius: BorderRadius.circular(20), color: Colors.grey[100]),
                                                      alignment: Alignment.center,
                                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                        Expanded(
                                                            child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                              Text(tr('Language:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                              Text(
                                                                  profileData!['individual_languages'][index]
                                                                      [lang == "ar" ? 'language_name_ar' : "language_name_en"],
                                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                              Text(tr('Level:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                              Text(profileData!['individual_languages'][index]['level'],
                                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                              Text(tr('Read:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                              Text(profileData!['individual_languages'][index]['read'],
                                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                              Text(tr('Speak:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                              Text(profileData!['individual_languages'][index]['speak'],
                                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                              Text(tr('Write:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                              Text(profileData!['individual_languages'][index]['write'],
                                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                            ])),
                                                        IconButton(
                                                            onPressed: () async {
                                                              var tmp = await removePrompt(context, 'language', lang, 'Individual',
                                                                  profileData!['individual_languages'][index]['id'].toString());
                                                              if (tmp != null && tmp) {
                                                                setState(() {});
                                                              }
                                                            },
                                                            icon: Icon(Icons.remove_circle, color: Colors.red, size: 30))
                                                      ]));
                                                }))
                                        : SizedBox(),
                                    TextButton(
                                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                          Icon(Icons.add_circle_outline, color: Colors.blueGrey),
                                          SizedBox(width: 10),
                                          Text('Add Language', style: TextStyle(color: Colors.blueGrey, fontSize: 16)).tr()
                                        ]),
                                        onPressed: () async {
                                          var tmp = await languageFormPrompt(context);
                                          if (tmp != null && tmp) {
                                            setState(() {});
                                          }
                                        })
                                  ]),
                                )),
                            SizedBox(height: 20),
                          ]);
                        })))));
          } else {
            return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                    child: Container(
                        padding: EdgeInsets.all(50),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                          Text(
                            profileData!['msg'],
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

//Move to functions

//Move to API
