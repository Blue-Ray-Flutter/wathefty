import 'package:better_player/better_player.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wathefty/API.dart';
import '../../../functions.dart';

class TipsPage extends StatefulWidget {
  @override
  _TipsPageState createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<String> tips = ["Job Search Strategies", "Expert Videos", "Resume And Cover Letters", "Job interview tips", "Salary Negotiations", "Project ideas"];
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: watheftyBar(context, 'Career Tips', 16),
        body: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisSpacing: 10, mainAxisSpacing: 1, crossAxisCount: 2),
                itemCount: tips.length,
                itemBuilder: (context, index) {
                  return InkWell(
                      highlightColor: hexStringToColor('#6986b8'),
                      child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey[50], border: Border.all(color: hexStringToColor('#eeeeee')), borderRadius: BorderRadius.all(Radius.zero)),
                          child: Text(tips[index], textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)).tr()),
                      onTap: () {
                        Get.to(() => TipsList(type: index));
                      });
                })));
  }
}

class TipsList extends StatefulWidget {
  const TipsList({Key? key, required this.type}) : super(key: key);
  @override
  _TipsListState createState() => _TipsListState();
  final int type;
}

class _TipsListState extends State<TipsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<String> tips = ["Job Search Strategies", "Expert Videos", "Resume And Cover Letters", "Job interview tips", "Salary Negotiations", "Project ideas"];
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: watheftyBar(context, tips[widget.type], 15),
        body: FutureBuilder<List>(
            future: getTips(widget.type),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
                return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 3),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 30,
                            crossAxisCount: 1),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              highlightColor: hexStringToColor('#6986b8'),
                              child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      border: Border.all(color: hexStringToColor('#eeeeee')),
                                      borderRadius: BorderRadius.all(Radius.zero)),
                                  child: Column(children: [
                                    Expanded(
                                        child: Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: widget.type == 1
                                                        ? AssetImage('assets/video.png') as ImageProvider
                                                        : NetworkImage(snapshot.data![index]['image']))))),
                                    Text(snapshot.data![index]["title"],
                                            textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
                                        .tr(),
                                    Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: hexStringToColor('#6986b8'),
                                            border: Border.all(color: hexStringToColor('#eeeeee')),
                                            borderRadius: BorderRadius.all(Radius.zero)),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                          Text(widget.type != 1 ? "Read more" : "Watch",
                                                  textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                              .tr()
                                        ]))
                                  ])),
                              onTap: () {
                                Get.to(() => TipsInner(
                                    type: widget.type,
                                    title: snapshot.data![index]["title"],
                                    description: snapshot.data![index]["description"] ?? "",
                                    image: snapshot.data![index]["image"] ?? "",
                                    video: snapshot.data![index]["video"] ?? "",
                                    page: tips[widget.type]));
                              });
                        }));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Container(margin: EdgeInsets.only(top: 10), constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
              } else {
                return Center(
                    child: Container(
                        padding: EdgeInsets.all(50),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                          Text("No results", textAlign: TextAlign.center).tr(),
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

class TipsInner extends StatefulWidget {
  const TipsInner({Key? key, required this.type, required this.title, required this.video, required this.image, required this.description, required this.page})
      : super(key: key);
  @override
  _TipsInnerState createState() => _TipsInnerState();
  final int type;
  final String page, title, video, description, image;
}

class _TipsInnerState extends State<TipsInner> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: watheftyBar(context, widget.page, 15),
        body: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (widget.video.isEmpty && widget.image.isNotEmpty) Image.network(widget.image),
          if (widget.video.isNotEmpty)
            BetterPlayer.network(widget.video,
                betterPlayerConfiguration: BetterPlayerConfiguration(
                    autoPlay: false, fit: BoxFit.scaleDown, controlsConfiguration: BetterPlayerControlsConfiguration(enableSkips: false))),
          Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration:
                  BoxDecoration(color: Colors.white, border: Border.all(color: hexStringToColor('#eeeeee')), borderRadius: BorderRadius.all(Radius.zero)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text(tr('Title:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)).tr(),
                Text(widget.title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                Divider(),
                Text(tr('Description:'), style: TextStyle(color: Colors.blueGrey, fontSize: 15)).tr(),
                Text(widget.description, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))
              ]))
        ])));
  }
}
