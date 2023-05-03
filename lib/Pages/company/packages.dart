import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../API.dart';
import '../../functions.dart';
import '../../main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdvertPackagePage extends StatefulWidget {
  @override
  _AdvertPackagePageState createState() => _AdvertPackagePageState();
}

class _AdvertPackagePageState extends State<AdvertPackagePage> {
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
              appBar: watheftyBar(context, "Packages", 20),
              bottomNavigationBar: watheftyBottomBar(context),
              body: FutureBuilder<List>(
                  future: getInfo('package', lang, ''),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                      return Container(
                        color: Colors.white,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: getWH(context, 1) * 0.8,
                        width: getWH(context, 2),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length >= 5 ? 5 : snapshot.data!.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (ctx, index) {
                              return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: GestureDetector(
                                      onTap: () async {},
                                      child: Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                          decoration: BoxDecoration(
                                            color: Colors.white70,
                                            border: Border.all(color: Colors.white, width: 3.0),
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          ),
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                            Flexible(
                                                child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(snapshot.data![index]['name'],
                                                    style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 18)),
                                                Text('Adverts: ' + snapshot.data![index]['package_quantity']),
                                                Text(snapshot.data![index]['on_sale'] == "Sale" ? (tr('On ') + snapshot.data![index]['on_sale']) : ''),
                                                Text(snapshot.data![index]['on_sale'] == "Sale"
                                                    ? (tr('Old price ') +
                                                        snapshot.data![index]['package_price'] +
                                                        tr(' JOD\nNew price: ') +
                                                        snapshot.data![index]['package_on_sale_price'] +
                                                        tr(' JOD'))
                                                    : tr('Price: ') + snapshot.data![index]['package_price'] + tr(' JOD')),
                                              ],
                                            )),
                                            Flexible(
                                                child: Column(children: [
                                              Icon(Icons.money),
                                              Text(snapshot.data![index]['on_sale'] == "Sale"
                                                  ? snapshot.data![index]['package_on_sale_price']
                                                  : snapshot.data![index]['package_price']),
                                              TextButton(
                                                  onPressed: () {},
                                                  style: TextButton.styleFrom(
                                                      backgroundColor: Colors.white,
                                                      shadowColor: Colors.black,
                                                      elevation: 5,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(30.0), side: BorderSide(color: Colors.black))),
                                                  child: Text('Buy', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 12)).tr())
                                            ]))
                                          ]))));
                            }),
                      );
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Scaffold(
      
                          backgroundColor: Colors.white,
                          body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
                    } else {
                      return SizedBox();
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
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.clear();
                              Get.offAll(() => StartPage());
                            },
                            child: Text('Retry').tr())
                      ]))));
        }
      });
}
