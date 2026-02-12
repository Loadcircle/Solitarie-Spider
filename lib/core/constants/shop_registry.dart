import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/shop_item.dart';

class ShopRegistry {
  ShopRegistry._();

  // ─── Parsed data (populated by init()) ───

  static List<BackgroundItem> _backgrounds = const [];
  static List<CardBackItem> _cardBacks = const [];
  static List<FigureItem> _figures = const [];
  static Map<String, Map<String, String>> _names = const {};

  static List<BackgroundItem> get backgrounds => _backgrounds;
  static List<CardBackItem> get cardBacks => _cardBacks;
  static List<FigureItem> get figures => _figures;

  // ─── Const defaults (for SettingsState const constructor) ───

  static const BackgroundItem defaultBackground = BackgroundItem(
    id: 'background_felt_texture',
    displayNameKey: 'background_felt_texture',
    assetPath: 'assets/images/backgrounds/felt_texture.png',
  );

  static const CardBackItem defaultCardBack = CardBackItem(
    id: 'card_red_crosshatch',
    displayNameKey: 'card_red_crosshatch',
    assetPath: 'assets/images/cards/classic_red.png',
  );

  static const FigureItem defaultFigure = FigureItem(
    id: 'figure_king',
    displayNameKey: 'figure_king',
    folderPath: 'assets/images/figures/elegant',
  );

  // ─── Init (call once in main before runApp) ───

  static Future<void> init() async {
    final String json = await rootBundle.loadString('assets/shop_items.json');
    final Map<String, dynamic> data = jsonDecode(json) as Map<String, dynamic>;

    final Map<String, Map<String, String>> names = {};

    _backgrounds = (data['backgrounds'] as List<dynamic>).map((dynamic e) {
      final Map<String, dynamic> m = e as Map<String, dynamic>;
      final String id = m['id'] as String;

      names[id] = {
        'en': m['en'] as String? ?? id,
        'es': m['es'] as String? ?? id,
        'pt': m['pt'] as String? ?? id,
      };

      return BackgroundItem(
        id: id,
        displayNameKey: id,
        unlockLevel: m['unlockLevel'] as int?,
        assetPath: m['assetPath'] as String?,
        gradient: _parseGradient(m['gradientColors'] as List<dynamic>?),
        color: _parseColor(m['color'] as String?),
        colorLight: _parseColor(m['colorLight'] as String?),
      );
    }).toList();

    _cardBacks = (data['cardBacks'] as List<dynamic>).map((dynamic e) {
      final Map<String, dynamic> m = e as Map<String, dynamic>;
      final String id = m['id'] as String;

      names[id] = {
        'en': m['en'] as String? ?? id,
        'es': m['es'] as String? ?? id,
        'pt': m['pt'] as String? ?? id,
      };

      return CardBackItem(
        id: id,
        displayNameKey: id,
        unlockLevel: m['unlockLevel'] as int?,
        assetPath: m['assetPath'] as String?,
        color: _parseColor(m['color'] as String?),
        colorPattern: _parseColor(m['colorPattern'] as String?),
      );
    }).toList();

    _figures = (data['figures'] as List<dynamic>? ?? []).map((dynamic e) {
      final Map<String, dynamic> m = e as Map<String, dynamic>;
      final String id = m['id'] as String;

      names[id] = {
        'en': m['en'] as String? ?? id,
        'es': m['es'] as String? ?? id,
        'pt': m['pt'] as String? ?? id,
      };

      return FigureItem(
        id: id,
        displayNameKey: id,
        unlockLevel: m['unlockLevel'] as int?,
        folderPath: m['folder_path'] as String,
      );
    }).toList();

    _names = names;
  }

  // ─── Lookups ───

  static BackgroundItem backgroundById(String id) {
    return _backgrounds.firstWhere(
      (BackgroundItem b) => b.id == id,
      orElse: () => defaultBackground,
    );
  }

  static CardBackItem cardBackById(String id) {
    return _cardBacks.firstWhere(
      (CardBackItem c) => c.id == id,
      orElse: () => defaultCardBack,
    );
  }

  static FigureItem figureById(String id) {
    return _figures.firstWhere(
      (FigureItem f) => f.id == id,
      orElse: () => defaultFigure,
    );
  }

  // ─── Unlock helpers ───

  static List<Object> unlockedItemsForLevel(int level) {
    final List<Object> items = [];
    for (final BackgroundItem bg in _backgrounds) {
      if (bg.unlockLevel != null && bg.unlockLevel! <= level) {
        items.add(bg);
      }
    }
    for (final CardBackItem cb in _cardBacks) {
      if (cb.unlockLevel != null && cb.unlockLevel! <= level) {
        items.add(cb);
      }
    }
    for (final FigureItem fig in _figures) {
      if (fig.unlockLevel != null && fig.unlockLevel! <= level) {
        items.add(fig);
      }
    }
    return items;
  }

  static int? requiredLevelFor(Object item) {
    if (item is BackgroundItem) return item.unlockLevel;
    if (item is CardBackItem) return item.unlockLevel;
    if (item is FigureItem) return item.unlockLevel;
    return null;
  }

  static ({int level, Object reward})? nextRewardAfter(int currentLevel) {
    int? bestLevel;
    Object? bestReward;

    for (final BackgroundItem bg in _backgrounds) {
      if (bg.unlockLevel != null && bg.unlockLevel! > currentLevel) {
        if (bestLevel == null || bg.unlockLevel! < bestLevel) {
          bestLevel = bg.unlockLevel;
          bestReward = bg;
        }
      }
    }
    for (final CardBackItem cb in _cardBacks) {
      if (cb.unlockLevel != null && cb.unlockLevel! > currentLevel) {
        if (bestLevel == null || cb.unlockLevel! < bestLevel) {
          bestLevel = cb.unlockLevel;
          bestReward = cb;
        }
      }
    }
    for (final FigureItem fig in _figures) {
      if (fig.unlockLevel != null && fig.unlockLevel! > currentLevel) {
        if (bestLevel == null || fig.unlockLevel! < bestLevel) {
          bestLevel = fig.unlockLevel;
          bestReward = fig;
        }
      }
    }

    if (bestLevel != null && bestReward != null) {
      return (level: bestLevel, reward: bestReward);
    }
    return null;
  }

  /// Items unlocked between (fromLevel, toLevel] — exclusive start, inclusive end.
  static List<Object> itemsUnlockedBetween(int fromLevel, int toLevel) {
    final List<Object> items = [];
    for (final BackgroundItem bg in _backgrounds) {
      if (bg.unlockLevel != null &&
          bg.unlockLevel! > fromLevel &&
          bg.unlockLevel! <= toLevel) {
        items.add(bg);
      }
    }
    for (final CardBackItem cb in _cardBacks) {
      if (cb.unlockLevel != null &&
          cb.unlockLevel! > fromLevel &&
          cb.unlockLevel! <= toLevel) {
        items.add(cb);
      }
    }
    for (final FigureItem fig in _figures) {
      if (fig.unlockLevel != null &&
          fig.unlockLevel! > fromLevel &&
          fig.unlockLevel! <= toLevel) {
        items.add(fig);
      }
    }
    return items;
  }

  // ─── i18n display name resolver ───

  static String resolveName(String itemId, String locale) {
    final Map<String, String>? entry = _names[itemId];
    if (entry == null) return itemId;
    return entry[locale] ?? entry['en'] ?? itemId;
  }

  // ─── Private parse helpers ───

  static Color? _parseColor(String? hex) {
    if (hex == null) return null;
    return Color(int.parse(hex));
  }

  static LinearGradient? _parseGradient(List<dynamic>? colors) {
    if (colors == null || colors.length < 2) return null;
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: colors
          .map((dynamic c) => Color(int.parse(c as String)))
          .toList(),
    );
  }
}
