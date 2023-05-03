import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wathefty/API.dart';
import 'package:wathefty/Pages/auth/auth_signup.dart';
import 'package:wathefty/Pages/company/home.dart';
import 'package:wathefty/Pages/company/profile.dart';
import 'package:wathefty/Pages/individual/home.dart';
import 'package:wathefty/Pages/individual/profile.dart';
import '../../functions.dart';
import '../../main.dart';
import 'otp.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    getID();
  }

  String selected = '';
  var userType = '';
  bool loading = false, phone = false, mail = false, _obscureText = true;
  final email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final password = TextEditingController();
  ScrollController _scrollController = ScrollController();
  String deviceId = '', playerId = '';
  @override
  Widget build(BuildContext context) {
    loading = false;
    return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                centerTitle: true,
                leading: IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back), color: Colors.white),
                actions: [
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: IconButton(
                          icon: Icon(
                            Icons.language,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            selectLanguage(context);
                          }))
                ],
                backgroundColor: hexStringToColor('#6986b8'),
                elevation: 0,
                title: Text('Login', style: TextStyle(color: Colors.white)).tr()),
            body: SingleChildScrollView(
                controller: _scrollController,
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  SizedBox(height: 30),
                  Text(
                    'Sign in to your account',
                    style: TextStyle(fontSize: 21, color: Colors.black),
                  ).tr(),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                      onTap: () {
                        Get.off(() => RegisterPage());
                      },
                      child: Text(
                        'Not a member yet? Sign up now!',
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ).tr()),
                  SizedBox(
                    height: 25,
                  ),
                  StatefulBuilder(builder: (BuildContext context, StateSetter _setState) {
                    return Column(children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                              child: Column(children: [
                                Container(
                                  width: getWH(context, 2) * 0.27,
                                  height: 100,
                                  padding: EdgeInsets.all(20),
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(bottom: 5),
                                  decoration: BoxDecoration(
                                      color: selected == 'first' ? Colors.grey[200] : Colors.transparent,
                                      border: Border.all(color: Colors.transparent),
                                      borderRadius: BorderRadius.all(Radius.circular(20))),
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Image.asset(
                                      'assets/emp.png',
                                      color: selected == 'first' ? hexStringToColor('#6986b8') : Colors.grey[700],
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                                Text("Individual",
                                        style: TextStyle(color: (selected == 'first' ? hexStringToColor('#6986b8') : Colors.grey[700]), fontSize: 16))
                                    .tr()
                              ]),
                              onTap: () {
                                _setState(() {
                                  if (userType == 'Company') {
                                    mail = false;
                                    phone = false;
                                  }
                                  selected = 'first';
                                  userType = 'Individual';
                                });
                              }),
                          GestureDetector(
                              child: Column(children: [
                                Container(
                                    margin: EdgeInsets.only(bottom: 5),
                                    width: getWH(context, 2) * 0.27,
                                    height: 100,
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                        color: selected == 'second' ? Colors.grey[200] : Colors.transparent,
                                        border: Border.all(color: Colors.transparent),
                                        borderRadius: BorderRadius.all(Radius.circular(20))),
                                    alignment: Alignment.center,
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Image.asset(
                                        'assets/company.png',
                                        color: selected == 'second' ? hexStringToColor('#6986b8') : Colors.grey[700],
                                        fit: BoxFit.fitHeight,
                                      ),
                                    )),
                                Text("Company", style: TextStyle(color: (selected == 'second' ? hexStringToColor('#6986b8') : Colors.grey[700]), fontSize: 16))
                                    .tr()
                              ]),
                              onTap: () {
                                _setState(() {
                                  selected = 'second';
                                  userType = 'Company';
                                  mail = false;
                                  phone = false;
                                });
                              }),
                        ],
                      ),
                      userType == 'Individual'
                          ? IntrinsicHeight(
                              child: Column(children: [
                              SizedBox(height: 30),
                              StatefulBuilder(builder: (BuildContext context, StateSetter setRegister) {
                                return !loading
                                    ? Column(children: [
                                        Container(
                                            margin: EdgeInsets.symmetric(horizontal: 30, vertical: getWH(context, 1) * 0.01),
                                            child: TextButton(
                                                style: TextButton.styleFrom(
                                                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: getWH(context, 1) * 0.005),
                                                    backgroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0), side: BorderSide(width: 0.2))),
                                                onPressed: () async {
                                                  setRegister(() => loading = true);
                                                  var rg = await loginGoogle(lang);
                                                  setRegister(() => loading = false);
                                                  if (rg == 'Pending') {
                                                    Get.offAll(() => StartPage());
                                                    Get.snackbar(
                                                        tr('Your account is pending approval'), tr('You will be emailed when your process goes through'),
                                                        duration: Duration(seconds: 5),
                                                        backgroundColor: Colors.white,
                                                        colorText: Colors.green,
                                                        leftBarIndicatorColor: Colors.green);
                                                  } else if (rg == 'Individual') {
                                                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                                                      Get.offAll(() => HomePage());
                                                    });
                                                  } else if (rg == 'Company') {
                                                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                                                      Get.offAll(() => CompanyHomePage());
                                                    });
                                                  }
                                                },
                                                child: Row(children: [
                                                  Tab(icon: Image.asset("assets/google.png", height: 30)),
                                                  SizedBox(width: 30),
                                                  Text(
                                                    'Continue With Google',
                                                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                                                  ).tr(),
                                                ]))),
                                        Container(
                                            margin: EdgeInsets.symmetric(horizontal: 30, vertical: getWH(context, 1) * 0.01),
                                            child: TextButton(
                                                style: TextButton.styleFrom(
                                                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: getWH(context, 1) * 0.005),
                                                    backgroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0), side: BorderSide(width: 0.2))),
                                                onPressed: () async {
                                                  setRegister(() => loading = true);
                                                  var rg = await loginFacebook(lang);
                                                  setRegister(() => loading = false);
                                                  if (rg == 'Pending') {
                                                    Get.offAll(() => StartPage());
                                                    Get.snackbar(
                                                        tr('Your account is pending approval'), tr('You will be emailed when your process goes through'),
                                                        duration: Duration(seconds: 5),
                                                        backgroundColor: Colors.white,
                                                        colorText: Colors.green,
                                                        leftBarIndicatorColor: Colors.green);
                                                  } else if (rg == 'Individual') {
                                                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                                                      Get.offAll(() => HomePage());
                                                    });
                                                  } else if (rg == 'Company') {
                                                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                                                      Get.offAll(() => CompanyHomePage());
                                                    });
                                                  }
                                                },
                                                child: Row(children: [
                                                  Tab(icon: Image.asset("assets/fb.png", height: 30)),
                                                  SizedBox(width: 30),
                                                  Text(
                                                    'Continue With Facebook',
                                                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                                                  ).tr(),
                                                ]))),
                                       if (GetPlatform.isIOS)
                                          Container(
                                              margin: EdgeInsets.symmetric(horizontal: 30, vertical: getWH(context, 1) * 0.01),
                                              child: TextButton(
                                                  style: TextButton.styleFrom(
                                                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: getWH(context, 1) * 0.005),
                                                      backgroundColor: Colors.white,
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0), side: BorderSide(width: 0.2))),
                                                  onPressed: () async {
                                                    setRegister(() => loading = true);
                                                    var rg = await loginApple();
                                                    setRegister(() => loading = false);
                                                    if (rg == 'Pending') {
                                                      Get.offAll(() => StartPage());
                                                      Get.snackbar(
                                                          tr('Your account is pending approval'), tr('You will be emailed when your process goes through'),
                                                          duration: Duration(seconds: 5),
                                                          backgroundColor: Colors.white,
                                                          colorText: Colors.green,
                                                          leftBarIndicatorColor: Colors.green);
                                                    } else if (rg == 'Individual') {
                                                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                                                        Get.offAll(() => HomePage());
                                                      });
                                                    } else if (rg == 'Company') {
                                                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                                                        Get.offAll(() => CompanyHomePage());
                                                      });
                                                    }
                                                  },
                                                  child: Row(children: [
                                                    Tab(icon: Image.asset("assets/apple.png", height: 30)),
                                                    SizedBox(width: 30),
                                                    Text(
                                                      'Continue With Apple',
                                                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                                                    ).tr(),
                                                  ])))
                                      ])
                                    : Center(
                                        child: Container(
                                            width: 100,
                                            margin: EdgeInsets.only(top: 10),
                                            constraints: BoxConstraints.tightForFinite(),
                                            child: LinearProgressIndicator()));
                              }),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: getWH(context, 1) * 0.01),
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: getWH(context, 1) * 0.005),
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0), side: BorderSide(width: 0.2))),
                                      onPressed: () async {
                                        _setState(() {
                                          mail == false ? mail = true : mail = false;
                                          if (phone) email.clear();
                                          phone = false;
                                        });
                                        mail == true
                                            ? _scrollController.animateTo(180.0, duration: Duration(milliseconds: 500), curve: Curves.ease)
                                            // ignore: unnecessary_statements
                                            : null;
                                      },
                                      child: Row(children: [
                                        Tab(icon: Image.asset("assets/email.png", height: 30)),
                                        SizedBox(width: 30),
                                        Text('Continue With Email', style: TextStyle(fontSize: 18, color: Colors.grey[700])).tr(),
                                      ]))),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: getWH(context, 1) * 0.01),
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: getWH(context, 1) * 0.005),
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0), side: BorderSide(width: 0.2))),
                                      onPressed: () async {
                                        _setState(() {
                                          mail = false;
                                          phone == false ? phone = true : phone = false;
                                        });
                                        phone == true
                                            ? _scrollController.animateTo(180.0, duration: Duration(milliseconds: 500), curve: Curves.ease)
                                            // ignore: unnecessary_statements
                                            : null;
                                      },
                                      child: Row(children: [
                                        Tab(icon: Icon(Icons.phone_android, size: 30, color: Colors.green)),
                                        SizedBox(width: 30),
                                        Text('Continue With Phone', style: TextStyle(fontSize: 18, color: Colors.grey[700])).tr(),
                                      ]))),
                              if (mail)
                                Container(
                                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                    child: Form(
                                        key: _formKey,
                                        child: Column(children: [
                                          TextFormField(
                                            textDirection: ui.TextDirection.ltr,
                                            controller: email,
                                            decoration: InputDecoration(
                                              labelText: tr('Email'),
                                              hintText: 'example@provider.com',
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return tr('Please enter your Email');
                                              } else if (!value.contains("@")) {
                                                return tr('Please enter a valid Email');
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(height: 15),
                                          TextFormField(
                                            textDirection: ui.TextDirection.ltr,
                                            controller: password,
                                            obscureText: _obscureText,
                                            decoration: InputDecoration(
                                              labelText: tr('Password'),
                                              hintText: tr('at least 8 characters'),
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  _setState(() {
                                                    _obscureText = !_obscureText;
                                                  });
                                                },
                                                color: Colors.black,
                                                icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return tr('Please Enter Your Password');
                                              } else if (value.length < 8) {
                                                return tr('Please input at least 8 characters');
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                              width: getWH(context, 2),
                                              height: getWH(context, 1) * 0.07,
                                              margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                                              child: !loading
                                                  ? ElevatedButton(
                                                      onPressed: () async {
                                                        if (_formKey.currentState!.validate()) {
                                                          _setState(() => loading = true);
                                                          var log = await login(email.text, password.text, lang, "Individual");
                                                          _setState(() => loading = false);
                                                          if (log == 'Pending') {
                                                            return;
                                                          } else if (log && log != 'Pending') {
                                                            Get.offAll(() => IndivProfilePage());
                                                          }
                                                        }
                                                      },
                                                      style: TextButton.styleFrom(
                                                          backgroundColor: hexStringToColor('#6986b8'),
                                                          elevation: 0,
                                                          shape:
                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0), side: BorderSide(width: 0.2))),
                                                      child: Text('Sign in', style: TextStyle(fontSize: 18, color: Colors.white)).tr())
                                                  : Center(child: CircularProgressIndicator())),
                                          GestureDetector(
                                              onTap: () {
                                                _setState(() => loading = false);
                                                launch('https://wathefty.net/forgot-password');
                                              },
                                              child: Text('forgot password', style: TextStyle(color: hexStringToColor('#6986b8'), fontSize: 17)).tr()),
                                          SizedBox(height: 100)
                                        ]))),
                              if (phone)
                                Container(
                                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                    child: Form(
                                        key: _formKey2,
                                        child: Column(children: [
                                          InternationalPhoneNumberInput(
                                            inputDecoration: InputDecoration(
                                                fillColor: Colors.grey[50],
                                                filled: true,
                                                enabledBorder:
                                                    OutlineInputBorder(borderSide: BorderSide(width: 0.4), borderRadius: BorderRadius.all(Radius.circular(25))),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(25)))),
                                            spaceBetweenSelectorAndTextField: 1,
                                            onInputChanged: (PhoneNumber number) {
                                              email.text = number.phoneNumber!;
                                            },
                                            selectorConfig: SelectorConfig(
                                                leadingPadding: 15, selectorType: PhoneInputSelectorType.BOTTOM_SHEET, setSelectorButtonAsPrefixIcon: true),
                                            autoValidateMode: AutovalidateMode.onUserInteraction,
                                            initialValue: PhoneNumber(isoCode: 'JO'),
                                            errorMessage: tr('Invalid phone number'),
                                            selectorTextStyle: TextStyle(color: Colors.black),
                                            keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                          ),
                                          SizedBox(height: 15),
                                          Container(
                                              width: getWH(context, 2),
                                              height: getWH(context, 1) * 0.07,
                                              margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                                              child: !loading
                                                  ? ElevatedButton(
                                                      onPressed: () async {
                                                        if (_formKey2.currentState!.validate()) {
                                                          _setState(() => loading = true);
                                                          Map tmp = await getOTPLogin(email.text, "Individual");
                                                          if (tmp.isNotEmpty && tmp['status']) {
                                                            Get.to(() => OTP(data: {"phone": email.text, "type": "Individual"}, type: 3));
                                                          }
                                                          _setState(() => loading = false);
                                                        }
                                                      },
                                                      style: TextButton.styleFrom(
                                                          backgroundColor: hexStringToColor('#6986b8'),
                                                          elevation: 0,
                                                          shape:
                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0), side: BorderSide(width: 0.2))),
                                                      child: Text('Sign in', style: TextStyle(fontSize: 18, color: Colors.white)).tr())
                                                  : Center(child: CircularProgressIndicator())),
                                          SizedBox(height: 100)
                                        ])))
                            ]))
                          : SizedBox(),
                      userType == 'Company'
                          ? Container(
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              child: Form(
                                  key: _formKey,
                                  child: Column(children: [
                                    TextFormField(
                                      textDirection: ui.TextDirection.ltr,
                                      controller: email,
                                      decoration: InputDecoration(
                                        labelText: tr('Email'),
                                        hintText: 'example@provider.com',
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return tr('Please enter your Email');
                                        } else if (!value.contains("@")) {
                                          return tr('Please enter a valid Email');
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      textDirection: ui.TextDirection.ltr,
                                      controller: password,
                                      obscureText: _obscureText,
                                      decoration: InputDecoration(
                                        labelText: tr('Password'),
                                        hintText: tr('at least 8 characters'),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            _setState(() {
                                              _obscureText = !_obscureText;
                                            });
                                          },
                                          color: Colors.black,
                                          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return tr('Please Enter Your Password');
                                        } else if (value.length < 8) {
                                          return tr('Please input at least 8 characters');
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      width: getWH(context, 2),
                                      height: getWH(context, 1) * 0.07,
                                      margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                                      child: !loading
                                          ? ElevatedButton(
                                              onPressed: () async {
                                                // playerId = await getID();
                                                // if (playerId.isEmpty) {
                                                //   return Get.snackbar(
                                                //     tr('Please try again in a few seconds'),
                                                //     tr("We're making sure your phone supports wathefty."),
                                                //     backgroundColor: Colors.white,
                                                //   );
                                                // }
                                                if (_formKey.currentState!.validate()) {
                                                  _setState(() => loading = true);
                                                  var log = await login(email.text, password.text, lang, "Company");
                                                  if (log == 'Pending') {
                                                    _setState(() => loading = false);
                                                    return;
                                                  } else if (log != null && log != 'Pending' && log != 'Inactive') {
                                                    Get.offAll(() => CompanyProfilePage());
                                                  }
                                                  _setState(() => loading = false);
                                                }
                                              },
                                              style: TextButton.styleFrom(
                                                  backgroundColor: hexStringToColor('#6986b8'),
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0), side: BorderSide(width: 0.2))),
                                              child: Text('Log in', style: TextStyle(fontSize: 18, color: Colors.white)).tr(),
                                            )
                                          : Center(child: CircularProgressIndicator()),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          launch('https://wathefty.net/forgot-password');
                                        },
                                        child: Text('forgot password', style: TextStyle(color: hexStringToColor('#6986b8'), fontSize: 17)).tr()),
                                    SizedBox(height: 100)
                                  ])),
                            )
                          : SizedBox()
                    ]);
                  }),
                ])));
  }
}
