import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../CONSTANTS.dart';

class AdsWidget extends StatefulWidget {
  const AdsWidget({Key? key}) : super(key: key);

  @override
  State<AdsWidget> createState() => _AdsWidgetState();
}

class _AdsWidgetState extends State<AdsWidget> {
  late BannerAd _ad;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    MobileAds.instance
        .updateRequestConfiguration(RequestConfiguration(testDeviceIds: [
      'DF693493239FEF390746FE861B201FC3',
      'EB458550DFD9A5B6EF3D8FD1A0705EFA',
      '5BF49B5666B0C509C03B9E26F4DA9DDD',
      'E40EE0533B0AE80A89AE8F5ED8DE334D',
    ]));

    _ad = BannerAd(
        size: AdSize.banner,
        adUnitId: 'ca-app-pub-1896379146653594/2885992250',
        listener: BannerAdListener(
          onAdLoaded: (_) {
            setState(() {
              _isAdLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // Releases an ad resource when it fails to load
            ad.dispose();
            throw error;
          },
        ),
        request: const AdRequest());

    int? noAdsStartTime = GetStorage().read(kNoAdsStartTime);
    if (noAdsStartTime != null) {
      int now = DateTime.now().millisecondsSinceEpoch;
      if ((now - noAdsStartTime) < const Duration(minutes: 10).inMilliseconds) {
        return; // return immediately to prevent _ad.load() call
      }
      // if the time has exceeded, remove the key from storage
      GetStorage().remove(kNoAdsStartTime);
    }
    // ads load normally
    _ad.load();
  }

  @override
  Widget build(BuildContext context) {
    if (_isAdLoaded) {
      return Container(
          width: _ad.size.width.toDouble(),
          height: _ad.size.height.toDouble(),
          alignment: Alignment.center,
          child: AdWidget(ad: _ad));
    } else {
      return const SizedBox.shrink();
      // return const Placeholder(
      //   fallbackHeight: 50,
      //   fallbackWidth: 320,
      // );
    }
  }
}
