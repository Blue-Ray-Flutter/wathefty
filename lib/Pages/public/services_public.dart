import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wathefty/API.dart';
import '../../functions.dart';
import 'service_page.dart';

class PublicServices extends StatefulWidget {
  @override
  State<PublicServices> createState() => _PublicServicesState();
  const PublicServices({
    Key? key,
  }) : super(key: key);
}

class _PublicServicesState extends State<PublicServices> {
  @override
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
         
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: watheftyBar(context, "Service", 20),
              bottomNavigationBar: watheftyBottomBar(context),
              body: FutureBuilder<Map>(
                  future: publicServices(lang),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (ctx, index) {
                            return GestureDetector(
                                onTap: () {
                                  Get.to(() => ServicePage(status: 1, id: snapshot.data![index]['id']));
                                },
                                child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                    padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 5),
                                    decoration:
                                        BoxDecoration(border: Border.all(width: 0.025), borderRadius: BorderRadius.circular(20), color: Colors.grey[50]),
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
                                        ]))
                                      ])
                                    ])));
                          });
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(heightFactor: 4, child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                    } else {
                      return Center(child: Text('No results').tr());
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
