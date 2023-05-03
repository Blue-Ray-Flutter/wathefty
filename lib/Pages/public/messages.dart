import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../../../functions.dart';
import '../../API.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
  const Messages({Key? key, required this.uType}) : super(key: key);
  final String uType;
}

class _MessagesState extends State<Messages> {
  @override
  void initState() {
    super.initState();
    userList.clear();

    refreshTimer = Timer.periodic(Duration(seconds: 15), (Timer t) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    refreshTimer.cancel();
    userList.clear();
  }

  late Timer refreshTimer;

  Widget build(BuildContext context) {
   
    return FutureBuilder<List>(
        future: getMessages(lang),
        builder: (context, snapshot) {
          if (userList.isNotEmpty || snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
            return Scaffold(
                backgroundColor: Colors.white,
                appBar: watheftyBar(context, "Messages", 20),
                bottomNavigationBar: watheftyBottomBar(context),
                body: ListView.builder(
                    itemCount: userList.length,
                    padding: EdgeInsets.only(top: 16),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Get.to(() => Chat(
                                uType: snapshot.data![index].toType,
                                uid: snapshot.data![index].to,
                                image: snapshot.data![index].image,
                                name: snapshot.data![index].name,
                                id: snapshot.data![index].id));
                          },
                          child: Container(
                              padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Row(children: <Widget>[
                                  CircleAvatar(backgroundImage: NetworkImage(userList[index].image), maxRadius: 30),
                                  SizedBox(width: 16),
                                  Expanded(
                                      child: Container(
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                    Text(userList[index].name, style: TextStyle(fontSize: 16)),
                                    SizedBox(height: 6),
                                    Text(userList[index].messageText,
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.grey.shade600, fontWeight: userList[index].read ? FontWeight.bold : FontWeight.normal))
                                  ])))
                                ])),
                                Text(userList[index].time,
                                    style: TextStyle(fontSize: 12, fontWeight: userList[index].read ? FontWeight.bold : FontWeight.normal))
                              ])));
                    }));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                backgroundColor: Colors.white,
                appBar: watheftyBar(context, "Messages", 20),
                bottomNavigationBar: watheftyBottomBar(context),
                body: Center(child: Container(constraints: BoxConstraints.tightForFinite(), child: CircularProgressIndicator())));
          } else {
            return Scaffold(
                backgroundColor: Colors.white,
                appBar: watheftyBar(context, "Messages", 20),
                bottomNavigationBar: watheftyBottomBar(context),
                body: Center(child: Text('No messages').tr()));
          }
        });
  }
}

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
  const Chat({Key? key, required this.uType, required this.uid, required this.name, required this.image, this.id}) : super(key: key);
  final String name;
  final String image;
  final String uType;
  final String uid;
  final String? id;
}

class _ChatState extends State<Chat> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    messages.clear();
    refreshTimer = Timer.periodic(Duration(seconds: 15), (Timer t) {
      setState(() {});
    });
  }

  late Timer refreshTimer;

  @override
  void dispose() {
    super.dispose();
    messages.clear();
    text.dispose();
    refreshTimer.cancel();
  }

  final text = TextEditingController();
  Widget build(BuildContext context) {
   
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: hexStringToColor('#6986b8'),
            elevation: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: 90,
            flexibleSpace: SafeArea(
                child: Container(
                    padding: EdgeInsets.only(right: 16),
                    child: Row(children: <Widget>[
                      IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back), color: Colors.white),
                      SizedBox(width: 2),
                      CircleAvatar(backgroundImage: NetworkImage(widget.image), maxRadius: 20),
                      SizedBox(width: 12),
                      Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                        Text(widget.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                        SizedBox(height: 6),
                        Text(widget.uType, style: TextStyle(color: Colors.grey.shade300, fontSize: 13))
                      ])),
                      if (widget.id != null)
                        IconButton(
                            onPressed: () async {
                              var temp = await removeConversation(context, lang, widget.id!);
                              if (temp != null && temp) {
                                setState(() {});
                              }
                            },
                            icon: Icon(Icons.delete),
                            color: Colors.red[300]),
                    ])))),
        bottomNavigationBar: watheftyBottomBar(context),
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
              child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                  child: FutureBuilder<List<ChatMessage>>(
                      future: getChat(lang, widget.uid, widget.uType, widget.id),
                      builder: (context, snapshot) {
                        if (messages.isNotEmpty || snapshot.connectionState == ConnectionState.done && snapshot.data!.isNotEmpty) {
                          SchedulerBinding.instance!.addPostFrameCallback((_) {
                            _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
                          });
                          return ListView.builder(
                              itemCount: messages.length,
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              physics: BouncingScrollPhysics(),
                              controller: _scrollController,
                              itemBuilder: (context, index) {
                                return Container(
                                    padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                                    child: Align(
                                        alignment: (messages[index].messageType == "2" ? Alignment.topLeft : Alignment.topRight),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: (messages[index].messageType == "2" ? Colors.grey.shade200 : hexStringToColor('#6986b8'))),
                                            padding: EdgeInsets.all(16),
                                            child: Text(messages[index].messageContent,
                                                style: TextStyle(fontSize: 15, color: (messages[index].messageType == "2" ? Colors.black : Colors.white))))));
                              });
                        } else if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                              child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 50),
                                  constraints: BoxConstraints.tightForFinite(),
                                  child: CircularProgressIndicator()));
                        } else {
                          return Center(child: Text('No messages').tr());
                        }
                      }))),
          Stack(children: <Widget>[
            Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                    padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                    height: 60,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(children: <Widget>[
                      // GestureDetector(
                      //     onTap: () {},
                      //     child: Container(
                      //         height: 30,
                      //         width: 30,
                      //         decoration: BoxDecoration(
                      //           color: hexStringToColor('#6986b8'),
                      //           borderRadius: BorderRadius.circular(30),
                      //         ),
                      //         child: Icon(Icons.add, color: Colors.white, size: 20))),
                      SizedBox(width: 15),
                      Expanded(
                          child: TextField(
                              controller: text,
                              decoration: InputDecoration(hintText: tr("Message"), hintStyle: TextStyle(color: Colors.black54), border: InputBorder.none))),
                      SizedBox(width: 15),
                      FloatingActionButton(
                          onPressed: () async {
                            if (text.text.isNotEmpty) {
                              var temp = text.text;
                              text.clear();
                              messages.add(ChatMessage(messageContent: temp, messageType: "sender"));
                              await sendMessage(lang, widget.uid, widget.uType, temp, null);
                              setState(() {});
                            }
                          },
                          child: Icon(Icons.send, color: Colors.white, size: 18),
                          backgroundColor: hexStringToColor('#6986b8'),
                          elevation: 0)
                    ])))
          ])
        ]));
  }
}
