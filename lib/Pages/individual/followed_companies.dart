
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wathefty/Pages/individual/company_page.dart';
import '../../API.dart';
import '../../functions.dart';
import '../../main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndividualFollowersPage extends StatefulWidget {
  @override
  _IndividualFollowersPageState createState() => _IndividualFollowersPageState();
}

class _IndividualFollowersPageState extends State<IndividualFollowersPage> {
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
              appBar: AppBar(
                  centerTitle: true,
                  leading: IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back), color: Colors.white),
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
                            }))
                  ],
                  backgroundColor: hexStringToColor('#6986b8'),
                  elevation: 0,
                  title: Text('Followed Companies', style: TextStyle(color: Colors.white)).tr()),
              bottomNavigationBar: watheftyBottomBar(context),
              body: FutureBuilder<List>(
                  future: getInfo('following', lang, snapshot.data!['uid']),
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
                                                Get.to(() => ViewCompany(companyId: snapshot.data![index]['id'].toString()));
                                              },
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.symmetric(vertical: 10),
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[50],
                                                      border: Border.all(color: hexStringToColor('#eeeeee')),
                                                      borderRadius: BorderRadius.all(Radius.zero)),
                                                  child: Row(children: [
                                                    Container(
                                                        margin: EdgeInsets.only(right: lang == 'ar' ? 0 : 15, left: lang == 'ar' ? 15 : 0),
                                                        height: 110,
                                                        width: 110,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(image: NetworkImage(snapshot.data![index]['img']), fit: BoxFit.fill),
                                                            color: Colors.grey[50],
                                                            border: Border.all(color: Colors.transparent),
                                                            borderRadius: BorderRadius.all(Radius.zero))),
                                                    Flexible(child: Text(snapshot.data![index]['name'], style: TextStyle(fontWeight: FontWeight.bold)))
                                                  ])));
                                        })))
                            : SizedBox()
                      ]);
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
                                  "No results", textAlign: TextAlign.center
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
