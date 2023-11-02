import 'package:emg/utils/buttons.dart';
import 'package:emg/utils/colors.dart';
import 'package:emg/utils/globals.dart';
import 'package:emg/view/widgets/emergency_help_dialog.dart';
import 'package:emg/view/widgets/profile/bottom_sheet_profile_view.dart';
import 'package:emg/view/widgets/profile_image_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: const Text(
      //     "Fawad Kaleem",
      //     style: TextStyle(color: colorGrey),
      //   ),
      //   actions: [
      //     GestureDetector(
      //       onTap: () {},
      //       child: const Padding(
      //         padding: EdgeInsets.symmetric(horizontal: 12),
      //         child: Row(
      //           children: [
      //             Text(
      //               "America",
      //               style: TextStyle(color: offRedButton),
      //             ),
      //             Icon(
      //               Icons.add_location,
      //               color: offRedButton,
      //               size: 30,
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //     // TextButton.icon(
      //     //     onPressed: () {},
      //     //     icon: const Icon(
      //     //       Icons.location_pin,
      //     //       color: buttonColor,
      //     //     ),
      //     //     label: const Text(
      //     //       "America",
      //     //       style: TextStyle(color: buttonColor),
      //     //     ))
      //   ],
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          builder: (_) => const BottomSheetProfileView(),
                        );
                      },
                      child: Row(
                        children: [
                          const ProfileImageWidget(),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Hello ${Globals.currentUser!.getFullName()}!"),
                              const SizedBox(
                                height: 4,
                              ),
                              const Text(
                                "Incomplete profile",
                                style: TextStyle(color: offRedButton),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Row(
                        children: [
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
                  ],
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                OutlineButton(
                  style: OutlinedButton.styleFrom(
                    fixedSize: const Size(200, 50),
                  ),
                  title: "See Your Location",
                  onTap: () {},
                ),
                SizedBox(
                  height: size.height * 0.06,
                ),
                const Text(
                  "Emergency help\n needed?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: dimGrey, fontSize: 30),
                ),
                const Text(
                  "Just Tap the button to call",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colorGrey, fontSize: 12),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        scrollable: true,
                        backgroundColor: colorWhite,
                        content: Container(
                          // color: colorWhite,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                          width: size.width * 0.85,
                          height: size.height * 0.48,
                          child: const EmergencyHelpDialog(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: size.height * 0.3,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("assets/icon_call.png"),
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
