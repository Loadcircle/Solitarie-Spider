import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'app.dart';
import 'core/constants/shop_registry.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await ShopRegistry.init();
  await NotificationService.instance.init();
  runApp(
    const ProviderScope(
      child: SpiderSolitaireApp(),
    ),
  );
}
