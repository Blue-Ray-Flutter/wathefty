import 'package:carousel_slider/carousel_slider.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../API.dart';
import '../../functions.dart';
import 'individual_profile.dart';

class ReviewsPage extends StatefulWidget {
  @override
  _ReviewsPageState createState() => _ReviewsPageState();
  const ReviewsPage({Key? key, required this.companyId}) : super(key: key);
  final String companyId;
}

class _ReviewsPageState extends State<ReviewsPage> {
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
    loading = false;
  }

  bool loading = false;
  
  Widget build(BuildContext context) {
    loading = false;
    
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: globalType != 'Guest'
            ? FloatingActionButton(
                heroTag: "btn8",
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                onPressed: () async {
                  await commentDialog(context, globalType, 'company review', lang, '', widget.companyId.toString(), '', null);
                },
                child: Icon(Icons.star, color: Colors.blueGrey))
            : SizedBox(),
        appBar: watheftyBar(context, "Reviews", 20),
        bottomNavigationBar: watheftyBottomBar(context),
        body: FutureBuilder<Map>(
            future: getReviews(widget.companyId, lang),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
                return SingleChildScrollView(child: StatefulBuilder(builder: (BuildContext context, StateSetter setRefresh) {
                  return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    SizedBox(height: 20),
                    // Text('Reviews', style: TextStyle(fontFamily: 'Aleo', fontWeight: FontWeight.bold, fontSize: 23.0, color: Colors.blue)),
                    Text(snapshot.data!['percentage'], style: TextStyle(fontFamily: 'Aleo', fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.blue)),
                    SizedBox(height: 10),
                    RichText(
                        text: TextSpan(style: DefaultTextStyle.of(context).style, children: <TextSpan>[
                      TextSpan(text: tr('Reviews: '), style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: snapshot.data!['count'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue))
                    ])),
                    Container(
                        margin: EdgeInsets.all(25),
                        child: RatingBar.builder(
                            initialRating: double.parse(snapshot.data!['percentage']),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            ignoreGestures: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                            onRatingUpdate: (rating) {})),
                    Stack(alignment: Alignment.center, children: <Widget>[
                      Container(
                          height: 20,
                          margin: EdgeInsets.all(5),
                          width: getWH(context, 2) * 0.7,
                          child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              child: LinearProgressIndicator(
                                value: double.parse(snapshot.data!['one']) / 100,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                                backgroundColor: Colors.grey[50],
                              ))),
                      Align(child: Text(tr('One Star ') + snapshot.data!['one'] + '%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)))
                    ]),
                    Stack(alignment: Alignment.center, children: <Widget>[
                      Container(
                          margin: EdgeInsets.all(5),
                          height: 20,
                          width: getWH(context, 2) * 0.7,
                          child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              child: LinearProgressIndicator(
                                value: double.parse(snapshot.data!['two']) / 100,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                                backgroundColor: Colors.grey[50],
                              ))),
                      Align(
                        child: Text(
                          tr('Two Stars ') + snapshot.data!['two'] + '%',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ]),
                    Stack(alignment: Alignment.center, children: <Widget>[
                      Container(
                          margin: EdgeInsets.all(5),
                          height: 20,
                          width: getWH(context, 2) * 0.7,
                          child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              child: LinearProgressIndicator(
                                value: double.parse(snapshot.data!['three']) / 100,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                                backgroundColor: Colors.grey[50],
                              ))),
                      Align(
                        child: Text(
                          tr('Three Stars ') + snapshot.data!['three'] + '%',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ]),
                    Stack(alignment: Alignment.center, children: <Widget>[
                      Container(
                          margin: EdgeInsets.all(5),
                          height: 20,
                          width: getWH(context, 2) * 0.7,
                          child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              child: LinearProgressIndicator(
                                value: double.parse(snapshot.data!['four']) / 100,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                                backgroundColor: Colors.grey[50],
                              ))),
                      Align(child: Text(tr('Four Star ') + snapshot.data!['four'] + '%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)))
                    ]),
                    Stack(alignment: Alignment.center, children: <Widget>[
                      Container(
                          margin: EdgeInsets.all(5),
                          height: 20,
                          width: getWH(context, 2) * 0.7,
                          child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              child: LinearProgressIndicator(
                                value: double.parse(snapshot.data!['five']) / 100,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                                backgroundColor: Colors.grey[50],
                              ))),
                      Align(
                        child: Text(
                          tr('Five Stars ') + snapshot.data!['five'] + '%',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ]),
                    Divider(),
                    snapshot.data!['reviews'].isNotEmpty && globalType != 'Guest'
                        ? CarouselSlider(
                            options: CarouselOptions(height: getWH(context, 1) * 0.4, autoPlay: true, viewportFraction: 1),
                            items: snapshot.data!['reviews'].map<Widget>((i) {
                              return SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: GestureDetector(
                                      onTap: () {
                                        Get.to(() => IndividualProfile(iid: i.id.toString()));
                                      },
                                      child: Column(children: [
                                        CircleAvatar(radius: 30, backgroundImage: NetworkImage(i.img)),
                                        Text(i.name),
                                        RatingBar.builder(
                                            ignoreGestures: true,
                                            initialRating: double.parse(snapshot.data!['percentage']),
                                            itemSize: 15,
                                            direction: Axis.horizontal,
                                            itemCount: 5,
                                            itemPadding: EdgeInsets.symmetric(horizontal: 0.2),
                                            itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                                            onRatingUpdate: (rating) {}),
                                        Text(i.created, style: TextStyle(fontSize: 12)),
                                        Padding(padding: EdgeInsets.all(15), child: Text(i.note, style: TextStyle(fontSize: 17.0, color: Colors.blueGrey)))
                                      ])));
                            }).toList())
                        : SizedBox()
                  ]);
                }));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                    backgroundColor: Colors.white,
                    body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
              } else {
                return Center(
                    child: Container(
                        padding: EdgeInsets.all(50),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                          Text(
                            "There are no reviews for this company yet.",
                            textAlign: TextAlign.center,
                          ).tr(),
                          TextButton(
                              onPressed: () async {
                                Get.back();
                              },
                              child: Text('Go back').tr())
                        ])));
              }
            }));
  }
}
