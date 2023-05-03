import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:wathefty/API.dart';
import 'package:wathefty/Pages/public/course_page.dart';
import 'package:wathefty/main.dart';
import '../../functions.dart';
import '../individual/course_requests.dart';

class CourseList extends StatefulWidget {
  @override
  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  @override
  void initState() {
    super.initState();
  }

  
  var j;
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          
          return Scaffold(
              backgroundColor: Colors.white,
              floatingActionButton: globalType == 'Individual'
                  ? SpeedDial(
                      animatedIcon: AnimatedIcons.menu_close,
                      animatedIconTheme: IconThemeData(size: 22.0),
                      curve: Curves.bounceIn,
                      overlayColor: Colors.black,
                      overlayOpacity: 0.5,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 8.0,
                      direction: SpeedDialDirection.up,
                      switchLabelPosition: lang == 'ar' ? true : false,
                      shape: CircleBorder(),
                      children: [
                          SpeedDialChild(
                              child: Icon(Icons.book),
                              backgroundColor: Colors.white,
                              label: tr('Subscription requests'),
                              onTap: () {
                                Get.to(() => IndividualRequestsPage());
                              }),
                          SpeedDialChild(
                              child: Icon(Icons.add_box_outlined),
                              backgroundColor: Colors.white,
                              label: tr('Add request'),
                              onTap: () async {
                                await courseSubscribeRequest(context, lang, snapshot.data!['uid']);
                              })
                        ])
                  : SizedBox(),
              appBar: watheftyBar(context, "Courses", 20),
              bottomNavigationBar: watheftyBottomBar(context),
              body: StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
                return FutureBuilder<List>(
                    future: getInfo('courses', lang, snapshot.data!['uid']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!.isNotEmpty) {
                        j = snapshot.data!;
                        return Container(
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                            width: getWH(context, 2),
                            height: getWH(context, 1) * 0.68,
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
                                                Text(j[index]['days'] + ' / ' + j[index]['hours'], style: TextStyle(fontSize: 13)),
                                                SizedBox(height: 5),
                                                Row(children: [Icon(Icons.access_time, size: 20), SizedBox(width: 5), Flexible(child: Text(j[index]['date']))])
                                              ],
                                            )),
                                          ])));
                                }));
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: Container(margin: EdgeInsets.all(35), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                      } else {
                        return Container(alignment: Alignment.center, margin: EdgeInsets.all(40), child: Text('No courses match your criteria').tr());
                      }
                    });
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
