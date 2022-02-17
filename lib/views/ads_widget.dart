import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsWidget extends StatefulWidget {
  const AdsWidget({Key? key}) : super(key: key);

  @override
  _AdsWidgetState createState() => _AdsWidgetState();
}

class _AdsWidgetState extends State<AdsWidget> {
  late BannerAd _ad;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
        testDeviceIds: [
          'DF693493239FEF390746FE861B201FC3',
          'EB458550DFD9A5B6EF3D8FD1A0705EFA'
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
    _ad.load();
  }

  @override
  Widget build(BuildContext context) {
    if (_isAdLoaded) {
      return Container(
          child: AdWidget(ad: _ad),
          width: _ad.size.width.toDouble(),
          height: _ad.size.height.toDouble() + 30,
          alignment: Alignment.center);
    } else {
      return const SizedBox.shrink();
    }
  }
}
