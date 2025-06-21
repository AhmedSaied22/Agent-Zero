import 'package:elgassos/core/extensions/font_styles_extensions.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {
  static SnackBar show({
    required BuildContext context,
    required String message,
    required SnackBarType snackBarType,
  }) {
    IconData iconData;
    Color bgColor;
    Color textColor = Colors.white;

    switch (snackBarType) {
      case SnackBarType.alert:
        iconData = Icons.info_outline;
        bgColor = const Color.fromARGB(255, 201, 121, 2);
        break;
      case SnackBarType.done:
        iconData = Icons.check_circle_outline;
        bgColor = Colors.green;
        break;
      case SnackBarType.error:
        iconData = Icons.error_outline;
        bgColor = Colors.red;
        break;
    }

    return SnackBar(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(iconData, color: textColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message, style: context.bodyLarge),
            ),
          ],
        ),
      ),
      backgroundColor: bgColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
    );
  }
}

enum SnackBarType {
  alert,
  done,
  error,
}
