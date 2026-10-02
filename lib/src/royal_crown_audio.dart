import 'dart:math' as math;
import 'dart:typed_data';

class RoyalCrownAudio {
  static const int sampleRate = 22050;
  static Uint8List? _themeCache;

  static Uint8List theme() => _themeCache ??= _makeTheme();

  static Uint8List effect(String name) {
    switch (name) {
      case 'ready':
        return _notes(.42, const [
          [0.00, .22, 392.00, .22],
          [0.09, .28, 523.25, .24],
        ]);
      case 'go':
        return _notes(.62, const [
          [0.00, .26, 523.25, .23],
          [0.10, .35, 659.25, .25],
          [0.20, .38, 783.99, .28],
        ]);
      case 'hit':
        return _notes(.34, const [
          [0.00, .16, 880.00, .24],
          [0.05, .24, 1318.51, .20],
        ]);
      case 'miss':
        return _notes(.24, const [
          [0.00, .20, 150.00, .22],
        ], noiseAmp: .035);
      case 'rush':
        return _notes(1.08, const [
          [0.00, .44, 196.00, .16],
          [0.10, .54, 392.00, .20],
          [0.20, .70, 784.00, .22],
          [0.34, .68, 1046.50, .20],
        ], noiseAmp: .025);
      case 'finish':
        return _notes(1.45, const [
          [0.00, .35, 261.63, .18],
          [0.12, .45, 329.63, .20],
          [0.24, .60, 392.00, .22],
          [0.40, .82, 523.25, .25],
          [0.62, .72, 783.99, .20],
        ]);
      default:
        return _notes(.12, const [[0, .10, 500, .08]]);
    }
  }

  static Uint8List _makeTheme() {
    const duration = 8.0;
    final n = (sampleRate * duration).round();
    final samples = List<double>.filled(n, 0);
    const chords = <List<double>>[
      [130.81, 164.81, 196.00],
      [116.54, 146.83, 174.61],
      [98.00, 123.47, 146.83],
      [116.54, 146.83, 174.61],
    ];

    for (var i = 0; i < n; i++) {
      final t = i / sampleRate;
      final bar = (t / 2).floor().clamp(0, 3);
      final local = t % 2;
      var v = 0.0;

      for (final f in chords[bar]) {
        v += math.sin(2 * math.pi * f * t) * .055;
        v += math.sin(2 * math.pi * f * 2 * t) * .016;
      }

      for (final beat in const [0.0, .5, 1.0, 1.5]) {
        final d = local - beat;
        if (d >= 0 && d < .20) {
          v += math.sin(2 * math.pi * 62 * d) * .12 * math.exp(-13 * d);
        }
      }

      final shimmer = math.sin(2 * math.pi * 1046.5 * t) * .014 *
          (.35 + .65 * math.sin(math.pi * local).abs());

      final fadeIn = (t / .24).clamp(0.0, 1.0);
      final fadeOut = ((duration - t) / .24).clamp(0.0, 1.0);
      samples[i] = (v + shimmer) * fadeIn * fadeOut;
    }

    return _wav(samples);
  }

  static Uint8List _notes(
    double duration,
    List<List<double>> events, {
    double noiseAmp = 0,
  }) {
    final n = (sampleRate * duration).round();
    final samples = List<double>.filled(n, 0);
    var seed = 911;

    for (var i = 0; i < n; i++) {
      final t = i / sampleRate;
      var v = 0.0;

      for (final e in events) {
        final start = e[0], dur = e[1], freq = e[2], amp = e[3];
        final d = t - start;
        if (d >= 0 && d < dur) {
          final attack = (d / .012).clamp(0.0, 1.0);
          final release =
              ((dur - d) / math.min(.14, dur * .5)).clamp(0.0, 1.0);
          final decay = math.exp(-1.8 * d / dur);
          v += math.sin(2 * math.pi * freq * d) *
              amp *
              attack *
              release *
              decay;
        }
      }

      if (noiseAmp > 0) {
        seed = (1664525 * seed + 1013904223) & 0x7fffffff;
        final r = (seed / 0x7fffffff) * 2 - 1;
        v += r * noiseAmp * math.exp(-8 * t / duration);
      }

      samples[i] = v.clamp(-.95, .95).toDouble();
    }

    return _wav(samples);
  }

  static Uint8List _wav(List<double> samples) {
    final dataSize = samples.length * 2;
    final out = ByteData(44 + dataSize);

    void ascii(int offset, String s) {
      for (var i = 0; i < s.length; i++) {
        out.setUint8(offset + i, s.codeUnitAt(i));
      }
    }

    ascii(0, 'RIFF');
    out.setUint32(4, 36 + dataSize, Endian.little);
    ascii(8, 'WAVE');
    ascii(12, 'fmt ');
    out.setUint32(16, 16, Endian.little);
    out.setUint16(20, 1, Endian.little);
    out.setUint16(22, 1, Endian.little);
    out.setUint32(24, sampleRate, Endian.little);
    out.setUint32(28, sampleRate * 2, Endian.little);
    out.setUint16(32, 2, Endian.little);
    out.setUint16(34, 16, Endian.little);
    ascii(36, 'data');
    out.setUint32(40, dataSize, Endian.little);

    for (var i = 0; i < samples.length; i++) {
      out.setInt16(
        44 + i * 2,
        (samples[i].clamp(-1.0, 1.0) * 32767).round(),
        Endian.little,
      );
    }

    return out.buffer.asUint8List();
  }
}
