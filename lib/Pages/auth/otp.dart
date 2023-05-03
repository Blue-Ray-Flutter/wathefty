import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import '../../../functions.dart';
import '../../API.dart';
import '../../main.dart';
import '../company/profile.dart';
import '../individual/profile.dart';
import 'dart:ui' as ui;

class OTP extends StatefulWidget {
  const OTP({Key? key, required this.data, required this.type}) : super(key: key);
  @override
  State<OTP> createState() => _OTPState();
  final Map data;
  final int type;
}

class _OTPState extends State<OTP> {
  final phone = TextEditingController();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loading = false;
  }

  @override
  void dispose() {
    super.dispose();
    loading = false;
    counter = 600;
  }

  int counter = 600;
  String code = "";
  @override
  Widget build(BuildContext context) {
    counter = 600;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          centerTitle: true,
          leading: IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back), color: Colors.white),
          backgroundColor: hexStringToColor('#6986b8'),
          elevation: 0,
          title: Text('Verify your phone', style: TextStyle(color: Colors.white)).tr()),
      body: CustomScrollView(slivers: [
        SliverFillRemaining(
            hasScrollBody: false,
            child: Form(
                key: _formKey,
                child:
                    // FutureBuilder<Map>(
                    // future: getOTP(widget.data['phone'], lang),
                    // builder: (context, snapshot) {
                    //   if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
                    //     return
                    Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  // Container(
                  //     margin: const EdgeInsets.only(top: 20, bottom: 15),
                  //     width: 160,
                  //     height: 160,
                  //     decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/logo.png"), fit: BoxFit.contain))),

                  const SizedBox(height: 40),
                  Text(tr('Enter the one-time password sent to ') + widget.data['phone'], textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 15),
                  Directionality(
                      textDirection: ui.TextDirection.ltr,
                      child: OtpTextField(
                          numberOfFields: 6,
                          borderColor: const Color(0xFF512DA8),
                          showFieldAsBox: true,
                          fieldWidth: 50,
                          onSubmit: (String verificationCode) {
                            code = verificationCode;
                          })),
                  StatefulBuilder(builder: (BuildContext context, StateSetter _setRegister) {
                    return Container(
                        width: getWH(context, 2) * 0.55,
                        margin: const EdgeInsets.all(20),
                        child: !loading
                            ? TextButton(
                                onPressed: () async {
                                  if (code.isEmpty) {
                                    Get.snackbar(tr('The code is required'), tr('It will be sent to your phone'),
                                        duration: Duration(seconds: 5),
                                        backgroundColor: Colors.white,
                                        colorText: Colors.amber,
                                        leftBarIndicatorColor: Colors.amber);
                                    return;
                                  }
                                  if (_formKey.currentState!.validate()) {
                                    _setRegister(() => loading = true);
                                    if (widget.type == 1) {
                                      var rg = await register(
                                          widget.data['username'],
                                          widget.data['nameEn'],
                                          widget.data['nameAr'],
                                          widget.data['email'],
                                          widget.data['phone'],
                                          widget.data['password'],
                                          widget.data['userType'],
                                          widget.data['country'],
                                          widget.data['region'],
                                          lang,
                                          code,
                                          '2',
                                          '',
                                          '',
                                          widget.data['employing_company']);
                                      if (rg == 'Pending') {
                                        Get.offAll(() => StartPage());
                                        Get.snackbar(tr('Your account is pending approval'), tr('You will be emailed when your process goes through'),
                                            duration: Duration(seconds: 5),
                                            backgroundColor: Colors.white,
                                            colorText: Colors.green,
                                            leftBarIndicatorColor: Colors.green);
                                      } else if (rg == 'Individual') {
                                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                                          Get.offAll(() => IndivProfilePage());
                                        });
                                      } else if (rg == 'Company') {
                                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                                          Get.offAll(() => CompanyProfilePage());
                                        });
                                      }
                                    } else if (widget.type == 2) {
                                      Map uInfo = widget.data;
                                      uInfo['code'] = code;
                                      var tmp = await updateProfile(lang, uInfo['id'], uInfo['type'], uInfo);
                                      if (tmp['status'] == true && uInfo['type'] == 'Individual') {
                                        Get.offAll(() => IndivProfilePage());
                                      } else if (tmp['status'] == true && uInfo['type'] == 'Company') {
                                        Get.offAll(() => CompanyProfilePage());
                                      }
                                    } else if (widget.type == 3) {
                                      var log = await loginPhone(widget.data["phone"], code, widget.data["type"]);
                                      if (log) {
                                        Get.offAll(() => IndivProfilePage());
                                      }
                                    }
                                    _setRegister(() => loading = false);
                                  }
                                },
                                style: TextButton.styleFrom(
                                    backgroundColor: hexStringToColor('#6986b8'),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0), side: BorderSide(width: 0.2))),
                                child: const Text('Verify', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)).tr())
                            : const Center(child: CircularProgressIndicator(color: Colors.black)));
                  }),
                  StatefulBuilder(builder: (BuildContext context, StateSetter countDown) {
                    if (counter > 0) {
                      Future.delayed(const Duration(milliseconds: 1000), () {
                        countDown(() {
                          counter--;
                        });
                      });
                    } else if (counter == 0) {
                      countDown(() {
                        counter = -1;
                      });
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        Get.snackbar(tr('You ran out of time!'), tr('Please resend the code and try again'),
                            duration: const Duration(seconds: 4), backgroundColor: Colors.white, colorText: Colors.amber, leftBarIndicatorColor: Colors.amber);
                      });
                    }
                    return Column(children: [
                      Text(counter != -1 ? counter.toString() : tr('Timed out')),
                      const SizedBox(height: 20),
                      counter == -1
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  counter = 600;
                                });
                              },
                              child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(text: tr("Didn't receive a code? "), style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                                    TextSpan(text: tr(" Tap here to resend "), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black))
                                  ])))
                          : SizedBox(),
                    ]);
                  }),
                  const Spacer(),
                ])
                //     ;
                //   } else if (snapshot.connectionState == ConnectionState.waiting) {
                //     return Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                //   } else {
                //     return Center(
                //         child: Container(
                //             padding: EdgeInsets.all(50),
                //             child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                //               Text("A problem occurred, either your phone number is invalid, or you are not connected to the internet. If this keeps happening, contact support.",
                //                       textAlign: TextAlign.center)
                //                   .tr(),
                //               TextButton(
                //                   onPressed: () {
                //                     Get.back();
                //                   },
                //                   child: Text('Go back').tr())
                //             ])));
                //   }
                // })
                ))
      ]),
    );
  }
}
