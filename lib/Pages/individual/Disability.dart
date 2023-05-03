import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wathefty/Pages/individual/profile.dart';
import '../../API.dart';
import '../../functions.dart';
import '../../main.dart';

class DisabilityPage extends StatefulWidget {
  @override
  _DisabilityPageState createState() => _DisabilityPageState();
}

class _DisabilityPageState extends State<DisabilityPage> {
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
    loading = false;
  }

  bool loading = false;
  List<Map<dynamic, dynamic>> mains = [];
  List<Map<dynamic, dynamic>> subs = [];
  final main = TextEditingController();
  final sub = TextEditingController();
  String mainDefault = "";
  String subDefault = "";
  int status = 1;
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          loading = false;
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: watheftyBar(context, "Special Needs", 16),
              bottomNavigationBar: watheftyBottomBar(context),
              body: FutureBuilder<Map>(
                  future: disabilities(1, null),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data!.isNotEmpty) {
                        main.text = snapshot.data!['category_id'].toString();
                        sub.text = snapshot.data!['sub_category_id'].toString();
                        status = int.parse(snapshot.data!['status']);
                        mainDefault = lang == "ar" ? snapshot.data!["category_name_ar"] : snapshot.data!["category_name_en"];
                        subDefault = lang == "ar" ? snapshot.data!["sub_category_name_ar"] : snapshot.data!["sub_category_name_en"];
                      }
                      return SingleChildScrollView(
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                Text('Help employers understand your needs', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)).tr(),
                                Divider(),
                                StatefulBuilder(builder: (BuildContext context, StateSetter setMain) {
                                  return Column(children: [
                                    FutureBuilder<List<Map<String, dynamic>>>(
                                        future: getInfo('mainDisability', lang, 'Individual'),
                                        builder: (context, snapshot) {
                                          if (mains.isNotEmpty || (snapshot.connectionState == ConnectionState.done && snapshot.hasData)) {
                                            if (mains.isEmpty) {
                                              mains = mp3;
                                            }
                                            return Container(
                                                margin: (EdgeInsets.symmetric(vertical: 5)),
                                                child: DropdownSearch<Map>(
                                                  items: mains,
                                                  maxHeight: 300,
                                                  popupItemBuilder: (context, item, isSelected) {
                                                    return Container(height: 50, child: Column(children: [Expanded(child: Text(item['label'])), Divider(thickness: 1, indent: 10, endIndent: 10)]));
                                                  },
                                                  dropdownBuilder: (context, selectedItem) {
                                                    return Text(selectedItem?['label'] ?? mainDefault);
                                                  },
                                                  dropdownSearchDecoration: InputDecoration(
                                                      hintText: tr('Search'),
                                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                                                      filled: true,
                                                      fillColor: Colors.grey[50],
                                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                  onChanged: (val) {
                                                    setMain(() {
                                                      mainDefault = val!["label"];
                                                      main.text = val['value'].toString();
                                                      mp3.clear();
                                                      sub.clear();
                                                      subDefault = '';
                                                    });
                                                  },
                                                  showSearchBox: true,
                                                ));
                                          } else if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Center(child: Container(margin: EdgeInsets.only(top: 10), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                                          } else {
                                            return SizedBox();
                                          }
                                        }),
                                    if (main.text.isNotEmpty)
                                      FutureBuilder<List<Map<String, dynamic>>>(
                                          future: getInfo('subDisability', lang, main.text),
                                          builder: (context, snapshot) {
                                            if (subs.isNotEmpty || snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
                                              if (subs.isEmpty) {
                                                subs = mp4;
                                              }
                                              return Container(
                                                  margin: (EdgeInsets.symmetric(vertical: 5)),
                                                  child: DropdownSearch<Map>(
                                                    items: subs,
                                                    maxHeight: 300,
                                                    popupItemBuilder: (context, item, isSelected) {
                                                      return Container(height: 50, child: Column(children: [Expanded(child: Text(item['label'])), Divider(thickness: 1, indent: 10, endIndent: 10)]));
                                                    },
                                                    dropdownBuilder: (context, selectedItem) {
                                                      return Text(selectedItem?['label'] ?? subDefault);
                                                    },
                                                    dropdownSearchDecoration: InputDecoration(
                                                        hintText: tr('Search'),
                                                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                                                        filled: true,
                                                        fillColor: Colors.grey[50],
                                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                                    onChanged: (val) {
                                                      sub.text = val!['value'].toString();
                                                      subDefault = val['label'].toString();
                                                      setMain(() {
                                                        mp4.clear();
                                                      });
                                                    },
                                                    showSearchBox: true,
                                                  ));
                                            } else {
                                              return SizedBox();
                                            }
                                          })
                                  ]);
                                }),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    margin: EdgeInsets.only(bottom: 5, top: 5),
                                    child: Text('Disclose your case?', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                StatefulBuilder(builder: (BuildContext context, StateSetter setmartialart) {
                                  return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                    Expanded(
                                        child: ListTile(
                                            title: Text("Yes", style: TextStyle(color: status == 1 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                            leading: Radio(
                                                value: 1,
                                                groupValue: status,
                                                onChanged: (value) {
                                                  setmartialart(() {
                                                    status = value as int;
                                                  });
                                                },
                                                activeColor: hexStringToColor('#6986b8')))),
                                    Expanded(
                                        child: ListTile(
                                            title: Text("No", style: TextStyle(color: status == 2 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                            leading: Radio(
                                                value: 2,
                                                groupValue: status,
                                                onChanged: (value) {
                                                  setmartialart(() {
                                                    status = value as int;
                                                  });
                                                },
                                                activeColor: hexStringToColor('#6986b8'))))
                                  ]);
                                }),
                                Divider(),
                                StatefulBuilder(builder: (BuildContext context, StateSetter setSubmit) {
                                  return !loading
                                      ? GestureDetector(
                                          onTap: () async {
                                                    if (main.text.isEmpty || sub.text.isEmpty) {
                                                      Get.snackbar(tr('All the fields are required'), tr('Please select them and try again'),
                                                          duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.orange, leftBarIndicatorColor: Colors.orange);
                                                      return;
                                                    }
                                                    Map uInfo = {'category_id': main.text, 'sub_category_id': sub.text, 'status': status.toString()};
                                                    setSubmit(() {
                                                      loading = true;
                                                    });
                                                    var tmp = await disabilities(2, uInfo);
                                                    setSubmit(() {
                                                      loading = false;
                                                    });
                                                    if (tmp['status'] == true) {
                                                      Get.offAll(() => IndivProfilePage());
                                                    }
                                      },
                                      child: Container(
                                              decoration: BoxDecoration(color: hexStringToColor('#6986b8'), border: Border.all(width: 0.2), borderRadius: BorderRadius.all(Radius.circular(30))),
                                              width: getWH(context, 2),
                                              height: getWH(context, 1) * 0.07,
                                              margin: EdgeInsets.only(top: 25),
                                              alignment: Alignment.center,
                                              child: Text('Update', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)).tr())) 
                                      : Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                                }),
                              ])));
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Scaffold(backgroundColor: Colors.white, body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
                    } else {
                      return SizedBox();
                    }
                  }));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(backgroundColor: Colors.white, body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
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
                              Get.offAll(() => StartPage());
                            },
                            child: Text('Retry').tr())
                      ]))));
        }
      });
}
