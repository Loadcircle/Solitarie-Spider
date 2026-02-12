import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/constants/shop_registry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ShopRegistry.init();
  runApp(
    const ProviderScope(
      child: SpiderSolitaireApp(),
    ),
  );
}
