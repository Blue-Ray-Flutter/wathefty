import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../API.dart';
import '../../data.dart';
import '../../functions.dart';
import '../../main.dart';
import 'profile.dart';
import 'dart:ui' as ui;

class IndividualSkillsPage extends StatefulWidget {
  @override
  _IndividualSkillsPageState createState() => _IndividualSkillsPageState();
}

class _IndividualSkillsPageState extends State<IndividualSkillsPage> {
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
    loading = false;
  }

  List<File>? images;
  String text = tr('You can upload multiple pictures');

  bool loading = false;

  final workshopsize = TextEditingController();
  final workshophelp = TextEditingController(text: '2');
  final rank = TextEditingController(text: '');
  final socialController = TextEditingController(text: '2');
  final sharedController = TextEditingController(text: '2');
  final marketController = TextEditingController(text: '2');
  final toolsController = TextEditingController(text: '2');
  final teamController = TextEditingController(text: '2');
  final feasibilityController = TextEditingController(text: '2');
  final skillController = TextEditingController();
  final trainingController = TextEditingController();
  final certificateController = TextEditingController();
  final galleryNameAr = TextEditingController(text: '');
  final galleryNameEn = TextEditingController(text: '');
  final socialMediaUrl = TextEditingController(text: '');
  int shared = 2;
  int market = 2;
  int training = 2;
  int tools = 2;
  int team = 2;
  int feasibility = 2;
  int social = 2;
  bool edit = false;
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          loading = false;
          var uid = snapshot.data!['uid'];
          var type = snapshot.data!['type'];
          var data;
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: watheftyBar(context, "Skills", 20),
              bottomNavigationBar: watheftyBottomBar(context),
              body: SingleChildScrollView(
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                        Text('Add a personal skill or hobby',
                                textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87))
                            .tr(),
                        SizedBox(height: 15),
                        FutureBuilder(
                            future: Future.wait([
                              getSkillRequest(uid, 'Individual', lang),
                              getInfo('personalSkills', lang, uid),
                              getInfo('skillCertificates', lang, uid),
                              // getInfo('trainingAbility', lang, uid)
                            ]),
                            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                if (snapshot.data![0].isNotEmpty) {
                                  edit = true;
                                  data = snapshot.data![0]['personalSkills'];
                                  socialController.text = data['have_social_media_page'] == 'Yes' ? '1' : '2';
                                  sharedController.text = data['sharing_handicraft_fairs'] == 'Yes' ? '1' : '2';
                                  marketController.text = data['marketing_product_on_wathefty'] == 'Yes' ? '1' : '2';
                                  toolsController.text = data['owning_the_tools_to_work'] == 'Yes' ? '1' : '2';
                                  trainingController.text = data['training_ability_id'] == 'Yes' ? '1' : '2';
                                  teamController.text = data['working_in_team'] == 'Yes' ? '1' : '2';
                                  feasibilityController.text = data['submit_feasibility_study'] == 'Yes' ? '1' : '2';
                                  skillController.text = data['personal_skill_id'].toString();
                                  galleryNameAr.text = data['gallery_name_ar'];
                                  galleryNameEn.text = data['gallery_name_en'];
                                  socialMediaUrl.text = data['social_media_page_url'];
                                  workshophelp.text = data['workshops_without_any_help'] == 'Yes' ? '1' : '2';
                                  workshopsize.text = data['workshops_without_help_id'].toString();
                                  rank.text = data['rank_professional_id'].toString();
                                  // trainingController.text = data['training_ability_id'].toString();
                                  certificateController.text = data['skill_certificate_id'].toString();
                                  shared = data['sharing_handicraft_fairs'] == 'No' ? 2 : 1;
                                  market = data['marketing_product_on_wathefty'] == 'No' ? 2 : 1;
                                  tools = data['owning_the_tools_to_work'] == 'No' ? 2 : 1;
                                  training = data['training_ability_id'] == 'No' ? 2 : 1;
                                  team = data['working_in_team'] == 'No' ? 2 : 1;
                                  feasibility = data['submit_feasibility_study'] == 'No' ? 2 : 1;
                                  social = data['have_social_media_page'] == 'No' ? 2 : 1;
                                }
                                return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                  Container(
                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                      margin: EdgeInsets.only(bottom: 5, top: 10),
                                      child: Text('Professional Rank', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                  DropdownSearch<Map>(
                                    items: arrtoList(professionalRankArr, lang, ''),
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
                                        return Text(data["rank_professional_name"] ?? "");
                                    },
                                    dropdownSearchDecoration: InputDecoration(
                                        hintText: tr('Search'),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        enabledBorder:
                                            OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                    onChanged: (val) {
                                      rank.text = val!['value'].toString();
                                    },
                                    showSearchBox: true,
                                  ),
                                  Container(
                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                      margin: EdgeInsets.only(bottom: 5, top: 10),
                                      child: Text('What skill/hobby do you have?', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                  DropdownSearch<Map>(
                                    items: mp1,
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
                                        return Text(data["personal_skill"][lang == "ar" ? "skill_title_ar" : "skill_title_en"] ?? "");
                                    },
                                    dropdownSearchDecoration: InputDecoration(
                                        hintText: tr('Search'),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        enabledBorder:
                                            OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                    onChanged: (val) {
                                      skillController.text = val!['value'].toString();
                                    },
                                    showSearchBox: true,
                                  ),
                                  Container(
                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                      margin: EdgeInsets.only(bottom: 5, top: 10),
                                      child:
                                          Text('Do you have a certificate for the skill/hobby?', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                  Container(
                                      margin: (EdgeInsets.symmetric(vertical: 5)),
                                      child: SelectFormField(
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return tr('Please select certificate');
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            suffixIcon: Icon(Icons.arrow_drop_down),
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                            enabledBorder:
                                                OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                        type: SelectFormFieldType.dropdown,
                                        items: mp3,
                                        controller: certificateController,
                                      )),
                                  Container(
                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                      margin: EdgeInsets.only(bottom: 5, top: 10),
                                      child: Text('Do you have the ability to train others in your skill/hobby?',
                                              style: TextStyle(fontSize: 15.0, color: Colors.black54))
                                          .tr()),
                                  StatefulBuilder(builder: (BuildContext context, StateSetter setShare) {
                                    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                      Expanded(
                                          child: ListTile(
                                              title: Text("Yes", style: TextStyle(color: training == 1 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                              leading: Radio(
                                                  value: 1,
                                                  groupValue: training,
                                                  activeColor: hexStringToColor('#6986b8'),
                                                  onChanged: (value) {
                                                    setShare(() {
                                                      training = value as int;
                                                      trainingController.text = training.toString();
                                                    });
                                                  }))),
                                      Expanded(
                                          child: ListTile(
                                              title: Text("No", style: TextStyle(color: training == 2 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                              leading: Radio(
                                                  value: 2,
                                                  groupValue: training,
                                                  activeColor: hexStringToColor('#6986b8'),
                                                  onChanged: (value) {
                                                    setShare(() {
                                                      training = value as int;
                                                      trainingController.text = training.toString();
                                                    });
                                                  })))
                                    ]);
                                  }),
                                  Container(
                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                      margin: EdgeInsets.only(bottom: 5, top: 10),
                                      child: Text('Can you host professional workshops without any assistance?',
                                              style: TextStyle(fontSize: 15.0, color: Colors.black54))
                                          .tr()),
                                  StatefulBuilder(builder: (BuildContext context, StateSetter setHelp) {
                                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                        Expanded(
                                            child: ListTile(
                                                title:
                                                    Text("Yes", style: TextStyle(color: workshophelp.text == "1" ? hexStringToColor('#6986b8') : Colors.black))
                                                        .tr(),
                                                leading: Radio(
                                                    value: 1,
                                                    groupValue: int.parse(workshophelp.text),
                                                    activeColor: hexStringToColor('#6986b8'),
                                                    onChanged: (value) {
                                                      setHelp(() {
                                                        workshophelp.text = value.toString();
                                                      });
                                                    }))),
                                        Expanded(
                                            child: ListTile(
                                                title:
                                                    Text("No", style: TextStyle(color: workshophelp.text == "2" ? hexStringToColor('#6986b8') : Colors.black))
                                                        .tr(),
                                                leading: Radio(
                                                    value: 2,
                                                    groupValue: int.parse(workshophelp.text),
                                                    activeColor: hexStringToColor('#6986b8'),
                                                    onChanged: (value) {
                                                      setHelp(() {
                                                        workshophelp.text = value.toString();
                                                      });
                                                    })))
                                      ]),
                                      if (workshophelp.text == "1")
                                        Container(
                                            padding: EdgeInsets.symmetric(horizontal: 15),
                                            margin: EdgeInsets.only(bottom: 5, top: 10),
                                            child: Text('Type of training workshop', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                      if (workshophelp.text == "1")
                                        Container(
                                            margin: (EdgeInsets.symmetric(vertical: 5)),
                                            child: SelectFormField(
                                              validator: (val) {
                                                if (val!.isEmpty) {
                                                  return 'Select';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                                  filled: true,
                                                  fillColor: Colors.grey[50],
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                              type: SelectFormFieldType.dropdown,
                                              items: arrtoList(workshopSizeArr, lang, ''),
                                              controller: workshopsize,
                                            ))
                                    ]);
                                  }),
                                  // Container(
                                  //     margin: (EdgeInsets.symmetric(vertical: 5)),
                                  //     child: SelectFormField(
                                  //       validator: (val) {
                                  //         if (val!.isEmpty) {
                                  //           return tr('Please select an answer');
                                  //         }
                                  //       },
                                  //       decoration: InputDecoration(
                                  //           suffixIcon: Icon(Icons.arrow_drop_down),
                                  //           filled: true,
                                  //           fillColor: Colors.grey[50],
                                  //           enabledBorder:
                                  //               OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                  //           focusedBorder: OutlineInputBorder(
                                  //               borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  //       type: SelectFormFieldType.dropdown,
                                  //       items: mp2,
                                  //       controller: trainingController,
                                  //     )),
                                  Container(
                                      padding: EdgeInsets.only(left: 15),
                                      margin: EdgeInsets.only(bottom: 10, top: 20),
                                      child:
                                          Text('Have you ever displayed your work in a fair?', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                  StatefulBuilder(builder: (BuildContext context, StateSetter setShare) {
                                    return Column(children: [
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                        Expanded(
                                            child: ListTile(
                                          title: Text("Yes", style: TextStyle(color: shared == 1 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                          leading: Radio(
                                            value: 1,
                                            groupValue: shared,
                                            onChanged: (value) {
                                              setShare(() {
                                                shared = value as int;
                                                sharedController.text = shared.toString();
                                              });
                                            },
                                            activeColor: hexStringToColor('#6986b8'),
                                          ),
                                        )),
                                        Expanded(
                                            child: ListTile(
                                                title: Text("No", style: TextStyle(color: shared == 2 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                                leading: Radio(
                                                    value: 2,
                                                    groupValue: shared,
                                                    onChanged: (value) {
                                                      setShare(() {
                                                        shared = value as int;
                                                        sharedController.text = shared.toString();
                                                      });
                                                    },
                                                    activeColor: hexStringToColor('#6986b8'))))
                                      ]),
                                      if (shared == 1)
                                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          Container(
                                              padding: EdgeInsets.symmetric(horizontal: 15),
                                              margin: EdgeInsets.only(bottom: 5, top: 15),
                                              child: Text('Gallery Name in Arabic', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                          TextField(
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[50],
                                                enabledBorder:
                                                    OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                            style: TextStyle(color: Colors.blueGrey),
                                            textDirection: lang == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                                            controller: galleryNameAr,
                                          ),
                                          Container(
                                              padding: EdgeInsets.symmetric(horizontal: 15),
                                              margin: EdgeInsets.only(bottom: 5, top: 15),
                                              child: Text('Gallery Name in English', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                          TextField(
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.grey[50],
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                              style: TextStyle(color: Colors.blueGrey),
                                              textDirection: lang == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                                              controller: galleryNameEn)
                                        ])
                                    ]);
                                  }),
                                  Container(
                                      padding: EdgeInsets.only(left: 15),
                                      margin: EdgeInsets.only(bottom: 10, top: 20),
                                      child: Text('Do you have your own tools?', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                  StatefulBuilder(builder: (BuildContext context, StateSetter setShare) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                            child: ListTile(
                                          title: Text("Yes", style: TextStyle(color: tools == 1 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                          leading: Radio(
                                            value: 1,
                                            groupValue: tools,
                                            onChanged: (value) {
                                              setShare(() {
                                                tools = value as int;
                                                toolsController.text = tools.toString();
                                              });
                                            },
                                            activeColor: hexStringToColor('#6986b8'),
                                          ),
                                        )),
                                        Expanded(
                                            child: ListTile(
                                          title: Text("No", style: TextStyle(color: tools == 2 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                          leading: Radio(
                                            value: 2,
                                            groupValue: tools,
                                            onChanged: (value) {
                                              setShare(() {
                                                tools = value as int;
                                                toolsController.text = tools.toString();
                                              });
                                            },
                                            activeColor: hexStringToColor('#6986b8'),
                                          ),
                                        )),
                                      ],
                                    );
                                  }),
                                  Container(
                                      padding: EdgeInsets.only(left: 15),
                                      margin: EdgeInsets.only(bottom: 10, top: 20),
                                      child:
                                          Text('Would you like to market your craft through Wathefty?', style: TextStyle(fontSize: 15.0, color: Colors.black54))
                                              .tr()),
                                  StatefulBuilder(builder: (BuildContext context, StateSetter setShare) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                            child: ListTile(
                                          title: Text("Yes", style: TextStyle(color: market == 1 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                          leading: Radio(
                                            value: 1,
                                            groupValue: market,
                                            onChanged: (value) {
                                              setShare(() {
                                                market = value as int;
                                                marketController.text = market.toString();
                                              });
                                            },
                                            activeColor: hexStringToColor('#6986b8'),
                                          ),
                                        )),
                                        Expanded(
                                            child: ListTile(
                                          title: Text("No", style: TextStyle(color: market == 2 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                          leading: Radio(
                                            value: 2,
                                            groupValue: market,
                                            onChanged: (value) {
                                              setShare(() {
                                                market = value as int;
                                                marketController.text = market.toString();
                                              });
                                            },
                                            activeColor: hexStringToColor('#6986b8'),
                                          ),
                                        )),
                                      ],
                                    );
                                  }),
                                  Container(
                                      padding: EdgeInsets.only(left: 15),
                                      margin: EdgeInsets.only(bottom: 10, top: 20),
                                      child: Text('Can you work with a single team?', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                  StatefulBuilder(builder: (BuildContext context, StateSetter setShare) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                            child: ListTile(
                                          title: Text("Yes", style: TextStyle(color: team == 1 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                          leading: Radio(
                                            value: 1,
                                            groupValue: team,
                                            onChanged: (value) {
                                              setShare(() {
                                                team = value as int;
                                                teamController.text = team.toString();
                                              });
                                            },
                                            activeColor: hexStringToColor('#6986b8'),
                                          ),
                                        )),
                                        Expanded(
                                            child: ListTile(
                                          title: Text("No", style: TextStyle(color: team == 2 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                          leading: Radio(
                                            value: 2,
                                            groupValue: team,
                                            onChanged: (value) {
                                              setShare(() {
                                                team = value as int;
                                                teamController.text = team.toString();
                                              });
                                            },
                                            activeColor: hexStringToColor('#6986b8'),
                                          ),
                                        )),
                                      ],
                                    );
                                  }),
                                  Container(
                                      padding: EdgeInsets.only(left: 15),
                                      margin: EdgeInsets.only(bottom: 10, top: 20),
                                      child: Text('Can you provide a feasibility study and would you need financial support?',
                                              style: TextStyle(fontSize: 15.0, color: Colors.black54))
                                          .tr()),
                                  StatefulBuilder(builder: (BuildContext context, StateSetter setShare) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                            child: ListTile(
                                          title: Text("Yes", style: TextStyle(color: feasibility == 1 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                          leading: Radio(
                                            value: 1,
                                            groupValue: feasibility,
                                            onChanged: (value) {
                                              setShare(() {
                                                feasibility = value as int;
                                                feasibilityController.text = feasibility.toString();
                                              });
                                            },
                                            activeColor: hexStringToColor('#6986b8'),
                                          ),
                                        )),
                                        Expanded(
                                            child: ListTile(
                                          title: Text("No", style: TextStyle(color: feasibility == 2 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                          leading: Radio(
                                            value: 2,
                                            groupValue: feasibility,
                                            onChanged: (value) {
                                              setShare(() {
                                                feasibility = value as int;
                                                feasibilityController.text = feasibility.toString();
                                              });
                                            },
                                            activeColor: hexStringToColor('#6986b8'),
                                          ),
                                        )),
                                      ],
                                    );
                                  }),
                                  Container(
                                      padding: EdgeInsets.only(left: 15),
                                      margin: EdgeInsets.only(bottom: 10, top: 20),
                                      child: Text('Do you have a social media page?', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                  StatefulBuilder(builder: (BuildContext context, StateSetter setShare) {
                                    return Column(children: [
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                        Expanded(
                                            child: ListTile(
                                          title: Text("Yes", style: TextStyle(color: social == 1 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                          leading: Radio(
                                            value: 1,
                                            groupValue: social,
                                            onChanged: (value) {
                                              setShare(() {
                                                social = value as int;
                                                socialController.text = social.toString();
                                              });
                                            },
                                            activeColor: hexStringToColor('#6986b8'),
                                          ),
                                        )),
                                        Expanded(
                                            child: ListTile(
                                                title: Text("No", style: TextStyle(color: social == 2 ? hexStringToColor('#6986b8') : Colors.black)).tr(),
                                                leading: Radio(
                                                    value: 2,
                                                    groupValue: social,
                                                    onChanged: (value) {
                                                      setShare(() {
                                                        social = value as int;
                                                        socialController.text = social.toString();
                                                      });
                                                    },
                                                    activeColor: hexStringToColor('#6986b8'))))
                                      ]),
                                      if (social == 1)
                                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          Container(
                                              padding: EdgeInsets.symmetric(horizontal: 15),
                                              margin: EdgeInsets.only(bottom: 5, top: 15),
                                              child: Text('Social Media Link', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                          TextField(
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.grey[50],
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                              style: TextStyle(color: Colors.blueGrey),
                                              textDirection: lang == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                                              controller: socialMediaUrl)
                                        ])
                                    ]);
                                  }),
                                  Container(
                                      padding: EdgeInsets.only(left: 15),
                                      margin: EdgeInsets.only(bottom: 10, top: 20),
                                      child: Text('Upload examples of your skill/hobby', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                                  StatefulBuilder(builder: (BuildContext context, StateSetter setImage) {
                                    return Row(children: [
                                      Expanded(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[50], border: Border.all(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                              child: TextButton(
                                                  onPressed: () async {
                                                    var tmp = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: true);
                                                    if (tmp != null) {
                                                      setImage(() {
                                                        images = tmp.paths.map((path) => File(path!)).toList();
                                                        text = images.toString();
                                                      });
                                                    }
                                                  },
                                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                    Flexible(child: Text(text, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54)).tr()),
                                                    Icon(Icons.file_upload_outlined, color: hexStringToColor('#6986b8'))
                                                  ]))))
                                    ]);
                                  }),
                                  edit ? Divider() : SizedBox(),
                                  data != null && data['personal_skill_images'].isNotEmpty ? Text('Tap an image to enlarge or remove it') : SizedBox(),
                                  StatefulBuilder(builder: (BuildContext context, StateSetter setImages) {
                                    return data != null && data['personal_skill_images'].isNotEmpty
                                        ? SizedBox(
                                            height: 100,
                                            width: getWH(context, 2),
                                            child: GridView.builder(
                                                scrollDirection: Axis.horizontal,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(crossAxisSpacing: 0, mainAxisSpacing: 1, crossAxisCount: 1),
                                                itemCount: data['personal_skill_images'].length,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  fit: BoxFit.cover, image: NetworkImage(data['personal_skill_images'][index]['image'])))),
                                                      onTap: () async {
                                                        var tmp = await biggerImage(context, data['personal_skill_images'][index]['image'], uid, type,
                                                            {'id': data['personal_skill_images'][index]['id'].toString()}, lang, true, 2);
                                                        if (tmp != null && tmp) {
                                                          data['personal_skill_images'].removeAt(index);
                                                          setImages(() {});
                                                        }
                                                      });
                                                }))
                                        : SizedBox();
                                  }),
                                  if (loading) SizedBox(height: 20),
                                  StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
                                    return !loading
                                        ? Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                                            GestureDetector(
                                                onTap: () async {
                                                  if (socialController.text.isEmpty ||
                                                      sharedController.text.isEmpty ||
                                                      marketController.text.isEmpty ||
                                                      workshopsize.text.isEmpty ||
                                                      workshophelp.text.isEmpty ||
                                                      rank.text.isEmpty ||
                                                      teamController.text.isEmpty ||
                                                      toolsController.text.isEmpty ||
                                                      skillController.text.isEmpty ||
                                                      trainingController.text.isEmpty ||
                                                      certificateController.text.isEmpty ||
                                                      (social == 1 && socialMediaUrl.text.isEmpty) ||
                                                      (shared == 1 && (galleryNameAr.text.isEmpty || galleryNameEn.text.isEmpty))) {
                                                    Get.snackbar(tr('All the fields are required'), tr('Please fill them and try again'),
                                                        duration: Duration(seconds: 5),
                                                        backgroundColor: Colors.white,
                                                        colorText: Colors.orange,
                                                        leftBarIndicatorColor: Colors.orange);
                                                    return;
                                                  }
                                                  Map uInfo = {
                                                    'workshops_without_any_help': workshophelp.text,
                                                    'rank_professional': rank.text,
                                                    'have_social_media_page': socialController.text,
                                                    'social_media_page_url': socialMediaUrl.text,
                                                    'sharing_handicraft_fairs': sharedController.text,
                                                    'marketing_product_on_wathefty': marketController.text,
                                                    'working_in_team': teamController.text,
                                                    'owning_the_tools_to_work': toolsController.text,
                                                    'personal_skill_id': skillController.text,
                                                    'training_ability_id': trainingController.text,
                                                    'skill_certificate_id': certificateController.text,
                                                    'submit_feasibility_study': feasibilityController.text,
                                                    'gallery_name_ar': galleryNameAr.text,
                                                    'gallery_name_en': galleryNameEn.text,
                                                    'workshops_without_any_help_select': workshopsize.text
                                                  };
                                                  if (images != null && images!.isNotEmpty) {
                                                    uInfo['personal_skill_image'] = images;
                                                  }

                                                  _setState(() {
                                                    loading = true;
                                                  });
                                                  Map tmp = await personalSkills(uid, lang, type, 1, uInfo);
                                                  _setState(() {
                                                    loading = false;
                                                  });
                                                  if (tmp['status'] == true) {
                                                    Get.offAll(() => IndivProfilePage());
                                                  }
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: hexStringToColor('#6986b8'),
                                                        border: Border.all(width: 0.2),
                                                        borderRadius: BorderRadius.all(Radius.circular(30))),
                                                    width: getWH(context, 2),
                                                    height: getWH(context, 1) * 0.07,
                                                    margin: EdgeInsets.only(top: 25),
                                                    alignment: Alignment.center,
                                                    child: Text(edit ? tr('Edit Information') : tr('Add Request'),
                                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))
                                                        .tr())),
                                            SizedBox(height: 20),
                                            GestureDetector(
                                                onTap: () async {
                                                  _setState(() {
                                                    loading = true;
                                                  });
                                                  Map tmp = await personalSkills(uid, lang, type, 3, null);
                                                  _setState(() {
                                                    loading = false;
                                                  });
                                                  if (tmp['status'] == true) {
                                                    Get.offAll(() => IndivProfilePage());
                                                  }
                                                },
                                                child: Text('Remove request',
                                                        style: TextStyle(
                                                            decoration: TextDecoration.underline, color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15))
                                                    .tr())
                                          ])
                                        : Center(
                                            child: Container(
                                                margin: EdgeInsets.all(30), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                                  }),
                                ]);
                              } else if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                    child: Container(
                                        margin: EdgeInsets.only(top: 10), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                              } else {
                                return Center(child: Text('Please check your internet and try again').tr());
                              }
                            }),
                      ]))));
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
