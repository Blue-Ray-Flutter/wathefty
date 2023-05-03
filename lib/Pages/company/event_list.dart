import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wathefty/API.dart';
import '../../functions.dart';
import 'event_create.dart';
import 'event_page.dart';

class CompanyEventListPage extends StatefulWidget {
  @override
  _CompanyEventListPageState createState() => _CompanyEventListPageState();
}

class _CompanyEventListPageState extends State<CompanyEventListPage> {
  @override
  void initState() {
    super.initState();
  }

  
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          
          return DefaultTabController(
              length: 2,
              child: Scaffold(
                backgroundColor: Colors.white,
                floatingActionButton: FloatingActionButton(
                    heroTag: "btn5",
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    onPressed: () {
                      Get.to(() => CompanyCreateEventPage(eventEdit: false, eventId: ''));
                    },
                    child: Icon(Icons.event, color: Colors.blueGrey)),
                appBar: AppBar(
                    bottom: PreferredSize(
                        child: TabBar(
                            isScrollable: true,
                            unselectedLabelColor: Colors.white.withOpacity(0.3),
                            indicatorColor: Colors.white,
                            labelColor: Colors.white,
                            tabs: [Tab(child: Text('Active events').tr()), Tab(child: Text('Inactive events').tr())]),
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
                    title: Text('Events', style: TextStyle(color: Colors.white)).tr()),
                bottomNavigationBar: watheftyBottomBar(context),
                body: TabBarView(
                  children: [Events(eventStatus: '1'), Events(eventStatus: '2')],
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

class Events extends StatefulWidget {
  @override
  State<Events> createState() => _EventsState();
  const Events({
    Key? key,
    required this.eventStatus,
  }) : super(key: key);
  final String eventStatus;
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
         
          var uid = snapshot.data!['uid'];
          return SingleChildScrollView(
            child: StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
              return FutureBuilder<Map>(
                  future: getCompanyEvents(uid, 'Company', lang, widget.eventStatus, null),
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
                                    Get.to(() =>
                                        CompanyEventPage(eventId: snapshot.data![index]['id'].toString(), eventImage: snapshot.data![index]['event_image']));
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          border: Border.all(color: hexStringToColor('#eeeeee')),
                                          borderRadius: BorderRadius.all(Radius.zero)),
                                      child: Row(children: [
                                        Flexible(
                                            child: Container(
                                                margin: EdgeInsets.only(right: lang == 'ar' ? 0 : 15, left: lang == 'ar' ? 15 : 0),
                                                height: 110,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: snapshot.data![index]['event_image'] != null
                                                            ? NetworkImage(snapshot.data![index]['event_image'])
                                                            : AssetImage('assets/logo.png') as ImageProvider,
                                                        fit: BoxFit.cover),
                                                    color: Colors.grey[50],
                                                    border: Border.all(color: Colors.transparent),
                                                    borderRadius: BorderRadius.all(Radius.zero)))),
                                        Flexible(
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          Text(snapshot.data![index]['event_title'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                          Divider(),
                                          Text(snapshot.data![index]['event_des'], overflow: TextOverflow.ellipsis)
                                        ])),
                                        Expanded(
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                          IconButton(
                                              onPressed: () {
                                                Get.to(() => CompanyCreateEventPage(eventEdit: true, eventId: snapshot.data![index]['id'].toString()));
                                              },
                                              icon: Icon(Icons.edit, color: hexStringToColor('#6986b8'))),
                                          IconButton(
                                            icon: Icon(Icons.delete, color: Colors.red[900]),
                                            onPressed: () async {
                                              var remove = await removeInfo('event', lang, 'Company', uid, snapshot.data![index]['id'].toString());
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
                                        ]))
                                      ])));
                            }),
                      );
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(heightFactor: 4, child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                    } else {
                      return Center(heightFactor: 4, child: Text('No results').tr());
                    }
                  });
            }),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              backgroundColor: Colors.white, body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
        } else {
          return SizedBox();
        }
      });
}
