import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import '../../API.dart';
import '../../data.dart';
import '../../functions.dart';
import '../../main.dart';
import 'dart:ui' as ui;

class BranchesPage extends StatefulWidget {
  @override
  _BranchesPageState createState() => _BranchesPageState();
}

class _BranchesPageState extends State<BranchesPage> {
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
    loading = false;
  }

  bool loading = false;
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          loading = false;
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: watheftyBar(context, "Branches", 18),
              bottomNavigationBar: watheftyBottomBar(context),
              floatingActionButton: SpeedDial(
                  animatedIcon: AnimatedIcons.add_event,
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
                  onPress: () async {
                    await Get.to(() => AddBranch());
                    setState(() {});
                  }),
              body: FutureBuilder<List>(
                  future: getBranches(null),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
                      return snapshot.data!.isNotEmpty
                          ? Container(
                              margin: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                              width: getWH(context, 2),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.grey[50],
                                            border: Border.all(color: hexStringToColor('#eeeeee')),
                                            borderRadius: BorderRadius.all(Radius.zero)),
                                        child: Row(children: [
                                          Flexible(
                                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            RichText(
                                                overflow: TextOverflow.ellipsis,
                                                text: TextSpan(children: <TextSpan>[
                                                  TextSpan(text: tr('Address:') + "    ", style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                  TextSpan(
                                                      text: snapshot.data![index]['address'],
                                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                ])),
                                            Divider(height: 3),
                                            RichText(
                                                overflow: TextOverflow.ellipsis,
                                                text: TextSpan(children: <TextSpan>[
                                                  TextSpan(text: tr('Region:') + "    ", style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                  TextSpan(
                                                      text: snapshot.data![index]['country_name'] + " - " + snapshot.data![index]['region_name'],
                                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                ]))
                                          ])),
                                          StatefulBuilder(builder: (BuildContext context, StateSetter setDelete) {
                                            return !loading
                                                ? IconButton(
                                                    onPressed: () async {
                                                      setDelete(() {
                                                        loading = true;
                                                      });
                                                      var delete = await deleteBranch(snapshot.data![index]["id"].toString());
                                                      if (delete) {
                                                        setState(() {
                                                          loading = false;
                                                        });
                                                      } else
                                                        setDelete(() {
                                                          loading = false;
                                                        });
                                                    },
                                                    icon: Icon(Icons.delete, color: Colors.red))
                                                : Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                                          })
                                        ]));
                                  }))
                          : SizedBox();
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Scaffold(
                          backgroundColor: Colors.white,
                          body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
                    } else {
                      return Center(
                          child: Container(
                              padding: EdgeInsets.all(50),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                Text("You have no branches", textAlign: TextAlign.center).tr(),
                                TextButton(
                                    onPressed: () async {
                                      Get.back();
                                    },
                                    child: Text('Go back').tr())
                              ])));
                    }
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
                              Get.offAll(() => StartPage());
                            },
                            child: Text('Retry').tr())
                      ]))));
        }
      });
}

class AddBranch extends StatefulWidget {
  @override
  _AddBranchState createState() => _AddBranchState();
}

class _AddBranchState extends State<AddBranch> {
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
    loading = false;
  }

  final formKey = GlobalKey<FormState>();
  final country = TextEditingController();
  final region = TextEditingController();
  final addressAr = TextEditingController();
  final addressEn = TextEditingController();
  bool loading = false;
  Widget build(BuildContext context) {
    loading = false;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: watheftyBar(context, "Add Branch", 18),
        bottomNavigationBar: watheftyBottomBar(context),
        body: SingleChildScrollView(
            child: Form(
          key: formKey,
          child: StatefulBuilder(builder: (BuildContext context, StateSetter _setRegion) {
            return Container(
                margin: const EdgeInsets.only(top: 35),
                padding: const EdgeInsets.only(top: 15, bottom: 30, right: 15, left: 15),
                decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.1), borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                  Container(
                      padding: EdgeInsets.only(left: 15),
                      margin: EdgeInsets.only(bottom: 10, top: 20),
                      child: Text('Country', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                  DropdownSearch<Map>(
                    validator: (value) {
                      if (value == null) {
                        return tr("Select country");
                      }
                      return null;
                    },
                    items: arrtoList(countryArr, lang, ''),
                    maxHeight: 300,
                    popupItemBuilder: (context, item, isSelected) {
                      return Container(
                          height: 50, child: Column(children: [Expanded(child: Text(item['label'])), Divider(thickness: 1, indent: 10, endIndent: 10)]));
                    },
                    dropdownBuilder: (context, selectedItem) {
                      if (selectedItem != null)
                        return Text(selectedItem['label']);
                      else
                        return Text('');
                    },
                    dropdownSearchDecoration: InputDecoration(
                        hintText: tr('Search'),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        filled: true,
                        fillColor: Colors.white,
                        focusedErrorBorder:
                            OutlineInputBorder(borderSide: BorderSide(width: 0.4, color: Colors.red), borderRadius: BorderRadius.all(Radius.circular(25))),
                        errorBorder:
                            OutlineInputBorder(borderSide: BorderSide(width: 0.4, color: Colors.red), borderRadius: BorderRadius.all(Radius.circular(25))),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                    onChanged: (val) {
                      _setRegion(() {
                        country.text = (val!['value'].toString());
                        region.text = '';
                      });
                    },
                    showSearchBox: true,
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 15),
                      margin: EdgeInsets.only(bottom: 10, top: 20),
                      child: Text('Region', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                  if (country.text.isEmpty)
                    TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                            hintText: tr('Select country'),
                            filled: true,
                            fillColor: Colors.white,
                            focusedErrorBorder:
                                OutlineInputBorder(borderSide: BorderSide(width: 0.4, color: Colors.red), borderRadius: BorderRadius.all(Radius.circular(25))),
                            errorBorder:
                                OutlineInputBorder(borderSide: BorderSide(width: 0.4, color: Colors.red), borderRadius: BorderRadius.all(Radius.circular(25))),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                            focusedBorder:
                                OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                        style: TextStyle(color: Colors.blueGrey),
                        textDirection: ui.TextDirection.ltr),
                  if (country.text.isNotEmpty)
                    FutureBuilder<List<Map<String, dynamic>>>(
                        future: getInfo('region', lang, country.text),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                            return DropdownSearch<Map>(
                              validator: (value) {
                                if (value == null) {
                                  return tr("Select region");
                                }
                                return null;
                              },
                              items: mpR,
                              maxHeight: 300,
                              popupItemBuilder: (context, item, isSelected) {
                                return Container(
                                    height: 50,
                                    child: Column(children: [Expanded(child: Text(item['label'])), Divider(thickness: 1, indent: 10, endIndent: 10)]));
                              },
                              dropdownBuilder: (context, selectedItem) {
                                if (selectedItem != null)
                                  return Text(selectedItem['label']);
                                else
                                  return Text('');
                              },
                              dropdownSearchDecoration: InputDecoration(
                                  hintText: tr('Search'),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 0.4, color: Colors.red), borderRadius: BorderRadius.all(Radius.circular(25))),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 0.4, color: Colors.red), borderRadius: BorderRadius.all(Radius.circular(25))),
                                  focusedBorder:
                                      OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                              onChanged: (val) {
                                region.text = val!['value'].toString();
                              },
                              showSearchBox: true,
                            );
                          } else if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                                child: Container(
                                    margin: EdgeInsets.only(top: 10), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                          } else {
                            return SizedBox();
                          }
                        }),
                  Container(
                      padding: EdgeInsets.only(left: 15),
                      margin: EdgeInsets.only(bottom: 10, top: 20),
                      child: Text('Address in Arabic', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                  TextFormField(
                      textDirection: ui.TextDirection.rtl,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedErrorBorder:
                              OutlineInputBorder(borderSide: BorderSide(width: 0.4, color: Colors.red), borderRadius: BorderRadius.all(Radius.circular(25))),
                          errorBorder:
                              OutlineInputBorder(borderSide: BorderSide(width: 0.4, color: Colors.red), borderRadius: BorderRadius.all(Radius.circular(25))),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                      style: TextStyle(color: Colors.blueGrey),
                      controller: addressAr,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return tr("Please type the address");
                        }
                        return null;
                      }),
                  Container(
                      padding: EdgeInsets.only(left: 15),
                      margin: EdgeInsets.only(bottom: 10, top: 20),
                      child: Text('Address in English', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                  TextFormField(
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedErrorBorder:
                              OutlineInputBorder(borderSide: BorderSide(width: 0.4, color: Colors.red), borderRadius: BorderRadius.all(Radius.circular(25))),
                          errorBorder:
                              OutlineInputBorder(borderSide: BorderSide(width: 0.4, color: Colors.red), borderRadius: BorderRadius.all(Radius.circular(25))),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                      style: TextStyle(color: Colors.blueGrey),
                      controller: addressEn,
                      textDirection: ui.TextDirection.ltr,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return tr("Please type the address");
                        }
                        return null;
                      }),
                  StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
                    return !loading
                        ? GestureDetector(
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                Map info = {
                                  'lang': lang,
                                  'company_id': globalUid,
                                  'address_en': addressEn.text,
                                  'address_ar': addressAr.text,
                                  'country_id': country.text,
                                  'region_id': region.text,
                                  "api_password": "ase1iXcLAxanvXLZcgh6tk"
                                };
                                _setState(() {
                                  loading = true;
                                });
                                await addBranches(info);
                                _setState(() {
                                  loading = false;
                                });
                              }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: hexStringToColor('#6986b8'), border: Border.all(width: 0.2), borderRadius: BorderRadius.all(Radius.circular(30))),
                                width: getWH(context, 2),
                                height: getWH(context, 1) * 0.07,
                                margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                                alignment: Alignment.center,
                                child: Text("Add", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)).tr()))
                        : Center(
                            child: Container(margin: EdgeInsets.all(30), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                  }),
                ]));
          }),
        )));
  }
}
