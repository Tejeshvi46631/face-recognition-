import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

class RootDetection {
  static Future<void> checkJailbreakOnInit(BuildContext context) async {
    bool jailbroken;
    bool developerMode;

    try {
      jailbroken = await FlutterJailbreakDetection.jailbroken;
      developerMode = await FlutterJailbreakDetection.developerMode;
    } on PlatformException {
      jailbroken = true; // Assume jailbroken if an error occurs.
      developerMode = true; // Assume developer mode if an error occurs.
    }

    if (jailbroken || developerMode) {
      _showJailbreakDialog(context);
    }
  }

  static void _showJailbreakDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Device Rooted'),
          content:
              Text('Your device is rooted. The application will now exit.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                SystemChannels.platform
                    .invokeMethod<void>('SystemNavigator.pop');
              },
            ),
          ],
        );
      },
    );
  }
}
