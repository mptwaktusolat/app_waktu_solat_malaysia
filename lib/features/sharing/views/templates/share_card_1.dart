import 'package:flutter/material.dart';

import 'base_share_card.dart';

class ShareCard1 extends BaseShareCard {
  const ShareCard1({super.key, super.repaintBoundaryKey});

  @override
  Widget buildCardContent(
    BuildContext context, {
    required String formattedDate,
    required String location,
    required Map<String, String> prayerTimes,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formattedDate,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            location,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...prayerTimes.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    entry.value,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }),
          const Spacer(),
          Center(child: buildAppLogo(context)),
        ],
      ),
    );
  }
}
