import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:wathefty/Pages/individual/driver_form.dart';
import 'package:wathefty/Pages/individual/personal_skills.dart';
import 'package:wathefty/Pages/individual/profile.dart';
import 'package:wathefty/Pages/individual/saved.dart';
import 'package:wathefty/Pages/individual/security_form.dart';
import 'package:wathefty/Pages/individual/visitors.dart';
import 'package:wathefty/Pages/public/filter_drivers.dart';
import 'package:wathefty/Pages/public/filter_individuals.dart';
import 'package:wathefty/Pages/public/filter_security.dart';
import 'package:wathefty/Pages/public/filters_handicraft.dart';
import 'package:wathefty/Pages/public/gallery.dart';
import 'package:wathefty/Pages/public/join_us.dart';
import 'package:wathefty/Pages/public/messages.dart';
import 'package:wathefty/Pages/public/services_public.dart';
import 'package:wathefty/Pages/public/tips.dart';
// import 'package:wathefty/main.dart';
import '../../functions.dart';
import '../public/contact_page.dart';
import '../public/news.dart';
import '../public/course_list.dart';
import 'followed_companies.dart';
import 'followed_jobs.dart';
import 'my_jobs.dart';
import '../public/service_list.dart';
import 'dart:math' as math;

// class IndivMenuPage extends StatefulWidget {
//   @override
//   _IndivMenuPageState createState() => _IndivMenuPageState();
// }

// class _IndivMenuPageState extends State<IndivMenuPage> {
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
//             backgroundColor: Colors.white,
//             appBar: watheftyBar(context, "Menu", 20),
//             bottomNavigationBar: watheftyBottomBar(context),
//             body: StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
//               return Column(children: [
//                 Expanded(
//                     child: Container(
//                   width: getWH(context, 2),
//                   child: Drawer(
//                     child: ListView(children: [
//                       ListTile(
//                           title: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                           onTap: () {
//                             Get.offAll(() => IndivProfilePage());
//                           }),
//                       Divider(thickness: 2, indent: 18, endIndent: 18),
//                       ListTile(
//                           title: Text('Applications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                           onTap: () {
//                             Get.to(() => IndividualMyJobsPage());
//                           }),
//                       Divider(thickness: 2, indent: 18, endIndent: 18),
//                       ListTile(
//                           title: Text('Messages', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                           onTap: () {
//                             Get.to(() => Messages(uType: globalType));
//                           }),
//                       Divider(thickness: 2, indent: 18, endIndent: 18),
//                       ListTile(
//                           title: Text('My Services', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                           onTap: () {
//                             Get.to(() => ServicesPage());
//                           }),
//                       Divider(thickness: 2, indent: 18, endIndent: 18),
//                       ListTile(
//                           title: Text('Saved Searches', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                           onTap: () {
//                             Get.to(() => SavedSearches());
//                           }),
//                       Divider(thickness: 2, indent: 18, endIndent: 18),
//                       ListTile(
//                           title: Text('Profile Visitors', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                           onTap: () {
//                             Get.to(() => VisitorsPage());
//                           }),
//                       Divider(thickness: 2, indent: 18, endIndent: 18),
//                       ListTile(
//                           title: Text('News', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                           onTap: () {
//                             Get.to(() => NewsPage());
//                           }),
//                       Divider(thickness: 2, indent: 18, endIndent: 18),
//                       ListTile(
//                           title: Text('Training Courses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                           onTap: () {
//                             Get.to(() => CourseList());
//                           }),
//                       Divider(thickness: 2, indent: 18, endIndent: 18),
//                       ListTile(
//                           title: Text('Personal Skills', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                           onTap: () {
//                             Get.to(() => IndividualSkillsPage());
//                           }),
//                       Divider(thickness: 2, indent: 18, endIndent: 18),
//                       ListTile(
//                           title:
//                               Text('Apply for a Smart-App Driver position', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54))
//                                   .tr(),
//                           onTap: () {
//                             Get.to(() => IndividualDriverPage());
//                           }),
//                       Divider(thickness: 2, indent: 18, endIndent: 18),
//                       ListTile(
//                           title:
//                               Text('Apply for a Security job (Discharged)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54))
//                                   .tr(),
//                           onTap: () {
//                             Get.to(() => IndividualSecurityPage());
//                           }),
//                       Divider(thickness: 2, indent: 18, endIndent: 18),
//                       ListTile(
//                           title: Text('Job Seekers & Companies', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                           onTap: () {
//                             Get.to(() => People());
//                           }),
//                       Divider(thickness: 2, indent: 18, endIndent: 18),
//                       ListTile(
//                           title: Text('Public Services', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                           onTap: () {
//                             Get.to(() => PublicServices());
//                           }),
//                       Divider(thickness: 2, indent: 18, endIndent: 18),
//                       ListTile(
//                           title: Text('Drivers looking for work', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                           onTap: () {
//                             Get.to(() => DriversPage(filters: null));
//                           }),
//                       Divider(thickness: 2, indent: 18, endIndent: 18),
//                       ListTile(
//                           title: Text('Military retirees looking for work', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54))
//                               .tr(),
//                           onTap: () {
//                             Get.to(() => SecurityPage(filters: null));
//                           }),
//                       Divider(thickness: 2, indent: 18, endIndent: 18),
//                       ListTile(
//                           title: Text('Talent Providers and Handicrafts Job Seekers',
//                                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54))
//                               .tr(),
//                           onTap: () {
//                             Get.to(() => HandicraftPage(filters: null));
//                           }),
//                       Divider(thickness: 2, indent: 18, endIndent: 18),
//                       ListTile(
//                           title: Text('Join us', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                           onTap: () {
//                             Get.to(() => JoinUsPage());
//                           }),
//                       Divider(thickness: 2, indent: 18, endIndent: 18),
//                       ListTile(
//                           title: Text('Career Tips', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                           onTap: () {
//                             Get.to(() => TipsPage());
//                           }),
//                       Divider(thickness: 2, indent: 18, endIndent: 18),
//                       ListTile(
//                           title: Text('Contact us', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                           onTap: () {
//                             Get.to(() => ContactUsPage());
//                           }),
//                       Divider(thickness: 2, indent: 18, endIndent: 18),
//                       !loading
//                           ? ListTile(
//                               title: Text('Log out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
//                               onTap: () async {
//                                 setState(() => loading = true);
//                                 await logout();
//                                 setState(() => loading = false);
//                               })
//                           : Center(child: CircularProgressIndicator())
//                     ]),
//                   ),
//                 ))
//               ]);
//             }),
//           );
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

class IndivSubMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool loading = false;
    List<Map> items = [
      {"title": "Profile"}, // "image": "assets/profile.png"},
      {"title": "Jobs & Applications"}, // "image": "assets/search.jpg"},
      {"title": "Job Seekers"}, // "image": "assets/search.jpg"},
      {"title": "Tips & Support"} // "image": "assets/search.jpg"},
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
                                            Get.offAll(() => IndivProfilePage());
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title: Text('Messages', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                          onTap: () {
                                            Get.to(() => Messages(uType: globalType));
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title: Text('Gallery', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                          onTap: () {
                                            Get.to(() => GalleryPage(iid: globalUid, owner: true));
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title:
                                              Text('Profile Visitors', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                          onTap: () {
                                            Get.to(() => VisitorsPage());
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title:
                                              Text('Training Courses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                          onTap: () {
                                            Get.to(() => CourseList());
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title:
                                              Text('Personal Skills', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                          onTap: () {
                                            Get.to(() => IndividualSkillsPage());
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
                                          title: Text('Applications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                          onTap: () {
                                            Get.to(() => IndividualMyJobsPage());
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title: Text('My Services', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                          onTap: () {
                                            Get.to(() => ServicesPage());
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title:
                                              Text('Saved Searches', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                          onTap: () {
                                            Get.to(() => SavedSearches());
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title: Text('Followed Companies', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54))
                                              .tr(),
                                          onTap: () {
                                            Get.to(() => IndividualFollowersPage());
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title:
                                              Text('Followed Company Jobs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54))
                                                  .tr(),
                                          onTap: () {
                                            Get.to(() => IndividualFollowedCopmanyJobs());
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title: Text('Apply for a Smart-App Driver position',
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54))
                                              .tr(),
                                          onTap: () {
                                            Get.to(() => IndividualDriverPage());
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title: Text('Apply for a Security job (Discharged)',
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54))
                                              .tr(),
                                          onTap: () {
                                            Get.to(() => IndividualSecurityPage());
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
                                              Text('Public Services', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                          onTap: () {
                                            Get.to(() => PublicServices());
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
                                          title: Text('News', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                          onTap: () {
                                            Get.to(() => NewsPage());
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title: Text('Join us', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                          onTap: () {
                                            Get.to(() => JoinUsPage());
                                          }),
                                      Divider(thickness: 2, indent: 18, endIndent: 18),
                                      ListTile(
                                          title: Text('Career Tips', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)).tr(),
                                          onTap: () {
                                            Get.to(() => TipsPage());
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
