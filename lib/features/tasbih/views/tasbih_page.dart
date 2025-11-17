import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get_storage/get_storage.dart';

import '../../../shared/constants/constants.dart';
import '../../../l10n/app_localizations.dart';
import 'components/tasbih_bead.dart';
import 'components/tasbih_colors.dart';

class TasbihPage extends StatefulWidget {
  const TasbihPage({super.key});

  @override
  State<TasbihPage> createState() => _TasbihPageState();
}

class _TasbihPageState extends State<TasbihPage> {
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

  /// Update the tasbih bead color
  void _updateTasbihColour(int tasbihColorKey) {
    setState(() {
      _tasbihColourindex = tasbihColorKey;
      GetStorage().write(kTasbihGradientColour, tasbihColorKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasbih"),
        centerTitle: true,
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
            tooltip: AppLocalizations.of(context)!.tasbihResetTooltip,
            icon: const Icon(Icons.restart_alt),
          ),
          MenuAnchor(
            menuChildren: TasbihColors.beadDesigns()
                .asMap()
                .entries
                .map((e) => MenuItemButton(
                      onPressed: () => _updateTasbihColour(e.key),
                      child: Row(
                        children: [
                          TasbihBead(gradientColor: e.value.gradient),
                          Gap(8),
                          Text(e.value.name)
                        ],
                      ),
                    ))
                .toList(),
            builder: (context, controller, _) {
              return IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.palette_outlined),
                tooltip: AppLocalizations.of(context)!.tasbihColorPickerTooltip,
              );
            },
          ),
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
                itemBuilder: (_, __) => TasbihBead(
                    gradientColor:
                        TasbihColors.beadDesigns()[_tasbihColourindex]
                            .gradient),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
