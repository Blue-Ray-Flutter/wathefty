import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wathefty/Pages/public/gallery.dart';
import '../../API.dart';
import '../../functions.dart';
import 'messages.dart';

class UserInput {
  String type;
  String value;
  String name;

  UserInput(this.type, this.value, this.name);
}

class IndividualProfile extends StatefulWidget {
  @override
  _IndividualProfileState createState() => _IndividualProfileState();
  const IndividualProfile({Key? key, required this.iid, this.jobId, this.jobType, this.companyID}) : super(key: key);
  final String iid;
  final String? jobId;
  final int? jobType;
  final String? companyID;
}

class _IndividualProfileState extends State<IndividualProfile> {
  @override
  void initState() {
    super.initState();
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
      future: getIndivProfile(globalType, context.locale.toString(), widget.iid, widget.jobId, widget.jobType),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!.isNotEmpty) {
          profileData = snapshot.data as Map<String, dynamic>?;
          if (profileData!['status'] == true) {
            profileData = profileData!['user_info'];
            List<Map> values = [];
            if (profileData?['applyValues'] != null) {
              profileData!['applyValues'].forEach((k, v) {
                v['order'] = k.toString();
                values.add(v);
              });
            }

            
            return Scaffold(
                floatingActionButton: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.end, children: [
                  globalType != 'Guest' && (widget.iid != globalUid || (widget.iid == globalUid && globalType != 'Individual'))
                      ? FloatingActionButton(
                          heroTag: "btn6",
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          onPressed: () {
                            Get.to(() => Chat(
                                uType: 'Individual',
                                uid: widget.iid,
                                image: profileData?['profile_photo_path'] != null
                                    ? profileData!['profile_photo_path']
                                    : "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png",
                                name: lang == 'ar' ? profileData!['name_ar'] : profileData!['name_en']));
                          },
                          child: Icon(Icons.message, color: Colors.blueGrey))
                      : SizedBox(),
                  SizedBox(height: 5),
                  FloatingActionButton(
                      heroTag: "btn20",
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      onPressed: () => Get.to(() => GalleryPage(iid: widget.iid, owner: false)),
                      child: Icon(Icons.image, color: Colors.blueGrey))
                ]),
                backgroundColor: Colors.white,
                appBar: watheftyBar(context, "Profile", 20),
                bottomNavigationBar: watheftyBottomBar(context),
                body: SmartRefresher(
                    enablePullDown: true,
                    header: WaterDropHeader(),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: SingleChildScrollView(
                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: [
                      SizedBox(height: 15),
                      Center(
                          child: Column(children: [
                        CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(profileData?['profile_photo_path'] ??
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png')),
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text(
                                profileData!['email'],
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(lang == 'ar' ? profileData!['name_ar'] : profileData!['name_en'],
                                  style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 22))
                            ]))
                      ])),
                      Divider(),
                      if (widget.companyID == globalUid && profileData?['applyValues'] != null)
                        Text('Application form', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 20)).tr(),
                      if (widget.companyID == globalUid && profileData?['applyValues'] != null)
                        Container(
                            margin: EdgeInsets.all(10),
                            child: Table(
                                columnWidths: {0: FlexColumnWidth(2), 1: FlexColumnWidth(4)},
                                border: TableBorder.all(color: Colors.black54, style: BorderStyle.solid, width: 1),
                                children: [
                                  TableRow(children: [
                                    Container(
                                        alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                        padding: EdgeInsets.all(5),
                                        color: Colors.grey[200],
                                        child: Column(children: [Text('Title', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)).tr()])),
                                    Container(
                                        alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                        padding: EdgeInsets.all(5),
                                        color: Colors.grey[200],
                                        child: Column(children: [Text('User Input', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)).tr()]))
                                  ]),
                                  for (var u in values)
                                    TableRow(children: [
                                      Container(
                                          alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                          padding: EdgeInsets.all(5),
                                          color: Colors.grey[200],
                                          child: Column(children: [Text(u['field_name'])])),
                                      Container(
                                          alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                          padding: EdgeInsets.all(5),
                                          child: Column(children: [Text(u['field_value'])]))
                                    ])
                                ])),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(child: Text(tr('Summary:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15))),
                                    Container(
                                        width: getWH(context, 2),
                                        height: getWH(context, 1) * 0.2,
                                        margin: EdgeInsets.symmetric(vertical: 15),
                                        decoration:
                                            BoxDecoration(border: Border.all(width: 0.025), borderRadius: BorderRadius.circular(20), color: Colors.grey[50]),
                                        padding: EdgeInsets.all(20),
                                        child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Text(profileData?['user_profile']['individual_overview'] ?? '',
                                                style: TextStyle(color: Colors.black, fontSize: 18)))),
                                    Divider(),
                                    Text(tr('Location:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text((profileData!['country_name'] ?? '') + ' - ' + (profileData!['region_name'] ?? ''),
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Phone:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(profileData?['phone'] ?? '', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Address:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(lang == 'ar' ? (profileData!['address_ar'] ?? '') : (profileData!['address_en'] ?? ''),
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Extra phone:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(profileData!['user_profile']['individual_phone_extra'] ?? '',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('National number:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(profileData!['user_profile']['individual_national_number'] ?? '',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Social status:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(profileData!['user_profile']['individual_social_status'] ?? '',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Gender:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(profileData!['user_profile']['individual_gender'] ?? '',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Nationality:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(profileData!['user_profile']['nationality_name'] ?? '',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Birth date:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(profileData!['user_profile']['individual_birth_date'] ?? '',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Academic degree:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(profileData!['user_profile']['academic_degree_name'] ?? '',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Experience:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text((profileData!['user_profile']['individual_total_experience'] ?? '0') + ' years',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Section:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(profileData!['user_profile']['section_name'] ?? '',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Specialty:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(profileData!['user_profile']['specialty_name'] ?? '',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Whatsapp:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(profileData!['user_profile']['whatsapp_number'] ?? '',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('English level:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(profileData!['user_profile']['english_level'] ?? '',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    // Divider(),
                                    // Text(tr('Languages:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    // Text(profileData!['user_profile']['individual_languages'] ?? '',
                                    //     style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    // Divider(),
                                    // Text(tr('Computer skills:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    // Text(profileData!['user_profile']['computer_skills_level'] ?? '',
                                    //     style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    Text(tr('Employment status:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    Text(profileData!['user_profile']['current_status'] ?? '',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                       if (profileData?["individual_professions"] != null && profileData!["individual_professions"].isNotEmpty)
                                      Text(tr('Professions:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                    if (profileData?["individual_professions"] != null && profileData!["individual_professions"].isNotEmpty)
                                      for (var u in profileData!["individual_professions"])
                                        Text(u ?? ' - ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Divider(),
                                    profileData?['user_profile']['individual_cv_file'] != null
                                        ? GestureDetector(
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
                                            })
                                        : SizedBox()
                                  ],
                                )),
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
                                                        Text(profileData!['courses'][index]['start_at'] + ' - ' + profileData!['courses'][index]['end_at'],
                                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                      ]),
                                                ]));
                                          }),
                                    )
                                  : SizedBox(),
                            ]),
                          )),
                      Container(
                          margin: EdgeInsets.all(30),
                          child: ExpandablePanel(
                            header: Text('Education', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 19)).tr(),
                            collapsed: Text(profileData!['educations'] != null && profileData?['educations'].isNotEmpty ? 'Tap to expand ' : 'No information',
                                    softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis)
                                .tr(),
                            expanded: Column(children: [
                              Divider(),
                              profileData?['educations'] != null && profileData!['educations'].isNotEmpty
                                  ? Container(
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      height: profileData!['educations'].length > 1 ? 300 : 260,
                                      width: getWH(context, 2),
                                      child: ListView.builder(
                                          itemCount: profileData!['educations'].length,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (ctx, index) {
                                            return Container(
                                                margin: EdgeInsets.symmetric(vertical: 10),
                                                height: 250,
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
                                                       Text(profileData!['educations'][index]['start_at'] + (' - ' + (profileData!['educations'][index]['end_at'] ?? " ")),
                                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                    if (profileData!['educations'][index]['file'] != null) Text(tr('Attachment:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                    if (profileData!['educations'][index]['file'] != null)
                                                      GestureDetector(
                                                          child: SizedBox(
                                                              width: 200,
                                                              child: Text(profileData!['educations'][index]['file'],
                                                                  overflow: TextOverflow.ellipsis, style: TextStyle(color: hexStringToColor('#6986b8'), fontWeight: FontWeight.bold, fontSize: 15))),
                                                          onTap: () async {
                                                            var _url = profileData!['educations'][index]['file'];
                                                            await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                                          })
                                                      ]),
                                                ]));
                                          }))
                                  : SizedBox(),
                            ]),
                          )),
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
                                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))
                                                        ]),
                                                  ]));
                                            }),
                                      )
                                    : SizedBox()
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
                                profileData?['skills'] != null && profileData!['skills'].isNotEmpty
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
                                                          Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(profileData!['skills'][index]['created_at'])),
                                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                        ]),
                                                  ]));
                                            }),
                                      )
                                    : SizedBox(),
                              ]))),
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
                                                            child: Image.network(profileData?['projects'][index]['project_image'], fit: BoxFit.contain)),
                                                    ]));
                                          }))
                                  : SizedBox(),
                            ]),
                          )),
                          Container(
                          margin: EdgeInsets.all(30),
                          child: ExpandablePanel(
                            header: Text('Professional Certificates', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 19)).tr(),
                            collapsed: Text(
                                    profileData!['individual_professional_certificates'] != null && profileData?['individual_professional_certificates'].isNotEmpty
                                        ? 'Tap to expand '
                                        : 'No information',
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis)
                                .tr(),
                            expanded: Column(children: [
                              Divider(),
                              profileData!['individual_professional_certificates'] != null && profileData?['individual_professional_certificates'].isNotEmpty
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
                                                decoration: BoxDecoration(border: Border.all(width: 0.1), borderRadius: BorderRadius.circular(20), color: Colors.grey[100]),
                                                alignment: Alignment.center,
                                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                  Expanded(
                                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                                    Text(tr('Certificate:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                    Text(profileData!['individual_professional_certificates'][index][lang == "ar" ? 'certificate_title_ar' : "certificate_title_en"],
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
                                                                  overflow: TextOverflow.ellipsis, style: TextStyle(color: hexStringToColor('#6986b8'), fontWeight: FontWeight.bold, fontSize: 15))),
                                                          onTap: () async {
                                                            var _url = profileData!['individual_professional_certificates'][index]['file'];
                                                            await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                                          })
                                                  ])),
                                                ]));
                                          }))
                                  : SizedBox(),
                            ]),
                          )),
                      Container(
                          margin: EdgeInsets.all(30),
                          child: ExpandablePanel(
                              header: Text('Computer Skills', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 19)).tr(),
                              collapsed: Text(profileData!['user_computer_skills'] != null && profileData?['user_computer_skills'].isNotEmpty ? 'Tap to expand ' : 'No information',
                                      softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis)
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
                                                  decoration: BoxDecoration(border: Border.all(width: 0.1), borderRadius: BorderRadius.circular(20), color: Colors.grey[100]),
                                                  alignment: Alignment.center,
                                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                    Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                                      Text(tr('Skill:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                      Text(lang == 'ar' ? profileData!['user_computer_skills'][index]['skill_title_ar'] : profileData!['user_computer_skills'][index]['skill_title_en'],
                                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                      Text(tr('Program Type:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                      Text(
                                                          lang == 'ar'
                                                              ? profileData!['user_computer_skills'][index]['program_type_ar']
                                                              : profileData!['user_computer_skills'][index]['program_type_en'],
                                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                      Text(tr('Version:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                      Text(profileData!['user_computer_skills'][index]['version'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                      Text(tr('Last year used:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                      Text(profileData!['user_computer_skills'][index]['last_year_of_use'].toString(),
                                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                      Text(tr('Experience:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                      Text(profileData!['user_computer_skills'][index]['number_of_years_of_experience'].toString(),
                                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                    ]),
                                                  ]));
                                            }))
                                    : SizedBox(),
                              ]))),
                      Container(
                          margin: EdgeInsets.all(30),
                          child: ExpandablePanel(
                            header: Text('Languages', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 19)).tr(),
                            collapsed: Text(profileData!['individual_languages'] != null && profileData?['individual_languages'].isNotEmpty ? 'Tap to expand ' : 'No information',
                                    softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis)
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
                                                decoration: BoxDecoration(border: Border.all(width: 0.1), borderRadius: BorderRadius.circular(20), color: Colors.grey[100]),
                                                alignment: Alignment.center,
                                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                  Expanded(
                                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                                    Text(tr('Language:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                    Text(profileData!['individual_languages'][index][lang == "ar" ? 'language_name_ar' : "language_name_en"],
                                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                    Text(tr('Level:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                    Text(profileData!['individual_languages'][index]['level'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                    Text(tr('Read:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                    Text(profileData!['individual_languages'][index]['read'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                    Text(tr('Speak:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                    Text(profileData!['individual_languages'][index]['speak'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                    Text(tr('Write:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                                    Text(profileData!['individual_languages'][index]['write'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                                  ]))
                                                ]));
                                          }))
                                  : SizedBox(),
                            ]),
                          )),
                      SizedBox(height: 20),
                    ]))));
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
                        Text(
                          "Something went wrong, please try again.",
                          textAlign: TextAlign.center,
                        ).tr(),
                        TextButton(onPressed: () => Get.back(), child: Text('Retry').tr())
                      ]))));
        }
      });
}
