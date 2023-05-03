import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wathefty/Pages/company/home.dart';
import 'package:wathefty/Pages/company/job_page.dart';
import 'package:wathefty/Pages/individual/home.dart';
import 'package:wathefty/Pages/individual/job_page.dart';
import 'API.dart';
import 'Pages/public/individual_profile.dart';
import 'functions.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
  const NotificationPage({Key? key, required this.uType}) : super(key: key);
  final String uType;
}

class _NotificationPageState extends State<NotificationPage> {
  RefreshController _refreshController1 = RefreshController(initialRefresh: false);
  RefreshController _refreshController2 = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController1.refreshCompleted();
    _refreshController2.refreshCompleted();
    setState(() {});
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) setState(() {});
    _refreshController1.loadComplete();
    _refreshController2.loadComplete();
  }

  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                  centerTitle: true,
                  leading: IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back), color: Colors.white),
                  backgroundColor: hexStringToColor('#6986b8'),
                  elevation: 0,
                  title: Text('Notifications', style: TextStyle(fontSize: 20, color: Colors.white)).tr(),
                  actions: <Widget>[
                    GestureDetector(
                        child: Container(
                            margin: EdgeInsets.only(right: 25, left: 25),
                            alignment: Alignment.center,
                            child: Text(tr('Clear'),
                                style: TextStyle(
                                    shadows: [Shadow(color: Colors.white, offset: Offset(0, -5))],
                                    color: Colors.transparent,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                    decorationThickness: 2,
                                    decorationStyle: TextDecorationStyle.solid,
                                    fontSize: 15))),
                        onTap: () async {
                          await clearNotifs(snapshot.data!['uid'], lang, widget.uType);
                          setState(() {});
                          Get.snackbar('Cleared all notifications', '', backgroundColor: Colors.white);
                        })
                  ]),
              body: SmartRefresher(
                enablePullDown: true,
                header: WaterDropHeader(),
                controller: _refreshController1,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: Container(
                    padding: EdgeInsets.all(32),
                    child: FutureBuilder<Map>(
                      future: getNotifications(lang, widget.uType, '2'),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.data!['notification_details'] != null &&
                            snapshot.data!['notification_details'].isNotEmpty) {
                          List data = snapshot.data!['notification_details'];
                          return SmartRefresher(
                              enablePullDown: true,
                              header: WaterDropHeader(),
                              controller: _refreshController2,
                              onRefresh: _onRefresh,
                              onLoading: _onLoading,
                              child: ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                        onTap: () {
                                          if (data[index]['type'] == 'Job' && widget.uType == 'Company') {
                                            Get.to(() => (CompanyJobPage(jobId: data[index]['base_id'].toString(), jobType: 1)));
                                          } else if (data[index]['type'] == 'Job' && widget.uType == 'Individual') {
                                            Get.to(() => (IndividualJobPage(jobId: data[index]['base_id'].toString(), jobType: 'Normal Job')));
                                          } else if (data[index]['type'] == 'Special Job') {
                                            if (widget.uType == 'Company') {
                                              Get.to(() => CompanyJobPage(jobId: data[index]['base_id'].toString(), jobType: 2));
                                            } else {
                                              Get.to(() => (IndividualJobPage(jobId: data[index]['base_id'].toString(), jobType: 'Special Job')));
                                            }
                                          } else if ((data[index]['type'] == 'Apply' || data[index]['type'] == 'Follow up of The Company') &&
                                              widget.uType == 'Company') {
                                            Get.to(() => IndividualProfile(iid: data[index]['base_id'].toString()));
                                          }
                                        },
                                        child: Container(
                                            margin: EdgeInsets.symmetric(vertical: 10),
                                            padding: EdgeInsets.symmetric(vertical: 20),
                                            decoration: BoxDecoration(
                                                color: Color.fromRGBO(244, 244, 244, 1),
                                                border: Border.all(color: Color.fromRGBO(202, 202, 202, 1), width: 0.5),
                                                borderRadius: BorderRadius.all(Radius.circular(20))),
                                            child: ListTile(
                                              leading: Icon(Icons.notifications),
                                              title: Text(data[index]['notification_body'] ?? tr('No message')),
                                              subtitle: Text(data[index]['notification_date'].substring(0, 9)),
                                            )));
                                  }));
                        } else if (snapshot.connectionState == ConnectionState.waiting) {
                          return Scaffold(
                              backgroundColor: Colors.white,
                              body: Center(
                                  child:
                                      Container(color: Colors.transparent, constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
                        } else {
                          return Scaffold(
                              backgroundColor: Colors.white,
                              body: Center(
                                  child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('No notifications').tr(),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextButton(
                                        style: TextButton.styleFrom(
                                          primary: Colors.black,
                                          backgroundColor: hexStringToColor('#6986b8'),
                                          onSurface: Colors.grey,
                                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                          shape: (RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.white))),
                                        ),
                                        onPressed: () {
                                          if (globalType == 'Individual') {
                                            Get.offAll(HomePage());
                                          } else if (globalType == 'Company') {
                                            Get.offAll(CompanyHomePage());
                                          }
                                        },
                                        child: SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.6,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: SizedBox(),
                                                ),
                                                Flexible(
                                                  flex: 4,
                                                  child: Text(
                                                    "Go back",
                                                    style: TextStyle(letterSpacing: 1, fontSize: 19.0, fontWeight: FontWeight.bold, color: Colors.white),
                                                  ).tr(),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: SizedBox(),
                                                ),
                                                Flexible(
                                                  child: Icon(
                                                    Icons.arrow_right_alt,
                                                    color: Colors.white,
                                                  ),
                                                  flex: 1,
                                                )
                                              ],
                                            ))),
                                  ],
                                ),
                              )));
                        }
                      },
                    )),
              ));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              backgroundColor: Colors.white, body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
        } else {
          return SizedBox();
        }
      });
}
