
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wathefty/Pages/individual/company_page.dart';
import '../../API.dart';
import '../../functions.dart';
import '../../main.dart';

class VisitorsPage extends StatefulWidget {
  @override
  _VisitorsPageState createState() => _VisitorsPageState();
}

class _VisitorsPageState extends State<VisitorsPage> {
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
              appBar: watheftyBar(context, "Visitors", 18),
              bottomNavigationBar: watheftyBottomBar(context),
              body: FutureBuilder<List>(
                  future: getVisitors(),
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
                                                Get.to(() => ViewCompany(companyId: snapshot.data![index]['company_id'].toString()));
                                              },
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.symmetric(vertical: 10),
                                                  decoration:
                                                      BoxDecoration(color: Colors.grey[50], border: Border.all(color: hexStringToColor('#eeeeee')), borderRadius: BorderRadius.all(Radius.zero)),
                                                  child: Row(children: [
                                                    Container(
                                                        margin: EdgeInsets.only(right: lang == 'ar' ? 0 : 15, left: lang == 'ar' ? 15 : 0),
                                                        height: 110,
                                                        width: 110,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image: NetworkImage(snapshot.data![index]['company_image'] ??
                                                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png'),
                                                                fit: BoxFit.fill),
                                                            color: Colors.grey[50],
                                                            border: Border.all(color: Colors.transparent),
                                                            borderRadius: BorderRadius.all(Radius.zero))),
                                                    Flexible(
                                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                      Text(lang == "ar" ? snapshot.data![index]['company_name_ar'] : snapshot.data![index]['company_name_en'],
                                                          style: TextStyle(fontWeight: FontWeight.bold)),
                                                      Text(snapshot.data![index]['company_email'] ?? "", style: TextStyle(fontWeight: FontWeight.bold)),
                                                      Text(
                                                          lang == "ar"
                                                              ? ((snapshot.data![index]['company_country_ar'] ?? "") + " - " + (snapshot.data![index]['company_region_ar']))
                                                              : ((snapshot.data![index]['company_country_en'] ?? "") + " - " + (snapshot.data![index]['company_region_en'])),
                                                          style: TextStyle(fontWeight: FontWeight.bold)),
                                                      Text(tr("Last view: ") + (snapshot.data![index]['latest_view'] ?? ""), style: TextStyle(fontWeight: FontWeight.bold)),
                                                    ]))
                                                  ])));
                                        })))
                            : SizedBox()
                      ]);
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Scaffold(backgroundColor: Colors.white, body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
                    } else {
                      return Center(
                          child: Container(
                              padding: EdgeInsets.all(50),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                Text("You have no visitors, try updating your profile!", textAlign: TextAlign.center).tr(),
                                TextButton(
                                    onPressed: () async {
                                      Get.back();
                                    },
                                    child: Text('Go back').tr())
                              ])));
                    }
                  }));
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
                              Get.offAll(() => StartPage());
                            },
                            child: Text('Retry').tr())
                      ]))));
        }
      });
}
