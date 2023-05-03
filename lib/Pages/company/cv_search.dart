import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:wathefty/API.dart';
import 'package:wathefty/Pages/public/individual_profile.dart';
import '../../../data.dart';
import '../../../functions.dart';

class CVFiltersPage extends StatefulWidget {
  @override
  _CVFiltersPageState createState() => _CVFiltersPageState();
}

class _CVFiltersPageState extends State<CVFiltersPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    filters.clear();
    section.dispose();
    specialty.dispose();
    professions.clear();
    education.dispose();
    country.dispose();
    region.dispose();
    gender.dispose();
    experienceF.dispose();
    experienceT.dispose();
    options1.clear();
    options2.clear();
    options3.clear();
    options4.clear();
  }

  final section = TextEditingController();
  final specialty = TextEditingController();
  List professions = [];
  final education = TextEditingController();
  final country = TextEditingController(text: '111');
  final region = TextEditingController();
  final gender = TextEditingController();
  final experienceF = TextEditingController();
  final experienceT = TextEditingController();
  final socialStatus = TextEditingController();
  List<Map<String, dynamic>> options1 = [];
  List<Map<String, dynamic>> options2 = [];
  List<Map<String, dynamic>> options3 = [];
  List<Map<String, dynamic>> options4 = [];

  Map filters = {};
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: watheftyBar(context, 'Advanced Search', 19),
        body: SingleChildScrollView(child: StatefulBuilder(builder: (BuildContext context, StateSetter setFields) {
          return Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(children: [
                StatefulBuilder(builder: (BuildContext context, StateSetter setSection) {
                  return Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.only(top: 15, bottom: 30, right: 15, left: 15),
                      decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.1), borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Column(children: [
                        Container(
                            alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            margin: EdgeInsets.only(bottom: 5, top: 15),
                            child: Text('Section', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                        FutureBuilder<List<Map<String, dynamic>>>(
                            future: getInfo('jsection', lang, globalType),
                            builder: (context, snapshot) {
                              if (options1.isNotEmpty || (snapshot.hasData && snapshot.connectionState == ConnectionState.done)) {
                                options1 = mpJC;
                                return SizedBox(
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
                                      labelText: tr('Job section'),
                                      items: options1,
                                      controller: section,
                                      onChanged: (val) {
                                        setSection(() {
                                          mpJS.clear();
                                          specialty.clear();
                                          options2.clear();
                                          options3.clear();
                                        });
                                      },
                                    ));
                              } else {
                                return Center(
                                    child: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                        constraints: BoxConstraints.tightForFinite(),
                                        child: LinearProgressIndicator()));
                              }
                            }),
                        section.text.isNotEmpty
                            ? Container(
                                alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                margin: EdgeInsets.only(bottom: 5, top: 15),
                                child: Text('Specialty', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr())
                            : SizedBox(),
                        section.text.isNotEmpty
                            ? FutureBuilder<List<Map<String, dynamic>>>(
                                future: getInfo('jspecialty', lang, section.text),
                                builder: (context, snapshot) {
                                  if (options2.isNotEmpty || (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty)) {
                                    options2 = mpJS;
                                    return SizedBox(
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
                                          items: options2,
                                          controller: specialty,
                                          onChanged: (val) {
                                            setSection(() {
                                              professions.clear();
                                              options3.clear();
                                            });
                                          },
                                        ));
                                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(
                                        child: Container(
                                            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                            constraints: BoxConstraints.tightForFinite(),
                                            child: LinearProgressIndicator()));
                                  } else {
                                    return SizedBox();
                                  }
                                })
                            : SizedBox(),
                        specialty.text.isNotEmpty
                            ? Container(
                                alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                margin: EdgeInsets.only(top: 15),
                                child: Text('Professions', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr())
                            : SizedBox(),
                        specialty.text.isNotEmpty
                            ? FutureBuilder<List<Map<String, dynamic>>>(
                                future: getInfo('profession', lang, specialty.text),
                                builder: (context, snapshot) {
                                  if (options3.isNotEmpty || (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty)) {
                                    options3 = mpPRF;
                                    return Container(
                                        margin: (EdgeInsets.symmetric(vertical: 10)),
                                        child: MultiSelectDialogField(
                                            cancelText: Text('Cancel').tr(),
                                            confirmText: Text('Confirm').tr(),
                                            searchHint: tr('Search'),
                                            title: Text('Select').tr(),
                                            searchable: true,
                                            buttonText: Text('Select').tr(),
                                            items: options3.map((e) => MultiSelectItem(e['value'], e['display'])).toList(),
                                            listType: MultiSelectListType.LIST,
                                            initialValue: professions,
                                            chipDisplay: MultiSelectChipDisplay.none(),
                                            buttonIcon: Icon(Icons.arrow_drop_down),
                                            decoration: BoxDecoration(
                                                color: Colors.grey[50],
                                                border: Border.all(color: Colors.black54, width: 0.4),
                                                borderRadius: BorderRadius.all(Radius.circular(10))),
                                            onConfirm: (values) {
                                              professions = values;
                                            }));
                                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(
                                        child: Container(
                                            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                            constraints: BoxConstraints.tightForFinite(),
                                            child: LinearProgressIndicator()));
                                  } else {
                                    return SizedBox();
                                  }
                                })
                            : SizedBox(),
                      ]));
                }),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.only(top: 15, bottom: 30, right: 15, left: 15),
                    decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.1), borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: StatefulBuilder(builder: (BuildContext context, StateSetter setFields) {
                      return Column(children: [
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
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                    focusedBorder:
                                        OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                type: SelectFormFieldType.dropdown,
                                items: arrtoList(countryArr, lang, ''),
                                controller: country,
                                onChanged: (val) {
                                  setFields(() {});
                                  options4.clear();
                                })),
                        country.text.isNotEmpty
                            ? Container(
                                alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                margin: EdgeInsets.only(bottom: 5, top: 15),
                                child: Text('Region', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr())
                            : SizedBox(),
                        country.text.isNotEmpty
                            ? FutureBuilder<List<Map<String, dynamic>>>(
                                future: getInfo('region', lang, country.text),
                                builder: (context, snapshot) {
                                  if (options4.isNotEmpty || (snapshot.hasData && snapshot.connectionState == ConnectionState.done)) {
                                    options4 = mpR;
                                    return SizedBox(
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
                                            items: mpR,
                                            controller: region));
                                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(
                                        child: Container(
                                            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                            constraints: BoxConstraints.tightForFinite(),
                                            child: LinearProgressIndicator()));
                                  } else {
                                    return SizedBox();
                                  }
                                })
                            : SizedBox()
                      ]);
                    })),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.only(top: 15, bottom: 30, right: 15, left: 15),
                    decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.1), borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Column(children: [
                      Container(
                          alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          margin: EdgeInsets.only(bottom: 5, top: 15),
                          child: Text('Social status', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                      SizedBox(
                          height: getWH(context, 1) * 0.05,
                          child: SelectFormField(
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                  focusedBorder:
                                      OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                              type: SelectFormFieldType.dropdown,
                              items: arrtoList(maritalStatusArr, lang, ''),
                              controller: socialStatus)),
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
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                  focusedBorder:
                                      OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
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
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                  focusedBorder:
                                      OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                              type: SelectFormFieldType.dropdown,
                              items: arrtoList(genderArr, lang, ''),
                              controller: gender))
                    ])),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.only(top: 15, bottom: 30, right: 15, left: 15),
                    decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.1), borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Column(children: [
                      Container(
                          alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          margin: EdgeInsets.only(bottom: 5, top: 15),
                          child: Text('Experience', style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.bold)).tr()),
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
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                  focusedBorder:
                                      OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                              type: SelectFormFieldType.dropdown,
                              items: numbers,
                              controller: experienceF)),
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
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                  focusedBorder:
                                      OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                              type: SelectFormFieldType.dropdown,
                              items: numbers,
                              controller: experienceT))
                    ])),
                Container(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                        onPressed: () {
                          filters.clear();
                          Get.back();
                          Get.to(() => CVFiltersPage());
                        },
                        child: Text("Clear", style: TextStyle(color: Colors.black, fontSize: 16)).tr())),
                GestureDetector(
                    onTap: () {
                      if (section.text.isNotEmpty) filters['job_section_id_searche'] = section.text;
                      if (specialty.text.isNotEmpty) filters['specialty_id_searche'] = specialty.text;
                      if (professions.isNotEmpty) filters['professions_searche[]'] = professions.isNotEmpty ? professions.toString() : '';
                      if (education.text.isNotEmpty) filters['public_academic_degree_id_searche'] = education.text;
                      if (country.text.isNotEmpty) filters['country_id_searche'] = country.text;
                      if (region.text.isNotEmpty) filters['region_id_searche'] = region.text;
                      if (gender.text.isNotEmpty) filters['gender_searche'] = gender.text;
                      if (experienceF.text.isNotEmpty) filters['experience_years_from_searche'] = experienceF.text;
                      if (experienceT.text.isNotEmpty) filters['experience_years_to_searche'] = experienceT.text;
                      if (socialStatus.text.isNotEmpty) filters['social_status'] = socialStatus.text;
                      filters['type'] = '1';
                      filters['company_id'] = globalUid;
                      filters['lang'] = lang;
                      Get.to(() => CVResultsPage(filters: filters, saved: 1));
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: hexStringToColor('#6986b8'), border: Border.all(width: 0.2), borderRadius: BorderRadius.all(Radius.circular(30))),
                        width: getWH(context, 2),
                        height: getWH(context, 1) * 0.05,
                        margin: EdgeInsets.only(top: 10),
                        alignment: Alignment.center,
                        child: Text("Search", style: TextStyle(color: Colors.white, fontSize: 16)).tr())),
                TextButton(
                    onPressed: () async {
                      if (section.text.isNotEmpty) filters['job_section_id_searche'] = section.text;
                      if (specialty.text.isNotEmpty) filters['specialty_id_searche'] = specialty.text;
                      if (professions.isNotEmpty) filters['professions_searche[]'] = professions.isNotEmpty ? professions.toString() : '';
                      if (education.text.isNotEmpty) filters['public_academic_degree_id_searche'] = education.text;
                      if (country.text.isNotEmpty) filters['country_id_searche'] = country.text;
                      if (region.text.isNotEmpty) filters['region_id_searche'] = region.text;
                      if (gender.text.isNotEmpty) filters['gender_searche'] = gender.text;
                      if (experienceF.text.isNotEmpty) filters['experience_years_from_searche'] = experienceF.text;
                      if (experienceT.text.isNotEmpty) filters['experience_years_to_searche'] = experienceT.text;
                      if (socialStatus.text.isNotEmpty) filters['social_status'] = socialStatus.text;
                      filters['type'] = '2';
                      filters['company_id'] = globalUid;
                      filters['lang'] = lang;
                      await saveSearch(context, filters, 2);
                    },
                    child: Text("Save search", style: TextStyle(decoration: TextDecoration.underline, color: hexStringToColor('#6986b8'), fontSize: 16)).tr())
              ]));
        })));
  }
}

//====================================================Results

class CVResultsPage extends StatefulWidget {
  const CVResultsPage({Key? key, required this.filters, required this.saved}) : super(key: key);

  @override
  _CVResultsPageState createState() => _CVResultsPageState();
  final Map filters;
  final int saved;
}

class _CVResultsPageState extends State<CVResultsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    loading = false;
  }

  bool loading = false;
  List j = [];
  Widget build(BuildContext context) {
    loading = false;
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
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
            children: [
              SpeedDialChild(
                  child: Icon(Icons.star, color: Colors.blueGrey),
                  backgroundColor: Colors.white,
                  label: tr('Review'),
                  onTap: () async {
                    Map review = {};
                    review.addAll(widget.filters);
                    review["company_id"] = globalUid;
                    await commentDialog(context, globalType, 'CV search review', lang, globalUid, '', '', review);
                  })
            ]),
        appBar: watheftyBar(context, "Search Results", 18),
        body: SingleChildScrollView(
            child: FutureBuilder<Map>(
                future: advancedCVSearch(widget.filters, 1),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData &&
                      snapshot.data!.isNotEmpty &&
                      snapshot.data!["individuals_data"].isNotEmpty) {
                    j = snapshot.data!['individuals_data'];
                    return Column(children: [
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                          width: getWH(context, 2),
                          height: getWH(context, 1) * 0.68,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: j.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      Get.to(() => IndividualProfile(iid: j[index]['id'].toString()));
                                    },
                                    child: Column(children: [
                                      Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.symmetric(vertical: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[50],
                                              border: Border.all(color: hexStringToColor('#eeeeee')),
                                              borderRadius: BorderRadius.all(Radius.zero)),
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                            Container(
                                                margin: EdgeInsets.only(right: lang == 'ar' ? 0 : 15, left: lang == 'ar' ? 15 : 0),
                                                height: 110,
                                                width: 110,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: j[index]['profile_photo_path'] != null
                                                            ? NetworkImage(j[index]['profile_photo_path'])
                                                            : AssetImage('assets/logo.png') as ImageProvider,
                                                        fit: BoxFit.fill),
                                                    color: Colors.grey[50],
                                                    border: Border.all(color: Colors.transparent),
                                                    borderRadius: BorderRadius.all(Radius.zero))),
                                            Flexible(
                                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                              Text(lang == 'ar' ? j[index]['name_ar'] : j[index]['name_en'], style: TextStyle(fontWeight: FontWeight.bold)),
                                              SizedBox(height: 5),
                                              Text(j[index]['email']),
                                              SizedBox(height: 5),
                                              Text(
                                                  lang == 'ar'
                                                      ? ((j[index]['section_name_ar'] ?? "") + ' - ' + (j[index]['specialty_name_ar'] ?? ""))
                                                      : ((j[index]['section_name_en'] ?? "") + ' - ' + (j[index]['specialty_name_en'] ?? "")),
                                                  style: TextStyle(fontSize: 13)),
                                              SizedBox(height: 5),
                                              if (j[index]['total_experience'] != null) Text(j[index]['total_experience'] + tr(" years of experience")),
                                              Divider(),
                                              Row(children: [
                                                Icon(Icons.location_pin, size: 20),
                                                SizedBox(width: 5),
                                                Text(lang == 'ar'
                                                    ? (j[index]['country_ar'] + ' - ' + j[index]['region_ar'])
                                                    : (j[index]['country_en'] + ' - ' + j[index]['region_en']))
                                              ]),
                                              StatefulBuilder(builder: (BuildContext context, StateSetter setLike) {
                                                return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                                  IconButton(
                                                      onPressed: () async {
                                                        setLike(() => loading = true);
                                                        Map like = await likeCV(j[index]["id"].toString());
                                                        setLike(() {
                                                          loading = false;
                                                          if (like.isNotEmpty && like["status"]) {
                                                            j[index]["cvLiked"] == "no" ? j[index]["cvLiked"] = "yes" : j[index]["cvLiked"] = "no";
                                                          }
                                                        });
                                                      },
                                                      icon: Icon(j[index]["cvLiked"] == "no" ? Icons.favorite_border : Icons.favorite),
                                                      color: Colors.red)
                                                ]);
                                              })
                                            ]))
                                          ]))
                                    ]));
                              }))
                    ]);
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Container(margin: EdgeInsets.all(35), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                  } else {
                    return Center(child: Container(margin: EdgeInsets.all(10), child: Text('No CVs match your criteria').tr()));
                  }
                })));
  }
}
