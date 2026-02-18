import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_service.dart';

/// Displays a banner ad. Manages its own lifecycle (load + dispose).
/// Shows nothing while the ad is loading or if it fails.
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key, this.size = AdSize.banner});

  final AdSize size;

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _adLoaded = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: AdService.bannerAdUnitId,
      size: widget.size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (!mounted) return;
          setState(() => _adLoaded = true);
        },
        onAdFailedToLoad: (ad, _) => ad.dispose(),
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_adLoaded || _bannerAd == null) return const SizedBox.shrink();
    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
