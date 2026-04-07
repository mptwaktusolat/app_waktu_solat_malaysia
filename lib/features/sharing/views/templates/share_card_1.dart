import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:waktusolat_api_client/waktusolat_api_client.dart';

import 'base_share_card.dart';

class ShareCard1 extends BaseShareCard {
  const ShareCard1({super.key, super.repaintBoundaryKey});

  @override
  Widget buildCardContent(
    BuildContext context, {
    required String formattedDate,
    required String location,
    required Map<String, String> prayerTimes,
    required HijriDate hijriDate,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Extract year and date format for display
    final now = DateTime.now();
    final masihiYear = now.year;
    final hijriYear = hijriDate.year;

    final masihiFormatter =
        DateFormat('d MMMM', Localizations.localeOf(context).languageCode);
    final masihiDate = masihiFormatter.format(now);

    final hijriDateFormatted = hijriDate.dMMM();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/mosque_bgs/pexels-rohit-george-1141376880-31730748-optim.jpg',
                fit: BoxFit.cover,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colorScheme.scrim.withValues(alpha: 0.45),
                      colorScheme.scrim.withValues(alpha: 0.5),
                      colorScheme.scrim.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      '${hijriYear}H / ${masihiYear}M',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.archivo(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'WAKTU SOLAT',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.archivo(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${hijriDateFormatted.toUpperCase()} | ${masihiDate.toUpperCase()}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.archivo(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.archivo(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.scrim.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          const horizontalSpacing = 8.0;
                          const runSpacing = 10.0;
                          const minItemWidth = 58.0;

                          final itemCount = prayerTimes.length;
                          final maxItemsPerRow = itemCount == 0
                              ? 1
                              : (constraints.maxWidth /
                                      (minItemWidth + horizontalSpacing))
                                  .floor()
                                  .clamp(1, itemCount);

                          final itemWidth = (constraints.maxWidth -
                                  ((maxItemsPerRow - 1) * horizontalSpacing)) /
                              maxItemsPerRow;

                          return Wrap(
                            spacing: horizontalSpacing,
                            runSpacing: runSpacing,
                            children: prayerTimes.entries
                                .map(
                                  (entry) => SizedBox(
                                    width: itemWidth,
                                    child: Column(
                                      children: [
                                        Text(
                                          entry.key.toUpperCase(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.archivo(
                                            color: colorScheme.onPrimary,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 10,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          entry.value,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.archivo(
                                            color: colorScheme.onPrimary,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildAppLogo(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
