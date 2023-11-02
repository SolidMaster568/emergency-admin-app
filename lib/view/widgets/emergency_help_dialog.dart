import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emg/models/channel_model.dart';
import 'package:emg/utils/colors.dart';
import 'package:emg/utils/globals.dart';
import 'package:emg/view/widgets/custom_card_widget.dart';
import 'package:flutter/material.dart';

class EmergencyHelpDialog extends StatefulWidget {
  const EmergencyHelpDialog({super.key});

  @override
  State<EmergencyHelpDialog> createState() => _EmergencyHelpDialogState();
}

class _EmergencyHelpDialogState extends State<EmergencyHelpDialog> {
  int? selected;

  final List<Map<String, dynamic>> data = [
    {
      "path": "assets/heart-icon.png",
      "label": "Health Care",
      "color": persianRed
    },
    {"path": "assets/police-icon.png", "label": "Police", "color": gray},
    {"path": "assets/fire-icon.png", "label": "Fire", "color": hunyadiYellow},
    {
      "path": "assets/accident-icon.png",
      "label": "Accident",
      "color": persianRed
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Select Category to proceed"),
        const SizedBox(
          height: 12,
        ),
        Expanded(
          // height: MediaQuery.of(context).size.height * 0.6,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 25,
              crossAxisSpacing: 25,
            ),
            itemCount: data.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              // bool isSelected = index == selected;
              return CustomCardWidget(
                onTap: () {
                  setState(() => selected = index);

                  String channelId =
                      "${Globals.currentUser!.uid}_IOIYcdB0mQVCTQGHQXCtytmVg4F2";
                  Map<String, dynamic> channelInfo = {
                    "id": channelId,
                    "userID": Globals.currentUser!.uid,
                    "adminID": "IOIYcdB0mQVCTQGHQXCtytmVg4F2",
                    "service": data[index]['label']
                  };
                  ChannelModel channel = ChannelModel.fromJson(channelInfo);

                  DocumentReference<Map<String, dynamic>> channelDocumentRef =
                      FirebaseFirestore.instance
                          .collection("chat")
                          .doc(channelId);
                  var batch = FirebaseFirestore.instance.batch();
                  batch.set(
                      channelDocumentRef, channelInfo, SetOptions(merge: true));

                  // batch.commit().then((value) {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (_) => ChatPage(channel: channel),
                  //     ),
                  //   );
                  // }, onError: (e) {
                  //   print(e);
                  // });
                },
                iconData: data[index]['path'] as String,
                label: data[index]['label'] as String,
                iconColor: data[index]['color'] as Color,
                isSelected: index == selected,
              );
            },
          ),
        ),
      ],
    );
  }
}
