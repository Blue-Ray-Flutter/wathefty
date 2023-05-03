import 'package:easy_localization/easy_localization.dart';
import 'dart:math' as math;
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wathefty/Pages/company/branches.dart';
import 'package:wathefty/Pages/company/followers.dart';
import 'package:wathefty/Pages/company/profile.dart';
import 'package:wathefty/Pages/company/savedCV.dart';
import 'package:wathefty/Pages/public/filter_drivers.dart';
import 'package:wathefty/Pages/public/filter_individuals.dart';
import 'package:wathefty/Pages/public/filter_security.dart';
import 'package:wathefty/Pages/public/filters_handicraft.dart';
import 'package:wathefty/Pages/public/messages.dart';
import 'package:wathefty/Pages/public/reviews.dart';
import 'package:wathefty/Pages/public/contact_page.dart';
import 'package:wathefty/Pages/public/service_list.dart';
import 'package:wathefty/Pages/public/services_public.dart';
import '../../functions.dart';
// import '../../main.dart';
import '../public/news.dart';
import 'event_list.dart';
import 'job_create.dart';
import 'job_list.dart';

// class CompanyMenuPage extends StatefulWidget {
//   @override
//   _CompanyMenuPageState createState() => _CompanyMenuPageState();
// }

// class _CompanyMenuPageState extends State<CompanyMenuPage> {
//   @override
//   void initState() {
//     super.initState();
//     loading = false;
//   }

//   bool loading = false;

//   Widget build(BuildContext context) => FutureBuilder<Map>(
//       future: loadUser(),
//       builder: (context, snapshot) {
//         if (globalUid != '0' || snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
//           return Scaffold(
//               backgroundColor: Colors.white,
//               appBar: watheftyBar(context, "Menu", 20),
//               bottomNavigationBar: watheftyBottomBar(context),
//               body: StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
//                 return Column(children: [
//                   Expanded(
//                       child: Container(
//                           width: getWH(context, 2),
//                           child: Drawer(
//                               child: ListView(children: [
//                             ListTile(
//                                 title: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                                 onTap: () {
//                                   Get.offAll(() => CompanyProfilePage());
//                                 }),
//                             Divider(thickness: 2, indent: 18, endIndent: 18),
//                             ListTile(
//                                 title: Text('Messages', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                                 onTap: () {
//                                   Get.to(() => Messages(uType: globalType));
//                                 }),
//                             Divider(thickness: 2, indent: 18, endIndent: 18),
//                             ListTile(
//                                 title: Text('Jobs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                                 onTap: () {
//                                   Get.to(() => CompanyJobListPage(jobType: 1));
//                                 }),
//                             Divider(thickness: 2, indent: 18, endIndent: 18),
//                             ListTile(
//                                 title: Text('Saved Searches & CVs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                                 onTap: () {
//                                   Get.to(() => SavedCVSearches());
//                                 }),
//                             Divider(thickness: 2, indent: 18, endIndent: 18),
//                             ListTile(
//                                 title: Text('Private jobs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                                 onTap: () {
//                                   Get.to(() => CompanyJobListPage(jobType: 2));
//                                 }),
//                             Divider(thickness: 2, indent: 18, endIndent: 18),
//                             ListTile(
//                                 title: Text('Add job', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                                 onTap: () {
//                                   Get.to(() => CompanyCreateJobPage(jobEdit: false, jobId: ''));
//                                 }),
//                             Divider(thickness: 2, indent: 18, endIndent: 18),
//                             ListTile(
//                                 title: Text('Services', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                                 onTap: () {
//                                   Get.to(() => ServicesPage());
//                                 }),
//                             Divider(thickness: 2, indent: 18, endIndent: 18),
//                             ListTile(
//                                 title: Text('Events', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                                 onTap: () {
//                                   Get.to(() => CompanyEventListPage());
//                                 }),
//                             Divider(thickness: 2, indent: 18, endIndent: 18),
//                             ListTile(
//                                 title: Text('Branches', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                                 onTap: () {
//                                   Get.to(() => BranchesPage());
//                                 }),
//                             // Divider(
//                             //   thickness: 2,
//                             //   indent: 18,
//                             //   endIndent: 18,
//                             // ),
//                             // ListTile(
//                             //   title: Text('Advertising Packages',
//                             //           style: TextStyle(
//                             //               fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54))
//                             //       .tr(),
//                             //   onTap: () {
//                             //     Get.to(() => AdvertPackagePage());
//                             //   },
//                             // ),
//                             Divider(thickness: 2, indent: 18, endIndent: 18),
//                             ListTile(
//                                 title: Text('Reviews', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                                 onTap: () {
//                                   Get.to(() => ReviewsPage(companyId: snapshot.data!['uid']));
//                                 }),
//                             Divider(thickness: 2, indent: 18, endIndent: 18),
//                             ListTile(
//                                 title: Text('Followers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                                 onTap: () {
//                                   Get.to(() => CompanyFollowersPage());
//                                 }),
//                             Divider(thickness: 2, indent: 18, endIndent: 18),
//                             ListTile(
//                                 title: Text('News', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                                 onTap: () {
//                                   Get.to(() => NewsPage());
//                                 }),
//                             Divider(thickness: 2, indent: 18, endIndent: 18),
//                             ListTile(
//                                 title: Text('Job Seekers & Companies', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                                 onTap: () {
//                                   Get.to(() => People());
//                                 }),
//                             Divider(thickness: 2, indent: 18, endIndent: 18),
//                             ListTile(
//                                 title: Text('Public Services', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                                 onTap: () {
//                                   Get.to(() => PublicServices());
//                                 }),
//                             Divider(thickness: 2, indent: 18, endIndent: 18),
//                             ListTile(
//                                 title:
//                                     Text('Drivers looking for work', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                                 onTap: () {
//                                   Get.to(() => DriversPage(filters: null));
//                                 }),
//                             Divider(thickness: 2, indent: 18, endIndent: 18),
//                             ListTile(
//                                 title: Text('Military retirees looking for work',
//                                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54))
//                                     .tr(),
//                                 onTap: () {
//                                   Get.to(() => SecurityPage(filters: null));
//                                 }),
//                             Divider(thickness: 2, indent: 18, endIndent: 18),
//                             ListTile(
//                                 title: Text('Talent Providers and Handicrafts Job Seekers',
//                                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54))
//                                     .tr(),
//                                 onTap: () {
//                                   Get.to(() => HandicraftPage(filters: null));
//                                 }),
//                             Divider(thickness: 2, indent: 18, endIndent: 18),
//                             ListTile(
//                                 title: Text('Contact us', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                                 onTap: () {
//                                   Get.to(() => ContactUsPage());
//                                 }),
//                             Divider(thickness: 2, indent: 18, endIndent: 18),
//                             ListTile(
//                                 title: Text('Log out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                                 onTap: () async {
//                                   setState(() => loading = true);
//                                   await logout();
//                                   setState(() => loading = false);
//                                 })
//                           ]))))
//                 ]);
//               }));
//         } else if (snapshot.connectionState == ConnectionState.waiting) {
//           return Scaffold(
//               backgroundColor: Colors.white, body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
//         } else {
//           return Scaffold(
//               backgroundColor: Colors.white,
//               body: Center(
//                   child: Container(
//                       padding: EdgeInsets.all(50),
//                       child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
//                         Text(
//                           "Something went wrong, please check your internet and try to log in again.",
//                           textAlign: TextAlign.center,
//                         ).tr(),
//                         TextButton(
//                             onPressed: () async {
//                               SharedPreferences prefs = await SharedPreferences.getInstance();
//                               prefs.clear();
//                               Get.offAll(() => StartPage());
//                             },
//                             child: Text('Retry').tr())
//                       ]))));
//         }
//       });
// }

class CompanySubMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool loading = false;
    List<Map> items = [
      {"title": "Profile"}, //, "image": "assets/profile.png"},
      {"title": "Jobs"}, //, "image": "assets/search.jpg"},
      {"title": "Job Seekers"}, // "image": "assets/search.jpg"},
      {"title": "Services & Support"} // "image": "assets/search.jpg"},
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: watheftyBar(context, "Menu", 20),
        bottomNavigationBar: watheftyBottomBar(context),
        body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              ExpandableController _controller = ExpandableController();
              return InkWell(
                  highlightColor: hexStringToColor('#6986b8'),
                  child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey[50], border: Border.all(color: hexStringToColor('#eeeeee')), borderRadius: BorderRadius.all(Radius.zero)),
                      child: ExpandableNotifier(
                          child: ScrollOnExpand(
                              child: ExpandablePanel(
                                  controller: _controller,
                                  theme: const ExpandableThemeData(
                                      headerAlignment: ExpandablePanelHeaderAlignment.center, tapBodyToExpand: true, tapBodyToCollapse: true, hasIcon: false),
                                  header: Container(
                                      height: 50,
                                      color: hexStringToColor('#6986b8'),
                                      child: Row(children: [
                                        Expanded(
                                            child: Text(items[index]["title"],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 17))
                                                .tr()),
                                        ExpandableIcon(
                                            theme: const ExpandableThemeData(
                                                expandIcon: Icons.arrow_right,
                                                collapseIcon: Icons.arrow_drop_down,
                                                iconColor: Colors.white,
                                                iconSize: 28.0,
                                                iconRotationAngle: math.pi / 2,
                                                iconPadding: EdgeInsets.only(right: 5),
                                                hasIcon: false))
                                      ])),
                                  collapsed: SizedBox(),
                                  expanded: SingleChildScrollView(
                                      child: Column(children: [
                                    if (index == 0) ...[
                                      ListTile(
                                          title: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                          onTap: () {
                                            Get.offAll(() => CompanyProfilePage());
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title: Text('Messages', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                          onTap: () {
                                            Get.to(() => Messages(uType: globalType));
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title: Text('Branches', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                          onTap: () {
                                            Get.to(() => BranchesPage());
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title: Text('Reviews', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                          onTap: () {
                                            Get.to(() => ReviewsPage(companyId: globalUid));
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title: Text('Followers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                          onTap: () {
                                            Get.to(() => CompanyFollowersPage());
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      StatefulBuilder(builder: (BuildContext context, StateSetter setLogOut) {
                                        return !loading
                                            ? ListTile(
                                                title: Text('Log out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                                onTap: () async {
                                                  setLogOut(() => loading = true);
                                                  await logout();
                                                  setLogOut(() => loading = false);
                                                })
                                            : Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                                      })
                                    ] else if (index == 1) ...[
                                      ListTile(
                                          title: Text('Jobs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                          onTap: () {
                                            Get.to(() => CompanyJobListPage(jobType: 1));
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title: Text('Private jobs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                          onTap: () {
                                            Get.to(() => CompanyJobListPage(jobType: 2));
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title: Text('Add job', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                          onTap: () {
                                            Get.to(() => CompanyCreateJobPage(jobEdit: false, jobId: ''));
                                          }),
                                    ] else if (index == 2) ...[
                                      ListTile(
                                          title: Text('Job Seekers & Companies',
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54))
                                              .tr(),
                                          onTap: () {
                                            Get.to(() => People());
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title:
                                              Text('Saved Searches & CVs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54))
                                                  .tr(),
                                          onTap: () {
                                            Get.to(() => SavedCVSearches());
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title: Text('Drivers looking for work',
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54))
                                              .tr(),
                                          onTap: () {
                                            Get.to(() => DriversPage(filters: null));
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title: Text('Military retirees looking for work',
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54))
                                              .tr(),
                                          onTap: () {
                                            Get.to(() => SecurityPage(filters: null));
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title: Text('Talent Providers and Handicrafts Job Seekers',
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54))
                                              .tr(),
                                          onTap: () {
                                            Get.to(() => HandicraftPage(filters: null));
                                          }),
                                    ] else if (index == 3) ...[
                                      ListTile(
                                          title: Text('My Services', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                          onTap: () {
                                            Get.to(() => ServicesPage());
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title: Text('Events', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                          onTap: () {
                                            Get.to(() => CompanyEventListPage());
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title:
                                              Text('Public Services', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                          onTap: () {
                                            Get.to(() => PublicServices());
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title: Text('News', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                          onTap: () {
                                            Get.to(() => NewsPage());
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title: Text('Contact us', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                          onTap: () {
                                            Get.to(() => ContactUsPage());
                                          }),
                                    ] else
                                      SizedBox(),
                                  ])))))),
                  onTap: () {
                    _controller.toggle();
                  });
            }));
  }
}
