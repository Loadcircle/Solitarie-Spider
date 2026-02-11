// ignore_for_file: avoid_print
// Generates placeholder WAV files for sound effects that don't have
// real audio files yet. Each WAV is a short sine-wave tone.
//
// Run: dart run tool/generate_placeholder_sounds.dart
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

void main() {
  final soundsDir = Directory('assets/sounds');
  if (!soundsDir.existsSync()) {
    soundsDir.createSync(recursive: true);
  }

  // Only generate files that don't already exist
  final placeholders = <String, _ToneSpec>{
    'lose.wav': _ToneSpec(frequency: 220, durationMs: 600, fadeOut: true),
    'sequence_complete.wav':
        _ToneSpec(frequency: 880, durationMs: 400, fadeOut: false),
    'invalid_move.wav':
        _ToneSpec(frequency: 150, durationMs: 200, fadeOut: true),
  };

  for (final entry in placeholders.entries) {
    final file = File('${soundsDir.path}/${entry.key}');
    if (file.existsSync()) {
      print('  SKIP ${entry.key} (already exists)');
      continue;
    }
    final bytes = _generateWav(entry.value);
    file.writeAsBytesSync(bytes);
    print('  CREATED ${entry.key} (${bytes.length} bytes)');
  }

  print('Done.');
}

class _ToneSpec {
  final double frequency;
  final int durationMs;
  final bool fadeOut;

  const _ToneSpec({
    required this.frequency,
    required this.durationMs,
    required this.fadeOut,
  });
}

Uint8List _generateWav(_ToneSpec spec) {
  const sampleRate = 22050;
  const bitsPerSample = 16;
  const numChannels = 1;

  final numSamples = (sampleRate * spec.durationMs / 1000).round();
  final dataSize = numSamples * numChannels * (bitsPerSample ~/ 8);
  final fileSize = 36 + dataSize;

  final buffer = ByteData(8 + fileSize);
  var offset = 0;

  // RIFF header
  void writeString(String s) {
    for (var i = 0; i < s.length; i++) {
      buffer.setUint8(offset++, s.codeUnitAt(i));
    }
  }

  writeString('RIFF');
  buffer.setUint32(offset, fileSize, Endian.little);
  offset += 4;
  writeString('WAVE');

  // fmt sub-chunk
  writeString('fmt ');
  buffer.setUint32(offset, 16, Endian.little);
  offset += 4; // sub-chunk size
  buffer.setUint16(offset, 1, Endian.little);
  offset += 2; // PCM
  buffer.setUint16(offset, numChannels, Endian.little);
  offset += 2;
  buffer.setUint32(offset, sampleRate, Endian.little);
  offset += 4;
  buffer.setUint32(
      offset, sampleRate * numChannels * (bitsPerSample ~/ 8), Endian.little);
  offset += 4; // byte rate
  buffer.setUint16(offset, numChannels * (bitsPerSample ~/ 8), Endian.little);
  offset += 2; // block align
  buffer.setUint16(offset, bitsPerSample, Endian.little);
  offset += 2;

  // data sub-chunk
  writeString('data');
  buffer.setUint32(offset, dataSize, Endian.little);
  offset += 4;

  // PCM samples
  for (var i = 0; i < numSamples; i++) {
    final t = i / sampleRate;
    var sample = sin(2.0 * pi * spec.frequency * t);

    if (spec.fadeOut) {
      final envelope = 1.0 - (i / numSamples);
      sample *= envelope;
    }

    final intSample = (sample * 32767 * 0.5).round().clamp(-32768, 32767);
    buffer.setInt16(offset, intSample, Endian.little);
    offset += 2;
  }

  return buffer.buffer.asUint8List();
}
