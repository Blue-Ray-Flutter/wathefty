import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wathefty/API.dart';
import 'package:wathefty/main.dart';
import '../../functions.dart';

class AlertsPage extends StatefulWidget {
  @override
  _AlertsPageState createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  @override
  void initState() {
    super.initState();
  }

  var j;
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: watheftyBar(context, "Saved Alerts", 18),
              bottomNavigationBar: watheftyBottomBar(context),
              body: StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
                return FutureBuilder<Map>(
                    future: saveAlert(1, null),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty && snapshot.data!['saved_alerts_data'].isNotEmpty) {
                        j = snapshot.data!['saved_alerts_data'];
                        return Container(
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                            width: getWH(context, 2),
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: j.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                      padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 5),
                                      decoration: BoxDecoration(border: Border.all(width: 0.025), borderRadius: BorderRadius.circular(20), color: Colors.grey[50]),
                                      child: Column(children: [
                                        Container(
                                            margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                                            child: Text(j![index]['saved_alert_name'], style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 18))),
                                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          Container(
                                              margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                                              child: Text("Active", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 18)).tr()),
                                          Container(
                                              alignment: lang == 'ar' ? Alignment.centerLeft : Alignment.centerRight,
                                              child: IconButton(
                                                  icon: Icon(Icons.delete, color: Colors.red[900]),
                                                  onPressed: () async {
                                                    var remove = await removePrompt(context, "alert", lang, globalType, j[index]['id'].toString());
                                                    if (remove['status'] != null && remove['status'] == true) {
                                                      _setState(() {});
                                                    }
                                                  }))
                                        ]),
                                      ]));
                                }));
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: Container(margin: EdgeInsets.all(35), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                      } else {
                        return Container(alignment: Alignment.center, margin: EdgeInsets.all(40), child: Text('No saved alerts found', style: TextStyle(color: Colors.black)).tr());
                      }
                    });
              }));
        } else if (!snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            Get.offAll(() => StartPage());
          });
          return SizedBox();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(backgroundColor: Colors.white, body: Center(child: Container(margin: EdgeInsets.all(35), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
        } else {
          return Center(child: Text("No results").tr());
        }
      });
}
