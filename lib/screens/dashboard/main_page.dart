import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emg/chat/call_page.dart';
import 'package:emg/models/channel_model.dart';
import 'package:emg/screens/dashboard/pages/emergency_page.dart';
import 'package:emg/screens/dashboard/pages/message_page.dart';
import 'package:emg/screens/dashboard/pages/notification_page.dart';
import 'package:emg/screens/dashboard/pages/upgrade_page.dart';
import 'package:emg/utils/colors.dart';
import 'package:emg/utils/globals.dart';
import 'package:emg/utils/utils.dart';
import 'package:emg/view/widgets/home_cell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int? selected;

  final List<Map<String, dynamic>> iconList = [
    {"icon": Icons.chat, "label": "Admin Chat"},
    {"icon": Icons.add, "label": "Emergency"},
    {"icon": Icons.people, "label": "Not Available"},
    {"icon": Icons.notifications, "label": "Notifications"},
    {"icon": Icons.settings, "label": "Setting"},
    {"icon": Icons.arrow_upward, "label": "Upgrade"},
  ];

  late StreamSubscription<QuerySnapshot> callListener;

  @override
  void initState() {
    super.initState();

    callListener = FirebaseFirestore.instance
        .collection("calls")
        .where("adminID", isEqualTo: Globals.currentAdmin!.uid)
        .where("status", isEqualTo: "calling")
        .snapshots()
        .listen((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> channelInfo = querySnapshot.docs.first.data();
        ChannelModel channel = ChannelModel.fromJson(channelInfo);

        goCall(channel);
      }
    });
  }

  @override
  void dispose() {
    callListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            elevation: 0,
            leadingWidth: 80,
            leading: const Center(
                child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Good Morning"),
            )),
            title: Center(
              child: Image.asset(
                "assets/logo.png",
                height: 48,
              ),
            ),
            actions: const [
              Text(
                "America",
                style: TextStyle(color: offRedButton),
              ),
              Icon(
                Icons.add_location,
                color: offRedButton,
                size: 30,
              ),
            ],
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            primary: false,
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.8,
            children: iconList.map<Widget>((e) {
              return HomeCell(
                  callback: () => goNext(e["label"]),
                  iconData: e["icon"],
                  title: e["label"]);
            }).toList(),
          ),
        ),
      ),
    );
  }

  void goNext(String title) {
    switch (title) {
      case "Admin Chat":
        Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => const MessagePage()));
        break;
      case "Emergency":
        Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => const EmergencyPage()));
        break;
      case "Not Available":
        Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => const UpgradePage()));
        break;
      case "Notifications":
        Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => const NotificationPage()));
        break;
      case "Setting":
        Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => const UpgradePage()));
        break;
      default:
        Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => const UpgradePage()));
    }
  }

  void goCall(ChannelModel channel) async {
    Map<String, dynamic> result = await Util.getAgoraToken(channel.id);

    if (result["token"] == null) {
      showSnakBar("Failed to get token", context);
    } else {
      var batch = FirebaseFirestore.instance.batch();
      batch.set(FirebaseFirestore.instance.collection("calls").doc(channel.id),
          {"status": "accepted"}, SetOptions(merge: true));

      batch.commit().then((value) {}, onError: (e) {
        print(e);
      });

      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).push(CupertinoPageRoute(
          builder: (context) =>
              CallPage(channel: channel, token: result["token"])));
    }
  }
}
