import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import '../../CONSTANTS.dart';
import 'qibla.dart';

class QiblaWarn extends StatelessWidget {
  const QiblaWarn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 20),
        child: Column(
          children: [
            const Spacer(),
            Icon(Icons.warning_amber_rounded,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.yellow
                    : Colors.yellow.shade700,
                size: 45),
            const SizedBox(height: 15),
            const UnorderedListItem(
              TextSpan(
                children: [
                  TextSpan(
                      text:
                          "Users must understand that Qibla Compass feature utilises the sensors of the user's device and does not use any data from JAKIM. Therefore, users should "),
                  TextSpan(
                      text: "wisely evaluate ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: "the information obtained.")
                ],
              ),
            ),
            const UnorderedListItem(
              TextSpan(
                children: [
                  TextSpan(text: "MPT app provides this function as a"),
                  TextSpan(
                      text: ' guide ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          "only. MPT app is not responsible if the information obtained is inaccurate. Please refer to the recommended way to get the exact Qibla direction."),
                ],
              ),
            ),
            const UnorderedListItem(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        "To improve the accuracy, make sure the internet and GPS connection are stable and perform the calibration by rotating your device in an",
                  ),
                  TextSpan(
                      text: ' 8 ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'or'),
                  TextSpan(
                      text: ' infinity ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: "shape as below:"),
                ],
              ),
            ),
            SvgPicture.asset(
              'assets/qibla/compass callibrate.svg',
              width: 150,
            ),
            const Spacer(),
            CupertinoButton.filled(
              child: const Text('I understood'),
              onPressed: () {
                GetStorage().write(kHasShowQiblaWarning, true);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const Qibla(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class UnorderedListItem extends StatelessWidget {
  const UnorderedListItem(this.text, {Key? key}) : super(key: key);
  final TextSpan text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("• "),
          Expanded(
            child: Text.rich(text, textAlign: TextAlign.justify),
          ),
        ],
      ),
    );
  }
}
