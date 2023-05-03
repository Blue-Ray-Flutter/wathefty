import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../API.dart';
import '../../functions.dart';
import '../public/reviews.dart';
import 'guest_job_page.dart';

class GuestCompanyView extends StatefulWidget {
  @override
  _GuestCompanyViewState createState() => _GuestCompanyViewState();
  const GuestCompanyView({Key? key, required this.companyId}) : super(key: key);
  final String companyId;
}

class _GuestCompanyViewState extends State<GuestCompanyView> {
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
  

  bool loading = false;
  var dflt = 1;
  bool loadingReviews = false;
  bool loadingButton = false;
  bool loading2 = false;
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: getOtherProfile('Guest', context.locale.toString(), widget.companyId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!.isNotEmpty) {
          loadingButton = false;
          loadingReviews = false;
          loading = false;
          profileData = snapshot.data as Map<String, dynamic>?;
          if (profileData!['status'] == true) {
            profileData = profileData!['company'];
            
            return Scaffold(
                backgroundColor: Colors.white,
                appBar: watheftyBar(context, "Company Information", 18),
                bottomNavigationBar: watheftyBottomBar(context),
                body: SmartRefresher(
                    enablePullDown: true,
                    header: WaterDropHeader(),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
                          return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            SizedBox(height: 15),
                            Container(
                                margin: EdgeInsets.all(15),
                                child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                  CircleAvatar(
                                      radius: 45,
                                      backgroundImage: NetworkImage(profileData?['profile_photo_path'] != null
                                          ? profileData!['profile_photo_path']
                                          : "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png")),
                                  SizedBox(width: 10),
                                  Flexible(
                                      child: SizedBox(
                                          height: 130,
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                            SizedBox(height: 30),
                                            Text(lang == 'ar' ? profileData!['name_ar'] : profileData!['name_en'],
                                                style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 15)),
                                            SizedBox(height: 2),
                                            Text(profileData!['country_name'] + ' - ' + profileData!['region_name'],
                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
                                            SizedBox(height: 5),
                                            StatefulBuilder(builder: (BuildContext context, StateSetter setFollow) {
                                              return !loadingButton
                                                  ? SizedBox(
                                                      height: 24,
                                                      width: 60,
                                                      child: TextButton(
                                                          onPressed: () {
                                                            Get.snackbar(tr("Sign up to follow companies!"), '',
                                                                duration: Duration(seconds: 5),
                                                                backgroundColor: Colors.white,
                                                                colorText: Colors.blueGrey,
                                                                leftBarIndicatorColor: Colors.blueGrey);
                                                          },
                                                          child: Text('Follow', style: TextStyle(fontSize: 13)).tr(),
                                                          style: TextButton.styleFrom(
                                                              primary: Colors.white,
                                                              backgroundColor: hexStringToColor('#6986b8'),
                                                              onSurface: Colors.grey,
                                                              alignment: Alignment.center,
                                                              padding: EdgeInsets.only(bottom: 1.0, left: 1))))
                                                  : SizedBox(
                                                      height: 24,
                                                      width: 60,
                                                      child: Center(
                                                          child: Container(constraints: BoxConstraints.tightForFinite(), child: LinearProgressIndicator())));
                                            })
                                          ])))
                                ])),
                            Container(
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(color: Colors.white),
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Container(
                                      margin: EdgeInsets.symmetric(horizontal: 15),
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Text('Information', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 20)).tr(),
                                        GestureDetector(
                                            child: Column(children: [
                                              Text(
                                                  profileData?['companyReviews'].isNotEmpty
                                                      ? profileData!['companyReviews'].length.toString() + tr(' Reviews')
                                                      : 'No reviews',
                                                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                                              Container(
                                                  child: RatingBar.builder(
                                                      initialRating: double.parse(profileData!['companyReviews'].isNotEmpty
                                                          ? profileData!['companyReviews'][0]['review_value'].toString()
                                                          : '0'),
                                                      minRating: 1,
                                                      direction: Axis.horizontal,
                                                      allowHalfRating: true,
                                                      ignoreGestures: true,
                                                      itemSize: 15,
                                                      itemCount: 5,
                                                      itemPadding: EdgeInsets.symmetric(horizontal: 1),
                                                      itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                                                      onRatingUpdate: (rating) {}))
                                            ]),
                                            onTap: () {
                                              Get.to(() => ReviewsPage(companyId: widget.companyId));
                                            })
                                      ])),
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
                                            decoration: BoxDecoration(
                                                border: Border.all(width: 0.025), borderRadius: BorderRadius.circular(20), color: Colors.grey[50]),
                                            padding: EdgeInsets.all(10),
                                            child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Text(lang == 'ar' ? profileData!['company_overview_ar'] : profileData!['company_overview_en'] ?? '',
                                                    style: TextStyle(color: Colors.black, fontSize: 18)))),
                                        Divider(),
                                       Text(tr('Location:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                        Text(profileData!['country_name'] + ' - ' + profileData!['region_name'],
                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                        Divider(),
                                        Text(tr('Phone:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                        Text(profileData?['phone'] ?? '', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                        Divider(),
                                        Text(tr('Address:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                        Text((lang == 'ar' ? profileData!['address_ar'] : profileData!['address_en'] ?? ''),
                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                        Divider(),
                                          Text(tr('Section:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                        Text(profileData!['section'] ?? ' - ',
                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                        Divider(),
                                        Text(tr('Specialty:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                                        Text(profileData!['specialty'] ?? ' - ',
                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
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
                                        Text(
                                            lang == 'ar'
                                                ? (profileData!['general_manager_name_ar'] ?? ' - ')
                                                : (profileData!['general_manager_name_en'] ?? ' - '),
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
                                      ]))
                                ])),
                            profileData?['jobs'] != null && profileData!['jobs'].isNotEmpty
                                ? StatefulBuilder(builder: (BuildContext context, StateSetter _setState2) {
                                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Container(
                                          margin: EdgeInsets.symmetric(horizontal: 30),
                                          child:
                                              Text('Job vacancies', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 20)).tr()),
                                      Container(
                                          color: Colors.white,
                                          margin: EdgeInsets.symmetric(vertical: 10),
                                          height: getWH(context, 1) * 0.35,
                                          width: getWH(context, 2),
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: profileData?['jobs'].length >= 5 ? 5 : profileData?['jobs'].length,
                                              scrollDirection: Axis.vertical,
                                              itemBuilder: (ctx, index) {
                                                return GestureDetector(
                                                    onTap: () async {
                                                      Get.to(() => GuestJobPage(jobId: profileData!['jobs'][index]['id'].toString()));
                                                    },
                                                    child: Container(
                                                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            border: Border.all(color: hexStringToColor('#eeeeee')),
                                                            borderRadius: BorderRadius.all(Radius.zero)),
                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                          Container(
                                                              margin: EdgeInsets.only(right: lang == 'ar' ? 0 : 15, left: lang == 'ar' ? 15 : 0),
                                                              height: 110,
                                                              width: 110,
                                                              decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                      image: NetworkImage(profileData!['jobs'][index]['job_image'] != null
                                                                          ? profileData!['jobs'][index]['job_image']
                                                                          : "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png"),
                                                                      fit: BoxFit.fill),
                                                                  color: Colors.white,
                                                                  border: Border.all(color: Colors.transparent),
                                                                  borderRadius: BorderRadius.all(Radius.zero))),
                                                          Expanded(
                                                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                            Text(
                                                                lang == 'ar'
                                                                    ? profileData!['jobs'][index]['job_title_ar']
                                                                    : profileData!['jobs'][index]['job_title_en'],
                                                                style: TextStyle(fontWeight: FontWeight.bold)),
                                                            SizedBox(height: 5),
                                                            Text(profileData!['jobs'][index]['section'] + ' - ' + profileData!['jobs'][index]['speciality'],
                                                                style: TextStyle(fontSize: 13)),
                                                            Divider(),
                                                            Row(children: [
                                                              Icon(Icons.location_pin, size: 20),
                                                              SizedBox(width: 5),
                                                              Text(profileData!['jobs'][index]['country_name'] +
                                                                  ' - ' +
                                                                  profileData!['jobs'][index]['region_name'])
                                                            ]),
                                                            SizedBox(height: 5),
                                                            Row(children: [
                                                              Icon(Icons.access_time, size: 20),
                                                              SizedBox(width: 5),
                                                              Flexible(child: Text(profileData!['jobs'][index]['submission_deadline']))
                                                            ])
                                                          ])),
                                                          Container(
                                                              margin: EdgeInsets.symmetric(horizontal: 10),
                                                              child: Column(children: [
                                                                Icon(Icons.remove_red_eye),
                                                                Text(profileData!['jobs'][index]['view_counter'] != null
                                                                    ? profileData!['jobs'][index]['view_counter'].toString()
                                                                    : '0'),
                                                                SizedBox(height: 60)
                                                              ]))
                                                        ])));
                                              }))
                                    ]);
                                  })
                                : Container(margin: EdgeInsets.all(30), child: Text('This company does not have any vacancies').tr()),
                            Divider(thickness: 2, indent: 15, endIndent: 15),
                            Container(
                                margin: EdgeInsets.all(30),
                                child: ExpandablePanel(
                                    header: Text('Company Posts', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 19)).tr(),
                                    collapsed: Text('Tap to expand', softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis).tr(),
                                    expanded: profileData?['posts'] != null && profileData?['posts'].isNotEmpty
                                        ? CarouselSlider(
                                            options: CarouselOptions(autoPlay: true, enlargeCenterPage: true),
                                            items: profileData!['posts'].map<Widget>((i) {
                                              DateTime dt = DateTime.parse(i['created_at']);
                                              return Card(
                                                  elevation: 4.0,
                                                  child: new SingleChildScrollView(
                                                      scrollDirection: Axis.vertical,
                                                      child: Column(children: [
                                                        ListTile(
                                                            onTap: () {
                                                              Get.snackbar(tr("Sign up to participate in company posts!"), '',
                                                                  duration: Duration(seconds: 5),
                                                                  backgroundColor: Colors.white,
                                                                  colorText: Colors.blueGrey,
                                                                  leftBarIndicatorColor: Colors.blueGrey);
                                                            },
                                                            contentPadding: EdgeInsets.all(8),
                                                            title: Text(lang == 'ar' ? i['company_post_title_ar'] : i['company_post_title_en']),
                                                            leading: CircleAvatar(
                                                              radius: 50,
                                                              backgroundImage: NetworkImage(i['company_post_main_image'] ??
                                                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png"),
                                                            ),
                                                            subtitle: Text(DateFormat('dd/MM/yyyy - hh:mm a').format(dt))),
                                                        Padding(
                                                            padding: EdgeInsets.all(15),
                                                            child: Text(lang == 'ar' ? i['company_post_des_ar'] : i['company_post_des_en'],
                                                                style: TextStyle(fontSize: 17.0, color: Colors.blueGrey)))
                                                      ])));
                                            }).toList())
                                        : SizedBox(child: Text('No results').tr()))),
                            StatefulBuilder(builder: (BuildContext context, StateSetter setReviews) {
                              return Container(
                                  margin: EdgeInsets.all(30),
                                  child: ExpandablePanel(
                                      header: Text('Reviews', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 19)).tr(),
                                      collapsed: Text('Tap to expand', softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis).tr(),
                                      expanded: profileData?['companyReviews'] != null && profileData?['companyReviews'].isNotEmpty
                                          ? CarouselSlider(
                                              options: CarouselOptions(autoPlay: true, viewportFraction: 1),
                                              items: profileData!['companyReviews'].map<Widget>((i) {
                                                DateTime dt = DateTime.parse(i['created_at']);
                                                return Card(
                                                    elevation: 4.0,
                                                    child: SingleChildScrollView(
                                                        scrollDirection: Axis.vertical,
                                                        child: Column(children: [
                                                          ListTile(
                                                              contentPadding: EdgeInsets.all(8),
                                                              title: Text(i['user_name']),
                                                              leading: CircleAvatar(
                                                                  radius: 50,
                                                                  backgroundImage: NetworkImage(i['user_image'] ??
                                                                      "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png")),
                                                              subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                Text(DateFormat('dd/MM/yyyy - hh:mm a').format(dt)),
                                                                RatingBar.builder(
                                                                    initialRating: double.parse(i['review_value'].toString()),
                                                                    minRating: 1,
                                                                    direction: Axis.horizontal,
                                                                    allowHalfRating: false,
                                                                    itemCount: 5,
                                                                    ignoreGestures: true,
                                                                    itemSize: 15,
                                                                    itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                                                    itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                                                                    onRatingUpdate: (double value) {})
                                                              ])),
                                                          Padding(
                                                              padding: EdgeInsets.all(15),
                                                              child: Text((i?['review_note'] ?? ''), style: TextStyle(fontSize: 17.0, color: Colors.blueGrey)))
                                                        ])));
                                              }).toList(),
                                            )
                                          : SizedBox(height: 100, child: Text('No results').tr())));
                            })
                          ]);
                        }))));
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
                          "This profile is private.",
                          textAlign: TextAlign.center,
                        ).tr(),
                        TextButton(
                            onPressed: () async {
                              Get.back();
                            },
                            child: Text('Go back').tr())
                      ]))));
        }
      });
}
