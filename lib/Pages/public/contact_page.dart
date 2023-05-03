import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wathefty/API.dart';
import '../../../functions.dart';
import '../../main.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  @override
  void initState() {
    super.initState();
  }

  final cname = TextEditingController();
  final cemail = TextEditingController();
  final csubject = TextEditingController();
  final phone = TextEditingController();

  bool loading = false;
  final globalFormKey = GlobalKey<FormState>();
  String name = '', email = '', subject = '';
  
  Widget build(BuildContext context) => FutureBuilder<Map>(
      future: loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
          
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: watheftyBar(context, "Contact Us", 20),
            bottomNavigationBar: watheftyBottomBar(context),
            body: StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
              return Column(children: [
                Expanded(
                    child: Container(
                        margin: EdgeInsets.all(30),
                        width: getWH(context, 2),
                        child: SingleChildScrollView(
                            child: Form(
                                key: globalFormKey,
                                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                  Container(
                                      margin: EdgeInsets.only(bottom: 30, left: 15, right: 15),
                                      child: Text('Get in touch', textAlign: TextAlign.start, style: TextStyle(fontSize: 23.0, color: Colors.black87)).tr()),
                                  TextFormField(
                                    keyboardType: TextInputType.name,
                                    controller: cname,
                                    onSaved: (input) {
                                      name = input!;
                                    },
                                    decoration: InputDecoration(
                                        hintText: tr("Name"),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        enabledBorder:
                                            OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  ),
                                  SizedBox(height: 20),
                                  TextFormField(
                                    textDirection: ui.TextDirection.ltr,
                                    keyboardType: TextInputType.emailAddress,
                                    controller: cemail,
                                    onSaved: (value) {
                                      email = value!;
                                    },
                                    validator: (input) => !input!.contains('@') ? tr("Invalid Email") : null,
                                    decoration: InputDecoration(
                                        hintText: tr("Email Address"),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        enabledBorder:
                                            OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                  ),
                                  SizedBox(height: 20),
                                  InternationalPhoneNumberInput(
                                    inputDecoration: InputDecoration(
                                        fillColor: Colors.grey[50],
                                        filled: true,
                                        hintText: tr('Phone Number'),
                                        enabledBorder:
                                            OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                    spaceBetweenSelectorAndTextField: 1,
                                    onInputChanged: (PhoneNumber number) {
                                      phone.text = number.phoneNumber!;
                                    },
                                    selectorConfig: SelectorConfig(
                                        leadingPadding: 15, selectorType: PhoneInputSelectorType.BOTTOM_SHEET, setSelectorButtonAsPrefixIcon: true),
                                    autoValidateMode: AutovalidateMode.onUserInteraction,
                                    initialValue: PhoneNumber(isoCode: 'JO'),
                                    errorMessage: tr('Invalid phone number'),
                                    selectorTextStyle: TextStyle(color: Colors.black),
                                    keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                  ),
                                  SizedBox(height: 20),

                                  // Container(
                                  //     height: 40,
                                  //     child: new TextFormField(
                                  //       keyboardType: TextInputType.text,
                                  //       onSaved: (input) {
                                  //         subject = input!;
                                  //       },
                                  //       decoration: new InputDecoration(
                                  //         hintText: tr("Subject"),
                                  //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                                  //         focusedBorder: OutlineInputBorder(borderSide: BorderSide()),
                                  //         contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40),
                                  //       ),
                                  //     )),
                                  // SizedBox(height: 20),
                                  Container(
                                      height: 200,
                                      child: new TextFormField(
                                        controller: csubject,
                                        keyboardType: TextInputType.multiline,
                                        onSaved: (input) {
                                          subject = input!;
                                        },
                                        maxLines: 8,
                                        decoration: InputDecoration(
                                            hintText: tr("Message"),
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                            enabledBorder:
                                                OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                      )),
                                  !loading
                                      ? Container(
                                          decoration: BoxDecoration(
                                              color: hexStringToColor('#6986b8'),
                                              border: Border.all(width: 0.2),
                                              borderRadius: BorderRadius.all(Radius.circular(30))),
                                          width: getWH(context, 2),
                                          height: getWH(context, 1) * 0.07,
                                          margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                                          alignment: Alignment.center,
                                          child: TextButton(
                                            onPressed: () async {
                                              if (globalFormKey.currentState!.validate()) {
                                                if (cname.text == '' || cemail.text == '' || csubject.text == '') {
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill out the fields").tr()));
                                                } else {
                                                  _setState(() {
                                                    loading = true;
                                                  });
                                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                                  var type = prefs.getString('type');
                                                  Map inf = {
                                                    'email': cemail.text,
                                                    'full_name': cname.text,
                                                    'message': csubject.text,
                                                    'subject': 'App Ticket',
                                                    'phone': phone.text
                                                  };
                                                  await contactUs(lang, type, inf);
                                                  _setState(() {
                                                    loading = false;
                                                  });
                                                }
                                              }
                                            },
                                            child: Text(
                                              "Submit",
                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                                            ).tr(),
                                          ))
                                      : Container(
                                          margin: EdgeInsets.symmetric(horizontal: 30),
                                          alignment: Alignment.centerLeft,
                                          constraints: BoxConstraints.tightForFinite(),
                                          child: CircularProgressIndicator())
                                ])))))
              ]);
            }),
          );
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
