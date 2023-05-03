import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wathefty/API.dart';
import '../../../functions.dart';

class WhatsappPage extends StatefulWidget {
  @override
  _WhatsappPageState createState() => _WhatsappPageState();
}

class _WhatsappPageState extends State<WhatsappPage> {
  @override
  void initState() {
    super.initState();
  }

  
  Widget build(BuildContext context) {
    
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: watheftyBar(context, 'Whatsapp Groups', 18),
        body: FutureBuilder<List>(
            future: whatsappGroups(lang),
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
                          return Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey[50], border: Border.all(color: hexStringToColor('#eeeeee')), borderRadius: BorderRadius.all(Radius.zero)),
                              child: ExpandablePanel(
                                  header: Row(children: [
                                    Container(
                                        margin: EdgeInsets.only(right: lang == 'ar' ? 0 : 15, left: lang == 'ar' ? 15 : 0),
                                        height: 110,
                                        width: 110,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: snapshot.data![index]['whatsapp_group_image'] != null
                                                    ? NetworkImage(snapshot.data![index]['whatsapp_group_image'])
                                                    : AssetImage('assets/logo.png') as ImageProvider,
                                                fit: BoxFit.fill),
                                            color: Colors.grey[50],
                                            border: Border.all(color: Colors.transparent),
                                            borderRadius: BorderRadius.all(Radius.zero))),
                                    Flexible(
                                        child: Column(children: [
                                      Text(lang == 'ar' ? snapshot.data![index]['whatsapp_group_name_ar'] : snapshot.data![index]['whatsapp_group_name_en'],
                                          style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 16))
                                    ]))
                                  ]),
                                  collapsed: SizedBox(),
                                  expanded: Column(children: [
                                    Text(
                                        lang == 'ar'
                                            ? snapshot.data![index]['whatsapp_group_description_ar']
                                            : snapshot.data![index]['whatsapp_group_description_en'],
                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                    Divider(),
                                    snapshot.data?[index]['whatsapp_group_url'] != null
                                        ? GestureDetector(
                                            child: Text('Join group', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15)).tr(),
                                            onTap: () async {
                                              if (snapshot.data?[index]['whatsapp_group_url'] != null) {
                                                var _url = snapshot.data?[index]['whatsapp_group_url'];
                                                await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                              }
                                            })
                                        : SizedBox(),
                                    SizedBox(height: 10)
                                  ])));
                        }));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Container(margin: EdgeInsets.all(35), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
              } else {
                return Center(child: Text('No results').tr());
              }
            }));
  }
}
