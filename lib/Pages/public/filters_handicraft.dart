import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:wathefty/API.dart';
import '../../../data.dart';
import '../../../functions.dart';
import 'individual_profile.dart';

class HandicraftFilters extends StatefulWidget {
  @override
  _HandicraftFiltersState createState() => _HandicraftFiltersState();
}

class _HandicraftFiltersState extends State<HandicraftFilters> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    filters.clear();
    feasibility.dispose();
    country.dispose();
    nationality.dispose();
    gender.dispose();
    tools.dispose();
    sharing.dispose();
    maritalStatus.dispose();
    team.dispose();
    education.dispose();
    training.dispose();
  }

  
  final training = TextEditingController();
  final sharing = TextEditingController();
  final tools = TextEditingController();
  final feasibility = TextEditingController();
  final team = TextEditingController();
  final education = TextEditingController();
  final skills = TextEditingController();
  final country = TextEditingController(text: '111');
  final nationality = TextEditingController();
  final gender = TextEditingController();
  final ageF = TextEditingController();
  final ageT = TextEditingController();
  final maritalStatus = TextEditingController();

  Map filters = {};
  Widget build(BuildContext context) {
    
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: watheftyBar(context, 'Handicraft providers', 18),
        body: SingleChildScrollView(child: StatefulBuilder(builder: (BuildContext context, StateSetter setRefresh) {
          return Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: FutureBuilder(
                  future: Future.wait(
                      [getInfo('personalSkills', lang, globalUid), getInfo('skillCertificates', lang, globalUid), getInfo('trainingAbility', lang, globalUid)]),
                  builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                      return Column(children: [
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.only(top: 15, bottom: 30, right: 15, left: 15),
                            decoration:
                                BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.1), borderRadius: BorderRadius.all(Radius.circular(15))),
                            child: Column(children: [
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 5, top: 15),
                                  child: Text('What skill/hobby do you have', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                              SizedBox(
                                  height: getWH(context, 1) * 0.05,
                                  child: SelectFormField(
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.arrow_drop_down),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                          enabledBorder:
                                              OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                      type: SelectFormFieldType.dropdown,
                                      items: mp1,
                                      controller: skills)),
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 5, top: 15),
                                  child: Text('Do you have a certificate for the skill/hobby?', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                              SizedBox(
                                  height: getWH(context, 1) * 0.05,
                                  child: SelectFormField(
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.arrow_drop_down),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                          enabledBorder:
                                              OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                      type: SelectFormFieldType.dropdown,
                                      items: mp3,
                                      controller: skills)),
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 5, top: 15),
                                  child: Text('Do you have the ability to train others in your skill/hobby?',
                                          style: TextStyle(fontSize: 15.0, color: Colors.black54))
                                      .tr()),
                              SizedBox(
                                  height: getWH(context, 1) * 0.05,
                                  child: SelectFormField(
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.arrow_drop_down),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                          enabledBorder:
                                              OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                      type: SelectFormFieldType.dropdown,
                                      items: mp2,
                                      controller: training)),
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 5, top: 15),
                                  child: Text('Have you ever displayed your work in a fair?', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                              SizedBox(
                                  height: getWH(context, 1) * 0.05,
                                  child: SelectFormField(
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.arrow_drop_down),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                          enabledBorder:
                                              OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                      type: SelectFormFieldType.dropdown,
                                      items: arrtoList(yesNo, lang, ''),
                                      controller: sharing)),
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 5, top: 15),
                                  child: Text('Do you have your own tools?', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                              SizedBox(
                                  height: getWH(context, 1) * 0.05,
                                  child: SelectFormField(
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.arrow_drop_down),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                          enabledBorder:
                                              OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                      type: SelectFormFieldType.dropdown,
                                      items: arrtoList(yesNo, lang, ''),
                                      controller: tools)),
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 5, top: 15),
                                  child: Text('Can you work with a single team?', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                              SizedBox(
                                  height: getWH(context, 1) * 0.05,
                                  child: SelectFormField(
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.arrow_drop_down),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                          enabledBorder:
                                              OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                      type: SelectFormFieldType.dropdown,
                                      items: arrtoList(yesNo, lang, ''),
                                      controller: team)),
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 5, top: 15),
                                  child: Text('Can you provide a feasibility study and would you need financial support?',
                                          style: TextStyle(fontSize: 15.0, color: Colors.black54))
                                      .tr()),
                              SizedBox(
                                  height: getWH(context, 1) * 0.05,
                                  child: SelectFormField(
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.arrow_drop_down),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                          enabledBorder:
                                              OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                      type: SelectFormFieldType.dropdown,
                                      items: arrtoList(yesNo, lang, ''),
                                      controller: feasibility)),
                            ])),
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.only(top: 15, bottom: 30, right: 15, left: 15),
                            decoration:
                                BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.1), borderRadius: BorderRadius.all(Radius.circular(15))),
                            child: Column(children: [
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 5, top: 15),
                                  child: Text('Age', style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.bold)).tr()),
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Text('From', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                              SizedBox(
                                  height: getWH(context, 1) * 0.05,
                                  child: SelectFormField(
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.arrow_drop_down),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                          enabledBorder:
                                              OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                      type: SelectFormFieldType.dropdown,
                                      items: numbers,
                                      controller: ageF)),
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 5, top: 15),
                                  child: Text('To', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                              SizedBox(
                                  height: getWH(context, 1) * 0.05,
                                  child: SelectFormField(
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.arrow_drop_down),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                          enabledBorder:
                                              OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                      type: SelectFormFieldType.dropdown,
                                      items: numbers,
                                      controller: ageT)),
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 5, top: 15),
                                  child: Text('Country', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                              SizedBox(
                                  height: getWH(context, 1) * 0.05,
                                  child: SelectFormField(
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.arrow_drop_down),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                          enabledBorder:
                                              OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                      type: SelectFormFieldType.dropdown,
                                      items: arrtoList(countryArr, lang, ''),
                                      controller: country)),
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 5, top: 15),
                                  child: Text('Nationality', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                              SizedBox(
                                  height: getWH(context, 1) * 0.05,
                                  child: SelectFormField(
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.arrow_drop_down),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                          enabledBorder:
                                              OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                      type: SelectFormFieldType.dropdown,
                                      items: arrtoList(nationalityArr, lang, ''),
                                      controller: nationality)),
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 5, top: 15),
                                  child: Text('Education level', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                              SizedBox(
                                  height: getWH(context, 1) * 0.05,
                                  child: SelectFormField(
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.arrow_drop_down),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                          enabledBorder:
                                              OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                      type: SelectFormFieldType.dropdown,
                                      items: arrtoList(degreeArr, lang, ''),
                                      controller: education)),
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 5, top: 15),
                                  child: Text('Gender', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                              SizedBox(
                                  height: getWH(context, 1) * 0.05,
                                  child: SelectFormField(
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.arrow_drop_down),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                          enabledBorder:
                                              OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                      type: SelectFormFieldType.dropdown,
                                      items: arrtoList(genderArr, lang, ''),
                                      controller: gender)),
                              Container(
                                  alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 5, top: 15),
                                  child: Text('Marital status', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                              SizedBox(
                                  height: getWH(context, 1) * 0.05,
                                  child: SelectFormField(
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.arrow_drop_down),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                          enabledBorder:
                                              OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                      type: SelectFormFieldType.dropdown,
                                      items: arrtoList(maritalStatusArr, lang, ''),
                                      controller: maritalStatus)),
                            ])),
                        Container(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                                onPressed: () {
                                  filters.clear();
                                      Get.back();
                                  Get.to(() => HandicraftFilters());
                                },
                                child: Text("Clear", style: TextStyle(color: Colors.black, fontSize: 16)).tr())),
                        GestureDetector(
                            onTap: () {
                              if (sharing.text.isNotEmpty) filters['sharing_handicraft_fairs'] = sharing.text;
                              if (tools.text.isNotEmpty) filters['owning_the_tools_to_work'] = tools.text;
                              if (feasibility.text.isNotEmpty) filters['submit_feasibility_study'] = feasibility.text;
                              if (skills.text.isNotEmpty) filters['personal_skill_id'] = skills.text;
                              if (team.text.isNotEmpty) filters['working_in_team'] = team.text;
                              if (education.text.isNotEmpty) filters['academec_degree_id'] = education.text;
                              if (country.text.isNotEmpty) filters['country_id'] = country.text;
                              if (nationality.text.isNotEmpty) filters['public_nationality_id'] = nationality.text;
                              if (gender.text.isNotEmpty) filters['individual_gender'] = gender.text;
                              if (ageF.text.isNotEmpty) filters['driver_age_from'] = ageF.text;
                              if (ageT.text.isNotEmpty) filters['driver_age_to'] = ageT.text;
                              if (maritalStatus.text.isNotEmpty) filters['individual_social_status'] = maritalStatus.text;
                              filters['type'] = '1';
                              filters['lang'] = lang;
                              Get.to(() => HandicraftPage(filters: filters));
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: hexStringToColor('#6986b8'), border: Border.all(width: 0.2), borderRadius: BorderRadius.all(Radius.circular(30))),
                                width: getWH(context, 2),
                                height: getWH(context, 1) * 0.05,
                                margin: EdgeInsets.only(top: 10),
                                alignment: Alignment.center,
                                child: Text("Search", style: TextStyle(color: Colors.white, fontSize: 16)).tr())),
                        SizedBox(height: 50)
                      ]);
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                              constraints: BoxConstraints.tightForFinite(),
                              child: LinearProgressIndicator()));
                    } else {
                      return SizedBox();
                    }
                  }));
        })));
  }
}

//====================================================Results

class HandicraftPage extends StatefulWidget {
  const HandicraftPage({Key? key, required this.filters}) : super(key: key);

  @override
  _HandicraftPageState createState() => _HandicraftPageState();
  final Map? filters;
}

class _HandicraftPageState extends State<HandicraftPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  
  List data = [];
  Widget build(BuildContext context) {
    
    Map fil = widget.filters ?? {'lang': lang};
    return Scaffold(
        floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22.0),
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            buttonSize: const Size(50.0, 50.0),
            label: Text('Advanced Filters', style: TextStyle(fontSize: 12)).tr(),
            elevation: 8.0,
            direction: SpeedDialDirection.up,
            switchLabelPosition: lang == 'ar' ? true : false,
            shape: CircleBorder(),
            children: [
              SpeedDialChild(
                  child: Icon(Icons.filter_list_sharp),
                  backgroundColor: Colors.white,
                  label: tr("Filters"),
                  onTap: () {
                    Get.off(() => HandicraftFilters());
                  }),
              SpeedDialChild(
                  child: Icon(Icons.clear),
                  backgroundColor: Colors.white,
                  label: tr('Reset'),
                  onTap: () {
                    setState(() {
                      fil.clear();
                      fil['lang'] = lang;
                    });
                  })
            ]),
        backgroundColor: Colors.white,
        appBar: watheftyBar(context, 'Search Results', 18),
        body: SingleChildScrollView(child: StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
          return FutureBuilder<Map>(
              future: jobSeekers(fil, 3),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!.isNotEmpty) {
                  data = snapshot.data!['personalSkills'];
                  return Column(children: [
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                        width: getWH(context, 2),
                        height: getWH(context, 1) * 0.68,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                  onTap: () {
                                    Get.to(() => IndividualProfile(iid: data[index]['individual_id'].toString()));
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          border: Border.all(color: hexStringToColor('#eeeeee')),
                                          borderRadius: BorderRadius.all(Radius.zero)),
                                      child: Column(children: [
                                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          Container(
                                              margin: EdgeInsets.only(right: lang == 'ar' ? 0 : 15, left: lang == 'ar' ? 15 : 0),
                                              height: 110,
                                              width: 110,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: data[index]['profile_photo_path'] != null
                                                          ? NetworkImage(data[index]['profile_photo_path'])
                                                          : AssetImage('assets/logo.png') as ImageProvider,
                                                      fit: BoxFit.contain),
                                                  color: Colors.grey[50],
                                                  border: Border.all(color: Colors.transparent),
                                                  borderRadius: BorderRadius.all(Radius.zero))),
                                          Flexible(
                                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            Text(lang == 'ar' ? data[index]['name_ar'] : data[index]['name_en'], style: TextStyle(fontWeight: FontWeight.bold)),
                                            SizedBox(height: 5),
                                            Text((data[index]['country_name'] ?? '') + ' - ' + (data[index]['region_name'] ?? ''),
                                                style: TextStyle(fontSize: 13)),
                                            Divider(),
                                            Text(data[index]['email'], style: TextStyle(fontSize: 13)),
                                            SizedBox(height: 5),
                                            Row(children: [Icon(Icons.phone, size: 20), SizedBox(width: 5), Text(data[index]['phone'] ?? '')])
                                          ]))
                                        ]),
                                        Container(
                                            color: Colors.grey[50],
                                            padding: EdgeInsets.only(top: 20, bottom: 10, right: 5, left: 5),
                                            child: ExpandablePanel(
                                                header: Text('More Information',
                                                        style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 17))
                                                    .tr(),
                                                collapsed: SizedBox(),
                                                theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                                                expanded: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                  RichText(
                                                      text: TextSpan(children: <TextSpan>[
                                                    TextSpan(text: tr('Skill: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                    TextSpan(
                                                        text: (data[index]['personal_skill_name'] ?? ''),
                                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                  ])),
                                                  SizedBox(height: 4),
                                                  RichText(
                                                      overflow: TextOverflow.ellipsis,
                                                      text: TextSpan(children: <TextSpan>[
                                                        TextSpan(text: tr('Certificate: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                        TextSpan(
                                                            text: (data[index]['skill_certificate_name'] ?? ' - '),
                                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                      ])),
                                                  SizedBox(height: 4),
                                                  RichText(
                                                      overflow: TextOverflow.ellipsis,
                                                      text: TextSpan(children: <TextSpan>[
                                                        TextSpan(text: tr('Ability to train others: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                        TextSpan(
                                                            text: (data[index]['training_ability_name'] ?? ' - '),
                                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                      ])),
                                                  SizedBox(height: 4),
                                                  RichText(
                                                      overflow: TextOverflow.ellipsis,
                                                      text: TextSpan(children: <TextSpan>[
                                                        TextSpan(text: tr('Participated in fairs: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                        TextSpan(
                                                            text: (data[index]['sharing_handicraft_name'] ?? ''),
                                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                      ])),
                                                  SizedBox(height: 4),
                                                  RichText(
                                                      overflow: TextOverflow.ellipsis,
                                                      text: TextSpan(children: <TextSpan>[
                                                        TextSpan(
                                                            text: tr('Able to give feasibility study: '),
                                                            style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                        TextSpan(
                                                            text: (data[index]['feasibility_study_name'] ?? ''),
                                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                      ])),
                                                  SizedBox(height: 4),
                                                  RichText(
                                                      overflow: TextOverflow.ellipsis,
                                                      text: TextSpan(children: <TextSpan>[
                                                        TextSpan(text: tr('Able to work in a team: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                        TextSpan(
                                                            text: (data[index]['working_in_team_name'] ?? ''),
                                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                      ])),
                                                  SizedBox(height: 4),
                                                  RichText(
                                                      overflow: TextOverflow.ellipsis,
                                                      text: TextSpan(children: <TextSpan>[
                                                        TextSpan(text: tr('Has social pages: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                        TextSpan(
                                                            text: (data[index]['have_social_page_name'] ?? ''),
                                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                      ])),
                                                  SizedBox(height: 4),
                                                  RichText(
                                                      overflow: TextOverflow.ellipsis,
                                                      text: TextSpan(children: <TextSpan>[
                                                        TextSpan(text: tr('Has own tools: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                        TextSpan(
                                                            text: (data[index]['owning_the_tools_name'] ?? ''),
                                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                      ])),
                                                ])))
                                      ])));
                            })),
                  ]);
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Container(margin: EdgeInsets.all(35), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                } else {
                  return Center(child: Container(margin: EdgeInsets.all(10), child: Text('No individuals match your criteria').tr()));
                }
              });
        })));
  }
}
