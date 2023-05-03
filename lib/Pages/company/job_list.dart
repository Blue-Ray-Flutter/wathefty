import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:wathefty/API.dart';
import '../../functions.dart';
import 'job_create.dart';
import 'job_filters.dart';
import 'job_page.dart';

class CompanyJobListPage extends StatefulWidget {
  //1 = regular, 2 = special
  @override
  _CompanyJobListPageState createState() => _CompanyJobListPageState();
  const CompanyJobListPage({
    Key? key,
    required this.jobType,
    this.filters,
  }) : super(key: key);
  final int jobType;
  final Map? filters;
}

class _CompanyJobListPageState extends State<CompanyJobListPage> {
  @override
  void initState() {
    super.initState();
  }

  
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          
          return DefaultTabController(
              length: widget.jobType == 1 ? 5 : 3,
              child: Scaffold(
                floatingActionButton: SpeedDial(
                    animatedIcon: AnimatedIcons.menu_close,
                    animatedIconTheme: IconThemeData(size: 22.0),
                    curve: Curves.bounceIn,
                    overlayColor: Colors.black,
                    overlayOpacity: 0.5,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    buttonSize: const Size(50.0, 50.0),
                    label: Text('Advanced Filters', style: TextStyle(fontSize: 12)).tr(),
                    elevation: 8.0,
                    direction: SpeedDialDirection.up,
                    switchLabelPosition: lang == 'ar' ? true : false,
                    shape: CircleBorder(),
                    children: [
                      SpeedDialChild(
                          child: Icon(Icons.filter_list_sharp),
                          backgroundColor: Colors.white,
                          label: tr("Filters"),
                          onTap: () {
                            Get.to(() => CompanyFilters(type: widget.jobType));
                          }),
                      SpeedDialChild(
                          child: Icon(Icons.clear),
                          backgroundColor: Colors.white,
                          label: tr('Reset'),
                          onTap: () {
                            Get.offAll(() => CompanyJobListPage(jobType: widget.jobType));
                          })
                    ]),
                backgroundColor: Colors.white,
                appBar: AppBar(
                    bottom: PreferredSize(
                        child: TabBar(
                            isScrollable: true,
                            unselectedLabelColor: Colors.white.withOpacity(0.3),
                            indicatorColor: Colors.white,
                            labelColor: Colors.white,
                            tabs: widget.jobType == 1
                                ? [
                                    Tab(child: Text('Active jobs').tr()),
                                    Tab(child: Text('Pending jobs').tr()),
                                    Tab(child: Text('Stopped jobs').tr()),
                                    Tab(child: Text('Rejected jobs').tr()),
                                    Tab(child: Text('Expired jobs').tr())
                                  ]
                                : [Tab(child: Text('Active jobs').tr()), Tab(child: Text('Stopped jobs').tr()), Tab(child: Text('Expired jobs').tr())]),
                        preferredSize: Size.fromHeight(30.0)),
                    centerTitle: true,
                    leading: IconButton(
                        onPressed: () {
                          if (widget.jobType == 1) {
                            Get.offAll(() => CompanyJobListPage(jobType: 2));
                          } else {
                            Get.offAll(() => CompanyJobListPage(jobType: 1));
                          }
                        },
                        icon: Icon(widget.jobType == 1 ? Icons.star : Icons.work),
                        color: Colors.white),
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
                    title: Text(widget.jobType == 1 ? 'Jobs' : 'Special Jobs', style: TextStyle(color: Colors.white)).tr()),
                bottomNavigationBar: watheftyBottomBar(context),
                body: TabBarView(
                  children: widget.jobType == 1
                      ? [
                          Jobs(jobStatus: '2', jobType: 1, filters: widget.filters),
                          Jobs(jobStatus: '1', jobType: 1, filters: widget.filters),
                          Jobs(jobStatus: '4', jobType: 1, filters: widget.filters),
                          Jobs(jobStatus: '3', jobType: 1, filters: widget.filters),
                          Jobs(jobStatus: '6', jobType: 1, filters: widget.filters),
                        ]
                      : [
                          Jobs(jobStatus: '2', jobType: 2, filters: widget.filters),
                          Jobs(jobStatus: '4', jobType: 2, filters: widget.filters),
                          Jobs(jobStatus: '6', jobType: 2, filters: widget.filters),
                        ],
                ),
              ));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              backgroundColor: Colors.white, body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
        } else {
          return SizedBox();
        }
      });
}

class Jobs extends StatefulWidget {
  @override
  State<Jobs> createState() => _JobsState();
  const Jobs({Key? key, required this.jobStatus, required this.jobType, this.filters}) : super(key: key);
  final String jobStatus;
  final int jobType;
  final Map? filters;
}

class _JobsState extends State<Jobs> {
  @override
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
         
          var uid = snapshot.data!['uid'];
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter _setState) {
              return FutureBuilder<Map>(
                  future: getCompanyJobs(uid, 'Company', lang, widget.jobStatus, null, widget.jobType, widget.filters),
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
                              return Column(children: [
                                GestureDetector(
                                    onTap: () async {
                                      Get.to(() => CompanyJobPage(
                                          jobId: snapshot.data![index]['id'].toString(),
                                          jobType: widget.jobType));
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(top: 10),
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
                                            Text(snapshot.data![index]['section'] + ' - ' + snapshot.data![index]['specialty'], style: TextStyle(fontSize: 13)),
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
                                            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                                              Icon(Icons.remove_red_eye),
                                              Text(snapshot.data![index]['views'] ?? '0'),
                                              Icon(Icons.inbox),
                                              Text(snapshot.data![index]['applying'] ?? '0'),
                                            ]))
                                      ]),
                                    )),
                                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                  (widget.jobStatus == '2' || widget.jobStatus == '1') && widget.jobType != 2
                                      ? IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red[900]),
                                          onPressed: () async {
                                            var remove = await removeInfo('job', lang, 'Company', uid, snapshot.data![index]['id'].toString());
                                            if (remove['status'] == true) {
                                              Get.snackbar(remove['msg'], '',
                                                  duration: Duration(seconds: 3),
                                                  backgroundColor: Colors.white,
                                                  colorText: Colors.blueGrey,
                                                  leftBarIndicatorColor: Colors.red);
                                              _setState(() {});
                                            }
                                          },
                                        )
                                      : SizedBox(),
                                  widget.jobStatus == '2'
                                      ? IconButton(
                                          icon: Icon(Icons.desktop_access_disabled),
                                          onPressed: () async {
                                            var stop = await removeInfo('stopJob', lang, 'Company', uid, snapshot.data![index]['id'].toString());
                                            if (stop['status'] == true) {
                                              Get.snackbar(stop['msg'], '',
                                                  duration: Duration(seconds: 3),
                                                  backgroundColor: Colors.white,
                                                  colorText: Colors.blueGrey,
                                                  leftBarIndicatorColor: Colors.red);
                                              _setState(() {});
                                            }
                                          },
                                        )
                                      : SizedBox(),
                                  (widget.jobStatus == '2' || widget.jobStatus == '1') && widget.jobType != 2
                                      ? IconButton(
                                          onPressed: () {
                                            Get.to(() => CompanyCreateJobPage(jobEdit: true, jobId: snapshot.data![index]['id'].toString()));
                                          },
                                          icon: Icon(Icons.edit, color: hexStringToColor('#6986b8')))
                                      : SizedBox(),
                                  widget.jobStatus == '4'
                                      ? IconButton(
                                          icon: Icon(Icons.desktop_mac),
                                          onPressed: () async {
                                            var start = await removeInfo('startJob', lang, 'Company', uid, snapshot.data![index]['id'].toString());
                                            if (start['status'] == true) {
                                              Get.snackbar(start['msg'], '',
                                                  duration: Duration(seconds: 3),
                                                  backgroundColor: Colors.white,
                                                  colorText: Colors.blueGrey,
                                                  leftBarIndicatorColor: Colors.red);
                                              _setState(() {});
                                            }
                                          },
                                        )
                                      : SizedBox(),
                                ]),
                                SizedBox(height: 20)
                              ]);
                            }),
                      );
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(heightFactor: 4, child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                    } else {
                      return Center(heightFactor: 4, child: Text('No results').tr());
                    }
                  });
            },
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              backgroundColor: Colors.white, body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
        } else {
          return SizedBox();
        }
      });
}
