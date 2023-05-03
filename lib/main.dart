import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wathefty/Pages/company/home.dart';
import 'package:wathefty/Pages/public/course_list.dart';
import 'package:wathefty/Pages/public/filter_drivers.dart';
import 'package:wathefty/Pages/public/filter_individuals.dart';
import 'package:wathefty/Pages/public/filter_page.dart';
import 'package:wathefty/Pages/public/filter_security.dart';
import 'package:wathefty/Pages/individual/home.dart';
import 'package:wathefty/Pages/public/news.dart';
import 'package:wathefty/Pages/public/services_public.dart';
import 'package:wathefty/Pages/public/whatsapp_groups.dart';
import 'Pages/auth/auth_signup.dart';
import 'Pages/auth/auth_login.dart';
import 'Pages/public/filters_handicraft.dart';
import 'Pages/public/guest_job_list.dart';
import 'Pages/public/selected_jobs.dart';
import 'functions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // OneSignal.shared.setAppId("6bf64cfd-6c76-4b69-ab17-de49545f381c");
  OneSignal.shared.setAppId("b54fc97e-accd-41ca-a598-6dd7722dc528");
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {});
  await getID();
  runApp(
    EasyLocalization(supportedLocales: [Locale('en'), Locale('ar')], path: 'assets', fallbackLocale: Locale('en'), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  lang = context.locale.toString();
    return GetMaterialApp(
      title: 'wathefty',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.grey, primaryColorDark: Colors.grey, scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
      home: StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    updateCheck(context);
  }

  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isEmpty) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                  toolbarHeight: 80,
                  centerTitle: true,
                  backgroundColor: hexStringToColor('#6986b8'),
                  elevation: 1,
                  shadowColor: Colors.white,
                  title: Container(
                      height: 80,
                      width: getWH(context, 2),
                      child: Stack(fit: StackFit.passthrough, children: <Widget>[
                        Center(
                            heightFactor: 3.5,
                            child: Image.asset(
                              'assets/logo.png',
                              fit: BoxFit.contain,
                            )),
                        Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: IconButton(
                              icon: Icon(
                                Icons.language,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                selectLanguage(context);
                              },
                            )),
                      ]))),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(color: hexStringToColor('#6986b8')),
                        child: Column(children: [
                          Container(
                              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                              alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                              child: Text('Find the job', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)).tr()),
                          Container(
                              margin: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                              alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                              child: Text('of your dreams', style: TextStyle(color: Colors.white, fontSize: 22)).tr()),
                          Container(
                              margin: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
                              width: getWH(context, 2),
                              height: getWH(context, 1) * 0.06,
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0), side: BorderSide(color: Colors.white))),
                                  onPressed: () {
                                    Get.to(() => FilterPage());
                                  },
                                  child: Row(children: [Icon(Icons.search), SizedBox(width: 10), Text("What are you looking for?", style: TextStyle(color: Colors.blueGrey)).tr()]))),
                          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                            Container(
                                margin: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
                                width: getWH(context, 2) * 0.3,
                                height: getWH(context, 1) * 0.06,
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0), side: BorderSide(color: Colors.white))),
                                    onPressed: () {
                                      Get.to(() => GuestPage());
                                    },
                                    child: Text("Search", style: TextStyle(color: Color.fromRGBO(60, 67, 118, 1))).tr()))
                          ]),
                          SizedBox(height: 20)
                        ])),
                    Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                            width: getWH(context, 2) * 0.9,
                            child: Row(children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () async {
                                    Get.to(() => RegisterPage());
                                  },
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.symmetric(vertical: getWH(context, 1) * 0.025),
                                      primary: Colors.white,
                                      backgroundColor: Colors.grey[100],
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0), side: BorderSide(width: 0.2, color: Colors.black))),
                                  child: Text('Sign up', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey[700])).tr(),
                                ),
                              )
                            ])),
                        Container(
                            width: getWH(context, 2) * 0.9,
                            margin: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 30),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                          padding: EdgeInsets.symmetric(vertical: getWH(context, 1) * 0.025),
                                          primary: Colors.white,
                                          backgroundColor: hexStringToColor('#6986b8'),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0), side: BorderSide(width: 0.2, color: Colors.black))),
                                      onPressed: () async {
                                        Get.to(() => LoginPage());
                                      },
                                      child: Text(
                                        'Log in',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                                      ).tr()),
                                ),
                              ],
                            )),
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        width: getWH(context, 2),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Browse our jobs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)).tr(),
                          SizedBox(height: 5),
                          GestureDetector(
                              child: Text('See more filters', style: TextStyle(fontWeight: FontWeight.bold, color: hexStringToColor('#6986b8'))).tr(),
                              onTap: () async {
                                Get.to(() => FilterPage());
                              }),
                          Divider(color: Colors.transparent),
                          GestureDetector(
                              child: Text("Today's Jobs", style: TextStyle(color: hexStringToColor('#6986b8'))).tr(),
                              onTap: () {
                                Get.to(() => SelectedJobsPage(label: "Today's Jobs", type: '1'));
                              }),
                          Divider(),
                          GestureDetector(
                              child: Text("Multinational Company Jobs", style: TextStyle(color: hexStringToColor('#6986b8'))).tr(),
                              onTap: () {
                                Get.to(() => SelectedJobsPage(label: "Multinational Company Jobs", type: '2'));
                              }),
                          Divider(),
                          GestureDetector(
                              child: Text("Gulf Jobs", style: TextStyle(color: hexStringToColor('#6986b8'))).tr(),
                              onTap: () {
                                Get.to(() => SelectedJobsPage(label: "Gulf Jobs", type: '3'));
                              }),
                          Divider(),
                          GestureDetector(
                              child: Text('Civil Service Bureau Jobs', style: TextStyle(color: hexStringToColor('#6986b8'))).tr(),
                              onTap: () {
                                Get.to(() => SelectedJobsPage(label: "Civil Service Bureau Jobs", type: '5'));
                              }),
                          Divider(),
                          GestureDetector(
                              child: Text('Military recruitment', style: TextStyle(color: hexStringToColor('#6986b8'))).tr(),
                              onTap: () {
                                Get.to(() => SelectedJobsPage(label: "Military recruitment", type: '4'));
                              }),
                          Divider(color: Colors.transparent),
                          GestureDetector(
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text("See all", style: TextStyle(color: hexStringToColor('#6986b8'), fontSize: 18, fontWeight: FontWeight.bold)).tr(),
                                Icon(Icons.chevron_right, color: hexStringToColor('#6986b8'), size: 40)
                              ]),
                              onTap: () {
                                Get.to(() => GuestPage());
                              })
                        ])),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        width: getWH(context, 2),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Or recruit new employees', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)).tr(),
                          SizedBox(height: 20),
                          GestureDetector(
                              child: Text("Drivers looking for work", style: TextStyle(fontWeight: FontWeight.bold, color: hexStringToColor('#6986b8'))).tr(),
                              onTap: () {
                                Get.to(() => DriversPage(filters: {}));
                              }),
                          Divider(),
                          GestureDetector(
                              child: Text("Military retirees looking for work", style: TextStyle(fontWeight: FontWeight.bold, color: hexStringToColor('#6986b8'))).tr(),
                              onTap: () {
                                Get.to(() => SecurityPage(filters: {}));
                              }),
                          Divider(),
                          GestureDetector(
                              child: Text("Talent Providers and Handicrafts Job Seekers", style: TextStyle(fontWeight: FontWeight.bold, color: hexStringToColor('#6986b8'))).tr(),
                              onTap: () {
                                Get.to(() => HandicraftPage(filters: null));
                              }),
                          Divider(),
                          GestureDetector(
                              child: Text('Job Seekers and companies', style: TextStyle(fontWeight: FontWeight.bold, color: hexStringToColor('#6986b8'))).tr(),
                              onTap: () {
                                Get.to(() => People());
                              })
                        ])),
                    // Divider(indent: 20, endIndent: 20),
                    SizedBox(height: 45),
                    SizedBox(
                        width: getWH(context, 2) * 0.6, child: Row(children: [const Expanded(child: Divider(thickness: 1)), const Text(" OR ").tr(), const Expanded(child: Divider(thickness: 1))])),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      Column(children: [IconButton(onPressed: () => Get.to(() => NewsPage()), icon: Icon(Icons.history_edu_rounded, color: hexStringToColor('#6986b8'))), Text('News').tr()]),
                      Column(children: [IconButton(onPressed: () => Get.to(() => PublicServices()), icon: Icon(Icons.settings, color: hexStringToColor('#6986b8'))), Text('Services').tr()]),
                      Column(children: [IconButton(onPressed: () => Get.to(() => CourseList()), icon: Icon(Icons.my_library_books, color: hexStringToColor('#6986b8'))), Text('Courses').tr()])
                    ]),
                    GestureDetector(
                        onTap: () => Get.to(() => WhatsappPage()),
                        child: Container(
                            decoration: BoxDecoration(color: Colors.green, border: Border.all(width: 0.2), borderRadius: BorderRadius.all(Radius.circular(15))),
                            width: getWH(context, 2) * 0.7,
                            alignment: Alignment.center,
                            height: getWH(context, 1) * 0.05,
                            margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 35),
                            child: Text('Join us on Whatsapp', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 15)).tr())),
                    Container(
                        child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: CarouselSlider(
                              options: CarouselOptions(autoPlay: true, enlargeCenterPage: true),
                              items: imgList.map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(color: Colors.transparent),
                                      child: ColorFiltered(colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.75), BlendMode.dstATop), child: Image.network(i)),
                                    );
                                  },
                                );
                              }).toList(),
                            ))),
                  ],
                ),
              ));
        } else if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data!['type'] == 'Individual') {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              Get.offAll(() => HomePage());
            });
          } else if (snapshot.data!['type'] == 'Company') {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              Get.offAll(() => CompanyHomePage());
            });
          }
          return SizedBox();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(backgroundColor: Colors.white, body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
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
