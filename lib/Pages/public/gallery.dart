
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../API.dart';
import '../../../functions.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({Key? key, required this.iid, required this.owner}) : super(key: key);

  @override
  _GalleryPageState createState() => _GalleryPageState();
  final String iid;
  final bool owner;
}

var max = 3;

class _GalleryPageState extends State<GalleryPage> {
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
        if (snapshot.connectionState == ConnectionState.done) {
          
          return Scaffold(
              backgroundColor: Colors.white,
              floatingActionButton: widget.owner
                  ? FloatingActionButton(
                      heroTag: "btn10",
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      onPressed: () {
                        uploadImages(context, globalUid, globalType, lang);
                      },
                      child: Icon(Icons.upload_rounded, color: Colors.blueGrey))
                  : SizedBox(),
              appBar: AppBar(
                  centerTitle: true,
                  leading: IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back), color: Colors.white),
                  actions: [
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: IconButton(
                            icon: Icon(Icons.expand, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                if (max >= 2) {
                                  max--;
                                } else {
                                  max = 3;
                                }
                              });
                            }))
                  ],
                  backgroundColor: hexStringToColor('#6986b8'),
                  elevation: 0,
                  title: Text('Gallery', style: TextStyle(color: Colors.white)).tr()),
              body: FutureBuilder<Map>(
                  future: gallery(context, widget.iid, lang, globalType, 1, null),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
                      List data = snapshot.data!['Work_gallery'];
                      return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisSpacing: 0, mainAxisSpacing: 1, crossAxisCount: max),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                child:
                                    Container(decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(data[index]['image'])))),
                                onTap: () {
                                  biggerImage(
                                      context, data[index]['image'], widget.iid, globalType, {'id': data[index]['id'].toString()}, lang, widget.owner, 1);
                                });
                          });
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator()));
                    } else {
                      return Center(child: Text('No images submitted yet').tr());
                    }
                  }));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                  centerTitle: true,
                  leading: IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back), color: Colors.white),
                  backgroundColor: hexStringToColor('#6986b8'),
                  elevation: 0,
                  title: Text('Gallery', style: TextStyle(color: Colors.white)).tr()),
              body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
        } else {
          return Scaffold(
             appBar: AppBar(
                  centerTitle: true,
                  leading: IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back), color: Colors.white),
                  backgroundColor: hexStringToColor('#6986b8'),
                  elevation: 0,
                  title: Text('Gallery', style: TextStyle(color: Colors.white)).tr()),
              backgroundColor: Colors.white,
              body: Center(
                  child: Container(
                      padding: EdgeInsets.all(50),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Text(
                          "No images.",
                          textAlign: TextAlign.center,
                        ).tr(),
                        TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text('Go back').tr())
                      ]))));
        }
      });
}
