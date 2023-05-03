import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wathefty/Pages/public/gallery.dart';
import 'package:wathefty/data.dart';
import 'package:wathefty/functions.dart';

import 'Pages/individual/profile.dart';

// var l = Logger();
Future login(email, password, lang, type) async {
  email = (email.replaceAll(new RegExp(r"\s+"), ""));
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // 1
  Uri url = Uri.https(
      'wathefty.net', '/api/' + type.toString().toLowerCase() + '/login');
  var player = await getID();
  var response = await http.post(url, body: {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "email": email,
    "password": password,
    "lang": lang,
    "user_type": type,
    "player_id": player
  });
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == false) {
      Get.snackbar(map['msg'], '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return {'status': '0', 'message': map['msg']};
    } else if (map['status'] == true) {
      if (type == 'Company' && map['user']['user_status'] == 'Pending') {
        Get.snackbar(tr('Your account is pending approval'),
            tr('You will be emailed when your process goes through.'),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.green,
            leftBarIndicatorColor: Colors.green);
        return map['user']['user_status'];
      }
      if (map['user']['user_status'] == "Inactive") {
        Get.snackbar(tr('Your account is inactive'),
            tr('Contact support for more information.'),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return map['user']['user_status'];
      }
      prefs.setString('token', map['access_token']);
      await prefs.setString('uid', map['user']['id'].toString());
      await prefs.setString('name_ar', map['user']['name_ar']);
      await prefs.setString('name_en', map['user']['name_en']);
      await prefs.setString('username', map['user']['username']);
      await prefs.setString('email', map['user']['email']);
      await prefs.setString('type', type);
      await prefs.setString(
          'profile_photo_path',
          map['user']['profile_photo_path'] != null
              ? map['user']['profile_photo_path']
              : 'https://icon-library.com/images/white-profile-icon/white-profile-icon-24.jpg');
      globalImage = map['user']['profile_photo_path'] != null
          ? map['user']['profile_photo_path']
          : 'https://icon-library.com/images/white-profile-icon/white-profile-icon-24.jpg';
      globalType = type;
      globalUid = map['user']['id'].toString();

      return true;
    } else {
      Get.snackbar(map['msg'], '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
    }
  } else if (response.statusCode == 401) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == false) {
      Get.snackbar(map['error'], tr("User does not exist"),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return false;
    }
  } else {
    Get.snackbar(tr('Something went wrong'),
        tr("Please make sure you're connected the internet try again"),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.red,
        leftBarIndicatorColor: Colors.red);

    return false;
  }
}

Future<Map> getProfile(type) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var uid = prefs.getString('uid');
  Uri url;
  if (type == 'Individual') {
    // 2
    url = Uri.https('wathefty.net', '/api/individual/getUserProfile');
  } else {
    // 3
    url = Uri.https('wathefty.net', '/api/company/getCompanyProfile');
  }
  var response = await http.post(url, body: {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "user_id": uid.toString(),
    "user_type": type,
    "lang": lang
  });
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (map['status'] == true) {
      if (map['user_info'] != null &&
          map['user_info']['profile_photo_path'] == null) {
        map['user_info']['profile_photo_path'] =
            'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png';
      } else if (map['user'] != null &&
          map['user']['profile_photo_path'] == null) {
        map['user']['profile_photo_path'] =
            'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png';
      }
      type == 'Individual'
          ? prefs.setString(
              'profile_photo_path', map['user_info']['profile_photo_path'])
          : prefs.setString(
              'profile_photo_path', map['user']['profile_photo_path']);
      return map;
    } else {
      return {};
    }
  } else {
    return {};
  }
}

Future<Map> getOtherProfile(type, lang, id) async {
  // 4
  Uri url = Uri.https('wathefty.net', '/api/individual/getCompany');
  Map body = {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
    "individual_id": globalUid,
    "user_type": type,
    "company_id": id
  };
  if (type == 'Guest') {
    url = Uri.https('wathefty.net', '/api/frontend/getCompanyGuest');
    body = {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "user_id": '0',
      "user_type": type,
      "company_id": id
    };
  }
  var response = await http.post(url, body: body);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      return map;
    } else {
      return map;
    }
  } else {
    return {};
  }
}

Future<Map> getIndivProfile(
    String type, String lang, String id, String? jobId, int? jobType) async {
  var uid;
  if (type == 'Individual' || type == 'Guest') {
    uid = '1';
  } else {
    uid = globalUid;
  }
  Map body = {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
    "user_id": uid,
    "user_type": 'Company',
    "individual_id": id
  };
  if (jobId != null) {
    body['job_id'] = jobId;
    body['job_type'] = jobType == 1 ? 'Normal Job' : 'Special Job';
  }
  // 5

  Uri url =
      Uri.https('wathefty.net', '/api/company/companyShowProfileIndividual');
  var response = await http.post(url, body: body);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      return map;
    } else {
      return map;
    }
  } else {
    return {};
  }
}

Future getInformation(uid, type, lang) async {
  // 6
  Uri url = Uri.https('wathefty.net', '/api/users/getUserInformation');
  var response = await http.post(url, body: {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "user_id": uid.toString(),
    "user_type": type,
    "lang": lang,
  });
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      return map;
    } else {
      if (map['status'] == false) {
        return map;
      }
    }
  } else {
    return null;
  }
}

Future<Map> getCompanyJobs(String uid, String type, String lang, String? status,
    String? jobId, int jType, Map? filters) async {
  var temp = false;
  if (status == '4') {
    //If stopped job
    temp = true;
  }
  Uri url;
  Map jmap = {};
  Map body = {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "user_id": uid,
    "user_type": type,
    "lang": lang
  };
  if (jType == 1 && jobId == null) {
    //regular all jobs
    // 7
    url = Uri.https('wathefty.net', '/api/company/getAllCompanyJob');
  } else if (jobId != null && jType == 1) {
    //regular 1 job
    // 8
    url = Uri.https('wathefty.net', '/api/frontend/showJob');
    body['job_id'] = jobId;
    body['view_counter'] = '1';
  } else if (jobId != null && jType == 2) {
    //special 1 job
    // 9
    url = Uri.https('wathefty.net', '/api/company/companyShowSpecialJob');
    body['job_id'] = jobId;
  } else {
    //jType == 2 Special all jobs
    // 10
    url = Uri.https('wathefty.net', '/api/company/getAllCompanySpecialJobs');
  }
  if (filters != null && filters.isNotEmpty) {
    body.addAll(filters);
  }
  var response = await http.post(url, body: body);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      List<dynamic> data;
      if (jobId == null) {
        jType == 1 ? data = map["All_Jobs"] : data = map["All_Special_Jobs"];
        List<dynamic> dt = [];
        for (var u in data) {
          if (status != null && u['job_status'].toString() != status && !temp) {
            continue;
          } else if (status != null &&
              temp &&
              u['job_status'].toString() != '4' &&
              u['job_status'].toString() != '5') {
            continue;
          }
          dt.add({
            'id': u['id'],
            'section': lang == 'ar'
                ? u['job_section_name_ar']
                : u['job_section_name_en'],
            'specialty':
                lang == 'ar' ? u['specialty_name_ar'] : u['specialty_name_en'],
            'job_title': lang == 'ar' ? u['job_title_ar'] : u['job_title_en'],
            'job_description': lang == 'ar'
                ? u['job_description_ar']
                : u['job_description_en'],
            'job_status': u['job_status'],
            'submission_deadline': u['submission_deadline'],
            'show_company_info': jType == 1 ? u['show_company_info'] : '',
            'apply_type': jType == 1 ? u['apply_type'] : '',
            'gender': jType == 1 ? u['gender'] : '',
            'nationality': u['nationality'],
            'degree': u['academic_degrees'],
            'country': u['country'],
            'region': u['region'],
            'experience_years': u['experience_years'],
            'salary_from': u['salary_from'],
            'salary_to': u['salary_to'],
            'currency': u['currency'],
            'applying': u['individuals_applying'].toString(),
            'views': u['view_counter'].toString(),
            'job_image': u['job_image'] != null && u['job_image'].isNotEmpty
                ? u['job_image']
                : 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png',
          });
        }
        jmap = dt.asMap();
      } else {
        return map['Job'];
      }
      return jmap;
    } else {
      return {};
    }
  } else {
    return {};
  }
}

Future<Map> getJob(uid, type, lang, jobId, view, String jobType) async {
  Uri url;
  if (jobType == 'Normal Job') {
    // 11
    url = Uri.https('wathefty.net', '/api/individual/getJob');
  } else {
    // 12
    url = Uri.https('wathefty.net', '/api/individual/getSpecialJob');
  }
  var bod = {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "user_type": type,
    "lang": lang,
    "individual_id": uid.toString(),
    "job_id": jobId,
    "view_status": view ?? '2', //2 = didn't open job in last hour
  };
  var response = await http.post(url, body: bod);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      map['Job']['status'] = true;
      return map['Job'];
    } else {
      return {};
    }
  } else {
    return {};
  }
}

Future<Map> getCourse(uid, type, lang, courseId) async {
  // 13
  Uri url = Uri.https('wathefty.net', '/api/individual/courseDetails');
  if (type == 'Guest') {
    uid = '0';
    type = 'Individual';
  }
  var bod = {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "user_type": type,
    "lang": lang,
    "individual_id": uid,
    "course_id": courseId.toString(),
  };
  var response = await http.post(url, body: bod);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      map['course']['status'] = true;
      return map['course'];
    } else {
      return map;
    }
  } else {
    return {'status': false};
  }
}

Future<Map> getCompanyEvents(uid, type, lang, optional, eventId) async {
  Map jmap = {};
  // 14
  Uri url = Uri.https('wathefty.net', '/api/company/getAllCompanyEvents');
  var bod = {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "user_id": uid.toString(),
    "user_type": type,
    "lang": lang,
  };
  if (eventId != null) {
    // 15
    url = Uri.https('wathefty.net', '/api/frontend/showEventDetails');
    bod['event_id'] = eventId;
  }
  var response = await http.post(url, body: bod);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      List<dynamic> data;
      if (eventId == null) {
        data = map["company_posts"];
        List<dynamic> dt = [];
        for (var u in data) {
          if (optional != null && u['event_status'].toString() != optional) {
            continue;
          }
          dt.add({
            'id': u['event_id'],
            'event_title':
                lang == 'ar' ? u['event_title_ar'] : u['event_title_en'],
            'event_des': lang == 'ar' ? u['event_des_ar'] : u['event_des_en'],
            'company_id': u['company_id'],
            'event_status': u['event_status'],
            'event_image': (u['event_image'] != null
                ? u['event_image']
                : 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png'),
            'event_file': u['event_file'],
            'event_video': u['event_video'],
            'company_post_images': u['company_post_images'] != null &&
                    u['company_post_images'].isNotEmpty
                ? u['company_post_images']
                : '',
          });
        }
        jmap = dt.asMap();
      } else {
        return map['event_details'];
      }
      return jmap;
    } else {
      return {};
    }
  } else {
    return {};
  }
}

Future<Map> getAllJobs(lang, Map filters) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var uid = prefs.getString('uid') ?? '0';
  var type = prefs.getString('type') ?? 'Guest';
  Map body = {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
    "user_id": uid,
    "user_type": type,
  };
  if (filters.isNotEmpty) {
    filters.forEach((i, value) {
      body[i] = value;
    });
  }
  Map jmap = {};
  // 16
  Uri url = Uri.https('wathefty.net', '/api/frontend/getJobs');
  var response = await http.post(url, body: body);
  Map<String, dynamic> map = json.decode(response.body);
  if (response.statusCode == 200 && map['status']) {
    List<dynamic> data = map["jobs"];
    List dt = [];
    for (var u in data) {
      dt.add({
        'id': u['id'],
        'company_id': u['company_id'],
        'job_title': lang == 'ar' ? u['job_title_ar'] : u['job_title_en'],
        'gender': u['gender'],
        'submission_deadline': u['submission_deadline'],
        'experience_years': u['experience_years'],
        'salary_from': u['salary_from'],
        'salary_to': u['salary_to'],
        'currency': u['currency'],
        'job_description':
            lang == 'ar' ? u['job_description_ar'] : u['job_description_en'],
        'public_academic_degree_id': u['academic_Degree'],
        'section': u['section'],
        'specialty': u['speciality'],
        'location': (u['country_name'] + ' - ' + u['region_name']),
        'job_type': u['this_job_type'],
        'contact_phone': u['contact_phone'],
        'job_status': u['job_status'],
        'show_company_info': u['show_company_info'],
        'apply_type': u['apply_type'],
        'nationality': u['nationality'],
        'job_image': u['job_image'] != null
            ? u['job_image']
            : "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png",
        'view_counter': u['view_counter'],
        'suitability': u['suitability'] ?? '0',
      });
    }
    if (map['status'] == true) {
      jmap = dt.asMap();
      if (jmap[0].isEmpty) {
        jmap['status'] = true;
      }
      return jmap;
    } else {
      return {'status': false, 'msg': map['msg']};
    }
  } else {
    return {'status': false};
  }
}

Future register(
    username,
    nameEn,
    nameAr,
    String email,
    phone,
    password,
    type,
    countryId,
    regionId,
    lang,
    String code,
    String providerStatus,
    String? provider,
    String? providerId,
    String? companyType) async {
  email = (email.replaceAll(new RegExp(r"\s+"), ""));
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // 17
  Uri url = Uri.https(
      'wathefty.net', '/api/' + type.toString().toLowerCase() + '/register');
  var body = {};
  var player = await getID();
  if (providerStatus == '1') {
    body = {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "provider_id": providerId,
      "provider_status": '1',
      "name": username,
      "provider": provider,
      "player_id": player
    };
    if (email.isNotEmpty) {
      body['email'] = email;
    }
  } else {
    body = {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "name_en": nameEn,
      "name_ar": nameAr,
      "username": username,
      "phone": phone,
      "user_type": type,
      "password": password,
      "password_confirmation": password,
      "country_id": countryId.toString(),
      "region_id": regionId.toString(),
      "code": code,
      "email": email,
      "lang": lang,
      "provider_status": '2',
      "player_id": player
    };
    if (type == 'Company') body["employing_company"] = companyType;
  }
  var response = await http.post(url, body: body);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == false) {
      Get.snackbar(map['msg'], '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return {'status': '0', 'message': map['msg']};
    } else if (map['status'] == true) {
      if (type == 'Company' && map['user']['user_status'] == 'Pending') {
        return map['user']['user_status'];
      }
      prefs.setString('token', map['access_token'] ?? 'empty');
      await prefs.setString('uid', map['user']['id'].toString());
      await prefs.setString('name_ar', map['user']['name_ar']);
      await prefs.setString('name_en', map['user']['name_en']);
      await prefs.setString('username', map['user']['username']);
      await prefs.setString('email', map['user']['email']);
      await prefs.setString('type', type);
      await prefs.setString(
          'profile_photo_path',
          map['user']['profile_photo_path'] != null
              ? map['user']['profile_photo_path']
              : 'https://icon-library.com/images/white-profile-icon/white-profile-icon-24.jpg');
      globalImage = map['user']['profile_photo_path'] != null
          ? map['user']['profile_photo_path']
          : 'https://icon-library.com/images/white-profile-icon/white-profile-icon-24.jpg';
      globalType = type;
      globalUid = map['user']['id'].toString();
      mpN.clear();
      mpR.clear();

      return type;
    } else {
      Get.snackbar(map['msg'], '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return false;
    }
  } else if (response.statusCode == 401) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == false) {
      Get.snackbar(map['error'], tr("User does not exist"),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return false;
    }
  } else {
    Get.snackbar(tr('Something went wrong'),
        tr("Please make sure you're connected the internet try again"),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.red,
        leftBarIndicatorColor: Colors.red);
    return false;
  }
}

final List<Map<String, dynamic>> mpJC = [];
final List<Map<String, dynamic>> mpJS = [];
final List<Map<String, dynamic>> mpPRF = [];
final List<Map<String, dynamic>> mpSL = [];
final List<Map<String, dynamic>> mpDSC = [];
final List<Map<String, dynamic>> mpN = [];
final List<Map<String, dynamic>> mpR = [];
final List<Map<String, dynamic>> mp = [];
final List<Map<String, dynamic>> mp1 = [];
final List<Map<String, dynamic>> mp2 = [];
final List<Map<String, dynamic>> mp3 = [];
final List<Map<String, dynamic>> mp4 = [];
Future<List<Map<String, dynamic>>> getInfo(
    String iType, String lang, String? type) async {
  if (iType == 'skill') {
    // 18
    Uri url = Uri.https('wathefty.net', '/api/frontend/getAllSkills');
    var response = await http.post(url,
        body: {"api_password": "ase1iXcLAxanvXLZcgh6tk", "lang": lang});
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        List<dynamic> data = map["skills"];
        mp.clear();
        for (var u in data) {
          mp.add({
            'value': u['id'],
            'label': (lang == 'ar' ? u['skill_title_ar'] : u['skill_title_en'])
          });
        }
        return mp;
      } else {
        Get.snackbar('Please try again', '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return [];
      }
    } else {
      Get.snackbar('Please try again', '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return [];
    }
  } else if (iType == 'jsection') {
    // 19
    Uri url = Uri.https('wathefty.net', '/api/frontend/getJobSections');
    var response = await http.post(url,
        body: {"api_password": "ase1iXcLAxanvXLZcgh6tk", "lang": lang});
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        List<dynamic> data = map["job_sections"];
        mpJC.clear();
        for (var u in data) {
          mpJC.add({
            'value': u['id'],
            'label': (lang == 'ar'
                ? u['job_section_name_ar']
                : u['job_section_name_en'])
          });
        }
        return mpJC;
      } else {
        mpJC.clear();
        Get.snackbar('Please try again', '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return [];
      }
    } else {
      Get.snackbar('Please try again', '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return [];
    }
  } else if (iType == 'jspecialty') {
    // 20
    Uri url = Uri.https('wathefty.net', '/api/frontend/getJobSpectiality');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "section_id": type,
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        List<dynamic> data = map["specialties"];
        mpJS.clear();
        for (var u in data) {
          mpJS.add({
            'value': u['id'],
            'label':
                (lang == 'ar' ? u['specialty_name_ar'] : u['specialty_name_en'])
          });
        }
        return mpJS;
      } else {
        mpJS.clear();
        Get.snackbar('There are no specalities for this section yet', '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return [];
      }
    } else {
      Get.snackbar('There are no specialties for this section yet',
          tr('Please try again'),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return [];
    }
  } else if (iType == 'country') {
    var data = countryArr;
    mpN.clear();
    for (var u in data) {
      mpN.add({
        'value': u['id'],
        'label': (lang == 'ar' ? u['name_ar'] : u['name_en'])
      });
    }
    return mpN;
  } else if (iType == 'region') {
    // 21
    Uri url = Uri.https('wathefty.net', '/api/frontend/getRegions');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "country_id": type,
    });
    Map<String, dynamic> map = json.decode(response.body);
    if (response.statusCode == 200 && map['status'] == true) {
      List<dynamic> data = map["regions"];
      mpR.clear();
      for (var u in data) {
        mpR.add({
          'value': u['id'],
          'label': (lang == 'ar' ? u['name_ar'] : u['name_en'])
        });
      }
      return mpR;
    } else {
      Get.snackbar(map['msg'] != null ? map['msg'] : response.reasonPhrase, '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return [];
    }
  } else if (iType == 'profession') {
    // 22
    Uri url =
        Uri.https('wathefty.net', '/api/frontend/getSpectialityProfessions');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "spectielity_id": type,
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        List<dynamic> data = map["professions"];
        mpPRF.clear();
        for (var u in data) {
          mpPRF.add({
            'value': u['id'],
            'display': (lang == 'ar'
                ? u['profession_name_ar']
                : u['profession_name_en'])
          });
        }
        return mpPRF;
      } else {
        mpPRF.clear();
        Get.snackbar(tr('There are no professions for this specialty yet'), '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return [];
      }
    } else {
      Get.snackbar(tr('There are no specialties for this section yet'),
          tr('Please try again'),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return [];
    }
  } else if (iType == 'selection') {
    // 23
    Uri url = Uri.https('wathefty.net', '/api/company/categorySelectedJob');
    var response = await http.post(url,
        body: {"api_password": "ase1iXcLAxanvXLZcgh6tk", "lang": lang});
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        List<dynamic> data = map["categories"];
        mpSL.clear();
        for (var u in data) {
          mpSL.add({
            'value': u['id'],
            'label': (lang == 'ar'
                ? u['category_selected_job_name_ar']
                : u['category_selected_job_name_en'])
          });
        }
        return mpSL;
      } else {
        mpSL.clear();
        Get.snackbar(tr('There are no categories yet'), '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return [];
      }
    } else {
      Get.snackbar(tr('There are no categories yet'),
          tr('Please try again later or select another option'),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return [];
    }
  } else if (iType == 'distinction') {
    // 24
    Uri url =
        Uri.https('wathefty.net', '/api/company/advertisingDistinctionPackage');
    var response = await http.post(url,
        body: {"api_password": "ase1iXcLAxanvXLZcgh6tk", "lang": lang});
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        List<dynamic> data = map["advertising_Distinction_Packages"];
        mpDSC.clear();
        for (var u in data) {
          mpDSC.add({
            'value': u['number_of_day_discrimination'],
            'label': (lang == 'ar'
                ? (' - ميز ل' +
                    u['number_of_day_discrimination'] +
                    'ايام ب' +
                    (u.containsKey('discrimination_on_sale_price') &&
                            u['discrimination_on_sale_price'] != null
                        ? u['discrimination_on_sale_price'] + ' دينار مع خصم'
                        : u['discrimination_price']))
                : ('Distinguish for ' +
                    u['number_of_day_discrimination'] +
                    ' days for ' +
                    (u.containsKey('discrimination_on_sale_price') &&
                            u['discrimination_on_sale_price'] != null
                        ? u['discrimination_on_sale_price'] + 'JOD on sale'
                        : u['discrimination_price'])))
          });
        }
        return mpDSC;
      } else {
        mpDSC.clear();
        Get.snackbar(tr('There are no packages yet'), '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return [];
      }
    } else {
      Get.snackbar(tr('There are no packages yet'),
          tr('Please try again later or select another option'),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return [];
    }
  } else if (iType == 'package') {
    // 25
    Uri url = Uri.https('wathefty.net', '/api/company/advertisingPackageShow');
    var response = await http.post(url,
        body: {"api_password": "ase1iXcLAxanvXLZcgh6tk", "lang": lang});
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        List<dynamic> data = map["advertising_packages"];
        mp.clear();
        for (var u in data) {
          mp.add({
            'id': u['id'],
            'name':
                (lang == 'ar' ? u['package_name_ar'] : u['package_name_en']),
            'on_sale': u['on_sale'] != null ? u['on_sale'] : '',
            'package_on_sale_price': u['package_on_sale_price'] != null
                ? u['package_on_sale_price']
                : '',
            'package_price': u['package_price'],
            'package_quantity': u['package_quantity']
          });
        }
        return mp;
      } else {
        mp.clear();
        Get.snackbar(tr('There are no packages yet'), '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return [];
      }
    } else {
      Get.snackbar(
          tr('There are no packages yet'), tr('Please try again later'),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return [];
    }
  } else if (iType == 'followers') {
    // 26
    Uri url = Uri.https('wathefty.net', '/api/company/companyFollowerShow');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "company_id": type,
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        List<dynamic> data = map["company_followers"];
        mp.clear();
        for (var u in data) {
          mp.add({
            'id': u['id'],
            'name': (lang == 'ar' ? u['name_ar'] : u['name_en']),
            'location':
                ((lang == 'ar' ? u['region_ar'] : u['region_en']) ?? '') +
                    ' - ' +
                    ((lang == 'ar' ? u['country_ar'] : u['country_en']) ?? ''),
            'username': u['username'],
            'email': u['email'],
            'phone': u['phone'] != null ? u['phone'] : 'None',
            'img': u['individual_image'] != null
                ? u['individual_image']
                : 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png',
            'section': u['section_name_ar'] != null
                ? (lang == 'ar' ? u['section_name_ar'] : u['section_name_en'])
                : 'None',
            'specialty': u['specialty_name_ar'] != null
                ? (lang == 'ar'
                    ? u['specialty_name_ar']
                    : u['specialty_name_en'])
                : 'None'
          });
        }
        return mp;
      } else {
        mp.clear();
        return [];
      }
    } else {
      return [];
    }
  } else if (iType == 'following') {
    // 27
    Uri url = Uri.https('wathefty.net', '/api/individual/getFollowers');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "individual_id": type,
      "user_type": 'Individual',
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        List<dynamic> data = map["followers"];
        mp.clear();
        for (var u in data) {
          mp.add({
            'name': u['company_name'],
            'id': u['company_id'],
            'created': u['created_at'],
            'img': u['company_image'] != null
                ? u['company_image']
                : 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png',
          });
        }
        return mp;
      } else {
        mp.clear();
        return [];
      }
    } else {
      return [];
    }
  } else if (iType == 'cars') {
    // 28
    Uri url = Uri.https('wathefty.net', '/api/individual/getCarTypes');
    var response = await http.post(url,
        body: {"api_password": "ase1iXcLAxanvXLZcgh6tk", "lang": lang});
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        List<dynamic> data = map["carTypes"];
        mp.clear();
        for (var u in data) {
          mp.add({
            'value': u['id'],
            'label': lang == 'ar' ? u['name_ar'] : u['name_en']
          });
        }
        return mp;
      } else {
        mp.clear();
        Get.snackbar(tr('No cars added yet, please try again later'), '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.orange,
            leftBarIndicatorColor: Colors.orange);
        return [];
      }
    } else {
      Get.snackbar(tr('No cars added yet, please try again later'), '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.orange,
          leftBarIndicatorColor: Colors.orange);
      return [];
    }
  } else if (iType == 'serviceSection') {
    // 29
    Uri url =
        Uri.https('wathefty.net', '/api/individual/getPublicServiceSections');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "user_type": 'Individual',
      "individual_id": type,
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        List<dynamic> data = map["public_service_sections"];
        mp.clear();
        for (var u in data) {
          mp.add({'value': u['id'], 'label': u['public_service_section_name']});
        }
        return mp;
      } else {
        mp.clear();
        Get.snackbar(tr('No sections added yet, please try again later'), '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.orange,
            leftBarIndicatorColor: Colors.orange);
        return [];
      }
    } else {
      Get.snackbar(tr('No sections added yet, please try again later'), '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.orange,
          leftBarIndicatorColor: Colors.orange);
      return [];
    }
  } else if (iType == 'courses') {
    // 30
    Uri url = Uri.https('wathefty.net', '/api/individual/getAllCourses');
    var response = await http.post(url,
        body: {"api_password": "ase1iXcLAxanvXLZcgh6tk", "lang": lang});
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> list = [];
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status']) {
        List<dynamic> data = map["courses"];
        for (var u in data) {
          list.add({
            'id': u['id'],
            'name': (lang == 'ar' ? u['course_name_ar'] : u['course_name_en']),
            'program':
                (lang == 'ar' ? u['program_name_ar'] : u['program_name_ar']),
            'term': (lang == 'ar' ? u['course_term_ar'] : u['course_term_en']),
            'hours': u['course_hour'].toString() + tr(' hours'),
            'days': u['course_number_day_per_week'].toString() + tr(' days'),
            'date': u['course_start'] + ' - ' + u['course_end'],
            'age': u['course_age_from'].toString() +
                ' - ' +
                u['course_age_to'].toString() +
                tr('years old'),
            'gender': u['gender'],
            'price': u['subscription_price'] + tr(' JOD'),
            'img': u['image'] != null
                ? u['image']
                : 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png',
            'specialty': (lang == 'ar'
                ? u['course_specialty']['course_specialty_name_ar']
                : u['course_specialty']['course_specialty_name_en']),
            'degree': (lang == 'ar'
                ? u['public_academic_degree']['name_ar']
                : u['public_academic_degree']['name_en'])
          });
        }
        return list;
      } else {
        return [];
      }
    } else {
      Get.snackbar(tr('No courses found'), '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.orange,
          leftBarIndicatorColor: Colors.orange);
      return [];
    }
  } else if (iType == 'pendingCourses') {
    // 31
    Uri url = Uri.https('wathefty.net', '/api/individual/getCourseSubscribe');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "user_type": 'Individual',
      "individual_id": type,
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);

      if (map['status'] == true) {
        List<dynamic> data = map["course_subscriptions"];
        mp.clear();
        for (var u in data) {
          mp.add({
            'value': u['course_id'],
            'label': u['course_name_ar'],
          }); //lang == 'ar' ? u['training_course']['course_name_ar'] : u['training_course']['course_name_en']});
        }
        return mp;
      } else {
        mp.clear();
        Get.snackbar(tr('You did not subscribe to any courses.'), '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.orange,
            leftBarIndicatorColor: Colors.orange);
        return [];
      }
    } else {
      Get.snackbar(tr('You did not subscribe to any courses'), '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.orange,
          leftBarIndicatorColor: Colors.orange);
      return [];
    }
  } else if (iType == 'courseRequests') {
    // 32
    Uri url =
        Uri.https('wathefty.net', '/api/individual/getAllRequestAddCourse');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "individual_id": type,
      "user_type": 'Individual',
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        List<dynamic> data = map["training_course_individual_requests"];
        mp.clear();
        for (var u in data) {
          mp.add({
            'id': u['course_id'],
            'request': u['request_id'],
            'status': u['status'],
            'file': u['file'],
            'name': (lang == 'ar' ? u['course_name_ar'] : u['course_name_en']),
            // 'program': (lang == 'ar' ? u['program_name_ar'] : u['program_name_ar']),
            // 'term': (lang == 'ar' ? u['course_term_ar'] : u['course_term_en']),
            // 'hours': u['course_hour'] + tr(' hours'),
            // 'days': u['course_number_day_per_week'] + tr(' days'),
            // 'date': u['course_start'] + ' - ' + u['course_end'],
            // 'age': u['course_age_from'] + ' - ' + u['course_age_to'] + tr('years old'),
            // 'gender': u['gender'],
            // 'price': u['subscription_price'] + tr(' JOD'),
            // 'img': u['image'] != null
            //     ? u['image']
            //     : 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png',
          });
        }
        return mp;
      } else {
        mp.clear();
        Get.snackbar(tr('No courses found'), '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.orange,
            leftBarIndicatorColor: Colors.orange);
        return [];
      }
    } else {
      Get.snackbar(tr('No courses found'), '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.orange,
          leftBarIndicatorColor: Colors.orange);
      return [];
    }
  } else if (iType == 'personalSkills') {
    // 33
    Uri url = Uri.https('wathefty.net', '/api/individual/getPersonalSkills');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      'user_id': type
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        List<dynamic> data = map["skills"];
        mp1.clear();
        for (var u in data) {
          mp1.add({
            'value': u['id'],
            'label': lang == 'ar' ? u['skill_title_ar'] : u['skill_title_en']
          });
        }
        return mp1;
      } else {
        mp1.clear();
        // Get.snackbar(tr('No skills added yet, please try again later'), '',
        //     duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.orange, leftBarIndicatorColor: Colors.orange);
        return [];
      }
    } else {
      // Get.snackbar(tr('No skills added yet, please try again later'), '',
      //     duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.orange, leftBarIndicatorColor: Colors.orange);
      return [];
    }
  } else if (iType == 'trainingAbility') {
    // 34
    Uri url = Uri.https('wathefty.net', '/api/individual/trainingAbility');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      'user_id': type
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        List<dynamic> data = map["trainingAbility"];
        mp2.clear();
        for (var u in data) {
          mp2.add({
            'value': u['id'],
            'label':
                lang == 'ar' ? u['ability_title_ar'] : u['ability_title_en']
          });
        }
        return mp2;
      } else {
        mp2.clear();
        // Get.snackbar(tr('Nothing added yet, please try again later'), '',
        //     duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.orange, leftBarIndicatorColor: Colors.orange);
        return [];
      }
    } else {
      // Get.snackbar(tr('Nothing added yet, please try again later'), '', duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.orange, leftBarIndicatorColor: Colors.orange);
      return [];
    }
  } else if (iType == 'skillCertificates') {
    // 35
    Uri url = Uri.https('wathefty.net', '/api/individual/skillCertificates');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      'user_id': type
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        List<dynamic> data = map["skillCertificates"];
        mp3.clear();
        for (var u in data) {
          mp3.add({
            'value': u['id'],
            'label': lang == 'ar'
                ? u['certificate_title_ar']
                : u['certificate_title_en']
          });
        }
        return mp3;
      } else {
        mp3.clear();
        // Get.snackbar(tr('Nothing added yet, please try again later'), '',
        //     duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.orange, leftBarIndicatorColor: Colors.orange);
        return [];
      }
    } else {
      // Get.snackbar(tr('Nothing added yet, please try again later'), '', duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.orange, leftBarIndicatorColor: Colors.orange);
      return [];
    }
  } else if (iType == 'mainDisability') {
    // 36
    Uri url =
        Uri.https('wathefty.net', '/api/frontend/getCategoryDisabilities');
    var response = await http.post(url,
        body: {"api_password": "ase1iXcLAxanvXLZcgh6tk", "lang": lang});
    Map<String, dynamic> map = json.decode(response.body);
    if (response.statusCode == 200 && map.isNotEmpty && map['status'] == true) {
      List<dynamic> data = map["category_disabilities"];
      mp3.clear();
      for (var u in data) {
        mp3.add({
          'value': u['id'],
          'label': lang == 'ar' ? u['name_ar'] : u['name_en']
        });
      }
      return mp3;
    } else {
      mp3.clear();
      return [];
    }
  } else if (iType == 'subDisability') {
    // 37
    Uri url =
        Uri.https('wathefty.net', '/api/frontend/getSubCategoryDisabilities');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "category_id": type
    });
    Map<String, dynamic> map = json.decode(response.body);
    if (response.statusCode == 200 && map.isNotEmpty && map['status'] == true) {
      List<dynamic> data = map["sub_category_disabilities"];
      mp4.clear();
      for (var u in data) {
        mp4.add({
          'value': u['id'],
          'label': lang == 'ar' ? u['name_ar'] : u['name_en']
        });
      }
      return mp4;
    } else {
      mp4.clear();
      return [];
    }
  } else {
    return [];
  }
}

Future updateInfo(iType, String lang, type, String uid, String? iID,
    String? skillAr, String? skillEn) async {
  if (iType == 'skill') {
    // 38
    Uri url = Uri.https('wathefty.net', '/api/users/createUserSkills');
    var body = {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "user_id": uid,
      "user_type": type,
      "skill_id": iID,
      "lang": lang
    };
    if (skillAr != null && skillAr.isNotEmpty) {
      // 39
      url = Uri.https('wathefty.net', '/api/individual/individualAddNewSkill');
      body = {
        "api_password": "ase1iXcLAxanvXLZcgh6tk",
        "user_id": uid,
        "user_type": type,
        "skill_title_en": skillEn,
        "skill_title_ar": skillAr,
        "lang": lang
      };
    }
    var response = await http.post(url, body: body);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        return map;
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return map;
      }
    } else {
      return null;
    }
  }
}

Future comment(uType, type, lang, uid, data, tID, tType, optional) async {
  if (type == 'comment') {
    // 40
    Uri url = Uri.https('wathefty.net', '/api/frontend/addJobComments');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "user_type": uType,
      "user_id": uid,
      "job_id": tID,
      "job_type": tType,
      "comment_details": data,
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        return map;
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return map;
      }
    } else {
      return {'status': false};
    }
  } else if (type == 'report') {
    // 41
    Uri url = Uri.https('wathefty.net', '/api/individual/reportJob');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "user_type": uType,
      "user_id": uid,
      "job_id": tID,
      "job_type": tType,
      "report_details": data['text'],
      "report_type": data['type']
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        return map;
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return map;
      }
    } else {
      return {'status': false};
    }
  } else if (type == 'review') {
    // 42
    Uri url = Uri.https('wathefty.net', '/api/individual/jobReview');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "user_type": uType,
      "individual_id": uid,
      "job_id": tID,
      "job_type": tType,
      "review_value": optional.toString(),
      "review_note": data ?? ''
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        return map;
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return map;
      }
    } else {
      return {'status': false};
    }
  } else if (type == 'company review') {
    // 43
    Uri url = Uri.https('wathefty.net', '/api/individual/companyReview');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "user_type": uType,
      "individual_id": uid,
      "company_id": tID,
      "review_value": optional.toString(),
      "review_note": data ?? ''
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        return map;
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return map;
      }
    } else {
      return {'status': false};
    }
  } else if (type == 'search review' || type == 'CV search review') {
    Uri url;
    if (type == "CV search review") {
      // 44
      url = Uri.https('wathefty.net', '/api/company/searchCvReview');
    } else {
      // 45
      url = Uri.https('wathefty.net', '/api/individual/searchJobReview');
    }
    optional["api_password"] = "ase1iXcLAxanvXLZcgh6tk";
    optional["lang"] = lang;
    var response = await http.post(url, body: optional);
    Map<String, dynamic> map = json.decode(response.body);
    if (response.statusCode == 200 && map['status']) {
      return map;
    } else {
      Get.snackbar(map['msg'] ?? tr("Try again please"), '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return {'status': false};
    }
  } else {
    return {'status': false};
  }
}

Future jobAction(uType, type, lang, uid, tID, tType) async {
  if (type == 'like') {
    // 46
    Uri url = Uri.https('wathefty.net', '/api/individual/addTolikedJobs');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "user_type": uType,
      "individual_id": uid,
      "job_id": tID,
      "job_type": tType,
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.blue,
            leftBarIndicatorColor: Colors.blue);
        return map;
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return map;
      }
    } else {
      return {'status': false};
    }
  } else if (type == 'favorite') {
    // 47
    Uri url = Uri.https('wathefty.net', '/api/individual/addToWishlist');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "user_type": uType,
      "individual_id": uid,
      "job_id": tID,
      "job_type": tType,
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.blue,
            leftBarIndicatorColor: Colors.blue);
        return map;
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return map;
      }
    } else {
      return {'status': false};
    }
  } else if (type == 'save') {
    // 48
    Uri url = Uri.https('wathefty.net', '/api/individual/addToSavedJobs');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "user_type": uType,
      "individual_id": uid,
      "job_id": tID,
      "job_type": tType,
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.blue,
            leftBarIndicatorColor: Colors.blue);
        return map;
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return map;
      }
    } else {
      return {'status': false};
    }
  } else if (type == 'apply') {
    // 49
    Uri url = Uri.https('wathefty.net', '/api/individual/applyJob');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "user_type": uType,
      "individual_id": uid,
      "job_id": tID,
      "job_type": tType
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.blue,
            leftBarIndicatorColor: Colors.blue);
        return map;
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return map;
      }
    } else {
      return {'status': false};
    }
  } else if (type == 'follow') {
    // 50
    Uri url = Uri.https('wathefty.net', '/api/individual/addfollower');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "user_type": uType,
      "individual_id": uid,
      "company_id": tID,
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.blue,
            leftBarIndicatorColor: Colors.blue);
        return map;
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return map;
      }
    } else {
      return {'status': false};
    }
  } else if (type == 'subscribe') {
    // 51
    Uri url = Uri.https('wathefty.net', '/api/individual/subscribeCourse');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "user_type": uType,
      "individual_id": uid,
      "course_id": tID,
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.blue,
            leftBarIndicatorColor: Colors.blue);
        return map;
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return map;
      }
    } else {
      return {'status': false};
    }
  } else {
    return {'status': false};
  }
}

Future addImage(uType, lang, uid, tID, data) async {
  // 52
  Uri url = Uri.https('wathefty.net', '/api/company/companyAddImageEvent');
  var request = new http.MultipartRequest("POST", url);
  var status = false;
  if (data != null) {
    var stream = new http.ByteStream(data.openRead());
    stream.cast();
    var length = await data.length();
    var multipartFile = new http.MultipartFile('images[]', stream, length,
        filename: basename(data.path));
    request.files.add(multipartFile);
  }
  request.fields["api_password"] = "ase1iXcLAxanvXLZcgh6tk";
  request.fields["user_id"] = uid;
  request.fields["user_type"] = uType;
  request.fields["lang"] = lang;
  request.fields["event_id"] = tID;
  await request.send().then((response) async {
    response.stream.transform(utf8.decoder).listen((value) async {
      Map<String, dynamic> map = json.decode(value);
      if (map['status'] == true) {
        status = true;
        return map['status'];
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return map['status'];
      }
    });
  }).catchError((e) {
    return null;
  });
  if (status == true) {
    return {'status': true};
  } else {
    return {'status': false};
  }
}

Future removeInfo(iType, lang, type, uid, iID) async {
  if (iType == 'skill') {
    // 53
    Uri url = Uri.https('wathefty.net', '/api/users/deleteUserSkills');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "user_id": uid,
      "user_type": type,
      "skill_id": iID,
      "lang": lang
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        return map;
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return map;
      }
    } else {
      return null;
    }
  } else if (iType == 'courses') {
    // 54
    Uri url =
        Uri.https('wathefty.net', '/api/individual/deleteIndividualCourse');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "individual_id": uid,
      "user_type": type,
      "course_id": iID,
      "lang": lang
    });
    Map<String, dynamic> map = json.decode(response.body);
    if (response.statusCode == 200) {
      if (map['status'] == true) {
        return map;
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return map;
      }
    } else {
      Get.snackbar(map['msg'] ?? tr('Try again please'), '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return null;
    }
  } else if (iType == 'education') {
    // 55
    Uri url = Uri.https('wathefty.net', '/api/users/deleteUserEducation');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "user_id": uid,
      "user_type": type,
      "education_id": iID,
      "lang": lang
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        return map;
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return map;
      }
    } else {
      return null;
    }
  } else if (iType == 'experience') {
    // 56
    Uri url = Uri.https('wathefty.net', '/api/users/deleteUserExperiences');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "user_id": uid,
      "user_type": type,
      "experience_id": iID,
      "lang": lang
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        return map;
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return map;
      }
    } else {
      return null;
    }
  } else if (iType == 'job') {
    // 57

    Uri url = Uri.https('wathefty.net', '/api/company/companyDeleteJob');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "user_id": uid,
      "user_type": type,
      "job_id": iID,
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        return map;
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return map;
      }
    } else {
      return null;
    }
  } else if (iType == 'stopJob') {
    // 58
    Uri url = Uri.https('wathefty.net', '/api/company/companyStopJob');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "user_id": uid,
      "user_type": type,
      "job_id": iID,
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        return map;
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return map;
      }
    } else {
      return null;
    }
  } else if (iType == 'startJob') {
    // 59
    Uri url = Uri.https('wathefty.net', '/api/company/companyRepostJob');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "user_id": uid,
      "user_type": type,
      "job_id": iID,
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        return map;
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return map;
      }
    } else {
      return null;
    }
  } else if (iType == 'event') {
    // 60
    Uri url = Uri.https('wathefty.net', '/api/company/companySoftDeleteEvent');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "user_id": uid,
      "user_type": type,
      "event_id": iID,
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        return map;
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return map;
      }
    } else {
      return null;
    }
  } else if (iType == 'service') {
    // 61
    Uri url = Uri.https('wathefty.net', '/api/individual/deleteService');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "individual_id": uid,
      "user_type": type,
      "service_id": iID,
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == true) {
        return map;
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return map;
      }
    } else {
      return null;
    }
  } else if (iType == 'project') {
    // 62
    Uri url =
        Uri.https('wathefty.net', '/api/individual/individualProjectDelete');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "individual_id": uid,
      "user_type": type,
      "project_id": iID,
      "lang": lang
    });
    Map<String, dynamic> map = json.decode(response.body);
    if (response.statusCode == 200) {
      if (map['status'] == true) {
        return map;
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return map;
      }
    } else {
      Get.snackbar(map['msg'] ?? tr('Try again please'), '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return null;
    }
  } else if (iType == 'certificate') {
    // 63
    Uri url = Uri.https(
        'wathefty.net', '/api/individual/deleteUserProfessionalCertificate');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "user_id": uid,
      "user_type": type,
      "certificate_id": iID,
      "lang": lang
    });
    Map<String, dynamic> map = json.decode(response.body);
    if (response.statusCode == 200 && map['status'] == true) {
      return map;
    } else {
      Get.snackbar(map['msg'] ?? tr('Try again please'), '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return null;
    }
  } else if (iType == 'language') {
    // 64
    Uri url = Uri.https('wathefty.net', '/api/individual/deleteUserLanguage');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "user_id": uid,
      "user_type": type,
      "id": iID,
      "lang": lang
    });
    Map<String, dynamic> map = json.decode(response.body);
    if (response.statusCode == 200 && map['status']) {
      return map;
    } else {
      Get.snackbar(map['msg'] ?? tr('Try again please'), '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return null;
    }
  } else if (iType == "CV") {
    Map map = {};
    Map body = {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "individual_id": globalUid,
      "user_type": globalType
    };
    // 65
    Uri url = Uri.https('wathefty.net', '/api/individual/deleteCv');
    var response = await http.post(url, body: body);
    map = json.decode(response.body);
    if (response.statusCode == 200 && map["status"]) {
      return map;
    } else {
      Get.snackbar(map['msg'] ?? tr('Try again please'), '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return null;
    }
  } else if (iType == "computer") {
    // 66
    Uri url = Uri.https(
        'wathefty.net', '/api/individual/deleteIndividualComputerSkills');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "user_id": uid,
      "user_type": type,
      "computer_skill_id": iID,
      "lang": lang
    });
    Map<String, dynamic> map = json.decode(response.body);
    if (response.statusCode == 200 && map['status']) {
      return map;
    } else {
      Get.snackbar(map['msg'] ?? tr('Try again please'), '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return null;
    }
  } else if (iType == "alert") {
    // 67
    Uri url = Uri.https('wathefty.net', '/api/individual/deleteSavedAlert');
    var response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "user_id": uid,
      "user_type": type,
      "saved_alert_id": iID,
      "lang": lang
    });
    Map<String, dynamic> map = json.decode(response.body);
    if (response.statusCode == 200 && map['status']) {
      return map;
    } else {
      Get.snackbar(map['msg'] ?? tr('Try again please'), '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return null;
    }
  }
}

Future<Map> updateProfile(lang, uid, type, uInfo) async {
  if (uInfo.isEmpty) {
    return {'status': 'null'};
  }
  var status = false;
  if (type == 'Individual') {
    // 68
    Uri url = Uri.https('wathefty.net', '/api/individual/UserProfileUpdate');
    var request = new http.MultipartRequest("POST", url);
    if (uInfo['profile_photo_path'] != null) {
      var stream = new http.ByteStream(uInfo['profile_photo_path'].openRead());
      stream.cast();
      var length = await uInfo['profile_photo_path'].length();
      var multipartFile = new http.MultipartFile(
          'profile_photo_path', stream, length,
          filename: basename(uInfo['profile_photo_path'].path));
      request.files.add(multipartFile);
    }
    request.fields["api_password"] = "ase1iXcLAxanvXLZcgh6tk";
    request.fields["user_id"] = uid;
    request.fields["user_type"] = type;
    request.fields["lang"] = lang;
    request.fields['email'] = uInfo['email'].replaceAll(new RegExp(r"\s+"), "");
    request.fields['name_ar'] = uInfo['name_ar'];
    request.fields['name_en'] = uInfo['name_en'];
    request.fields['username'] = uInfo['username'];
    request.fields['phone'] = uInfo['phone'];
    request.fields['country_id'] = uInfo['country_id'];
    request.fields['region_id'] = uInfo['region_id'];
    request.fields['address_ar'] = uInfo['address_ar'];
    request.fields['address_en'] = uInfo['address_en'];
    if (uInfo['password'] != null)
      request.fields['password'] = uInfo['password'];
    if (uInfo['password'] != null)
      request.fields['password_confirmation'] = uInfo['password'];
    request.fields['code'] = uInfo['code'];
    await request.send().then((response) async {
      response.stream.transform(utf8.decoder).listen((value) async {
        Map<String, dynamic> map = json.decode(value);
        if (map['status'] == true) {
          status = true;
          return map['status'];
        } else {
          Get.snackbar(map['msg'], '',
              duration: Duration(seconds: 5),
              backgroundColor: Colors.white,
              colorText: Colors.red,
              leftBarIndicatorColor: Colors.red);
          return null;
        }
      });
    }).catchError((e) {
      return null;
    });
    if (status == true) {
      return {'status': true};
    } else {
      return {'status': 'false'};
    }
  } else if (type == 'Company') {
    // 69
    Uri url = Uri.https('wathefty.net', '/api/company/companyProfileUpdate');
    var request = new http.MultipartRequest("POST", url);
    if (uInfo['profile_photo_path'] != null) {
      var stream = new http.ByteStream(uInfo['profile_photo_path'].openRead());
      stream.cast();
      var length = await uInfo['profile_photo_path'].length();
      var multipartFile = new http.MultipartFile(
          'profile_photo_path', stream, length,
          filename: basename(uInfo['profile_photo_path'].path));
      request.files.add(multipartFile);
    }
    request.fields["api_password"] = "ase1iXcLAxanvXLZcgh6tk";
    request.fields["user_id"] = uid;
    request.fields["user_type"] = type;
    request.fields["lang"] = lang;
    request.fields['email'] = uInfo['email'].replaceAll(new RegExp(r"\s+"), "");
    request.fields['name_ar'] = uInfo['name_ar'];
    request.fields['name_en'] = uInfo['name_en'];
    request.fields['username'] = uInfo['username'];
    request.fields['email'] = uInfo['email'];
    request.fields['phone'] = uInfo['phone'];
    request.fields['country_id'] = uInfo['country_id'];
    request.fields['region_id'] = uInfo['region_id'];
    request.fields['address_ar'] = uInfo['address_ar'];
    request.fields['address_en'] = uInfo['address_en'];
    request.fields['job_section_id'] = uInfo['section_id'];
    request.fields['specialty_id'] = uInfo['specialty_id'];
    request.fields['code'] = uInfo['code'];
    if (uInfo['password'] != null)
      request.fields['password'] = uInfo['password'];
    if (uInfo['password'] != null)
      request.fields['password_confirmation'] = uInfo['password'];
    await request.send().then((response) async {
      response.stream.transform(utf8.decoder).listen((value) async {
        Map<String, dynamic> map = json.decode(value);
        if (map['status'] == true) {
          status = true;
          return map['status'];
        } else {
          Get.snackbar(map['msg'], '',
              duration: Duration(seconds: 5),
              backgroundColor: Colors.white,
              colorText: Colors.red,
              leftBarIndicatorColor: Colors.red);
          return null;
        }
      });
    }).catchError((e) {
      return null;
    });
    if (status == true) {
      return {'status': true};
    } else {
      return {'status': 'false'};
    }
  } else {
    return {'status': 'false'};
  }
}

Future<Map> updateInformation(lang, uid, type, uInfo) async {
  if (uInfo.isEmpty) {
    return {'status': 'null'};
  }
  var status = false;
  if (type == 'Individual') {
    // 70
    Uri url =
        Uri.https('wathefty.net', '/api/individual/updateUserInformation');
    var request = new http.MultipartRequest("POST", url);
    if (uInfo['individual_cv_file'] != null) {
      var stream = new http.ByteStream(uInfo['individual_cv_file'].openRead());
      stream.cast();
      var length = await uInfo['individual_cv_file'].length();
      var multipartFile = new http.MultipartFile(
          'individual_cv_file', stream, length,
          filename: basename(uInfo['individual_cv_file'].path));
      request.files.add(multipartFile);
    }
    request.fields["api_password"] = "ase1iXcLAxanvXLZcgh6tk";
    request.fields["user_id"] = uid;
    request.fields["user_type"] = type;
    request.fields["lang"] = lang;
    request.fields['individual_nationality'] = uInfo['individual_nationality'];
    request.fields['individual_phone_extra'] = uInfo['individual_phone_extra'];
    request.fields['academec_degree_id'] = uInfo['academec_degree_id'];
    request.fields['section_id'] = uInfo['section_id'];
    request.fields['specialty_id'] = uInfo['specialty_id'];
    request.fields['individual_national_number'] =
        uInfo['individual_national_number'];
    request.fields['individual_social_status'] = uInfo['social_status_id'];
    request.fields['individual_gender'] = uInfo['individual_gender'];
    request.fields['individual_birth_date'] = uInfo['individual_birth_date'];
    request.fields['individual_facebook_url'] =
        uInfo['individual_facebook_url'];
    request.fields['individual_overview'] = uInfo['individual_overview'];
    request.fields['computer_skills_level'] = uInfo['computer_skills_id'];
    request.fields['english_level'] = uInfo['english_level_id'];
    request.fields['current_status'] = uInfo['current_status_id'];
    request.fields['whatsapp_number'] = uInfo['whatsapp_number'];
    // if (uInfo['individual_languages'] != null) request.fields['individual_languages'] = uInfo['individual_languages'].join(",");
    if (uInfo['individual_professions'] != null)
      request.fields['individual_professions'] =
          uInfo['individual_professions'].join(",");
    await request.send().then((response) async {
      response.stream.transform(utf8.decoder).listen((value) async {
        Map<String, dynamic> map = json.decode(value);
        if (map['status'] == true) {
          status = true;
          return map['status'];
        } else {
          Get.snackbar(map['msg'], '',
              duration: Duration(seconds: 5),
              backgroundColor: Colors.white,
              colorText: Colors.red,
              leftBarIndicatorColor: Colors.red);
          return null;
        }
      });
    }).catchError((e) {
      return null;
    });
    if (status == true) {
      return {'status': true};
    } else {
      return {'status': 'false'};
    }
  }
  //Company
  else if (type == 'Company') {
    // 71
    Uri url =
        Uri.https('wathefty.net', '/api/company/companyInformationUpdate');
    var request = new http.MultipartRequest("POST", url);
    request.fields["api_password"] = "ase1iXcLAxanvXLZcgh6tk";
    request.fields["user_id"] = uid;
    request.fields["user_type"] = type;
    request.fields["lang"] = lang;
    request.fields['company_phone_extra'] = uInfo['company_phone_extra'];
    request.fields['company_size'] = uInfo['company_size'];
    request.fields['company_legal_capacity'] = uInfo['company_legal_capacity'];
    request.fields['company_category'] = uInfo['company_category'];
    request.fields['company_fax'] = uInfo['company_fax'];
    request.fields['landline_phone'] = uInfo['landline_phone'];
    request.fields['company_phone_extra'] = uInfo['company_phone_extra'];
    request.fields['general_manager_name_ar'] =
        uInfo['general_manager_name_ar'];
    request.fields['general_manager_name_en'] =
        uInfo['general_manager_name_en'];
    request.fields['general_manager_phone'] = uInfo['general_manager_phone'];
    request.fields['officer_link_name_ar'] = uInfo['officer_link_name_ar'];
    request.fields['officer_link_name_en'] = uInfo['officer_link_name_en'];
    request.fields['officer_link_phone'] = uInfo['officer_link_phone'];
    request.fields['company_website_url'] = uInfo['company_website_url'];
    request.fields['company_facebook_url'] = uInfo['company_facebook_url'];
    request.fields['company_linkedin_url'] = uInfo['company_linkedin_url'];
    request.fields['company_whatsapp_url'] = uInfo['company_whatsapp_url'];
    request.fields['company_instagram_url'] = uInfo['company_instagram_url'];
    request.fields['company_twitter_url'] = uInfo['company_twitter_url'];
    request.fields['company_youtube_url'] = uInfo['company_youtube_url'];
    request.fields['company_overview_en'] = uInfo['company_overview_en'];
    request.fields['company_overview_ar'] = uInfo['company_overview_ar'];
    await request.send().then((response) async {
      response.stream.transform(utf8.decoder).listen((value) async {
        Map<String, dynamic> map = json.decode(value);
        if (map['status'] == true) {
          status = true;
          return map['status'];
        } else {
          Get.snackbar(map['msg'], '',
              duration: Duration(seconds: 5),
              backgroundColor: Colors.white,
              colorText: Colors.red,
              leftBarIndicatorColor: Colors.red);
          return null;
        }
      });
    }).catchError((e) {
      return null;
    });
    if (status == true) {
      return {'status': true};
    } else {
      return {'status': 'false'};
    }
  } else {
    return {'status': 'false'};
  }
}

Future<Map> createJob(lang, uid, type, uInfo, String edit, int action) async {
  if (uInfo.isEmpty) {
    return {'status': false};
  }
  var status = false, msg = '';
  if (type == 'Company') {
    Uri url;
    if (edit.isNotEmpty && action == 2) {
      // 72
      url = Uri.https('wathefty.net', '/api/company/companyEditJob');
    } else if (edit.isNotEmpty && action == 3) {
      // 73
      url = Uri.https('wathefty.net', '/api/company/companyRepostJob');
    } else {
      // 74
      url = Uri.https('wathefty.net', '/api/company/companyAddJob');
    }
    var request = new http.MultipartRequest("POST", url);
    if (uInfo['job_image'] != null) {
      var stream = new http.ByteStream(uInfo['job_image'].openRead());
      stream.cast();
      var length = await uInfo['job_image'].length();
      var multipartFile = new http.MultipartFile('job_image', stream, length,
          filename: basename(uInfo['job_image'].path));
      request.files.add(multipartFile);
    }
    if (uInfo['job_file'] != null) {
      var stream = new http.ByteStream(uInfo['job_file'].openRead());
      stream.cast();
      var length = await uInfo['job_file'].length();
      var multipartFile = new http.MultipartFile('job_file', stream, length,
          filename: basename(uInfo['job_file'].path));
      request.files.add(multipartFile);
    }
    if (edit.isNotEmpty) {
      request.fields["job_id"] = edit;
    }
    request.fields["api_password"] = "ase1iXcLAxanvXLZcgh6tk";
    request.fields["user_id"] = uid;
    request.fields["user_type"] = type;
    request.fields["lang"] = lang;
    request.fields['job_title_ar'] = uInfo['job_title_ar'];
    request.fields['job_title_en'] = uInfo['job_title_en'];
    request.fields['job_section_id'] = uInfo['job_section_id'];
    request.fields['job_description_ar'] = uInfo['job_description_ar'];
    request.fields['job_description_en'] = uInfo['job_description_en'];
    request.fields['selected_job'] = uInfo['selected_job'];
    request.fields['professions'] = uInfo['professions'].join(",");
    request.fields['specialty_id'] = uInfo['specialty_id'];
    request.fields['submission_deadline'] = uInfo['submission_deadline'];
    request.fields['experience_years_from'] = uInfo['experience_years_from'];
    request.fields['experience_years_to'] = uInfo['experience_years_to'];
    request.fields['country_id'] = uInfo['country_id'];
    request.fields['region_id'] = uInfo['region_id'];
    request.fields['nationality'] = uInfo['nationality'];
    request.fields['public_academic_degree_id'] =
        uInfo['public_academic_degree_id'];
    if (uInfo['salary_determination'] != 2)
      request.fields['salary_from'] = uInfo['salary_from'];
    if (uInfo['salary_determination'] != 2)
      request.fields['salary_to'] = uInfo['salary_to'];
    if (uInfo['salary_determination'] != 2)
      request.fields['currency'] = uInfo['currency'];
    request.fields['show_company_info'] = uInfo['show_company_info'];
    request.fields['apply_type'] = uInfo['apply_type'];
    request.fields['discrimination_status'] = uInfo['discrimination_status'];
    request.fields['discrimination_deadline'] =
        uInfo['discrimination_deadline'];
    request.fields['contact_phone'] = uInfo['contact_phone'];
    request.fields['contact_email'] = uInfo['contact_email'];
    request.fields['contact_url'] = uInfo['contact_url'];
    request.fields['social_security_subscription'] =
        uInfo['social_security_subscription'];
    request.fields['work_nature'] = uInfo['work_nature'];
    request.fields['health_insurance'] = uInfo['health_insurance'];
    request.fields['contract_duration'] = uInfo['contract_duration'];
    request.fields['type_working_hours'] = uInfo['type_working_hours'];
    request.fields['salary_determination'] = uInfo['salary_determination'];
    request.fields['gender'] = uInfo['gender'];
    request.fields['social_status'] = uInfo['social_status'];
    await request.send().then((response) async {
      response.stream.transform(utf8.decoder).listen((value) async {
        Map<String, dynamic> map = json.decode(value);
        if (map['status'] != null && map['status'] == true) {
          status = map['status'];
          msg = map['msg'];
          return map['status'];
        } else {
          Get.snackbar(map['msg'], '',
              duration: Duration(seconds: 5),
              backgroundColor: Colors.white,
              colorText: Colors.red,
              leftBarIndicatorColor: Colors.red);
          return null;
        }
      });
    }).catchError((e) {
      return null;
    });
    if (status == true) {
      Get.snackbar(msg, '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.blue,
          leftBarIndicatorColor: Colors.blue);
      return {'status': true};
    } else {
      return {'status': 'false'};
    }
  } else {
    return {'status': 'false'};
  }
}

Future<Map> createEvent(lang, uid, type, uInfo, String edit) async {
  if (uInfo.isEmpty) {
    return {'status': false};
  }
  var status = false;
  if (type == 'Company') {
    Uri url;
    if (edit.isEmpty) {
      // 75
      url = Uri.https('wathefty.net', '/api/company/companyAddEvent');
    } else {
      // 76
      url = Uri.https('wathefty.net', '/api/company/companyEditEvent');
    }
    var request = new http.MultipartRequest("POST", url);
    if (uInfo['company_event_main_image'] != null) {
      var stream =
          new http.ByteStream(uInfo['company_event_main_image'].openRead());
      stream.cast();
      var length = await uInfo['company_event_main_image'].length();
      var multipartFile = new http.MultipartFile(
          'company_event_main_image', stream, length,
          filename: basename(uInfo['company_event_main_image'].path));
      request.files.add(multipartFile);
    }
    if (uInfo['company_event_main_file'] != null) {
      var stream =
          new http.ByteStream(uInfo['company_event_main_file'].openRead());
      stream.cast();
      var length = await uInfo['company_event_main_file'].length();
      var multipartFile = new http.MultipartFile(
          'company_event_main_file', stream, length,
          filename: basename(uInfo['company_event_main_file'].path));
      request.files.add(multipartFile);
    }
    if (uInfo['company_event_main_video'] != null) {
      var stream =
          new http.ByteStream(uInfo['company_event_main_video'].openRead());
      stream.cast();
      var length = await uInfo['company_event_main_video'].length();
      var multipartFile = new http.MultipartFile(
          'company_event_main_video', stream, length,
          filename: basename(uInfo['company_event_main_video'].path));
      request.files.add(multipartFile);
    }
    if (edit.isNotEmpty) {
      request.fields["event_id"] = edit;
    }
    request.fields["api_password"] = "ase1iXcLAxanvXLZcgh6tk";
    request.fields["user_id"] = uid;
    request.fields["user_type"] = type;
    request.fields["lang"] = lang;
    request.fields['company_event_title_ar'] = uInfo['company_event_title_ar'];
    request.fields['company_event_title_en'] = uInfo['company_event_title_en'];
    request.fields['company_event_des_ar'] = uInfo['company_event_des_ar'];
    request.fields['company_event_des_en'] = uInfo['company_event_des_en'];
    request.fields['company_event_status'] = uInfo['company_event_status'];
    await request.send().then((response) async {
      response.stream.transform(utf8.decoder).listen((value) async {
        Map<String, dynamic> map = json.decode(value);
        if (map['status'] != null && map['status'] == true) {
          status = map['status'];
          return map['status'];
        } else {
          Get.snackbar(map['msg'], '',
              duration: Duration(seconds: 5),
              backgroundColor: Colors.white,
              colorText: Colors.red,
              leftBarIndicatorColor: Colors.red);
          return null;
        }
      });
    }).catchError((e) {
      return null;
    });
    if (status == true) {
      // Get.snackbar(msg, '', duration: Duration(seconds: 5), backgroundColor: Colors.white, colorText: Colors.blue, leftBarIndicatorColor: Colors.blue);
      return {'status': true};
    } else {
      return {'status': 'false'};
    }
  } else {
    return {'status': 'false'};
  }
}

Future addEducation(String lang, Map uInfo) async {
  if (uInfo.isEmpty) {
    return {'status': false};
  }
  // 77
  Uri url = Uri.https('wathefty.net', '/api/users/createUserEducation');
  var status = false, msg = '';
  var request = new http.MultipartRequest("POST", url);
  if (uInfo['file'] != null) {
    var stream = new http.ByteStream(uInfo['file'].openRead());
    stream.cast();
    var length = await uInfo['file'].length();
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(uInfo['file'].path));
    request.files.add(multipartFile);
  }
  request.fields["api_password"] = "ase1iXcLAxanvXLZcgh6tk";
  request.fields["user_id"] = globalUid;
  request.fields["user_type"] = globalType;
  request.fields["lang"] = lang;
  request.fields["academec_degree_id"] = uInfo['academec_degree_id'];
  request.fields["major_name_ar"] = uInfo['major_name_ar'];
  request.fields["major_name_en"] = uInfo['major_name_en'];
  request.fields["organization_name_ar"] = uInfo['organization_name_ar'];
  request.fields["organization_name_en"] = uInfo['organization_name_en'];
  request.fields["average"] = uInfo['average'].toString();
  request.fields["average_type"] = uInfo['average_type'].toString();
  request.fields["start_at"] = uInfo['start_at'];
  if (uInfo['end_at'] != null) request.fields["end_at"] = uInfo['end_at'];
  if (uInfo['until_now'] != null)
    request.fields["until_now"] = uInfo['until_now'];
  await request.send().then((response) async {
    response.stream.transform(utf8.decoder).listen((value) async {
      Map<String, dynamic> map = json.decode(value);
      if (map['status'] != null && map['status'] == true) {
        status = map['status'];
        msg = map['msg'];
        return map['status'];
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return null;
      }
    });
  }).catchError((e) {
    return null;
  });
  if (status == true) {
    Get.snackbar(msg, '',
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.blue,
        leftBarIndicatorColor: Colors.blue);
    return {'status': true};
  } else {
    return {'status': 'false'};
  }
}

Future contactUs(lang, type, inf) async {
  // 78
  Uri url = Uri.https('wathefty.net', '/api/frontend/contactUsRequest');
  var response = await http.post(url, body: {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
    "email": inf['email'],
    "full_name": inf['full_name'],
    "message": inf['message'],
    "subject": inf['subject'],
    "phone": inf['phone'],
  });
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      Get.back();
      Get.snackbar(map['msg'], '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.blue,
          leftBarIndicatorColor: Colors.blue);
      return map;
    } else {
      Get.snackbar(map['msg'], '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return map;
    }
  } else {
    Get.snackbar('Please try again', '',
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.red,
        leftBarIndicatorColor: Colors.red);
    return [
      {'msg': 'error'}
    ];
  }
}

Future<Map> getNotifications(String lang, String type, String? action) async {
  // 79
  Uri url = Uri.https('wathefty.net', '/api/company/companyNotifications');
  var data = await http.post(url, body: {
    "api_password": 'ase1iXcLAxanvXLZcgh6tk',
    "user_id": globalUid,
    "lang": lang,
    "user_type": type,
    "action": action
  });
  Map<String, dynamic> map = json.decode(data.body);
  if (map['status'] == true) {
    return map;
  } else {
    return {};
  }
}

Future<String> clearNotifs(uid, lang, type) async {
  // 80
  Uri url =
      Uri.https('wathefty.net', '/api/frontend/allUserNotificationsDelete');
  var data = await http.post(url, body: {
    "api_password": 'ase1iXcLAxanvXLZcgh6tk',
    "user_id": uid,
    "lang": lang,
    "user_type": type
  });
  Map<String, dynamic> map = json.decode(data.body);
  if (map['status'] == true) {
    return map['msg'];
  } else {
    return '';
  }
}

Future getNotifCount(uid) async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // var uid = prefs.getString('id');
  // Uri url = Uri.https();
  // var response = await http.post(url, body: {'uid': uid});
  // Map<String, dynamic> map = json.decode(response.body);
  // if (response.statusCode == 200 && map['status'] == true) {
  // /ount = map['counter'];
  // }
  // return count;
  return null;
}

class Review {
  final String id;
  final String name;
  final String img;
  final String value;
  final String note;
  final String created;
  Review(this.id, this.name, this.img, this.value, this.note, this.created);
}

Future<Map> getReviews(uid, lang) async {
  // 81
  Uri url = Uri.https('wathefty.net', '/api/frontend/getAllCompanyReviews');
  var data = await http.post(url, body: {
    "api_password": 'ase1iXcLAxanvXLZcgh6tk',
    "company_id": uid,
    "lang": lang
  });
  Map<String, dynamic> map = json.decode(data.body);
  if (map['status'] == true) {
    List<dynamic> data = map["all_data"]['reviews'];
    List<Review> reviews = [];
    var stats = map["all_data"]['total_reviews'][0];
    for (var u in data) {
      reviews.add(Review(
          u["individual_id"].toString(),
          lang == 'ar' ? u["individual_name_ar"] : u['individual_name_en'],
          (u["individual_img"].isNotEmpty
              ? u["individual_img"]
              : 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png'),
          u['review_value'].toString(),
          u['review_note'] != null ? u['review_note'] : '',
          u['created_at']));
    }
    return {
      'percentage': stats['reviews_percentage'],
      'count': stats['reviews_count'].toString(),
      'one': stats['one_star'],
      'two': stats['two_star'],
      'three': stats['three_star'],
      'four': stats['four_star'],
      'five': stats['five_star'],
      'reviews': reviews
    };
  } else {
    return {};
  }
}

Future<Map> getMyJobs(uid, String type, lang, int jType, optional) async {
  Uri url;
  Map jmap = {};
  var bod = {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
    "individual_id": uid,
    "user_id": uid,
    "user_type": type,
  };
  if (jType == 1) {
    // 82
    url = Uri.https('wathefty.net', '/api/frontend/showApplyJobs');
  } else if (jType == 2) {
    // 83
    url = Uri.https('wathefty.net', '/api/individual/getSuitableJob');
  } else if (jType == 3) {
    // 84
    url = Uri.https('wathefty.net', '/api/individual/getIndividualSpecialJobs');
  } else if (jType == 4) {
    // 85
    url = Uri.https('wathefty.net', '/api/individual/getSavedJobs');
  } else if (jType == 5) {
    // 86
    url = Uri.https('wathefty.net', '/api/individual/getWishlist');
  } else {
    // if (jType == 6) {
    // 87
    url = Uri.https('wathefty.net', '/api/individual/getLikedJobs');
  }
  var response = await http.post(url, body: bod);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      List<dynamic> data;
      if (jType == 1) {
        data = map["appliedJobs"];
      } else if (jType == 2) {
        data = map["suitableJobs"];
      } else if (jType == 3) {
        data = map["specialJobs"];
      } else if (jType == 4) {
        data = map["jobSaveds"];
      } else if (jType == 5) {
        data = map["jobWishlists"];
      } else {
        data = map["jobLikeds"];
      }
      List<dynamic> dt = [];
      for (var u in data) {
        dt.add({
          'id': u['id'],
          'name': u['company_name'] ?? '',
          'section': u['section'],
          'specialty': u['speciality'],
          'job_title': lang == 'ar' ? u['job_title_ar'] : u['job_title_en'],
          'job_description':
              lang == 'ar' ? u['job_description_ar'] : u['job_description_en'],
          'job_status': u['job_status'],
          'job_type': u['this_job_type'],
          'submission_deadline': u['submission_deadline'],
          'degree': u['academic_Degree'],
          'country': u['country_name'],
          'region': u['region_name'],
          'experience_years': u['experience_years'],
          'show': u['show_company_info'],
          'salary_from': u['salary_from'],
          'salary_to': u['salary_to'],
          'currency': u['currency'],
          'applying': u['applicants_individuals_count'] != null
              ? u['applicants_individuals_count'].toString()
              : '0',
          'views':
              u['view_counter'] != null ? u['view_counter'].toString() : '0',
          'job_image': u['job_image'] ??
              'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png',
        });
      }
      jmap = dt.asMap();
      return jmap;
    } else {
      return {};
    }
  } else {
    return {};
  }
}

Future<Map> getExtra(uid, String type, lang, extra) async {
  // 88
  Uri url = (extra == 'driver'
      ? Uri.https('wathefty.net', '/api/individual/getUserDriver')
      // 89
      : Uri.https('wathefty.net', '/api/individual/getUserSecurity'));
  var response = await http.post(url, body: {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
    "user_type": type,
    "user_id": uid,
  });
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      if (extra == 'driver') {
        map['user_driver']['status'] = true;
        return map['user_driver'];
      } else {
        map['user_security']['status'] = true;
        return map['user_security'];
      }
    } else {
      return map;
    }
  } else {
    return {'status': false};
  }
}

Future<Map> removeExtra(
    String lang, String uid, String type, String extra) async {
  Uri url = (extra == 'driver'
      // 90
      ? Uri.https('wathefty.net', '/api/individual/deleteIndividualDriver')
      // 91
      : Uri.https('wathefty.net', '/api/individual/deleteIndividualSecurity'));
  var response = await http.post(url, body: {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
    "user_type": type,
    "individual_id": uid
  });
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      map['status'] = true;
      Get.snackbar(map['msg'], '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.green,
          leftBarIndicatorColor: Colors.green);
      return map;
    } else {
      Get.snackbar(map['msg'], '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return map;
    }
  } else {
    Get.snackbar(tr('Something went wrong'), tr('Please try again'),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.red,
        leftBarIndicatorColor: Colors.red);
    return {'status': false, 'msg': tr('Something went wrong')};
  }
}

Future<Map> removeCourse(
    String uid, String type, String lang, String courseId) async {
  // 92
  Uri url = Uri.https('wathefty.net', '/api/individual/deleteRequestAddCourse');
  var response = await http.post(url, body: {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
    "user_type": type,
    "individual_id": uid,
    "request_id": courseId,
  });
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      map['status'] = true;
      Get.snackbar(map['msg'], '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.green,
          leftBarIndicatorColor: Colors.green);
      return map;
    } else {
      Get.snackbar(map['msg'], '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return map;
    }
  } else {
    Get.snackbar(tr('Something went wrong'), tr('Please try again'),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.red,
        leftBarIndicatorColor: Colors.red);
    return {};
  }
}

Future<Map> createDriver(lang, uid, type, uInfo) async {
  if (uInfo.isEmpty) {
    return {'status': false};
  }
  var status = false, msg = '';
  // 93
  Uri url = Uri.https('wathefty.net', '/api/individual/updateUserDriver');
  var request = new http.MultipartRequest("POST", url);

  if (uInfo['car_license_image'] != null) {
    var stream = new http.ByteStream(uInfo['car_license_image'].openRead());
    stream.cast();
    var length = await uInfo['car_license_image'].length();
    var multipartFile = new http.MultipartFile(
        'car_license_image', stream, length,
        filename: basename(uInfo['car_license_image'].path));
    request.files.add(multipartFile);
  }
  if (uInfo['car_image'] != null) {
    var stream = new http.ByteStream(uInfo['car_image'].openRead());
    stream.cast();
    var length = await uInfo['car_image'].length();
    var multipartFile = new http.MultipartFile('car_image', stream, length,
        filename: basename(uInfo['car_image'].path));
    request.files.add(multipartFile);
  }
  if (uInfo['driver_image'] != null) {
    var stream = new http.ByteStream(uInfo['driver_image'].openRead());
    stream.cast();
    var length = await uInfo['driver_image'].length();
    var multipartFile = new http.MultipartFile('driver_image', stream, length,
        filename: basename(uInfo['driver_image'].path));
    request.files.add(multipartFile);
  }
  if (uInfo['image_no_criminal_record'] != null) {
    var stream =
        new http.ByteStream(uInfo['image_no_criminal_record'].openRead());
    stream.cast();
    var length = await uInfo['image_no_criminal_record'].length();
    var multipartFile = new http.MultipartFile(
        'image_no_criminal_record', stream, length,
        filename: basename(uInfo['image_no_criminal_record'].path));
    request.files.add(multipartFile);
  }
  if (uInfo['smart_work_permit_applications_image'] != null) {
    var stream = new http.ByteStream(
        uInfo['smart_work_permit_applications_image'].openRead());
    stream.cast();
    var length = await uInfo['smart_work_permit_applications_image'].length();
    var multipartFile = new http.MultipartFile(
        'smart_work_permit_applications_image', stream, length,
        filename: basename(uInfo['smart_work_permit_applications_image'].path));
    request.files.add(multipartFile);
  }
  if (uInfo['driver_license_image'] != null) {
    var stream = new http.ByteStream(uInfo['driver_license_image'].openRead());
    stream.cast();
    var length = await uInfo['driver_license_image'].length();
    var multipartFile = new http.MultipartFile(
        'driver_license_image', stream, length,
        filename: basename(uInfo['driver_license_image'].path));
    request.files.add(multipartFile);
  }
  request.fields["api_password"] = "ase1iXcLAxanvXLZcgh6tk";
  request.fields["individual_id"] = uid;
  request.fields["user_type"] = type;
  request.fields["lang"] = lang;
  request.fields['car_type_id'] = uInfo['car_type_id'];
  request.fields['car_owner_name'] = uInfo['car_owner_name'];
  request.fields['car_plate_number'] = uInfo['car_plate_number'];
  request.fields['car_insurance_type'] = uInfo['car_insurance_type'];
  request.fields['method_payment_wage'] = uInfo['method_payment_wage'];
  request.fields['year_of_manufacture'] = uInfo['year_of_manufacture'];
  request.fields['car_condition'] = uInfo['car_condition'];
  request.fields['transport_service_type'] = uInfo['transport_service_type'];
  request.fields['car_fuel_type'] = uInfo['car_fuel_type'];
  request.fields['start_working_immediately'] =
      uInfo['start_working_immediately'];
  await request.send().then((response) async {
    response.stream.transform(utf8.decoder).listen((value) async {
      Map<String, dynamic> map = json.decode(value);
      if (map['status'] != null && map['status'] == true) {
        status = map['status'];
        msg = map['msg'];
        return map['status'];
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return null;
      }
    });
  }).catchError((e) {
    return null;
  });
  if (status == true) {
    Get.snackbar(msg, '',
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.blue,
        leftBarIndicatorColor: Colors.blue);
    return {'status': true};
  } else {
    return {'status': 'false'};
  }
}

Future<Map> createSecurity(lang, uid, type, uInfo) async {
  if (uInfo.isEmpty) {
    return {'status': false};
  }
  var status = false, msg = '';
  // 94
  Uri url = Uri.https('wathefty.net', '/api/individual/updateUserSecurity');
  var request = new http.MultipartRequest("POST", url);
  if (uInfo['personal_image'] != null) {
    var stream = new http.ByteStream(uInfo['personal_image'].openRead());
    stream.cast();
    var length = await uInfo['personal_image'].length();
    var multipartFile = new http.MultipartFile('personal_image', stream, length,
        filename: basename(uInfo['personal_image'].path));
    request.files.add(multipartFile);
  }
  request.fields["api_password"] = "ase1iXcLAxanvXLZcgh6tk";
  request.fields["user_id"] = uid;
  request.fields["user_type"] = type;
  request.fields["lang"] = lang;
  request.fields['retirement_year'] = uInfo['retirement_year'];
  request.fields['duration_working_years'] = uInfo['duration_working_years'];
  request.fields['rank_degree'] = uInfo['rank_degree'];
  request.fields['previous_work'] = uInfo['previous_work'];
  request.fields['type_work'] = uInfo['type_work'];
  request.fields['do_you_have_fitness'] = uInfo['do_you_have_fitness'];
  request.fields['do_you_have_combat_skills'] =
      uInfo['do_you_have_combat_skills'];
  await request.send().then((response) async {
    response.stream.transform(utf8.decoder).listen((value) async {
      Map<String, dynamic> map = json.decode(value);
      if (map['status'] != null && map['status'] == true) {
        status = map['status'];
        msg = map['msg'];
        return map['status'];
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return null;
      }
    });
  }).catchError((e) {
    return null;
  });
  if (status == true) {
    Get.snackbar(msg, '',
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.blue,
        leftBarIndicatorColor: Colors.blue);
    return {'status': true};
  } else {
    return {'status': 'false'};
  }
}

Future<Map> getServices(
    uid, String edit, lang, int sType, int optional, String userType) async {
  bool flag = false;
  if (edit == 'edit' && optional != 0) {
    flag = true;
  }
  Uri url = optional == 0
      // 95
      ? Uri.https('wathefty.net', '/api/individual/getServices')
      // 96
      : Uri.https('wathefty.net', '/api/individual/getServiceInner');
  Map jmap = {};
  var bod = {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
    "user_id": uid,
    "user_type": userType
  };
  if (optional != 0) {
    bod['service_id'] = optional.toString();
  }
  var response = await http.post(url, body: bod);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      List<dynamic> data = [];
      if (optional != 0 && !flag) {
        data = [map['service']];
      } else if (optional != 0 && flag) {
        return map['service'];
      } else if (sType == 1) {
        data = map['services']["active_services"];
      } else if (sType == 2) {
        data = map['services']["pending_services"];
      } else {
        data = map['services']["rejected_services"];
      }
      List<dynamic> dt = [];
      for (var u in data) {
        dt.add({
          'id': u['id'],
          'service_section_id': u['service_section_id'] ?? '',
          'section_name': u['section_name'] ?? '',
          'price': u['price'] ?? '',
          'user_type': u['user_type'] ?? '',
          'contact_email': u['contact_email'] ?? '',
          'contact_phone': u['contact_phone'] ?? '',
          'contact_url': u['contact_url'] ?? '',
          'contact_address': u['contact_address'] ?? '',
          'created_at': u['created_at'] ?? '',
          'service_status': u['service_status'] ?? '',
          'title': lang == 'ar' ? u['service_title_ar'] : u['service_title_en'],
          'description': lang == 'ar'
              ? u['service_description_ar']
              : u['service_description_en'],
          'image': u['main_image'] ??
              'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png',
          'file': u['file'],
          'video': u['video'],
        });
      }
      jmap = dt.asMap();
      return jmap;
    } else {
      return {'status': false, 'msg': map['msg']};
    }
  } else {
    return {'status': false};
  }
}

Future<Map> createService(lang, uid, type, uInfo, String edit) async {
  if (uInfo.isEmpty) {
    return {'status': false};
  }
  var status = false, msg = '';
  Uri url = (edit == '0'
      // 97
      ? Uri.https('wathefty.net', '/api/individual/addService')
      // 98
      : Uri.https('wathefty.net', '/api/individual/updateService'));
  var request = new http.MultipartRequest("POST", url);
  if (uInfo['main_image'] != null) {
    var stream = new http.ByteStream(uInfo['main_image'].openRead());
    stream.cast();
    var length = await uInfo['main_image'].length();
    var multipartFile = new http.MultipartFile('main_image', stream, length,
        filename: basename(uInfo['main_image'].path));
    request.files.add(multipartFile);
  }
  if (uInfo['file'] != null) {
    var stream = new http.ByteStream(uInfo['file'].openRead());
    stream.cast();
    var length = await uInfo['file'].length();
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(uInfo['file'].path));
    request.files.add(multipartFile);
  }
  if (uInfo['video'] != null) {
    var stream = new http.ByteStream(uInfo['video'].openRead());
    stream.cast();
    var length = await uInfo['video'].length();
    var multipartFile = new http.MultipartFile('video', stream, length,
        filename: basename(uInfo['video'].path));
    request.files.add(multipartFile);
  }
  if (edit != '0') {
    request.fields["service_id"] = edit;
  }
  request.fields["api_password"] = "ase1iXcLAxanvXLZcgh6tk";
  request.fields["user_id"] = uid;
  request.fields["user_type"] = type;
  request.fields["lang"] = lang;
  request.fields['service_section_id'] = uInfo['service_section_id'];
  request.fields['price'] = uInfo['price'];
  request.fields['service_title_ar'] = uInfo['service_title_ar'];
  request.fields['service_title_en'] = uInfo['service_title_en'];
  request.fields['service_description_ar'] = uInfo['service_description_ar'];
  request.fields['service_description_en'] = uInfo['service_description_en'];
  request.fields['contact_email'] = uInfo['contact_email'];
  request.fields['contact_phone'] = uInfo['contact_phone'];
  request.fields['contact_address'] = uInfo['contact_address'];
  request.fields['contact_url'] = uInfo['contact_url'];
  request.fields['total_experience'] = uInfo['total_experience'];
  request.fields['service_completion_time'] = uInfo['service_completion_time'];
  await request.send().then((response) async {
    response.stream.transform(utf8.decoder).listen((value) async {
      Map<String, dynamic> map = json.decode(value);
      if (map['status'] != null && map['status'] == true) {
        status = map['status'];
        msg = map['msg'];
        return map['status'];
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return null;
      }
    });
  }).catchError((e) {
    return null;
  });
  if (status == true) {
    Get.snackbar(msg, '',
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.blue,
        leftBarIndicatorColor: Colors.blue);
    return {'status': true};
  } else {
    return {'status': 'false'};
  }
}

Future<Map> getRelevantPeople(String uid, String type, String lang, String jID,
    String jType, Map? filters, int pType) async {
  Map body = {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
    "user_type": type,
    "user_id": uid,
    "job_id": jID,
    "job_type": jType,
    "export": '1'
  };

  if (filters != null && filters.isNotEmpty) {
    body.addAll(filters);
  }
  Uri url = pType == 1
      // 99
      ? Uri.https('wathefty.net', '/api/company/companyShowApplyJob')
      // 100
      : Uri.https(
          'wathefty.net', '/api/company/companyShowSuitableIndividuals');
  var response = await http.post(url, body: body);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      return map;
    } else {
      return {};
    }
  } else {
    return {};
  }
}

Future<Map> getSkillRequest(String uid, String type, String lang) async {
  // 101
  Uri url =
      Uri.https('wathefty.net', '/api/individual/getIndividualPersonalSkills');
  var response = await http.post(url, body: {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
    "user_id": uid,
    "user_type": type,
  });
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      return map;
    } else {
      return {};
    }
  } else {
    return {};
  }
}

Future<Map> subscribeRequest(lang, uid, uInfo) async {
  if (uInfo.isEmpty) {
    return {'status': false};
  }
  var status = false, msg = '';
  // 102
  Uri url = Uri.https('wathefty.net', '/api/individual/sendRequestAddCourse');
  var request = new http.MultipartRequest("POST", url);
  if (uInfo['file'] != null) {
    var stream = new http.ByteStream(uInfo['file'].openRead());
    stream.cast();
    var length = await uInfo['file'].length();
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(uInfo['file'].path));
    request.files.add(multipartFile);
  }
  request.fields["api_password"] = "ase1iXcLAxanvXLZcgh6tk";
  request.fields["individual_id"] = uid;
  request.fields["user_type"] = 'Individual';
  request.fields["lang"] = lang;
  request.fields['course_id'] = uInfo['course_id'];
  await request.send().then((response) async {
    response.stream.transform(utf8.decoder).listen((value) async {
      Map<String, dynamic> map = json.decode(value);
      if (map['status'] != null && map['status'] == true) {
        status = map['status'];
        msg = map['msg'];
        return map['status'];
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return null;
      }
    });
  }).catchError((e) {
    return null;
  });
  if (status == true) {
    Get.offAll(() => IndivProfilePage());
    Get.snackbar(msg, '',
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.blue,
        leftBarIndicatorColor: Colors.blue);
    return {'status': true};
  } else {
    return {'status': false};
  }
}

Future<List> selectedJobs(
    String? uid, String? type, String lang, String id) async {
  // 103
  Uri url = Uri.https('wathefty.net', '/api/frontend/getSelectedJobs');
  Map body = {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
    "selected_job_id": id,
  };
  if (id == '6') {
    body['individual_id'] = uid;
    body['user_type'] = type;
  }
  var response = await http.post(url, body: body);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      return map['All_Jobs'];
    } else {
      return [];
    }
  } else {
    return [];
  }
}

Future<List> news(String lang) async {
  // 104
  Uri url = Uri.https('wathefty.net', '/api/frontend/getAllNewsBlogs');
  var response = await http.post(url, body: {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
  });
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      return map['newsBlogs'];
    } else {
      return [];
    }
  } else {
    return [];
  }
}

Future<List> whatsappGroups(String lang) async {
  // 105
  Uri url = Uri.https('wathefty.net', '/api/frontend/whatsappGroups');
  var response = await http.post(url, body: {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
  });
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      return map['whatsappGroups'];
    } else {
      return [];
    }
  } else {
    return [];
  }
}

//1 = view, 2 = add, 3 = remove
Future<Map> gallery(BuildContext context, String uid, String lang, String type,
    int action, Map? images) async {
  if (type == 'Guest') type = 'Individual';
  Uri url;
  Map body = {
    'api_password': "ase1iXcLAxanvXLZcgh6tk",
    'lang': lang,
    'user_id': uid,
    'user_type': type
  };
  if (action == 1) {
    // 106
    url = Uri.https('wathefty.net', '/api/individual/getWorkGallery');
  } else if (action == 2) {
    var status = false;
    // 107
    url = Uri.https('wathefty.net', '/api/individual/addWorkGallery');
    var request = new http.MultipartRequest("POST", url);
    if (images!.isNotEmpty) {
      for (var u in images['images']) {
        var stream = new http.ByteStream(u.openRead());
        stream.cast();
        var length = await u.length();
        var multipartFile = new http.MultipartFile('images[]', stream, length,
            filename: basename(u.path));
        request.files.add(multipartFile);
      }
    }
    request.fields["api_password"] = "ase1iXcLAxanvXLZcgh6tk";
    request.fields["user_id"] = uid;
    request.fields["user_type"] = type;
    request.fields["lang"] = lang;
    await request.send().then((response) async {
      response.stream.transform(utf8.decoder).listen((value) async {
        Map<String, dynamic> map = json.decode(value);
        if (map['status'] == true) {
          status = true;
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GalleryPage(iid: uid, owner: true)),
          );
          Get.snackbar(map['msg'], '',
              duration: Duration(seconds: 5),
              backgroundColor: Colors.white,
              colorText: Colors.green,
              leftBarIndicatorColor: Colors.green);
          return map['status'];
        } else {
          status = false;
          Get.snackbar(map['msg'], '',
              duration: Duration(seconds: 5),
              backgroundColor: Colors.white,
              colorText: Colors.red,
              leftBarIndicatorColor: Colors.red);
          return map['status'];
        }
      });
    }).catchError((e) {
      return null;
    });
    return {'status': status};
  } else {
    // 108
    url = Uri.https('wathefty.net', '/api/individual/deleteWorkGallery');
    body['image_id'] = images!['id'];
  }
  var response = await http.post(url, body: body);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      if (action != 1) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GalleryPage(iid: uid, owner: true)),
        );
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.green,
            leftBarIndicatorColor: Colors.green);
      }
      return map;
    } else {
      if (action != 1) {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
      }
      return {};
    }
  } else {
    return {};
  }
}

//1 = update, 2 = delete images, 3 = delete request
Future<Map> personalSkills(
    String uid, String lang, String type, int action, Map? info) async {
  Uri url;
  Map body;
  if (action == 1) {
    var status = false;
    // 109
    url = Uri.https(
        'wathefty.net', '/api/individual/individualPersonalSkillUpdate');
    var request = new http.MultipartRequest("POST", url);
    if (info!['personal_skill_image'] != null &&
        info['personal_skill_image'].isNotEmpty) {
      for (var u in info['personal_skill_image']) {
        var stream = new http.ByteStream(u.openRead());
        stream.cast();
        var length = await u.length();
        var multipartFile = new http.MultipartFile(
            'personal_skill_image[]', stream, length,
            filename: basename(u.path));
        request.files.add(multipartFile);
      }
    }
    request.fields["api_password"] = "ase1iXcLAxanvXLZcgh6tk";
    request.fields["user_id"] = uid;
    request.fields["user_type"] = type;
    request.fields["lang"] = lang;
    request.fields["have_social_media_page"] = info['have_social_media_page'];
    request.fields["social_media_page_url"] = info['social_media_page_url'];
    request.fields["sharing_handicraft_fairs"] =
        info['sharing_handicraft_fairs'];
    request.fields["marketing_product_on_wazefate"] =
        info['marketing_product_on_wathefty'];
    request.fields["working_in_team"] = info['working_in_team'];
    request.fields["owning_the_tools_to_work"] =
        info['owning_the_tools_to_work'];
    request.fields["personal_skill_id"] = info['personal_skill_id'];
    request.fields["training_ability_id"] = info['training_ability_id'];
    request.fields["skill_certificate_id"] = info['skill_certificate_id'];
    request.fields["submit_feasibility_study"] =
        info['submit_feasibility_study'];
    request.fields["gallery_name_ar"] = info['gallery_name_ar'];
    request.fields["gallery_name_en"] = info['gallery_name_en'];
    request.fields["workshops_without_any_help"] =
        info['workshops_without_any_help'];
    request.fields["rank_professional"] = info['rank_professional'];
    request.fields["workshops_without_any_help_select"] =
        info['workshops_without_any_help_select'];
    await request.send().then((response) async {
      response.stream.transform(utf8.decoder).listen((value) async {
        Map<String, dynamic> map = json.decode(value);
        if (map['status'] == true) {
          status = true;
          Get.snackbar(map['msg'], '',
              duration: Duration(seconds: 5),
              backgroundColor: Colors.white,
              colorText: Colors.green,
              leftBarIndicatorColor: Colors.green);
          return map['status'];
        } else {
          status = false;
          Get.snackbar(map['msg'], '',
              duration: Duration(seconds: 5),
              backgroundColor: Colors.white,
              colorText: Colors.red,
              leftBarIndicatorColor: Colors.red);
          return map['status'];
        }
      });
    }).catchError((e) {
      return null;
    });
    return {'status': status};
  }

  action == 2
      ? body = {
          'api_password': "ase1iXcLAxanvXLZcgh6tk",
          'lang': lang,
          'user_id': uid,
          'user_type': type,
          'image_id': info?['id']
        }
      : body = {
          'api_password': "ase1iXcLAxanvXLZcgh6tk",
          'lang': lang,
          'individual_id': uid,
          'user_type': type
        };
  action == 2
      // 110
      ? url =
          Uri.https('wathefty.net', '/api/individual/personalSkilldeleteimages')
      // 111
      : url = Uri.https(
          'wathefty.net', '/api/individual/individualPersonalSkillDelete');
  var response = await http.post(url, body: body);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      if (action == 3) {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.green,
            leftBarIndicatorColor: Colors.green);
      }
      return map;
    } else {
      Get.snackbar(map['msg'], '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return {};
    }
  } else {
    return {};
  }
}

Future<Map> getOTP(String phone, String lang) async {
  Map body = {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
    "phone": phone
  };
  // 112
  Uri url = Uri.https('wathefty.net', '/api/frontend/phoneVerificationCode');
  var response = await http.post(url, body: body);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      return map;
    } else {
      Get.snackbar(map['msg'], '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.blue,
          leftBarIndicatorColor: Colors.blue);
      return {};
    }
  } else {
    Get.snackbar(response.reasonPhrase.toString(), '',
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.blue,
        leftBarIndicatorColor: Colors.blue);
    return {};
  }
}

Future<Map> advancedSearch(Map filters, int type) async {
  // 113
  Map body = {"api_password": "ase1iXcLAxanvXLZcgh6tk"};
  Uri url;
  if (type == 1) {
    //Search or Save
    body.addAll(filters);
    // 114
    url = Uri.https('wathefty.net', '/api/frontend/advancedFilter');
  } else if (type == 3) {
    //delete
    body.addAll(filters);
    // 115
    url = Uri.https('wathefty.net', '/api/frontend/deleteSavedSearch');
  } else {
    //Get saved searches
    body['individual_id'] = filters['individual_id'];
    body['lang'] = filters['lang'];
    // 116
    url = Uri.https('wathefty.net', '/api/frontend/getAdvancedFilterSaved');
  }
  var response = await http.post(url, body: body);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      return map;
    } else {
      return {};
    }
  } else {
    return {};
  }
}

Future<Map> jobSeekers(Map filters, int type) async {
  Map body = {"api_password": "ase1iXcLAxanvXLZcgh6tk"};
  Uri url;
  if (type == 1) {
    // 117
    url = Uri.https('wathefty.net', '/api/frontend/allDriversFilter');
  } else if (type == 2) {
    // 118
    url = Uri.https('wathefty.net', '/api/frontend/allSecuritiesFilter');
  } else if (type == 3) {
    // 119
    url = Uri.https('wathefty.net', '/api/frontend/allPersonalSkillsFilter');
  } else {
    // 120
    url = Uri.https('wathefty.net', '/api/frontend/searchPeople');
  }
  body.addAll(filters);
  var response = await http.post(url, body: body);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      return map;
    } else {
      return {};
    }
  } else {
    return {};
  }
}

Future<Map> applicantActions(String lang, String jID, String aID, String jType,
    String status, String cID) async {
  // 121
  Uri url = Uri.https('wathefty.net', '/api/company/acceptRejectApplyJob');
  Map body = {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
    "user_type": 'Company',
    "job_type": jType,
    "user_id": aID,
    "job_id": jID,
    "status": status,
    "company_id": cID,
  };
  var response = await http.post(url, body: body);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      Get.snackbar(map['msg'], '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.blue,
          leftBarIndicatorColor: Colors.blue);
      return map;
    } else {
      Get.snackbar(map['msg'], '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return {};
    }
  } else {
    return {};
  }
}

Future<Map> publicServices(String lang) async {
  // 122
  Uri url = Uri.https('wathefty.net', '/api/frontend/getPublicServices');
  Map jmap = {};
  var bod = {"api_password": "ase1iXcLAxanvXLZcgh6tk", "lang": lang};
  var response = await http.post(url, body: bod);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      List<dynamic> data = [];
      data = map['services'];
      List<dynamic> dt = [];
      for (var u in data) {
        dt.add({
          'id': u['id'],
          'author': u['user_id'],
          'service_section_id': u['service_section_id'] ?? '',
          'section_name': u['section_name'] ?? '',
          'price': u['price'] ?? '',
          'user_type': u['user_type'] ?? '',
          'contact_email': u['contact_email'] ?? '',
          'contact_phone': u['contact_phone'] ?? '',
          'contact_url': u['contact_url'] ?? '',
          'contact_address': u['contact_address'] ?? '',
          'created_at': u['created_at'] ?? '',
          'service_status': u['service_status'] ?? '',
          'title': lang == 'ar' ? u['service_title_ar'] : u['service_title_en'],
          'description': lang == 'ar'
              ? u['service_description_ar']
              : u['service_description_en'],
          'image': u['main_image'] ??
              'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png',
          'file': u['file'],
          'video': u['video'],
        });
      }
      jmap = dt.asMap();
      return jmap;
    } else {
      return {};
    }
  } else {
    return {};
  }
}

class ChatMessage {
  String messageContent;
  String messageType;
  String? image;
  ChatMessage(
      {required this.messageContent, required this.messageType, this.image});
}

class ChatUsers {
  String id;
  String name;
  String messageText;
  String image;
  String time;
  String to;
  String toType;
  bool read;
  ChatUsers(
      {required this.id,
      required this.name,
      required this.messageText,
      required this.image,
      required this.time,
      required this.read,
      required this.to,
      required this.toType});
}

List<ChatMessage> messages = [];
List<ChatUsers> userList = [];
Future<List> getMessages(String lang) async {
  var type = globalType == 'Company' ? '1' : '2';
  Map body = {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
    "user_id": globalUid,
    "user_type": globalType == 'Company' ? '1' : '2'
  };
  // 123

  Uri url = Uri.https('wathefty.net', '/api/frontend/getMessages');
  var response = await http.post(url, body: body);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true && map['messages'].isNotEmpty) {
      userList.clear();
      for (var u in map['messages']) {
        String receiver = '', receiverImg = '', to = '', toType = '';
        if (u['sender_type'].toString() != type ||
            u['sender_id'].toString() != globalUid) {
          receiver = u['sender_name'];
          receiverImg = u['sender_image'] ??
              "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png";
          to = u['sender_id'].toString();
          toType = u['sender_type'] == '1' ? 'Company' : 'Individual';
        } else {
          receiver = u['reciever_name'];
          receiverImg = u['reciever_image'] ??
              "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1200px-No_image_available.svg.png";
          to = u['reciever_id'].toString();
          toType = u['reciever_type'] == '1' ? 'Company' : 'Individual';
        }
        userList.add(
          ChatUsers(
              id: u['id'].toString(),
              name: receiver,
              messageText: u['first_operation']['message_details'],
              image: receiverImg,
              time: DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(u['first_operation']['created_at'])),
              read: u['first_operation']['read_at'] != null ? true : false,
              to: to,
              toType: toType),
        );
      }
      return userList;
    } else {
      return [];
    }
  } else {
    return [];
  }
}

Future<List<ChatMessage>> getChat(
    String lang, String to, String toType, String? message) async {
  Map body = {"api_password": "ase1iXcLAxanvXLZcgh6tk", "lang": lang};
  Uri url;
  if (message == null) {
    // 124
    url = Uri.https('wathefty.net', '/api/frontend/getSelectedUserMessage');
    body['sender_id'] = globalUid;
    body['sent_from'] = globalType;
    body['reciever_id'] = to;
    body['sent_to'] = toType;
  } else {
    // 125
    url = Uri.https('wathefty.net', '/api/frontend/getSelectedMessage');
    body['user_id'] = globalUid;
    body['user_type'] = globalType;
    body['message_id'] = message;
  }

  var response = await http.post(url, body: body);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      messages.clear();
      for (var u in map['message']['message_operations']) {
        var sender = '1';
        if (u['user_flag'] == 2) {
          sender = '2';
        }
        messages.add(ChatMessage(
            messageContent: u['message_details'], messageType: sender));
      }
      return messages;
    } else {
      return [];
    }
  } else {
    return [];
  }
}

Future<Map> sendMessage(String lang, String to, String toType, String? message,
    String? file) async {
  Map body = {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
    "sender_id": globalUid,
    "reciever_id": to,
    "sent_from": globalType,
    "sent_to": toType,
    "message_details": message,
  };
  if (file != null) {
    body['message_file'] = file;
  }
  // 126
  Uri url = Uri.https('wathefty.net', '/api/frontend/sendMessages');
  var response = await http.post(url, body: body);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      return map;
    } else {
      return {};
    }
  } else {
    return {};
  }
}

Future<Map> getPDF(String lang) async {
  // 127
  Uri url = Uri.https('wathefty.net', '/api/individual/getPdf');
  var response = await http.post(url, body: {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
    "individual_id": globalUid,
    "user_type": globalType
  });
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    return map;
  } else {
    return {};
  }
}

Future<Map> addLanguage(Map data) async {
  // 128
  Uri url = Uri.https('wathefty.net', '/api/individual/createUserLanguage');
  var response = await http.post(url, body: {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
    "user_id": globalUid,
    "user_type": globalType,
    "language_id": data["language_id"],
    "read": data["read"],
    "write": data["write"],
    "speak": data["speak"],
    "level": data["level"]
  });
  Map<String, dynamic> map = json.decode(response.body);
  if (response.statusCode == 200 && map["status"]) {
    return map;
  } else {
    Get.snackbar(map['msg'] ?? tr("Try again please"), '',
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.red,
        leftBarIndicatorColor: Colors.red);
    return {};
  }
}

Future<Map> addComputer(Map data) async {
  Uri url = Uri.https(
      // 129
      'wathefty.net',
      '/api/individual/createIndividualComputerSkills');
  var response = await http.post(url, body: {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
    "user_id": globalUid,
    "user_type": globalType,
    "skill_title_ar": data["skill_title_ar"],
    "skill_title_en": data["skill_title_en"],
    "program_type_ar": data["program_type_ar"],
    "program_type_en": data["program_type_en"],
    "version": data["version"],
    "last_year_of_use": data["last_year_of_use"],
    "number_of_months_of_experience": data["number_of_months_of_experience"],
    "number_of_years_of_experience": data["number_of_years_of_experience"]
  });
  Map<String, dynamic> map = json.decode(response.body);
  if (response.statusCode == 200 && map["status"]) {
    return map;
  } else {
    Get.snackbar(map['msg'] ?? tr("Try again please"), '',
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.red,
        leftBarIndicatorColor: Colors.red);
    return {};
  }
}

Future<Map> addProject(String lang, Map uInfo) async {
  if (uInfo.isEmpty) {
    return {'status': false};
  }
  var status = false, msg = '';
  // 130
  Uri url =
      Uri.https('wathefty.net', '/api/individual/individualAddNewProject');
  var request = new http.MultipartRequest("POST", url);
  if (uInfo['project_image'] != null) {
    var stream = new http.ByteStream(uInfo['project_image'].openRead());
    stream.cast();
    var length = await uInfo['project_image'].length();
    var multipartFile = new http.MultipartFile('project_image', stream, length,
        filename: basename(uInfo['project_image'].path));
    request.files.add(multipartFile);
  }

  request.fields["api_password"] = "ase1iXcLAxanvXLZcgh6tk";
  request.fields["individual_id"] = globalUid;
  request.fields["user_type"] = globalType;
  request.fields["lang"] = lang;
  request.fields['project_title_en'] = uInfo['project_title_en'];
  request.fields['project_title_ar'] = uInfo['project_title_ar'];
  request.fields['project_description_ar'] = uInfo['project_description_ar'];
  request.fields['project_description_en'] = uInfo['project_description_en'];
  request.fields['project_url'] = uInfo['project_url'];
  await request.send().then((response) async {
    response.stream.transform(utf8.decoder).listen((value) async {
      Map<String, dynamic> map = json.decode(value);
      if (map['status'] != null && map['status'] == true) {
        status = map['status'];
        msg = map['msg'];
        return map['status'];
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return null;
      }
    });
  }).catchError((e) {
    return null;
  });
  if (status == true) {
    Get.snackbar(msg, '',
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.blue,
        leftBarIndicatorColor: Colors.blue);
    return {'status': true};
  } else {
    return {'status': 'false'};
  }
}

Future<Map> addCertificate(Map uInfo) async {
  if (uInfo.isEmpty) {
    return {'status': false};
  }
  var status = false, msg = '';
  // 131
  Uri url = Uri.https(
      'wathefty.net', '/api/individual/createUserProfessionalCertificate');
  var request = new http.MultipartRequest("POST", url);
  var stream = new http.ByteStream(uInfo['file'].openRead());
  stream.cast();
  var length = await uInfo['file'].length();
  var multipartFile = new http.MultipartFile('file', stream, length,
      filename: basename(uInfo['file'].path));
  request.files.add(multipartFile);
  request.fields["api_password"] = "ase1iXcLAxanvXLZcgh6tk";
  request.fields["user_id"] = globalUid;
  request.fields["user_type"] = globalType;
  request.fields["lang"] = lang;
  request.fields['release_date'] = uInfo['release_date'];
  if (uInfo['expiry_date'] != null)
    request.fields['expiry_date'] = uInfo['expiry_date'];
  request.fields['status'] = uInfo['status'].toString();
  request.fields['certificate_title_en'] = uInfo['certificate_title_en'];
  request.fields['certificate_title_ar'] = uInfo['certificate_title_ar'];
  await request.send().then((response) async {
    response.stream.transform(utf8.decoder).listen((value) async {
      Map<String, dynamic> map = json.decode(value);
      if (map['status'] != null && map['status'] == true) {
        status = map['status'];
        msg = map['msg'];
        return map['status'];
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return null;
      }
    });
  }).catchError((e) {
    return null;
  });
  if (status == true) {
    Get.snackbar(msg, '',
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.blue,
        leftBarIndicatorColor: Colors.blue);
    return {'status': true};
  } else {
    return {'status': 'false'};
  }
}

Future<Map> addExperience(String lang, Map uInfo) async {
  // 132
  Uri url = Uri.https('wathefty.net', '/api/users/createUserExperiences');
  if (uInfo.isEmpty) {
    return {'status': false};
  }
  var status = false, msg = '';
  var request = new http.MultipartRequest("POST", url);
  if (uInfo['file'] != null) {
    var stream = new http.ByteStream(uInfo['file'].openRead());
    stream.cast();
    var length = await uInfo['file'].length();
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(uInfo['file'].path));
    request.files.add(multipartFile);
  }
  request.fields["api_password"] = "ase1iXcLAxanvXLZcgh6tk";
  request.fields["user_id"] = globalUid;
  request.fields["user_type"] = globalType;
  request.fields["lang"] = lang;
  request.fields["position_en"] = uInfo['position_en'];
  request.fields["position_ar"] = uInfo['position_ar'];
  request.fields["company_name_ar"] = uInfo['company_name_ar'];
  request.fields["company_name_en"] = uInfo['company_name_en'];
  request.fields["start_at"] = uInfo['start_at'];
  if (uInfo['end_at'] != null) request.fields["end_at"] = uInfo['end_at'];
  if (uInfo['until_now'] != null)
    request.fields["until_now"] = uInfo['until_now'];
  await request.send().then((response) async {
    response.stream.transform(utf8.decoder).listen((value) async {
      Map<String, dynamic> map = json.decode(value);
      if (map['status'] != null && map['status'] == true) {
        status = map['status'];
        msg = map['msg'];
        return map['status'];
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return null;
      }
    });
  }).catchError((e) {
    return null;
  });
  if (status == true) {
    Get.snackbar(msg, '',
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.blue,
        leftBarIndicatorColor: Colors.blue);
    return {'status': true};
  } else {
    return {'status': 'false'};
  }
}

Future<Map> addCourse(String lang, Map uInfo) async {
  // 133
  Uri url = Uri.https('wathefty.net', '/api/individual/addCourse');
  if (uInfo.isEmpty) {
    return {'status': false};
  }
  var status = false, msg = '';
  var request = new http.MultipartRequest("POST", url);
  if (uInfo['file'] != null) {
    var stream = new http.ByteStream(uInfo['file'].openRead());
    stream.cast();
    var length = await uInfo['file'].length();
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(uInfo['file'].path));
    request.files.add(multipartFile);
  }
  request.fields["api_password"] = "ase1iXcLAxanvXLZcgh6tk";
  request.fields["individual_id"] = globalUid;
  request.fields["user_type"] = globalType;
  request.fields["lang"] = lang;
  request.fields["course_title_ar"] = uInfo['course_title_ar'];
  request.fields["course_title_en"] = uInfo['course_title_en'];
  request.fields["organization_name_ar"] = uInfo['organization_name_ar'];
  request.fields["organization_name_en"] = uInfo['organization_name_en'];
  request.fields["organization_address_ar"] = uInfo['organization_address_ar'];
  request.fields["organization_address_en"] = uInfo['organization_address_en'];
  request.fields["start_at"] = uInfo['start_date'];
  request.fields["end_at"] = uInfo['end_date'];
  await request.send().then((response) async {
    response.stream.transform(utf8.decoder).listen((value) async {
      Map<String, dynamic> map = json.decode(value);
      if (map['status'] != null && map['status'] == true) {
        status = map['status'];
        msg = map['msg'];
        return map['status'];
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return null;
      }
    });
  }).catchError((e) {
    return null;
  });
  if (status == true) {
    Get.snackbar(msg, '',
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.blue,
        leftBarIndicatorColor: Colors.blue);
    return {'status': true};
  } else {
    return {'status': 'false'};
  }
}

Future<Map> removeConversationAPI(String lang, String message) async {
  Map body = {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
    "user_id": globalUid,
    "user_type": globalType,
    "message_id": message,
  };
  // 134
  Uri url = Uri.https('wathefty.net', '/api/frontend/messageDelete');
  var response = await http.post(url, body: body);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      return map;
    } else {
      return {};
    }
  } else {
    return {};
  }
}

Future<Map> logoutAPI() async {
  // 135
  Uri url = Uri.https('wathefty.net', '/api/frontend/logout');
  var response = await http.post(url, body: {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "user_id": globalUid,
    "user_type": globalType
  });
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == true) {
      return map;
    } else {
      return {};
    }
  } else {
    return {};
  }
}

//1 = view, 2 = update
Future<Map> disabilities(int type, Map? data) async {
  Uri url;
  var response;
  Map map = {};
  if (type == 1) {
    // 136
    url = Uri.https('wathefty.net', '/api/individual/getUserSpecialNeed');
    response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "lang": lang,
      "user_id": globalUid,
      "user_type": globalType
    });
    map = json.decode(response.body);
    if (response.statusCode == 200 && map.isNotEmpty && map["status"]) {
      return map["user_special_need"][0];
    } else {
      return {};
    }
  } else if (type == 2 && data != null && data.isNotEmpty) {
    // 137
    url = Uri.https('wathefty.net', '/api/individual/updateUserSpecialNeed');
    response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "user_id": globalUid,
      "user_type": globalType,
      "category_id": data["category_id"],
      "sub_category_id": data["sub_category_id"],
      "status": data["status"]
    });
    map = json.decode(response.body);
    if (response.statusCode == 200 && map.isNotEmpty && map["status"]) {
      return {"status": true};
    } else {
      return {"status": false};
    }
  }
  return map;
}

//1 = view, 2 = update
Future<Map> privacy(int type, Map? data) async {
  Uri url;
  var response;
  Map map = {};
  if (type == 1) {
    return {};
  } else if (type == 2 && data != null && data.isNotEmpty) {
    // 138
    url = Uri.https('wathefty.net', '/api/individual/individualShowInfoUpdate');
    response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "user_id": globalUid,
      "user_type": globalType,
      "show_info_status": data["show_info_status"],
      "contact_info_visibility": data["contact_info_visibility"],
    });
    map = json.decode(response.body);
    if (response.statusCode == 200 && map.isNotEmpty && map["status"]) {
      return {"status": true};
    } else {
      return {"status": false};
    }
  }
  return map;
}

//1 = view, 2 = update
Future<Map> saveAlert(int type, Map? data) async {
  Uri url;
  var response;
  Map map = {};
  if (type == 1) {
    Map body = {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "user_id": globalUid,
      "lang": lang
    };
    Uri url;
    // 139
    url = Uri.https('wathefty.net', '/api/individual/getSavedAlert');
    var response = await http.post(url, body: body);
    Map<String, dynamic> map = json.decode(response.body);
    if (response.statusCode == 200 && map['status']) {
      return map;
    } else {
      return {};
    }
  } else if (type == 2 && data != null && data.isNotEmpty) {
    // 140
    url = Uri.https('wathefty.net', '/api/individual/createSavedAlert');
    response = await http.post(url, body: {
      "api_password": "ase1iXcLAxanvXLZcgh6tk",
      "user_id": globalUid,
      "user_type": globalType,
      "lang": lang,
      "saved_searche_id": data["saved_searche_id"],
      "alert_name": data["alert_name"],
    });
    map = json.decode(response.body);
    if (response.statusCode == 200 && map.isNotEmpty && map["status"]) {
      Get.back();
      Get.snackbar(map['msg'] ?? tr("Success"), '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.lightBlue,
          leftBarIndicatorColor: Colors.lightBlue);
      return {"status": true};
    } else {
      Get.snackbar(map['msg'] ?? tr("Failed"), '',
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return {"status": false};
    }
  }
  return map;
}

Future<List> getVisitors() async {
  Map map = {};
  Map body = {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
    "user_id": globalUid,
    "user_type": globalType
  };
  // 141
  Uri url = Uri.https('wathefty.net', '/api/individual/getCompanyViewProfile');
  var response = await http.post(url, body: body);
  map = json.decode(response.body);
  if (response.statusCode == 200 && map.isNotEmpty && map['status'] == true) {
    return map["companies_viewed_profile"];
  } else {
    return [];
  }
}

Future<List> getBranches(String? id) async {
  Map map = {};
  Map body = {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
    "company_id": id ?? globalUid,
    "user_type": globalType
  };
  // 142
  Uri url = Uri.https('wathefty.net', '/api/company/getCompanyBranches');
  var response = await http.post(url, body: body);
  map = json.decode(response.body);
  if (response.statusCode == 200 && map.isNotEmpty && map['status'] == true) {
    return map["branches"];
  } else {
    return [];
  }
}

Future<bool> addBranches(Map data) async {
  Map map = {};
  Map body = data;
  // 143
  Uri url = Uri.https('wathefty.net', '/api/company/addMoreBranches');
  var response = await http.post(url, body: body);
  map = json.decode(response.body);
  if (response.statusCode == 200 && map.isNotEmpty && map['status']) {
    Get.back();
    Get.reload();
    Get.snackbar((map['msg'] ?? ((response.reasonPhrase ?? "").toString())), '',
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.blue,
        leftBarIndicatorColor: Colors.blue);
    return true;
  } else {
    Get.snackbar(map['msg'] ?? response.reasonPhrase.toString() ?? "", tr(""),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.red,
        leftBarIndicatorColor: Colors.red);
    return false;
  }
}

Future<bool> deleteBranch(String id) async {
  Map map = {};
  // 144
  Uri url = Uri.https('wathefty.net', '/api/company/deleteCompanyBranches');
  var response = await http.post(url, body: {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
    "company_id": globalUid,
    "branch_id": id
  });
  map = json.decode(response.body);
  if (response.statusCode == 200 && map.isNotEmpty && map['status']) {
    Get.snackbar((map['msg'] ?? ((response.reasonPhrase ?? "").toString())), '',
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.blue,
        leftBarIndicatorColor: Colors.blue);
    return true;
  } else {
    Get.snackbar(map['msg'] ?? response.reasonPhrase.toString() ?? "", tr(""),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.red,
        leftBarIndicatorColor: Colors.red);
    return false;
  }
}

Future loginPhone(String phone, String code, String type) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // 145
  Uri url =
      Uri.https('wathefty.net', '/api/' + type.toLowerCase() + '/loginByCode');
  var player = await getID();
  var response = await http.post(url, body: {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "email": phone,
    "lang": lang,
    "user_type": type,
    "player_id": player,
    "code": code
  });
  Map<String, dynamic> map = json.decode(response.body);
  if (response.statusCode == 200 && !map['status']) {
    Get.snackbar(map['msg'], '',
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.red,
        leftBarIndicatorColor: Colors.red);
    return {'status': '0', 'message': map['msg']};
  } else if (response.statusCode == 200 && map['status']) {
    prefs.setString('token', map['access_token']);
    await prefs.setString('uid', map['user']['id'].toString());
    await prefs.setString('name_ar', map['user']['name_ar']);
    await prefs.setString('name_en', map['user']['name_en']);
    await prefs.setString('username', map['user']['username']);
    await prefs.setString('email', map['user']['email']);
    await prefs.setString('type', type);
    await prefs.setString(
        'profile_photo_path',
        map['user']['profile_photo_path'] != null
            ? map['user']['profile_photo_path']
            : 'https://icon-library.com/images/white-profile-icon/white-profile-icon-24.jpg');
    globalImage = map['user']['profile_photo_path'] != null
        ? map['user']['profile_photo_path']
        : 'https://icon-library.com/images/white-profile-icon/white-profile-icon-24.jpg';
    globalType = type;
    globalUid = map['user']['id'].toString();
    return true;
  } else if (response.statusCode == 401) {
    Map<String, dynamic> map = json.decode(response.body);
    if (map['status'] == false) {
      Get.snackbar(map['error'], tr(""),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.red,
          leftBarIndicatorColor: Colors.red);
      return false;
    }
  } else {
    Get.snackbar(tr('Something went wrong'),
        tr("Please make sure you're connected the internet try again"),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.red,
        leftBarIndicatorColor: Colors.red);
    return false;
  }
}

Future<Map> getOTPLogin(String phone, String type) async {
  Map body = {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
    "email": phone
  };
  // 146

  Uri url = Uri.https('wathefty.net',
      '/api/' + type.toLowerCase() + '/phoneVerificationCodeLogin');
  var response = await http.post(url, body: body);
  Map<String, dynamic> map = json.decode(response.body);
  if (response.statusCode == 200 && map['status']) {
    return map;
  } else {
    Get.snackbar(map['msg'] ?? response.reasonPhrase.toString() ?? "", '',
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.blue,
        leftBarIndicatorColor: Colors.blue);
    return {};
  }
}

// 147
Future<Map> joinUs(Map data) async {
  Uri url = Uri.https('wathefty.net', '/api/frontend/joinOurTeam');
  if (data.isEmpty) {
    return {'status': false};
  }
  var status = false, msg = '';
  var request = new http.MultipartRequest("POST", url);
  if (data['cv_file'] != null) {
    var stream = new http.ByteStream(data['cv_file'].openRead());
    stream.cast();
    var length = await data['cv_file'].length();
    var multipartFile = new http.MultipartFile('cv_file', stream, length,
        filename: basename(data['cv_file'].path));
    request.files.add(multipartFile);
  }
  request.fields["api_password"] = "ase1iXcLAxanvXLZcgh6tk";
  request.fields["individual_id"] = globalUid;
  request.fields["user_type"] = globalType;
  request.fields["lang"] = lang;
  request.fields["email"] = data['email'];
  request.fields["name"] = data['name'];
  request.fields["phone"] = data['phone'];
  request.fields["country_id"] = data['country_id'];
  request.fields["region_id"] = data['region_id'];
  request.fields["academic_id"] = data['academic_id'];
  request.fields["experience_years"] = data['experience_years'];
  request.fields["gender"] = data['gender'];
  request.fields["birth_date"] = data['birth_date'];
  await request.send().then((response) async {
    response.stream.transform(utf8.decoder).listen((value) async {
      Map<String, dynamic> map = json.decode(value);
      if (map['status'] != null && map['status'] == true) {
        status = map['status'];
        msg = map['msg'];
        return map['status'];
      } else {
        Get.snackbar(map['msg'], '',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white,
            colorText: Colors.red,
            leftBarIndicatorColor: Colors.red);
        return null;
      }
    });
  }).catchError((e) {
    return null;
  });
  if (status == true) {
    Get.snackbar(msg, '',
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.blue,
        leftBarIndicatorColor: Colors.blue);
    return {'status': true};
  } else {
    return {'status': 'false'};
  }
}

Future<List<Map<String, dynamic>>> getCurrencies() async {
  // 148
  Uri url = Uri.https('wathefty.net', '/api/frontend/getCurrencies');
  var response = await http.post(url,
      body: {"api_password": "ase1iXcLAxanvXLZcgh6tk", "lang": lang});
  Map data = json.decode(response.body);
  if (response.statusCode == 200 && data["status"] == true) {
    List<Map<String, dynamic>> list = [];
    for (var u in data["Currencies"]) {
      list.add({
        'value': u['id'],
        'label': lang == 'ar' ? u['name_ar'] : u['name_en']
      });
    }
    return list;
  } else {
    return [];
  }
}

Future<List> getTips(int type) async {
  Uri url;
  if (type == 0) {
    // 149
    url = Uri.https('wathefty.net', '/api/frontend/jobSearchStrategies');
  } else if (type == 1) {
    // 150
    url = Uri.https('wathefty.net', '/api/frontend/expertsVideos');
  } else if (type == 2) {
    // 151
    url = Uri.https('wathefty.net', '/api/frontend/resumeCoverLetter');
  } else if (type == 3) {
    // 152
    url = Uri.https('wathefty.net', '/api/frontend/getJobInterviewTips');
  } else if (type == 4) {
    // 153
    url = Uri.https('wathefty.net', '/api/frontend/salaryNegotiations');
  } else {
    // 154
    url = Uri.https('wathefty.net', '/api/frontend/getProjectIdeas');
  }
  var response = await http.post(url,
      body: {"api_password": "ase1iXcLAxanvXLZcgh6tk", "lang": lang});
  Map data = json.decode(response.body);
  if (response.statusCode == 200 && data["status"] == true) {
    if (type == 0) {
      return data["strategies"];
    } else if (type == 1) {
      return data["expert_videos"];
    } else if (type == 2) {
      return data["reume_letters"];
    } else if (type == 3) {
      return data["job_interview_tip"];
    } else if (type == 4) {
      return data["salary_negotiations"];
    } else {
      return data["ideas"];
    }
  } else {
    return [];
  }
}

Future<Map> advancedCVSearch(Map filters, int type) async {
  Map body = {"api_password": "ase1iXcLAxanvXLZcgh6tk"};
  Uri url;
  body.addAll(filters);
  if (type == 1) {
    //Search or Save
    // 155
    url = Uri.https('wathefty.net', '/api/company/advancedCvSearch');
  } else if (type == 3) {
    //delete
    // 156
    url = Uri.https('wathefty.net', '/api/company/deleteSearchCv');
  } else if (type == 4) {
    //Get like CVs
    // 157
    url = Uri.https('wathefty.net', '/api/company/cvLikedShow');
  } else {
    //Get saved searches
    // 158
    url = Uri.https('wathefty.net', '/api/company/getAdvancedCvSearchSaved');
  }
  var response = await http.post(url, body: body);
  Map<String, dynamic> map = json.decode(response.body);
  if (response.statusCode == 200 && map.isNotEmpty && map['status']) {
    return map;
  } else {
    return {};
  }
}

Future<Map> likeCV(String id) async {
  // 159
  Uri url = Uri.https('wathefty.net', '/api/company/cvLikedStore');
  Map body = {
    "api_password": "ase1iXcLAxanvXLZcgh6tk",
    "lang": lang,
    "company_id": globalUid,
    "individual_id": id
  };
  var response = await http.post(url, body: body);
  Map map = json.decode(response.body);
  if (response.statusCode == 200 && map.isNotEmpty && map["status"]) {
    Get.snackbar(map["msg"], '',
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.blue,
        leftBarIndicatorColor: Colors.blue);
    return map;
  } else {
    Get.snackbar(map['msg'] ?? tr("Please try again"), '',
        duration: Duration(seconds: 5),
        backgroundColor: Colors.white,
        colorText: Colors.red,
        leftBarIndicatorColor: Colors.red);
    return {};
  }
}
