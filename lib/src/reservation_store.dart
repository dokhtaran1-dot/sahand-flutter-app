import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationRecord {
  final String salonName;
  final String customerName;
  final String phone;
  final String date;
  final String time;
  final int guests;
  final String design;
  final String cake;
  final String music;
  final String note;
  /// Non-null only after the server accepted this request for management review.
  final String? onlineId;

  ReservationRecord({
    required this.salonName,
    required this.customerName,
    required this.phone,
    required this.date,
    required this.time,
    required this.guests,
    required this.design,
    required this.cake,
    this.music = '',
    required this.note,
    this.onlineId,
  });

  Map<String, dynamic> toMap() {
    return {
      'salonName': salonName,
      'customerName': customerName,
      'phone': phone,
      'date': date,
      'time': time,
      'guests': guests,
      'design': design,
      'cake': cake,
      'music': music,
      'note': note,
      'onlineId': onlineId,
    };
  }

  factory ReservationRecord.fromMap(Map<String, dynamic> map) {
    return ReservationRecord(
      salonName: map['salonName'] ?? '',
      customerName: map['customerName'] ?? '',
      phone: map['phone'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      guests: map['guests'] ?? 1,
      design: map['design'] ?? '',
      cake: map['cake'] ?? '',
      music: map['music'] ?? '',
      note: map['note'] ?? '',
      onlineId: map['onlineId'] as String?,
    );
  }
}

class ReservationStore {
  ReservationStore._() {
    _ready = _load();
  }

  late final Future<void> _ready;

  static final ReservationStore instance = ReservationStore._();

  static const String _storageKey = 'royal_village_reservations';

  final ValueNotifier<List<ReservationRecord>> reservations =
      ValueNotifier<List<ReservationRecord>>([]);

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();

    final raw = prefs.getString(_storageKey);

    if (raw == null || raw.isEmpty) {
      return;
    }

    try {
      final List<dynamic> decoded = jsonDecode(raw);

      reservations.value = decoded
          .map(
            (item) => ReservationRecord.fromMap(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    } catch (_) {
      reservations.value = [];
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();

    final data = reservations.value
        .map((item) => item.toMap())
        .toList();

    await prefs.setString(
      _storageKey,
      jsonEncode(data),
    );
  }

  Future<void> add(ReservationRecord reservation) async {
    await _ready;
    reservations.value = [
      reservation,
      ...reservations.value,
    ];

    await _save();
  }

  Future<void> removeAt(int index) async {
    await _ready;
    final list =
        List<ReservationRecord>.from(reservations.value);

    if (index < 0 || index >= list.length) {
      return;
    }

    list.removeAt(index);
    reservations.value = list;

    await _save();
  }

  Future<void> clear() async {
    await _ready;
    reservations.value = [];

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
