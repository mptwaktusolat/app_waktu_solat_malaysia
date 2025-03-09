import 'package:flutter/material.dart';

import 'base_share_card.dart';

class ShareCard2 extends BaseShareCard {
  const ShareCard2({super.key, super.repaintBoundaryKey});

  @override
  Widget buildCardContent(
    BuildContext context, {
    required String formattedDate,
    required String location,
    required Map<String, String> prayerTimes,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: buildAppLogo(context)),
          const Divider(thickness: 2),
          const SizedBox(height: 10),
          Text(
            formattedDate,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 5),
          Text(
            location,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          ...prayerTimes.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    entry.value,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
