import 'package:flutter/material.dart';
import 'package:hackru/styles.dart';

class SocialMediaCard extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? iconData;
  final Color bgColor;
  final Color iconColor;
  const SocialMediaCard(
      {Key? key,
      this.onPressed,
      this.iconData,
      required this.bgColor,
      required this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 0,
        color: bgColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              iconData,
              color: iconColor,
              size: 25.0,
            ),
          ),
        ),
      ),
    );
  }
}
