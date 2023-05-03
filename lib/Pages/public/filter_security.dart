import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:wathefty/API.dart';
import '../../../data.dart';
import '../../../functions.dart';
import 'individual_profile.dart';

class SecurityFilters extends StatefulWidget {
  @override
  _SecurityFiltersState createState() => _SecurityFiltersState();
}

class _SecurityFiltersState extends State<SecurityFilters> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    filters.clear();
    ranks.clear();
    education.dispose();
    country.dispose();
    nationality.dispose();
    gender.dispose();
    dateF.dispose();
    dateT.dispose();
    maritalStatus.dispose();
    previous.dispose();
  }

  
  List ranks = [];
  final education = TextEditingController();
  final country = TextEditingController(text: '111');
  final previous = TextEditingController();
  final work = TextEditingController();
  final nationality = TextEditingController();
  final gender = TextEditingController();
  final ageF = TextEditingController();
  final ageT = TextEditingController();
  final dateF = TextEditingController();
  final dateT = TextEditingController();
  var defaultTime1 = DateTime.now();
  var defaultTime2 = DateTime.now();
  final maritalStatus = TextEditingController();

  Map filters = {};
  Widget build(BuildContext context) {
    
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: watheftyBar(context, 'Military Retirees', 18),
        body: SingleChildScrollView(child: StatefulBuilder(builder: (BuildContext context, StateSetter setRefresh) {
          return Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(children: [
                Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.only(top: 15, bottom: 30, right: 15, left: 15),
                    decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(width: 0.1), borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Column(children: [
                      StatefulBuilder(builder: (BuildContext context, StateSetter setDates) {
                        return Column(children: [
                          Container(
                              alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              margin: EdgeInsets.only(bottom: 5, top: 15),
                              child: Text('Retirement year', style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.bold)).tr()),
                          Container(
                              alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text('From', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                          SizedBox(
                              height: getWH(context, 1) * 0.05,
                              child: TextButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 20)),
                                      foregroundColor: MaterialStateProperty.all(Colors.grey[50]),
                                      shape:
                                          MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(side: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                      backgroundColor: MaterialStateProperty.all(Colors.grey[50])),
                                  onPressed: () {
                                    var now = DateTime.now();
                                    DatePicker.showDatePicker(context, showTitleActions: true, maxTime: DateTime(now.year + 1, now.month + 12), onChanged: (date) {}, onConfirm: (date) {
                                      setDates(() {
                                        dateF.text = date.toString().substring(0, 10);
                                      });
                                    }, currentTime: defaultTime1, locale: lang == 'ar' ? LocaleType.ar : LocaleType.en);
                                  },
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(dateF.text.isNotEmpty ? dateF.text : 'Choose a date', style: TextStyle(color: Colors.black54)).tr(),
                                    Icon(Icons.calendar_today, color: Colors.black54)
                                  ]))),
                          Container(
                              alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              margin: EdgeInsets.only(bottom: 5, top: 10),
                              child: Text('To', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                          SizedBox(
                              height: getWH(context, 1) * 0.05,
                              child: TextButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 20)),
                                      foregroundColor: MaterialStateProperty.all(Colors.grey[50]),
                                      shape:
                                          MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(side: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10)))),
                                      backgroundColor: MaterialStateProperty.all(Colors.grey[50])),
                                  onPressed: () {
                                    var now = DateTime.now();
                                    DatePicker.showDatePicker(context, showTitleActions: true, maxTime: DateTime(now.year + 1, now.month + 12), onChanged: (date) {}, onConfirm: (date) {
                                      setDates(() {
                                        dateT.text = date.toString().substring(0, 10);
                                      });
                                    }, currentTime: defaultTime2, locale: lang == 'ar' ? LocaleType.ar : LocaleType.en);
                                  },
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(dateT.text.isNotEmpty ? dateT.text : 'Choose a date', style: TextStyle(color: Colors.black54)).tr(),
                                    Icon(Icons.calendar_today, color: Colors.black54)
                                  ]))),
                        ]);
                      }),
                      Container(
                          alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          margin: EdgeInsets.only(bottom: 5, top: 15),
                          child: Text('Ranks', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                      Container(
                          margin: (EdgeInsets.symmetric(vertical: 10)),
                          child: MultiSelectDialogField(
                              cancelText: Text('Cancel').tr(),
                              confirmText: Text('Confirm').tr(),
                              searchHint: tr('Search'),
                              title: Text('Select').tr(),
                              searchable: true,
                              buttonText: Text('Select').tr(),
                              items: arrtoList(rankArr, lang, 'multiselect').map((e) => MultiSelectItem(e['value'], e['display'])).toList(),
                              listType: MultiSelectListType.LIST,
                              chipDisplay: MultiSelectChipDisplay.none(),
                              buttonIcon: Icon(Icons.arrow_drop_down),
                              decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(color: Colors.black54, width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                              onConfirm: (values) {
                                ranks = values;
                              })),
                      Container(
                          alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          margin: EdgeInsets.only(bottom: 5, top: 15),
                          child: Text('Nature of work', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                      SizedBox(
                          height: getWH(context, 1) * 0.05,
                          child: SelectFormField(
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                              type: SelectFormFieldType.dropdown,
                              items: arrtoList(workTypeArr, lang, ''),
                              controller: work)),
                      Container(
                          alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          margin: EdgeInsets.only(bottom: 5, top: 15),
                          child: Text('Previous occupation', style: TextStyle(fontSize: 15.0, color: Colors.black54)).tr()),
                      SizedBox(
                          height: getWH(context, 1) * 0.05,
                          child: SelectFormField(
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                              type: SelectFormFieldType.dropdown,
                              items: arrtoList(previousWorkArr, lang, ''),
                              controller: previous)),
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
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
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
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
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
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
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
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
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
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                              type: SelectFormFieldType.dropdown,
                              items: arrtoList(maritalStatusArr, lang, ''),
                              controller: maritalStatus)),
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
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
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
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(10))),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10)))),
                              type: SelectFormFieldType.dropdown,
                              items: numbers,
                              controller: ageT)),
                    ])),
                Container(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                        onPressed: () {
                          filters.clear();
                          Get.back();
                          Get.to(() => SecurityFilters());
                        },
                        child: Text("Clear", style: TextStyle(color: Colors.black, fontSize: 16)).tr())),
                GestureDetector(
                    onTap: () {
                      if (ranks.isNotEmpty) filters['rank_degree'] = ranks.isNotEmpty ? ranks.toString() : '';
                      if (education.text.isNotEmpty) filters['academec_degree_id'] = education.text;
                      if (country.text.isNotEmpty) filters['country_id'] = country.text;
                      if (nationality.text.isNotEmpty) filters['public_nationality_id'] = nationality.text;
                      if (gender.text.isNotEmpty) filters['individual_gender'] = gender.text;
                      if (ageF.text.isNotEmpty) filters['age_from'] = ageF.text;
                      if (ageT.text.isNotEmpty) filters['age_to'] = ageT.text;
                      if (dateF.text.isNotEmpty) filters['retirement_year_from'] = dateF.text;
                      if (dateT.text.isNotEmpty) filters['retirement_year_to'] = dateT.text;
                      if (maritalStatus.text.isNotEmpty) filters['individual_social_status'] = maritalStatus.text;
                      if (previous.text.isNotEmpty) filters['previous_work'] = previous.text;
                      if (work.text.isNotEmpty) filters['type_work'] = work.text;
                      filters['type'] = '1';
                      filters['lang'] = lang;
                      Get.to(() => SecurityPage(filters: filters));
                    },
                    child: Container(
                        decoration: BoxDecoration(color: hexStringToColor('#6986b8'), border: Border.all(width: 0.2), borderRadius: BorderRadius.all(Radius.circular(30))),
                        width: getWH(context, 2),
                        height: getWH(context, 1) * 0.05,
                        margin: EdgeInsets.only(top: 10),
                        alignment: Alignment.center,
                        child: Text("Search", style: TextStyle(color: Colors.white, fontSize: 16)).tr())),
                SizedBox(height: 50)
              ]));
        })));
  }
}

//====================================================Results

class SecurityPage extends StatefulWidget {
  const SecurityPage({Key? key, required this.filters}) : super(key: key);

  @override
  _SecurityPageState createState() => _SecurityPageState();
  final Map? filters;
}

class _SecurityPageState extends State<SecurityPage> {
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
                    Get.off(() => SecurityFilters());
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
              future: jobSeekers(fil, 2),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!.isNotEmpty) {
                  data = snapshot.data!['securities'];
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
                                      decoration: BoxDecoration(color: Colors.grey[50], border: Border.all(color: hexStringToColor('#eeeeee')), borderRadius: BorderRadius.all(Radius.zero)),
                                      child: Column(children: [
                                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          Container(
                                              margin: EdgeInsets.only(right: lang == 'ar' ? 0 : 15, left: lang == 'ar' ? 15 : 0),
                                              height: 110,
                                              width: 110,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: data[index]['personal_image'] != null ? NetworkImage(data[index]['personal_image']) : AssetImage('assets/logo.png') as ImageProvider,
                                                      fit: BoxFit.contain),
                                                  color: Colors.grey[50],
                                                  border: Border.all(color: Colors.transparent),
                                                  borderRadius: BorderRadius.all(Radius.zero))),
                                          Flexible(
                                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            Text(lang == 'ar' ? data[index]['name_ar'] : data[index]['name_en'], style: TextStyle(fontWeight: FontWeight.bold)),
                                            SizedBox(height: 5),
                                            Text((data[index]['country_name'] ?? '') + ' - ' + (data[index]['region_name'] ?? ''), style: TextStyle(fontSize: 13)),
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
                                                header: Text('More Information', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 17)).tr(),
                                                collapsed: SizedBox(),
                                                theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                                                expanded: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                  RichText(
                                                      text: TextSpan(children: <TextSpan>[
                                                    TextSpan(text: tr('Retirement year: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                    TextSpan(text: (data[index]['retirement_year'] ?? ''), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                  ])),
                                                  SizedBox(height: 4),
                                                  RichText(
                                                      overflow: TextOverflow.ellipsis,
                                                      text: TextSpan(children: <TextSpan>[
                                                        TextSpan(text: tr('Working years: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                        TextSpan(
                                                            text: (data[index]['duration_working_years'] ?? ' - '), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                      ])),
                                                  SizedBox(height: 4),
                                                  RichText(
                                                      overflow: TextOverflow.ellipsis,
                                                      text: TextSpan(children: <TextSpan>[
                                                        TextSpan(text: tr('Rank: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                        TextSpan(text: (data[index]['rank_degree_name'] ?? ' - '), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                      ])),
                                                  SizedBox(height: 4),
                                                  RichText(
                                                      overflow: TextOverflow.ellipsis,
                                                      text: TextSpan(children: <TextSpan>[
                                                        TextSpan(text: tr('Previous work: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                        TextSpan(text: (data[index]['previous_work_name'] ?? ''), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                      ])),
                                                  SizedBox(height: 4),
                                                  RichText(
                                                      overflow: TextOverflow.ellipsis,
                                                      text: TextSpan(children: <TextSpan>[
                                                        TextSpan(text: tr('Work type: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                        TextSpan(text: (data[index]['type_work_name'] ?? ''), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                      ])),
                                                  SizedBox(height: 4),
                                                  RichText(
                                                      overflow: TextOverflow.ellipsis,
                                                      text: TextSpan(children: <TextSpan>[
                                                        TextSpan(text: tr('Fitness: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                        TextSpan(text: (data[index]['have_fitness_name'] ?? ''), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                      ])),
                                                  SizedBox(height: 4),
                                                  RichText(
                                                      overflow: TextOverflow.ellipsis,
                                                      text: TextSpan(children: <TextSpan>[
                                                        TextSpan(text: tr('Combat skills: '), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                                        TextSpan(text: (data[index]['have_combat_skills_name'] ?? ''), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                                      ])),
                                                ])))
                                      ])));
                            })),
                  ]);
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Container(margin: EdgeInsets.all(35), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                } else {
                  return Center(child: Container(margin: EdgeInsets.all(10), child: Text('No personnel match your criteria').tr()));
                }
              });
        })));
  }
}
