import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wathefty/API.dart';
import 'package:wathefty/Pages/individual/job_page.dart';
import '../../functions.dart';

class IndividualMyJobsPage extends StatefulWidget {
  @override
  _IndividualMyJobsPageState createState() => _IndividualMyJobsPageState();
  //   const IndividualMyJobsPage({
  //   Key? key,
  //   required this.jobType,
  // }) : super(key: key);
  // final int jobType;
}

class _IndividualMyJobsPageState extends State<IndividualMyJobsPage> {
  @override
  void initState() {
    super.initState();
  }

  
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          
          return DefaultTabController(
              length: 6,
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                    bottom: PreferredSize(
                        child: TabBar(
                            isScrollable: true,
                            unselectedLabelColor: Colors.white.withOpacity(0.3),
                            indicatorColor: Colors.white,
                            labelColor: Colors.white,
                            tabs: [
                              Tab(child: Text('Applications').tr()),
                              Tab(child: Text('Suitable jobs').tr()),
                              Tab(child: Text('Private jobs').tr()),
                              Tab(child: Text('Saved jobs').tr()),
                              Tab(child: Text('Wishlist').tr()),
                              Tab(child: Text('Liked jobs').tr())
                            ]),
                        preferredSize: Size.fromHeight(30.0)),
                    centerTitle: true,
                    leading: IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back), color: Colors.white),
                    actions: [
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
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
                    title: Text('Jobs', style: TextStyle(color: Colors.white)).tr()),
                bottomNavigationBar: watheftyBottomBar(context),
                body: TabBarView(
                    children: [MyJobs(jobType: 1), MyJobs(jobType: 2), MyJobs(jobType: 3), MyJobs(jobType: 4), MyJobs(jobType: 5), MyJobs(jobType: 6)]),
              ));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
        } else {
          return SizedBox();
        }
      });
}

class MyJobs extends StatefulWidget {
  @override
  State<MyJobs> createState() => _MyJobsState();
  const MyJobs({
    Key? key,
    required this.jobType,
  }) : super(key: key);
  final int jobType;
}

class _MyJobsState extends State<MyJobs> {
  @override
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
         
          return FutureBuilder<Map>(
              future: getMyJobs(snapshot.data!['uid'], 'Individual', lang, widget.jobType, ''),
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
                                Get.to(() => IndividualJobPage(
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
                                                image: snapshot.data![index]['job_image'] != null
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
                                        Text(snapshot.data![index]['job_title'], style: TextStyle(fontWeight: FontWeight.bold)),
                                        SizedBox(height: 5),
                                        Text((snapshot.data![index]['section'] ?? '') + ' - ' + (snapshot.data![index]['specialty'] ?? ''),
                                            style: TextStyle(fontSize: 13)),
                                        Divider(),
                                        Row(children: [
                                          Icon(Icons.location_pin, size: 20),
                                          SizedBox(width: 5),
                                          Flexible(child: Text((snapshot.data![index]['country'] ?? '') + ' - ' + (snapshot.data![index]['region'] ?? '')))
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
                                        child:
                                            Column(children: [Icon(Icons.remove_red_eye), Text(snapshot.data![index]['views'] ?? '0'), SizedBox(height: 60)]))
                                  ])));
                        }),
                  );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(heightFactor: 4, child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                } else {
                  return Center(heightFactor: 4, child: Text('No results').tr());
                }
              });
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              backgroundColor: Colors.white, body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
        } else {
          return SizedBox();
        }
      });
}
