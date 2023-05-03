import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wathefty/API.dart';
import 'package:wathefty/Pages/public/course_page.dart';
import 'package:wathefty/main.dart';
import '../../functions.dart';

class IndividualRequestsPage extends StatefulWidget {
  @override
  _IndividualRequestsPageState createState() => _IndividualRequestsPageState();
}

class _IndividualRequestsPageState extends State<IndividualRequestsPage> {
  @override
  void initState() {
    super.initState();
  }

  
  
  var j;
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          
          var uid = snapshot.data!['uid'];
          return Scaffold(
      
              backgroundColor: Colors.white,
              appBar: watheftyBar(context, "Pending Requests", 20),
              bottomNavigationBar: watheftyBottomBar(context),
              body: FutureBuilder<List>(
                  future: getInfo('courseRequests', lang, snapshot.data!['uid']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && (snapshot.data != null && snapshot.data!.isNotEmpty)) {
                      j = snapshot.data!;
                      return Container(
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                          width: getWH(context, 2),
                          child: ListView.builder(
                              itemCount: j.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () async {
                                      Get.to(() => CoursePage(courseId: j[index]['id'].toString()));
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
                                                    image: j[index]['img'] != null
                                                        ? NetworkImage(j[index]['img'])
                                                        : AssetImage('assets/logo.png') as ImageProvider,
                                                    fit: BoxFit.fill),
                                                color: Colors.grey[50],
                                                border: Border.all(color: Colors.transparent),
                                                borderRadius: BorderRadius.all(Radius.zero)),
                                          ),
                                          Flexible(
                                              child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(j[index]['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                                              SizedBox(height: 5),
                                              // Text(j[index]['degree'] + ' / ' + j[index]['specialty'], style: TextStyle(fontSize: 13)),
                                              Divider(),
                                              j?[index]['file'] != null
                                                  ? GestureDetector(
                                                      child: Text('Open attachment',
                                                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15))
                                                          .tr(),
                                                      onTap: () async {
                                                        if (j?[index]['file'] != null) {
                                                          var _url = j?[index]['file'];
                                                          await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                                        } else {
                                                          Get.snackbar(tr("No attachments"), '',
                                                              duration: Duration(seconds: 5),
                                                              backgroundColor: Colors.white,
                                                              colorText: Colors.blueGrey,
                                                              leftBarIndicatorColor: Colors.blueGrey);
                                                        }
                                                      })
                                                  : SizedBox(),
                                              // Text(j[index]['days'] + ' / ' + j[index]['hours'], style: TextStyle(fontSize: 13)),
                                              SizedBox(height: 5),
                                              IconButton(
                                                icon: Icon(Icons.delete, color: Colors.red[900]),
                                                onPressed: () async {
                                                  var remove = await removeCourse(uid, 'Individual', lang, j[index]['request'].toString());
                                                  if (remove['status'] == true) {
                                                    setState(() {});
                                                  }
                                                },
                                              )
                                              // Row(children: [Icon(Icons.access_time, size: 20), SizedBox(width: 5), Text(j[index]['date'])])
                                            ],
                                          )),
                                        ])));
                              }));
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: Container(margin: EdgeInsets.all(35), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                    } else {
                      return Center(child: Text('No courses found').tr());
                    }
                  }));
        } else if (!snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            Get.offAll(() => StartPage());
          });
          return SizedBox();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
      
              backgroundColor: Colors.white,
              body: Center(child: Container(margin: EdgeInsets.all(35), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
        } else {
          return SizedBox();
        }
      });
}
