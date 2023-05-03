import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wathefty/API.dart';
import '../../../functions.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  void initState() {
    super.initState();
  }

  

  Widget build(BuildContext context) {
    

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: watheftyBar(context, 'News', 20),
        bottomNavigationBar: watheftyBottomBar(context),
        body: FutureBuilder<List>(
            future: news(lang),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!.isNotEmpty) {
                return Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                    width: getWH(context, 2),
                    child: ListView.builder(
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
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: snapshot.data![index]['news_blog_main_image'] != null
                                                  ? NetworkImage(snapshot.data![index]['news_blog_main_image'])
                                                  : AssetImage('assets/logo.png') as ImageProvider,
                                              fit: BoxFit.fill),
                                          color: Colors.grey[50],
                                          border: Border.all(color: Colors.transparent),
                                          borderRadius: BorderRadius.all(Radius.zero))),
                                  Flexible(
                                      child: Column(children: [
                                    Text(lang == 'ar' ? snapshot.data![index]['news_blog_title_ar'] : snapshot.data![index]['news_blog_title_en'],
                                        style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 16))
                                  ]))
                                ]),
                                  collapsed: SizedBox(),
                                expanded: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(children: [
                                      SizedBox(
                                            height: 150,
                                            child: SingleChildScrollView(
                                                child: Text(
                                                    lang == 'ar' ? snapshot.data![index]['news_blog_des_ar'] : snapshot.data![index]['news_blog_des_en'],
                                                    style: TextStyle(fontWeight: FontWeight.bold)))),
                                        Divider(),
                                        snapshot.data?[index]['news_blog_file'] != null && snapshot.data![index]['news_blog_file'].isNotEmpty
                                          ? GestureDetector(
                                              child:
                                                  Text('Open attachment', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15))
                                                    .tr(),
                                                onTap: () async {
                                                if (snapshot.data?[index]['news_blog_file'] != null) {
                                                  var _url = snapshot.data?[index]['news_blog_file'];
                                                  await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                                } else {
                                                  Get.snackbar(tr("No attachments"), '',
                                                      duration: Duration(seconds: 5),
                                                      backgroundColor: Colors.white,
                                                      colorText: Colors.blueGrey,
                                                      leftBarIndicatorColor: Colors.blueGrey);
                                                }
                                              })
                                          : SizedBox(),
                                      SizedBox(height: 10)
                                      ])),
                              ));
                        }));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Container(margin: EdgeInsets.all(35), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
              } else {
                return Center(child: Text('No news').tr());
              }
            }));
  }
}
