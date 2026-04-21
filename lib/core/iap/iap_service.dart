import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

class IAPService {
  static final IAPService instance = IAPService._();
  IAPService._();

  static const String productId = 'remove_ads';

  StreamSubscription<List<PurchaseDetails>>? _sub;
  Function(bool)? _onAdsRemovedChanged;

  Future<void> init(Function(bool) onAdsRemovedChanged) async {
    _onAdsRemovedChanged = onAdsRemovedChanged;
    final available = await InAppPurchase.instance.isAvailable();
    if (!available) return;
    _sub = InAppPurchase.instance.purchaseStream
        .listen(_handlePurchases);
    try {
      await InAppPurchase.instance.restorePurchases();
    } catch (_) {
      // Billing service unavailable (emulator, no Play Store, etc.)
    }
  }

  void dispose() => _sub?.cancel();

  Future<ProductDetails?> fetchProductDetails() async {
    final available = await InAppPurchase.instance.isAvailable();
    if (!available) return null;
    final response = await InAppPurchase.instance
        .queryProductDetails({productId});
    return response.productDetails.firstOrNull;
  }

  Future<void> buy(ProductDetails product) async {
    final param = PurchaseParam(productDetails: product);
    await InAppPurchase.instance.buyNonConsumable(purchaseParam: param);
  }

  void _handlePurchases(List<PurchaseDetails> purchases) async {
    for (final p in purchases) {
      if (p.productID == productId) {
        if (p.status == PurchaseStatus.purchased ||
            p.status == PurchaseStatus.restored) {
          _onAdsRemovedChanged?.call(true);
        }
        if (p.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(p);
        }
      }
    }
  }
}
