import 'package:audioplayers/audioplayers.dart';

enum GameSound {
  cardMove,
  cardDeal,
  win,
  lose,
  sequenceComplete,
  invalidMove,
}

class SoundService {
  SoundService() {
    _configureAudioContext();
  }

  /// Primary player for short one-shot effects (move, deal, invalid).
  final AudioPlayer _fxPlayer = AudioPlayer();

  /// Secondary player so longer sounds (win, lose, sequence) don't cut off
  /// a short effect that may still be playing.
  final AudioPlayer _musicPlayer = AudioPlayer();

  /// Dedicated player for looping background music.
  final AudioPlayer _bgPlayer = AudioPlayer();

  bool _disposed = false;

  static const Map<GameSound, String> _assets = {
    GameSound.cardMove: 'sounds/card_move.mp3',
    GameSound.cardDeal: 'sounds/card_deal.mp3',
    GameSound.win: 'sounds/win.mp3',
    GameSound.lose: 'sounds/lose.mp3',
    GameSound.sequenceComplete: 'sounds/sequence_complete.mp3',
    GameSound.invalidMove: 'sounds/invalid_move.mp3',
  };

  static const Set<GameSound> _longSounds = {
    GameSound.win,
    GameSound.lose,
    GameSound.sequenceComplete,
  };

  /// Disable audio focus so players don't pause each other.
  void _configureAudioContext() {
    final context = AudioContext(
      android: const AudioContextAndroid(
        audioFocus: AndroidAudioFocus.none,
      ),
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: {AVAudioSessionOptions.mixWithOthers},
      ),
    );
    _fxPlayer.setAudioContext(context);
    _musicPlayer.setAudioContext(context);
    _bgPlayer.setAudioContext(context);
  }

  Future<void> play(GameSound sound) async {
    if (_disposed) return;

    final asset = _assets[sound];
    if (asset == null) return;

    final player = _longSounds.contains(sound) ? _musicPlayer : _fxPlayer;

    await player.stop();
    await player.play(AssetSource(asset));
  }

  Future<void> startBackgroundMusic() async {
    if (_disposed) return;
    await _bgPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgPlayer.setVolume(0.05);
    await _bgPlayer.play(AssetSource('sounds/background_music.mp3'));
  }

  Future<void> stopBackgroundMusic() async {
    if (_disposed) return;
    await _bgPlayer.stop();
  }

  Future<void> preload() async {
    if (_disposed) return;
    // Pre-set sources on players so the first play is faster
    await _fxPlayer.setSource(AssetSource('sounds/card_move.mp3'));
  }

  void dispose() {
    _disposed = true;
    _fxPlayer.dispose();
    _musicPlayer.dispose();
    _bgPlayer.dispose();
  }
}
