import 'package:better_player/better_player.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wathefty/API.dart';
import '../../functions.dart';

class ServicePage extends StatefulWidget {
  @override
  _ServicePageState createState() => _ServicePageState();
  const ServicePage({Key? key, required this.status, required this.id}) : super(key: key);
  final int status;
  final int id;
}

class _ServicePageState extends State<ServicePage> {
  @override
  void initState() {
    super.initState();
  }

  
  Widget build(BuildContext context) {
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: watheftyBar(context, "Service", 20),
          // bottomNavigationBar: watheftyBottomBar(context),
          body: Service(status: widget.status, id: widget.id)),
    );
  }
}

class Service extends StatefulWidget {
  @override
  State<Service> createState() => _ServiceState();
  const Service({
    Key? key,
    required this.status,
    required this.id,
  }) : super(key: key);
  final int status;
  final int id;
}

class _ServiceState extends State<Service> {
  @override
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
         
          return FutureBuilder<Map>(
              future: getServices(globalUid, 'view', lang, widget.status, widget.id, globalType),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!.isNotEmpty) {
                  Map data = snapshot.data![0];
                  return SingleChildScrollView(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    data['video'] != null
                        ? BetterPlayer.network(data['video'],
                            betterPlayerConfiguration: BetterPlayerConfiguration(
                                autoPlay: false, fit: BoxFit.scaleDown, controlsConfiguration: BetterPlayerControlsConfiguration(enableSkips: false)))
                        : SizedBox(),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.white, border: Border.all(color: hexStringToColor('#eeeeee')), borderRadius: BorderRadius.all(Radius.zero)),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Container(
                              margin: EdgeInsets.only(right: lang == 'ar' ? 0 : 15, left: lang == 'ar' ? 15 : 0),
                              height: 110,
                              width: 110,
                              decoration: BoxDecoration(
                                  image: DecorationImage(image: NetworkImage(data['image']), fit: BoxFit.fill),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.all(Radius.zero))),
                          Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(data['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            Text(data['section_name'], style: TextStyle(fontSize: 13)),
                            Divider(),
                            Row(children: [
                              Icon(Icons.access_time, size: 20),
                              SizedBox(width: 5),
                              Flexible(child: Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(data['created_at']))))
                            ])
                          ]))
                        ])),
                    Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.white, border: Border.all(color: hexStringToColor('#eeeeee')), borderRadius: BorderRadius.all(Radius.zero)),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                          Container(
                              decoration:
                                  BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.2), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              height: 140,
                              width: getWH(context, 2),
                              padding: EdgeInsets.all(15),
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text(data['description'],
                                      textAlign: TextAlign.start, style: TextStyle(fontSize: 14.0, height: 1.5, color: Colors.blueGrey)))),
                          Container(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                            Divider(),
                            Text(tr('Contact email:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)).tr(),
                            Text(data['contact_email'] ?? '', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                            Divider(),
                            Text(tr('Contact phone:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)).tr(),
                            Text(data['contact_phone'] ?? '', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                            Divider(),
                            Text(tr('Contact address:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)).tr(),
                            Text(data['contact_address'] ?? '', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                            Divider(),
                            Text(tr('Contact link:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)).tr(),
                            data['contact_url'] != null
                                ? GestureDetector(
                                    child: Text(data['contact_url'] ?? '', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15)),
                                    onTap: () async {
                                      var _url = data['contact_url'];
                                      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                    })
                                : SizedBox(),
                            Divider(),
                            Text(tr('Attachments:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)).tr(),
                            data['file'] != null
                                ? GestureDetector(
                                    child: Text(data['file'] ?? '', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15)),
                                    onTap: () async {
                                      if (data['file'] != null) {
                                        var _url = data['file'];
                                        await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                      } else {
                                        Get.snackbar(tr("No attachments"), '',
                                            duration: Duration(seconds: 5),
                                            backgroundColor: Colors.white,
                                            colorText: Colors.blueGrey,
                                            leftBarIndicatorColor: Colors.blueGrey);
                                      }
                                    })
                                : SizedBox()
                          ]))
                        ])),
                  ]));
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
