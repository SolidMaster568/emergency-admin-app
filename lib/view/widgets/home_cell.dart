import 'package:flutter/material.dart';

class HomeCell extends StatelessWidget {
  const HomeCell(
      {super.key,
      required this.callback,
      required this.iconData,
      required this.title});

  final VoidCallback callback;
  final IconData iconData;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color.fromARGB(232, 252, 133, 103)),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
