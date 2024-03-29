import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? banner;

  bool isLoading = true;

  @override
  void initState() {
    BannerAd(
      size: AdSize.banner,
      adUnitId: kReleaseMode ? 'ca-app-pub-5541125993552460/7474212401' : 'ca-app-pub-3940256099942544/6300978111',
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() {
          banner = ad as BannerAd;
          isLoading = false;
        }),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
      request: const AdRequest(),
    ).load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return isLoading
        ? const SizedBox(height: 55, width: 325)
        : Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              height: 55,
              width: 325,
              decoration: BoxDecoration(
                // boxShadow: [
                //   BoxShadow(
                //     blurRadius: 3,
                //     color: color.primary,
                //     offset: const Offset(0, 2),
                //   )
                // ],
                border: Border.all(
                  width: 0.5,
                  color: color.primary,
                ),
                borderRadius: BorderRadius.circular(6),
                color: color.secondaryContainer.withOpacity(0.9),
              ),
              child: SizedBox(
                height: 50,
                width: 320,
                child: AdWidget(ad: banner!),
              ),
            ),
          );
  }
}
