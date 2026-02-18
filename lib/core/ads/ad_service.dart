import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Central service for all ad types.
///
/// Usage:
///   - Call load*() to preload an ad before you need it.
///   - Call show*() when you want to display it.
///   - Banner ads are handled independently by [BannerAdWidget].
///
/// None of the ads are loaded or shown automatically.
class AdService {
  AdService._();
  static final AdService instance = AdService._();

  // ─── Ad Unit IDs (Google test IDs) ───────────────────────────────

  /// Banner ad unit ID — used directly by [BannerAdWidget].
  static const String bannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';

  static const String _interstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';

  static const String _rewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917';

  static const String _rewardedInterstitialAdUnitId =
      'ca-app-pub-3940256099942544/5354046379';

  static const String _appOpenAdUnitId =
      'ca-app-pub-3940256099942544/9257395921';

  // ─── Interstitial ─────────────────────────────────────────────────
  // Full-screen static ad. Load before the natural break, show at the break.
  // Good for: between games, after game over, navigating back to home.

  InterstitialAd? _interstitialAd;
  bool get isInterstitialReady => _interstitialAd != null;

  Future<void> loadInterstitial() async {
    await InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (_) => _interstitialAd = null,
      ),
    );
  }

  /// Shows the interstitial if ready. Calls [onDismissed] when closed.
  void showInterstitial({VoidCallback? onDismissed}) {
    final ad = _interstitialAd;
    if (ad == null) return;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (_) {
        _interstitialAd = null;
        onDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _interstitialAd = null;
      },
    );
    ad.show();
    _interstitialAd = null;
  }

  // ─── Rewarded ─────────────────────────────────────────────────────
  // Full-screen video. User watches to earn a reward (e.g. undo, hint).
  // Good for: extra undos, hints, continues after losing.

  RewardedAd? _rewardedAd;
  bool get isRewardedReady => _rewardedAd != null;

  Future<void> loadRewarded() async {
    await RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (_) => _rewardedAd = null,
      ),
    );
  }

  /// Shows the rewarded ad if ready.
  /// [onRewarded] fires when the user earns the reward.
  void showRewarded({
    required void Function(RewardItem reward) onRewarded,
    VoidCallback? onDismissed,
  }) {
    final ad = _rewardedAd;
    if (ad == null) return;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (_) {
        _rewardedAd = null;
        onDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _rewardedAd = null;
      },
    );
    ad.show(onUserEarnedReward: (_, reward) => onRewarded(reward));
    _rewardedAd = null;
  }

  // ─── Rewarded Interstitial ─────────────────────────────────────────
  // Like rewarded but can be skipped. Lower friction than rewarded.
  // Good for: optional XP boosts, cosmetic unlocks preview.

  RewardedInterstitialAd? _rewardedInterstitialAd;
  bool get isRewardedInterstitialReady => _rewardedInterstitialAd != null;

  Future<void> loadRewardedInterstitial() async {
    await RewardedInterstitialAd.load(
      adUnitId: _rewardedInterstitialAdUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) => _rewardedInterstitialAd = ad,
        onAdFailedToLoad: (_) => _rewardedInterstitialAd = null,
      ),
    );
  }

  /// Shows the rewarded interstitial if ready.
  void showRewardedInterstitial({
    required void Function(RewardItem reward) onRewarded,
    VoidCallback? onDismissed,
  }) {
    final ad = _rewardedInterstitialAd;
    if (ad == null) return;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (_) {
        _rewardedInterstitialAd = null;
        onDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _rewardedInterstitialAd = null;
      },
    );
    ad.show(onUserEarnedReward: (_, reward) => onRewarded(reward));
    _rewardedInterstitialAd = null;
  }

  // ─── App Open ─────────────────────────────────────────────────────
  // Full-screen ad shown when the app comes from background to foreground.
  // Good for: app resume after the user left mid-session.

  AppOpenAd? _appOpenAd;
  bool get isAppOpenReady => _appOpenAd != null;

  Future<void> loadAppOpen() async {
    await AppOpenAd.load(
      adUnitId: _appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) => _appOpenAd = ad,
        onAdFailedToLoad: (_) => _appOpenAd = null,
      ),
    );
  }

  /// Shows the app open ad if ready. Calls [onDismissed] when closed.
  void showAppOpen({VoidCallback? onDismissed}) {
    final ad = _appOpenAd;
    if (ad == null) return;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (_) {
        _appOpenAd = null;
        onDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _appOpenAd = null;
      },
    );
    ad.show();
    _appOpenAd = null;
  }

  // ─── Cleanup ──────────────────────────────────────────────────────

  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _rewardedInterstitialAd?.dispose();
    _appOpenAd?.dispose();
  }
}
