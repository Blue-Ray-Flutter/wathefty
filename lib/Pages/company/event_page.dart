import 'dart:io';
import 'package:better_player/better_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../API.dart';
import '../../functions.dart';
import '../../main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyEventPage extends StatefulWidget {
  @override
  _CompanyEventPageState createState() => _CompanyEventPageState();
  const CompanyEventPage({Key? key, required this.eventId, required this.eventImage}) : super(key: key);
  final String eventId;
  final String eventImage;
}

class _CompanyEventPageState extends State<CompanyEventPage> {
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
    loading = false;
  }

  FilePickerResult? result;
  
  
bool loading = false;
  var uid;
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          loading = false;
          
          uid = snapshot.data!['uid'];
          result = null;
          return Scaffold(
      
              backgroundColor: Colors.white,
              appBar: watheftyBar(context, "Event", 20),
              bottomNavigationBar: watheftyBottomBar(context),
              body: StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
                return FutureBuilder<Map>(
                    future: getCompanyEvents(uid, 'Company', lang, null, widget.eventId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
                        return SingleChildScrollView(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                          Container(
                              child: Column(children: [
                            snapshot.data!['event_video'] != null
                                ? AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: BetterPlayer.network(snapshot.data!['event_video'],
                                        betterPlayerConfiguration: BetterPlayerConfiguration(
                                            autoPlay: false,
                                            fit: BoxFit.scaleDown,
                                            controlsConfiguration: BetterPlayerControlsConfiguration(enableSkips: false))))
                                : Image.network(widget.eventImage),
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
                                        image: DecorationImage(image: NetworkImage(widget.eventImage), fit: BoxFit.fill),
                                        color: Colors.white,
                                        border: Border.all(color: Colors.transparent),
                                        borderRadius: BorderRadius.all(Radius.zero)),
                                  ),
                                  Expanded(
                                    child: Text(lang == 'ar' ? snapshot.data!['event_title_ar'] : snapshot.data!['event_title_en'],
                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                      child: IconButton(
                                        icon: Icon(Icons.attachment, color: hexStringToColor('#6986b8'), size: 40),
                                        onPressed: () async {
                                          var _url = snapshot.data!['event_file'];
                                          await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                        },
                                      ))
                                ])),
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                    color: Colors.grey[50], border: Border.all(width: 0.2), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                height: 140,
                                width: getWH(context, 2),
                                padding: EdgeInsets.all(15),
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Text(lang == 'ar' ? snapshot.data!['event_des_ar'] : snapshot.data!['event_des_en'],
                                        textAlign: TextAlign.start, style: TextStyle(fontSize: 14.0, height: 1.5, color: Colors.blueGrey)))),
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                width: getWH(context, 2),
                                child: Row(children: [
                                  const Expanded(child: Divider(thickness: 2)),
                                  const Text(" Contributions ", style: TextStyle(fontSize: 19.0, color: Colors.blueGrey)).tr(),
                                  const Expanded(child: Divider(thickness: 2))
                                ])),
                                
                            snapshot.data!['company_post_images'].isNotEmpty
                                ? CarouselSlider(
                                    options: CarouselOptions(autoPlay: true, enlargeCenterPage: true, viewportFraction: 1),
                                    items: snapshot.data!['company_post_images'].map<Widget>((i) {
                                      return Container(
                                        decoration: BoxDecoration(color: Colors.transparent),
                                        child: Image.network(i['image']),
                                      );
                                    }).toList(),
                                  )
                                : Text('No images yet').tr(),
                          ])),
                          uid == snapshot.data!['company_id'].toString()
                              ? StatefulBuilder(builder: (BuildContext context, StateSetter setImage) {
                                  return Container(
                                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                      child: Column(children: [
                                        SizedBox(
                                            width: getWH(context, 2),
                                            child: Row(children: [
                                              const Expanded(child: Divider(thickness: 2)),
                                              const Text(" Add More ", style: TextStyle(fontSize: 19.0, color: Colors.blueGrey)).tr(),
                                              const Expanded(child: Divider(thickness: 2))
                                            ])),
                                        SizedBox(height: 30),
                                        StatefulBuilder(builder: (BuildContext context, StateSetter setImage) {
                                          return Row(children: [
                                            Expanded(
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey[50],
                                                        border: Border.all(width: 0.4),
                                                        borderRadius: BorderRadius.all(Radius.circular(25))),
                                                    child: TextButton(
                                                        onPressed: () async {
                                                          result = await FilePicker.platform.pickFiles(type: FileType.image);
                                                          setImage(() {});
                                                        },
                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                          Flexible(
                                                              child: Text(result != null ? result!.files.first.name : '',
                                                                  overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54))),
                                                          Icon(Icons.file_upload_outlined, color: hexStringToColor('#6986b8'))
                                                        ])))),
                                            Container(
                                                margin: EdgeInsets.symmetric(horizontal: 15),
                                                height: 55,
                                                width: 55,
                                                decoration: BoxDecoration(
                                                    border: Border.all(width: 0.025),
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: Colors.grey[50],
                                                    image: DecorationImage(
                                                        fit: BoxFit.contain,
                                                        image: result != null
                                                            ? Image.file(File(result!.files.first.path!)).image
                                                            : AssetImage('assets/logo.png'))))
                                          ]);
                                        }),
                                        !loading
                                            ? GestureDetector(
                                                onTap: () async {
                                                  if (result == null) {
                                                     Get.snackbar(tr('No image selected'), tr('Please pick an image and try again'),
                                                        duration: Duration(seconds: 5),
                                                        backgroundColor: Colors.white,
                                                        colorText: Colors.orange,
                                                        leftBarIndicatorColor: Colors.orange);
                                                    return;
                                                  }
                                                  setImage(() {
                                                    loading = true;
                                                  });
                                                  var img = await addImage(
                                                      'Company', lang, uid, snapshot.data!['event_id'].toString(), File(result!.files.first.path!));
                                                  if (img == false) {
                                                    setImage(() {
                                                      loading = false;
                                                    });
                                                     Get.snackbar(tr('Something went wrong'), tr('Please try again'),
                                                        duration: Duration(seconds: 5),
                                                        backgroundColor: Colors.white,
                                                        colorText: Colors.red,
                                                        leftBarIndicatorColor: Colors.red);
                                                    return;
                                                  }
                                                  _setState(() {
                                                    result = null;
                                                    loading = false;
                                                  });
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: hexStringToColor('#6986b8'),
                                                        border: Border.all(width: 0.2),
                                                        borderRadius: BorderRadius.all(Radius.circular(30))),
                                                    width: getWH(context, 2) * 0.6,
                                                    height: getWH(context, 1) * 0.05,
                                                    margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                                                    alignment: Alignment.center,
                                                    child: Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)).tr()))
                                            : Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()))
                                      ]));
                                })
                              : SizedBox(),
                        ]));
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        return Scaffold(
      
                            backgroundColor: Colors.white,
                            body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
                      } else {
                        return SizedBox();
                      }
                    });
              }));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
      
              backgroundColor: Colors.white, body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
        } else {
          return Scaffold(
      
              backgroundColor: Colors.white,
              body: Center(
                  child: Container(
                      padding: EdgeInsets.all(50),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Text(
                          "Something went wrong, please check your internet and try to log in again.",
                          textAlign: TextAlign.center,
                        ).tr(),
                        TextButton(
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.clear();
                              Get.offAll(() => StartPage());
                            },
                            child: Text('Retry').tr())
                      ]))));
        }
      });
}
