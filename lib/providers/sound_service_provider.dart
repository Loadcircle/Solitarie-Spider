import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/sound_service.dart';

final soundServiceProvider = Provider<SoundService>((Ref ref) {
  final SoundService service = SoundService();
  ref.onDispose(service.dispose);
  return service;
});
