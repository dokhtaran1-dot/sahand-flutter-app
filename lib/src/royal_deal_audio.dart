import 'dart:math' as math;
import 'dart:typed_data';

class RoyalDealAudio {
  static const int sampleRate = 22050;
  static Uint8List? _themeCache;

  static Uint8List theme() => _themeCache ??= _makeTheme();

  static Uint8List effect(String name) {
    switch (name) {
      case 'ui_on':
        return _notes(0.38, const [
          [0.00, 0.12, 660, .28],
          [0.09, 0.22, 990, .30],
        ]);
      case 'case_select':
        return _notes(0.44, const [
          [0.00, 0.13, 420, .28],
          [0.08, 0.28, 840, .25],
          [0.10, 0.20, 1260, .10],
        ], noiseAmp: .035);
      case 'case_open':
        return _notes(0.58, const [
          [0.00, 0.30, 170, .32],
          [0.07, 0.22, 510, .22],
          [0.14, 0.32, 760, .16],
        ], noiseAmp: .055);
      case 'case_big':
        return _notes(1.08, const [
          [0.00, 0.75, 72, .50],
          [0.12, 0.55, 144, .20],
          [0.30, 0.65, 960, .13],
        ], noiseAmp: .075);
      case 'banker_ring':
        return _notes(1.62, const [
          [0.00, .11, 760, .25], [.13, .11, 980, .25], [.26, .11, 760, .25], [.39, .11, 980, .25],
          [.78, .11, 760, .25], [.91, .11, 980, .25], [1.04, .11, 760, .25], [1.17, .11, 980, .25],
          [0.00, .48, 190, .10], [.78, .48, 190, .10],
        ]);
      case 'deal_win':
        return _notes(1.28, const [
          [0.00, .35, 392, .20], [.12, .42, 523.25, .25], [.24, .52, 659.25, .25], [.38, .75, 783.99, .30],
        ], noiseAmp: .025);
      case 'no_deal':
        return _notes(.92, const [
          [0.00, .42, 92, .52], [.18, .34, 184, .20], [.30, .50, 138, .16],
        ], noiseAmp: .065);
      case 'final_reveal':
        return _notes(1.35, const [
          [0.00, .20, 220, .16], [.16, .25, 330, .19], [.34, .34, 440, .23], [.54, .60, 660, .26],
        ]);
      case 'jackpot':
        return _notes(2.65, const [
          [0.00, .55, 261.63, .18], [.13, .55, 329.63, .19], [.26, .55, 392, .20],
          [.39, .55, 523.25, .22], [.52, .55, 659.25, .23], [.65, .62, 783.99, .25], [.80, .82, 1046.5, .26],
          [.75, 1.40, 65, .35], [1.15, .65, 1500, .055], [1.40, .55, 1800, .050], [1.68, .50, 2200, .045],
        ], noiseAmp: .035);
      default:
        return _notes(.12, const [[0, .10, 500, .08]]);
    }
  }

  static Uint8List _makeTheme() {
    // High-energy Royal Deal game-show loop:
    // orchestral low brass + driving pulse + cinematic impacts + gold shimmer.
    const duration = 8.0;
    const bpm = 126.0;
    const beat = 60.0 / bpm;
    final n = (sampleRate * duration).round();
    final samples = List<double>.filled(n, 0);

    const chords = <List<double>>[
      [146.83, 174.61, 220.00], // Dm
      [130.81, 164.81, 196.00], // C
      [116.54, 146.83, 174.61], // Bb
      [130.81, 164.81, 220.00], // A tension
    ];

    const bassRoots = <double>[73.42, 65.41, 58.27, 55.00];

    var seed = 1971;

    for (var i = 0; i < n; i++) {
      final t = i / sampleRate;
      final section = (t / 2).floor().clamp(0, 3);
      final local2 = t % 2.0;
      final localBeat = t % beat;
      final beatIndex = (t / beat).floor();

      var v = 0.0;

      // Dark orchestral/brass bed.
      for (final f in chords[section]) {
        v += math.sin(2 * math.pi * f * t) * .042;
        v += math.sin(2 * math.pi * f * 2 * t) * .017;
        v += math.sin(2 * math.pi * f * 3 * t) * .006;
      }

      // Driving bass ostinato, stronger in the second half.
      final bass = bassRoots[section];
      final bassEnv = math.exp(-8.0 * localBeat / beat);
      final bassAmp = t < 2 ? .12 : t < 4 ? .15 : .18;
      v += math.sin(2 * math.pi * bass * localBeat) * bassAmp * bassEnv;
      v += math.sin(2 * math.pi * bass * 2 * localBeat) *
          (bassAmp * .24) *
          bassEnv;

      // Big cinematic kick every beat.
      if (localBeat < .16) {
        final x = localBeat / .16;
        final kickFreq = 84.0 - (46.0 * x);
        v += math.sin(2 * math.pi * kickFreq * localBeat) *
            .34 *
            math.exp(-11 * localBeat);
      }

      // Metallic/snare hit on beats 2 and 4.
      if (beatIndex % 2 == 1 && localBeat < .12) {
        seed = (1664525 * seed + 1013904223) & 0x7fffffff;
        final noise = (seed / 0x7fffffff) * 2 - 1;
        v += noise * .075 * math.exp(-26 * localBeat);
        v += math.sin(2 * math.pi * 210 * localBeat) *
            .055 *
            math.exp(-18 * localBeat);
      }

      // Fast royal arpeggio gives the "game show" tension.
      const arp = <double>[
        293.66, 349.23, 440.00, 523.25,
        440.00, 349.23, 523.25, 659.25,
      ];
      final stepDur = beat / 2;
      final step = (t / stepDur).floor() % arp.length;
      final stepLocal = t % stepDur;
      final arpEnv = math.exp(-10 * stepLocal / stepDur);
      final arpGain = t < 2 ? .025 : t < 4 ? .035 : .047;
      v += math.sin(2 * math.pi * arp[step] * stepLocal) *
          arpGain *
          arpEnv;

      // Gold shimmer / high strings.
      final shimmer =
          math.sin(2 * math.pi * (1174.66 + 35 * math.sin(t * 2.1)) * t);
      v += shimmer * (.010 + .006 * math.sin(math.pi * local2).abs());

      // Rising tension through each 2-second phrase.
      final phraseRise = (local2 / 2.0).clamp(0.0, 1.0);
      v += math.sin(
            2 *
                math.pi *
                (220 + 420 * phraseRise) *
                t,
          ) *
          .013 *
          phraseRise;

      // Huge impact entering the final 2 seconds.
      if (t >= 6.0) {
        final d = t - 6.0;
        if (d < .65) {
          v += math.sin(2 * math.pi * 52 * d) *
              .28 *
              math.exp(-4.5 * d);
        }
      }

      final fadeIn = (t / .10).clamp(0.0, 1.0);
      final fadeOut = ((duration - t) / .16).clamp(0.0, 1.0);
      final master = .88 * fadeIn * fadeOut;

      samples[i] = (v * master).clamp(-.96, .96).toDouble();
    }

    return _wav(samples);
  }

  static Uint8List _notes(double duration, List<List<double>> events, {double noiseAmp = 0}) {
    final n = (sampleRate * duration).round();
    final samples = List<double>.filled(n, 0);
    var seed = 1337;
    for (var i = 0; i < n; i++) {
      final t = i / sampleRate;
      var v = 0.0;
      for (final e in events) {
        final start = e[0], dur = e[1], freq = e[2], amp = e[3];
        final d = t - start;
        if (d >= 0 && d < dur) {
          final attack = (d / .012).clamp(0.0, 1.0);
          final release = ((dur - d) / math.min(.16, dur * .5)).clamp(0.0, 1.0);
          final decay = math.exp(-1.8 * d / dur);
          v += math.sin(2 * math.pi * freq * d) * amp * attack * release * decay;
        }
      }
      if (noiseAmp > 0) {
        seed = (1664525 * seed + 1013904223) & 0x7fffffff;
        final r = (seed / 0x7fffffff) * 2 - 1;
        final ne = math.exp(-8 * t / duration);
        v += r * noiseAmp * ne;
      }
      samples[i] = v.clamp(-.95, .95);
    }
    return _wav(samples);
  }

  static Uint8List _wav(List<double> samples) {
    final dataSize = samples.length * 2;
    final out = ByteData(44 + dataSize);
    void ascii(int offset, String s) {
      for (var i = 0; i < s.length; i++) out.setUint8(offset + i, s.codeUnitAt(i));
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
      out.setInt16(44 + i * 2, (samples[i].clamp(-1.0, 1.0) * 32767).round(), Endian.little);
    }
    return out.buffer.asUint8List();
  }
}
