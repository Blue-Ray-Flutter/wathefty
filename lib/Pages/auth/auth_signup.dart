import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wathefty/API.dart';
import 'package:wathefty/Pages/auth/auth_login.dart';
import 'package:wathefty/Pages/auth/otp.dart';
import '../../data.dart';
import '../../functions.dart';
import '../../main.dart';
import '../company/profile.dart';
import '../individual/profile.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  void initState() {
    super.initState();
    getID();
  }

  var rgn;
  PhoneNumber number = PhoneNumber(isoCode: 'JO');
  String selected = '';
  var userType = '';
  bool loading = false, _obscureText = true;
  final phone = TextEditingController();
  final country = TextEditingController(text: '111');
  final region = TextEditingController();
  final nameAr = TextEditingController();
  final nameEn = TextEditingController();
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool companyType = false;
  ScrollController _scrollController = ScrollController();

  FilePickerResult? result;
  String deviceId = '', playerId = '';
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
            title: Text('Sign Up', style: TextStyle(color: Colors.white)).tr()),
        body: SingleChildScrollView(
            controller: _scrollController,
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: [
              SizedBox(height: 30),
              Text('Create a new account', style: TextStyle(fontSize: 21, color: Colors.black)).tr(),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                  onTap: () {
                    Get.off(() => LoginPage());
                  },
                  child: Text(
                    'Already have an account? Sign in instead!',
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
                            Text("Individual", style: TextStyle(color: (selected == 'first' ? hexStringToColor('#6986b8') : Colors.grey[700]), fontSize: 16))
                                .tr()
                          ]),
                          onTap: () {
                            _setState(() {
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
                            Text("Company", style: TextStyle(color: (selected == 'second' ? hexStringToColor('#6986b8') : Colors.grey[700]), fontSize: 16)).tr()
                          ]),
                          onTap: () {
                            _setState(() {
                              selected = 'second';
                              userType = 'Company';
                            });
                          }),
                    ],
                  ),
                  userType.isNotEmpty
                      ? IntrinsicHeight(
                          child: Container(
                              margin: EdgeInsets.only(right: 30, left: 30, top: 30),
                              child: Form(
                                  key: _formKey,
                                  child: Column(children: [
                                    StatefulBuilder(builder: (BuildContext context, StateSetter setRegister) {
                                      return userType == 'Individual' && !loading
                                          ? Column(children: [
                                              Container(
                                                  margin: EdgeInsets.symmetric(vertical: getWH(context, 1) * 0.01),
                                                  child: TextButton(
                                                      style: TextButton.styleFrom(
                                                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: getWH(context, 1) * 0.005),
                                                          backgroundColor: Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0), side: BorderSide(width: 0.2))),
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
                                                            Get.offAll(() => IndivProfilePage());
                                                          });
                                                        } else if (rg == 'Company') {
                                                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                                                            Get.offAll(() => CompanyProfilePage());
                                                          });
                                                        }
                                                      },
                                                      child: Row(children: [
                                                        Tab(icon: Image.asset("assets/google.png", height: 30)),
                                                        SizedBox(width: 30),
                                                        Text('Continue With Google', style: TextStyle(fontSize: 18, color: Colors.grey[700])).tr()
                                                      ]))),
                                              Container(
                                                  margin: EdgeInsets.symmetric(vertical: getWH(context, 1) * 0.01),
                                                  child: TextButton(
                                                      style: TextButton.styleFrom(
                                                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: getWH(context, 1) * 0.005),
                                                          backgroundColor: Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0), side: BorderSide(width: 0.2))),
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
                                                            Get.offAll(() => IndivProfilePage());
                                                          });
                                                        } else if (rg == 'Company') {
                                                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                                                            Get.offAll(() => CompanyProfilePage());
                                                          });
                                                        }
                                                      },
                                                      child: Row(children: [
                                                        Tab(icon: new Image.asset("assets/fb.png", height: 30)),
                                                        SizedBox(width: 30),
                                                        Text('Continue With Facebook', style: TextStyle(fontSize: 18, color: Colors.grey[700])).tr()
                                                      ]))),
                                              if (GetPlatform.isIOS)
                                                Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: getWH(context, 1) * 0.01),
                                                    child: TextButton(
                                                        style: TextButton.styleFrom(
                                                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: getWH(context, 1) * 0.005),
                                                            backgroundColor: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(12.0), side: BorderSide(width: 0.2))),
                                                        onPressed: () async {
                                                          setRegister(() => loading = true);
                                                          var rg = await loginApple();
                                                          setRegister(() => loading = false);
                                                          if (rg == 'Pending') {
                                                            Get.offAll(() => StartPage());
                                                            Get.snackbar(tr('Your account is pending approval'),
                                                                tr('You will be emailed when your process goes through'),
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
                                          : loading
                                              ? Center(
                                                  child: Container(
                                                      width: 100,
                                                      margin: EdgeInsets.only(top: 10),
                                                      constraints: BoxConstraints.tightForFinite(),
                                                      child: LinearProgressIndicator()))
                                              : SizedBox();
                                    }),
                                    userType == 'Company'
                                        ? Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                            Checkbox(
                                                value: companyType,
                                                onChanged: (value) {
                                                  setState(() {
                                                    companyType = value!;
                                                  });
                                                }),
                                            Text('Recruiting Company').tr()
                                          ])
                                        : SizedBox(),
                                    TextFormField(
                                      textDirection: ui.TextDirection.ltr,
                                      controller: email,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.email),
                                        labelText: tr('Email'),
                                        hintText: 'example@provider.com',
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return tr('Please enter your Email');
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    TextFormField(
                                      textDirection: ui.TextDirection.ltr,
                                      controller: username,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.person),
                                        labelText: tr('Username'),
                                        hintText: tr('Please input a username'),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return tr('Please enter your username');
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    TextFormField(
                                      textDirection: ui.TextDirection.ltr,
                                      controller: nameEn,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.text_format),
                                        labelText: tr('English name'),
                                        hintText: tr('Please input your 4 part name in English'),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return tr('Please enter your name');
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    TextFormField(
                                      textDirection: ui.TextDirection.rtl,
                                      controller: nameAr,
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.format_textdirection_r_to_l_outlined),
                                          labelText: tr('Arabic name'),
                                          hintText: tr('Please input your 4 part name in Arabic')),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return tr('Please enter your name');
                                        }
                                        return null;
                                      },
                                    ),
                                    StatefulBuilder(builder: (BuildContext context, StateSetter _setRegion) {
                                      return Column(children: [
                                        SizedBox(height: 10),
                                        SelectFormField(
                                          validator: (val) {
                                            if (val!.isEmpty) {
                                              return tr('Please select country and region');
                                            }
                                            return null;
                                          },
                                          type: SelectFormFieldType.dropdown,
                                          labelText: tr('Country'),
                                          items: arrtoList(countryArr, lang, ''),
                                          // decoration: InputDecoration(
                                          //     hintText: tr('Select Country'), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                                          decoration:
                                              InputDecoration(prefixIcon: Icon(Icons.location_on), labelText: tr('Country'), hintText: tr('Select country')),
                                          controller: country,
                                          onChanged: (val) {
                                            _setRegion(() {
                                              region.clear();
                                            });
                                          },
                                        ),
                                        SizedBox(height: 10),
                                        country.text.isNotEmpty
                                            ? FutureBuilder<List<Map<String, dynamic>>>(
                                                future: getInfo('region', lang, country.text),
                                                builder: (context, snapshot) {
                                                  if (rgn != null || (snapshot.hasData && snapshot.connectionState == ConnectionState.done)) {
                                                    rgn = snapshot.data;
                                                    return SelectFormField(
                                                      decoration: InputDecoration(
                                                          prefixIcon: Icon(Icons.map_outlined), labelText: tr('Region'), hintText: tr('Select region')),
                                                      validator: (val) {
                                                        if (val!.isEmpty) {
                                                          return tr('Please select region');
                                                        }
                                                        return null;
                                                      },
                                                      type: SelectFormFieldType.dropdown,
                                                      labelText: tr('Region'),
                                                      items: rgn,
                                                      controller: region,
                                                    );
                                                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                                                    return Center(
                                                        child: Container(
                                                            margin: EdgeInsets.only(top: 10),
                                                            constraints: BoxConstraints.tightForFinite(),
                                                            child: CircularProgressIndicator()));
                                                  } else {
                                                    return SizedBox();
                                                  }
                                                })
                                            : SizedBox()
                                      ]);
                                    }),
                                    SizedBox(height: 10),
                                    InternationalPhoneNumberInput(
                                      inputDecoration: InputDecoration(labelText: tr('Mobile number'), hintText: tr('Input mobile number')),
                                      spaceBetweenSelectorAndTextField: 0,
                                      onInputChanged: (PhoneNumber number) {
                                        phone.text = number.phoneNumber!;
                                      },
                                      selectorConfig: SelectorConfig(setSelectorButtonAsPrefixIcon: true, selectorType: PhoneInputSelectorType.BOTTOM_SHEET),
                                      autoValidateMode: AutovalidateMode.onUserInteraction,
                                      hintText: tr('Phone number'),
                                      initialValue: phone.text.isNotEmpty ? PhoneNumber(isoCode: 'JO', phoneNumber: phone.text) : PhoneNumber(isoCode: 'JO'),
                                      errorMessage: tr('Invalid phone number'),
                                      selectorTextStyle: TextStyle(color: Colors.black),
                                      keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                    ),
                                    SizedBox(height: 10),
                                    StatefulBuilder(builder: (BuildContext context, StateSetter setObscure) {
                                      return TextFormField(
                                        textDirection: ui.TextDirection.ltr,
                                        controller: password,
                                        obscureText: _obscureText,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.password),
                                          labelText: tr('Password'),
                                          hintText: tr('at least 8 characters'),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setObscure(() {
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
                                      );
                                    }),
                                    SizedBox(height: 15),
                                    StatefulBuilder(builder: (BuildContext context, StateSetter _setRegister) {
                                      return Container(
                                          width: getWH(context, 2),
                                          height: getWH(context, 1) * 0.07,
                                          margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                                          child: !loading
                                              ? ElevatedButton(
                                                  onPressed: () async {
                                                    if (country.toString().isEmpty || region.toString().isEmpty) {
                                                      Get.snackbar('Please select your country', '');
                                                      return;
                                                    }
                                                    if (_formKey.currentState!.validate()) {
                                                      _setRegister(() => loading = true);
                                                      Map data = {
                                                        'username': username.text,
                                                        'nameEn': nameEn.text,
                                                        'nameAr': nameAr.text,
                                                        'email': email.text,
                                                        'phone': phone.text,
                                                        'password': password.text,
                                                        'userType': userType,
                                                        'country': country.text,
                                                        'region': region.text,
                                                        'employing_company': companyType ? '2' : '1',
                                                        "type": "Individual"
                                                      };
                                                      Map tmp = await getOTP(phone.text, lang);
                                                      if (tmp.isNotEmpty && tmp['status']) {
                                                        _setRegister(() => loading = false);
                                                        Get.to(() => OTP(data: data, type: 1));
                                                      } else {
                                                        _setRegister(() => loading = false);
                                                      }
                                                      // var rg = await register(username.text, nameEn.text, nameAr.text, email.text, phone.text, password.text,
                                                      //     userType, country.text, region.text, lang);
                                                      // if (rg == 'Pending') {
                                                      //   Get.offAll(() => StartPage());
                                                      //   Get.snackbar(
                                                      //       tr('Your account is pending approval'), tr('You will be emailed when your process goes through'),
                                                      //       duration: Duration(seconds: 5),
                                                      //       backgroundColor: Colors.white,
                                                      //       colorText: Colors.green,
                                                      //       leftBarIndicatorColor: Colors.green);
                                                      // } else if (rg == 'Individual') {
                                                      //   WidgetsBinding.instance!.addPostFrameCallback((_) {
                                                      //     Get.offAll(() => IndivProfilePage());
                                                      //   });
                                                      // } else if (rg == 'Company') {
                                                      //   WidgetsBinding.instance!.addPostFrameCallback((_) {
                                                      //     Get.offAll(() => CompanyProfilePage());
                                                      //   });
                                                      // }
                                                      // _setRegister(() => loading = false);
                                                    }
                                                  },
                                                  style: TextButton.styleFrom(
                                                      backgroundColor: hexStringToColor('#6986b8'),
                                                      elevation: 0,
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0), side: BorderSide(width: 0.2))),
                                                  child: Text('Register', style: TextStyle(fontSize: 18, color: Colors.white)).tr(),
                                                )
                                              : Center(child: CircularProgressIndicator()));
                                    })
                                  ]))))
                      : SizedBox(),
                  GestureDetector(
                      onTap: () async {
                        launch('https://wathefty.net/en/frontEnd/privacyPolicy');
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                          child: RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(text: tr("By signing up you agree to "), style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                                TextSpan(
                                    text: tr("Wathefty's privacy policy"),
                                    style: TextStyle(color: hexStringToColor('#6986b8'), fontWeight: FontWeight.bold, fontSize: 15))
                              ]))))
                ]);
              }),
            ])));
  }
}
