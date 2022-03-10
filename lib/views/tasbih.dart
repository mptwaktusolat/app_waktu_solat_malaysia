import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_storage/get_storage.dart';

import '../CONSTANTS.dart';
import '../utils/tasbih_colors.dart';

class Tasbih extends StatefulWidget {
  const Tasbih({Key? key}) : super(key: key);

  @override
  State<Tasbih> createState() => _TasbihState();
}

class _TasbihState extends State<Tasbih> {
  final PageController _controller =
      PageController(viewportFraction: 0.1, initialPage: 5);

  int _counter = GetStorage().read<int?>(kTasbihCount) ?? 0;

  int _tasbihColourindex = GetStorage().read(kTasbihGradientColour) ?? 0;

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
          ),
          IconButton(
              onPressed: () async {
                var selectedColourIndex = await showDialog(
                  context: context,
                  builder: (_) => const _ColourChooserDialog(),
                );

                if (selectedColourIndex == null) return;

                setState(() {
                  _tasbihColourindex = selectedColourIndex;
                  GetStorage()
                      .write(kTasbihGradientColour, selectedColourIndex);
                });
              },
              icon: const Icon(Icons.palette_outlined)),
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
                itemBuilder: (_, __) =>
                    TasbihBead(tasbihColourindex: _tasbihColourindex),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TasbihBead extends StatelessWidget {
  const TasbihBead({
    Key? key,
    required int tasbihColourindex,
  })  : _tasbihColourindex = tasbihColourindex,
        super(key: key);

  final int _tasbihColourindex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: TasbihColors.gradientColour()[_tasbihColourindex],
        ),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _ColourChooserDialog extends StatelessWidget {
  const _ColourChooserDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 56),
        child: Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                TasbihColors.gradientColour().length,
                (int index) => IconButton(
                  padding: const EdgeInsets.all(4),
                  onPressed: () => Navigator.pop(context, index),
                  icon: TasbihBead(tasbihColourindex: index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
