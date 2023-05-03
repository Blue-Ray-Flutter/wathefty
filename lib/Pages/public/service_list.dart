import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:wathefty/API.dart';
import 'package:wathefty/Pages/public/service_add.dart';
import '../../functions.dart';
import 'service_page.dart';

class ServicesPage extends StatefulWidget {
  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  @override
  void initState() {
    super.initState();
  }

  
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          
          return DefaultTabController(
              length: 3,
              child: Scaffold(
                  backgroundColor: Colors.white,
                  floatingActionButton: SpeedDial(
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
                            child: Icon(Icons.event),
                            backgroundColor: Colors.white,
                            label: tr('Add service'),
                            onTap: () {
                              Get.to(() => AddServicePage(id: 0, status: 0));
                            })
                      ]),
                  appBar: AppBar(
                      bottom: PreferredSize(
                          child: TabBar(
                              isScrollable: true,
                              unselectedLabelColor: Colors.white.withOpacity(0.3),
                              indicatorColor: Colors.white,
                              labelColor: Colors.white,
                              tabs: [Tab(child: Text('Active').tr()), Tab(child: Text('Pending').tr()), Tab(child: Text('Rejected').tr())]),
                          preferredSize: Size.fromHeight(30.0)),
                      centerTitle: true,
                      leading: IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back), color: Colors.white),
                      actions: [
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: IconButton(
                                icon: Icon(Icons.language, color: Colors.white),
                                onPressed: () {
                                  selectLanguage(context);
                                }))
                      ],
                      backgroundColor: hexStringToColor('#6986b8'),
                      elevation: 0,
                      title: Text('Services', style: TextStyle(color: Colors.white)).tr()),
                  bottomNavigationBar: watheftyBottomBar(context),
                  body: TabBarView(children: [MyServices(status: 1), MyServices(status: 2), MyServices(status: 3)])));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              backgroundColor: Colors.white, body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
        } else {
          return SizedBox();
        }
      });
}

class MyServices extends StatefulWidget {
  @override
  State<MyServices> createState() => _MyServicesState();
  const MyServices({
    Key? key,
    required this.status,
  }) : super(key: key);
  final int status;
}

class _MyServicesState extends State<MyServices> {
  @override
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
         
          var uid = snapshot.data!['uid'];
          var type = snapshot.data!['type'];
          return StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
            return FutureBuilder<Map>(
                future: getServices(uid, 'view', lang, widget.status, 0, type),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (ctx, index) {
                          return GestureDetector(
                              onTap: () {
                                Get.to(() => ServicePage(status: widget.status, id: snapshot.data![index]['id']));
                              },
                              child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                  padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 5),
                                  decoration: BoxDecoration(border: Border.all(width: 0.025), borderRadius: BorderRadius.circular(20), color: Colors.grey[50]),
                                  child: Column(children: [
                                    Container(
                                        margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                                        child: Text(snapshot.data![index]['title'],
                                            style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 18))),
                                    Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      CircleAvatar(radius: 55, backgroundImage: NetworkImage(snapshot.data![index]['image'])),
                                      SizedBox(width: 15),
                                      Expanded(
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        RichText(
                                            text: TextSpan(children: <TextSpan>[
                                          TextSpan(text: tr('Price: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                          TextSpan(
                                              text: snapshot.data![index]['price'],
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                        ])),
                                        Divider(height: 3),
                                        RichText(
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(children: <TextSpan>[
                                              TextSpan(text: tr('Description: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                              TextSpan(
                                                  text: snapshot.data![index]['description'],
                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                            ])),
                                        Divider(height: 3),
                                        RichText(
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(children: <TextSpan>[
                                              TextSpan(text: tr('Email: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                              TextSpan(
                                                  text: snapshot.data![index]['contact_email'],
                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                            ])),
                                        Divider(height: 3),
                                        RichText(
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(children: <TextSpan>[
                                              TextSpan(text: tr('Phone: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                              TextSpan(
                                                  text: snapshot.data![index]['contact_phone'],
                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                            ])),
                                        Divider(height: 3),
                                        RichText(
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(children: <TextSpan>[
                                              TextSpan(text: tr('Website: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                              TextSpan(
                                                  text: snapshot.data![index]['contact_url'],
                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                            ])),
                                        Divider(height: 3),
                                        RichText(
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(children: <TextSpan>[
                                              TextSpan(text: tr('Date: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                              TextSpan(
                                                  text: DateFormat('yyyy-MM-dd').format(DateTime.parse(snapshot.data![index]['created_at'])),
                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                            ])),
                                        Divider(height: 3),
                                        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                          widget.status == 1 || widget.status == 2
                                              ? IconButton(
                                                  onPressed: () {
                                                    Get.to(() => AddServicePage(status: widget.status, id: snapshot.data![index]['id']));
                                                  },
                                                  icon: Icon(Icons.edit, color: hexStringToColor('#6986b8')))
                                              : SizedBox(),
                                          SizedBox(width: 10),
                                          widget.status == 1 || widget.status == 2
                                              ? IconButton(
                                                  icon: Icon(Icons.delete, color: Colors.red[900]),
                                                  onPressed: () async {
                                                    var remove = await removeInfo('service', lang, type, uid, snapshot.data![index]['id'].toString());
                                                    if (remove['status'] == true) {
                                                      Get.snackbar(remove['msg'], '',
                                                          duration: Duration(seconds: 3),
                                                          backgroundColor: Colors.white,
                                                          colorText: Colors.blueGrey,
                                                          leftBarIndicatorColor: Colors.red);
                                                      _setState(() {});
                                                    }
                                                  })
                                              : SizedBox(),
                                        ])
                                      ]))
                                    ])
                                  ])));
                        });
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(heightFactor: 4, child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                  } else {
                    return Center(heightFactor: 4, child: Text('No results').tr());
                  }
                });
          });
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              backgroundColor: Colors.white, body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
        } else {
          return SizedBox();
        }
      });
}
