import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wathefty/Pages/company/job_page.dart';
import '../../../API.dart';
import '../../../functions.dart';
import 'guest_job_page.dart';
import '../individual/job_page.dart';

class SelectedJobsPage extends StatefulWidget {
  const SelectedJobsPage({Key? key, required this.type, required this.label}) : super(key: key);

  @override
  _SelectedJobsPageState createState() => _SelectedJobsPageState();
  final String type;
  final String label;
}

class _SelectedJobsPageState extends State<SelectedJobsPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var type;
          var uid;
          if (snapshot.data!.isNotEmpty) {
            type = snapshot.data!['type'];
            uid = snapshot.data!['uid'];
          }
         
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: watheftyBar(context, widget.label, 15),
              body: FutureBuilder<List>(
                  future: selectedJobs(uid, type, lang, widget.type),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return Container(
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                          width: getWH(context, 2),
                          child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () async {
                                      if (type == 'Company') {
                                        Get.to(() => CompanyJobPage(
                                            jobId: snapshot.data![index]['id'].toString(), jobType: 1));
                                      } else if (type == 'Individual') {
                                        Get.to(() =>
                                            IndividualJobPage(
                                            jobId: snapshot.data![index]['id'].toString(),
                                            jobType: snapshot.data![index]['job_type']));
                                      } else {
                                        Get.to(() => GuestJobPage(jobId: snapshot.data![index]['id'].toString()));
                                      }
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
                                                    image: snapshot.data![index]['job_image'] != null
                                                        ? NetworkImage(snapshot.data![index]['job_image'])
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
                                              Text(lang == 'ar' ? snapshot.data![index]['job_title_ar'] : snapshot.data![index]['job_title_en'],
                                                  style: TextStyle(fontWeight: FontWeight.bold)),
                                              SizedBox(height: 5),
                                              Text(
                                                  lang == 'ar'
                                                      ? (snapshot.data![index]['job_section_name_ar'] + ' - ' + snapshot.data![index]['specialty_name_ar'])
                                                      : (snapshot.data![index]['job_section_name_en'] + ' - ' + snapshot.data![index]['specialty_name_en']),
                                                  style: TextStyle(fontSize: 13)),
                                              Divider(),
                                              Row(children: [
                                                Icon(Icons.location_pin, size: 20),
                                                SizedBox(width: 5),
                                                Text(snapshot.data![index]['country'] + ' - ' + snapshot.data![index]['region'])
                                              ]),
                                              SizedBox(height: 5),
                                              Row(children: [
                                                Icon(Icons.access_time, size: 20),
                                                SizedBox(width: 5),
                                                Text(snapshot.data![index]['submission_deadline'])
                                              ])
                                            ],
                                          )),
                                          Container(
                                              margin: EdgeInsets.symmetric(horizontal: 10),
                                              child: Column(children: [
                                                Icon(Icons.remove_red_eye),
                                                Text(snapshot.data![index]['view_counter'] != null ? snapshot.data![index]['view_counter'].toString() : '0'),
                                                SizedBox(height: 60)
                                              ]))
                                        ])));
                              }));
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: Container(margin: EdgeInsets.all(35), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                    } else {
                      return Center(child: Text('No jobs match your criteria').tr());
                    }
                  }));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              backgroundColor: Colors.white, body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
        } else {
          return SizedBox();
        }
      });
}
