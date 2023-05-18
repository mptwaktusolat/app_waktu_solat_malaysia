import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../location_utils/location_database.dart';
import '../models/jakim_zones.dart';
import '../providers/location_provider.dart';

enum CurrentView { state, zone }

class ZoneSelectorDialog extends StatefulWidget {
  const ZoneSelectorDialog({super.key});

  @override
  State<ZoneSelectorDialog> createState() => _ZoneSelectorDialogState();
}

class _ZoneSelectorDialogState extends State<ZoneSelectorDialog> {
  final allZones = LocationDatabase.allLocation;
  late final List<String> negeriList;
  List<JakimZones> jakimZonesInSelectedNegeri = [];
  late String selectedNegeri;
  late JakimZones selectedJakimZone;
  CurrentView currentView = CurrentView.state;

  @override
  void initState() {
    super.initState();
    negeriList = allZones.map((e) => e.negeri).toSet().toList();

    var jakimCode = Provider.of<LocationProvider>(context, listen: false)
        .currentLocationCode;
    selectedNegeri = LocationDatabase.negeri(jakimCode);
    selectedJakimZone =
        allZones.firstWhere((element) => element.jakimCode == jakimCode);
  }

  @override
  Widget build(BuildContext context) {
    bool isWideScreen = MediaQuery.of(context).size.width > 768;

    return WillPopScope(
      onWillPop: () async {
        if (isWideScreen) return true;
        if (currentView == CurrentView.zone) {
          setState(() => currentView = CurrentView.state);
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              'Select ${currentView == CurrentView.state ? 'state' : 'zone'}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, selectedJakimZone);
              },
              child: const Text('Save'),
            ),
          ],
        ),
        body: Stack(
          alignment: Alignment.topRight,
          children: [
            ListView.builder(
              itemCount: negeriList.length,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(
                    negeriList[index],
                  ),
                  onTap: () {
                    setState(() {
                      currentView = CurrentView.zone;
                      selectedNegeri = negeriList[index];
                      jakimZonesInSelectedNegeri = allZones
                          .where((e) => e.negeri == negeriList[index])
                          .toList();
                    });
                  },
                  selected: negeriList[index] == selectedNegeri,
                  selectedTileColor:
                      Theme.of(context).colorScheme.primaryContainer,
                );
              },
            ),
            AnimatedFractionallySizedBox(
              duration: const Duration(milliseconds: 200),
              widthFactor: currentView == CurrentView.state
                  ? 0
                  : isWideScreen
                      // ? 1
                      ? .7
                      : 1,
              child: Card(
                margin: EdgeInsets.zero,
                clipBehavior: Clip.hardEdge,
                child: ListView.builder(
                  itemCount: jakimZonesInSelectedNegeri.length,
                  itemBuilder: (_, index) {
                    return ListTile(
                      title: Text.rich(
                        TextSpan(children: [
                          TextSpan(
                              text:
                                  '[${jakimZonesInSelectedNegeri[index].jakimCode}] ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: jakimZonesInSelectedNegeri[index].daerah),
                        ]),
                      ),
                      onTap: () {
                        setState(() {
                          selectedJakimZone = jakimZonesInSelectedNegeri[index];
                        });
                      },
                      selected: selectedJakimZone ==
                          jakimZonesInSelectedNegeri[index],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
