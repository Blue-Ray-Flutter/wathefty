import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../API.dart';
import '../../functions.dart';
import '../../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../public/individual_profile.dart';

class CompanyFollowersPage extends StatefulWidget {
  @override
  _CompanyFollowersPageState createState() => _CompanyFollowersPageState();
}

class _CompanyFollowersPageState extends State<CompanyFollowersPage> {
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
    loading = false;
  }
bool loading = false;

  
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          loading = false;
          

          return Scaffold(
              backgroundColor: Colors.white,
              appBar: watheftyBar(context, "Followers", 20),
              bottomNavigationBar: watheftyBottomBar(context),
              body: FutureBuilder<List>(
                  future: getInfo('followers', lang, snapshot.data!['uid']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
                      return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        snapshot.data!.isNotEmpty
                            ? Expanded(
                                child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                                    width: getWH(context, 2),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return GestureDetector(
                                              onTap: () {
                                                Get.to(() => IndividualProfile(iid: snapshot.data![index]['id'].toString()));
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
                                                              image: snapshot.data![index]['img'] != null
                                                                  ? NetworkImage(snapshot.data![index]['img'])
                                                                  : AssetImage('assets/logo.png') as ImageProvider,
                                                              fit: BoxFit.contain),
                                                          color: Colors.grey[50],
                                                          border: Border.all(color: Colors.transparent),
                                                          borderRadius: BorderRadius.all(Radius.zero)),
                                                    ),
                                                    Flexible(
                                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                      Text(snapshot.data![index]['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                                                      SizedBox(height: 5),
                                                      Text(snapshot.data![index]['section'] + ' - ' + snapshot.data![index]['specialty'],
                                                          style: TextStyle(fontSize: 13)),
                                                      Divider(),
                                                      Row(children: [
                                                        Icon(Icons.location_pin, size: 20),
                                                        SizedBox(width: 5),
                                                        Text(snapshot.data![index]['location'])
                                                      ]),
                                                      SizedBox(height: 5),
                                                      Row(children: [
                                                        Icon(Icons.access_time, size: 20),
                                                        SizedBox(width: 5),
                                                        Text(snapshot.data![index]['phone'])
                                                      ])
                                                    ]))
                                                  ])));
                                        })))
                            : SizedBox()
                      ]);
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                    } else {
                      return Center(
                          child: Container(
                              padding: EdgeInsets.all(50),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                Text(
                                  "There are no followers for this company yet.",
                                  textAlign: TextAlign.center,
                                ).tr(),
                                TextButton(
                                    onPressed: () async {
                                      Get.back();
                                    },
                                    child: Text('Go back').tr())
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
