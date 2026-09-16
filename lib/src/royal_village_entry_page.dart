import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoyalVillageEntryPage extends StatefulWidget {
  const RoyalVillageEntryPage({super.key});

  @override
  State<RoyalVillageEntryPage> createState() => _RoyalVillageEntryPageState();
}

class _RoyalVillageEntryPageState extends State<RoyalVillageEntryPage> {
  late final Future<Uint8List> _imageBytes = _loadImage();

  Future<Uint8List> _loadImage() async {
    const parts = [
      'assets/image/rv_entry_part_0.bin',
      'assets/image/rv_entry_part_1.bin',
      'assets/image/rv_entry_part_2.bin',
      'assets/image/rv_entry_part_3.bin',
    ];

    final chunks = <Uint8List>[];
    var total = 0;

    for (final path in parts) {
      final data = await rootBundle.load(path);
      final bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      chunks.add(bytes);
      total += bytes.length;
    }

    final image = Uint8List(total);
    var offset = 0;
    for (final bytes in chunks) {
      image.setRange(offset, offset + bytes.length, bytes);
      offset += bytes.length;
    }
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: FutureBuilder<Uint8List>(
          future: _imageBytes,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox.expand(
                child: ColoredBox(color: Colors.black),
              );
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Image.memory(
                snapshot.data!,
                width: double.infinity,
                fit: BoxFit.fitWidth,
                filterQuality: FilterQuality.high,
                gaplessPlayback: true,
              ),
            );
          },
        ),
      ),
    );
  }
}
