import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';
import 'banner_ad_widget.dart';

class AdBannerWidget extends ConsumerWidget {
  const AdBannerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adsRemoved = ref.watch(settingsProvider).adsRemoved;
    if (adsRemoved) return const SizedBox.shrink();
    return const SafeArea(top: false, child: BannerAdWidget());
  }
}
