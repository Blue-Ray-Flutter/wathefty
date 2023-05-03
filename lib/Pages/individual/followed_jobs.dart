import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wathefty/API.dart';
import '../../functions.dart';
import 'job_page.dart';

class IndividualFollowedCopmanyJobs extends StatefulWidget {
  @override
  _IndividualFollowedCopmanyJobsState createState() => _IndividualFollowedCopmanyJobsState();
}

class _IndividualFollowedCopmanyJobsState extends State<IndividualFollowedCopmanyJobs> {
  @override
  void initState() {
    super.initState();
  }

  
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: watheftyBar(context, "Followed Company Jobs", 15),
              bottomNavigationBar: watheftyBottomBar(context),
              body: FutureBuilder<List>(
                  future: selectedJobs(snapshot.data!['uid'], 'Individual', lang, '6'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                        width: getWH(context, 2),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (ctx, index) {
                              return GestureDetector(
                                  onTap: () async {
                                    Get.to(
                                        () => IndividualJobPage(
                                        jobId: snapshot.data![index]['id'].toString(),
                                        jobType: snapshot.data![index]['job_type']));
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
                                                    image: snapshot.data?[index]['job_image'] != null && snapshot.data![index]['job_image'].isNotEmpty
                                                        ? NetworkImage(snapshot.data![index]['job_image'])
                                                        : AssetImage('assets/logo.png') as ImageProvider,
                                                    fit: BoxFit.fill),
                                                color: Colors.grey[50],
                                                border: Border.all(color: Colors.transparent),
                                                borderRadius: BorderRadius.all(Radius.zero))),
                                        Flexible(
                                            child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(lang == 'ar' ? snapshot.data![index]['job_title_ar'] : snapshot.data![index]['job_title_en'],
                                                style: TextStyle(fontWeight: FontWeight.bold)),
                                            SizedBox(height: 5),
                                            Text(
                                                lang == 'ar'
                                                    ? (snapshot.data![index]['job_section_name_ar'] + ' - ' + snapshot.data![index]['job_section_name_ar'])
                                                    : (snapshot.data![index]['job_section_name_en'] + ' - ' + snapshot.data![index]['job_section_name_en']),
                                                style: TextStyle(fontSize: 13)),
                                            Divider(),
                                            Row(children: [
                                              Icon(Icons.location_pin, size: 20),
                                              SizedBox(width: 5),
                                              Flexible(child: Text(snapshot.data![index]['country'] + ' - ' + snapshot.data![index]['region']))
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
                                            child: Column(
                                                children: [Icon(Icons.remove_red_eye), Text(snapshot.data![index]['views'] ?? '0'), SizedBox(height: 60)]))
                                      ])));
                            }),
                      );
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(heightFactor: 4, child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                    } else {
                      return Center(heightFactor: 4, child: Text('No results').tr());
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
