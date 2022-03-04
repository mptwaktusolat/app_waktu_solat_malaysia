import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../CONSTANTS.dart';

class Tasbih extends StatefulWidget {
  const Tasbih({Key? key}) : super(key: key);

  @override
  State<Tasbih> createState() => _TasbihState();
}

class _TasbihState extends State<Tasbih> {
  final PageController _controller =
      PageController(viewportFraction: 0.1, initialPage: 5);

  int _counter = GetStorage().read<int?>(kTasbihCount) ?? 0;

  void _countUp() {
    _controller.nextPage(
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    HapticFeedback.lightImpact();
    setState(() {
      GetStorage().write(kTasbihCount, ++_counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasbih"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.tasbihResetDialog),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                          AppLocalizations.of(context)!.notifSettingCancel),
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _counter = 0;
                            GetStorage().write(kTasbihCount, 0);
                          });
                          Navigator.pop(context);
                        },
                        child: Text(AppLocalizations.of(context)!.tasbihReset))
                  ],
                ),
              );
            },
            icon: const Icon(Icons.restart_alt),
          )
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _counter.toString(),
                  style: const TextStyle(
                      fontSize: 72, fontWeight: FontWeight.w100),
                )
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onVerticalDragEnd: (details) {
                // only valid for scrolling down
                if (details.primaryVelocity! > 0) {
                  _countUp();
                }
              },
              onTap: _countUp,
              child: PageView.builder(
                reverse: true,
                physics: const NeverScrollableScrollPhysics(),
                controller: _controller,
                itemCount: null,
                scrollDirection: Axis.vertical,
                itemBuilder: (_, __) => Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xff2c3e50),
                          Color(0xff3498db),
                        ]),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
