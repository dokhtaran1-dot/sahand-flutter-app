import 'package:flutter/foundation.dart';

class ReservationRecord {
  final String salonName;
  final String customerName;
  final String phone;
  final String date;
  final String time;
  final int guests;
  final String design;
  final String cake;
  final String note;

  ReservationRecord({
    required this.salonName,
    required this.customerName,
    required this.phone,
    required this.date,
    required this.time,
    required this.guests,
    required this.design,
    required this.cake,
    required this.note,
  });
}

class ReservationStore {
  ReservationStore._();

  static final ReservationStore instance = ReservationStore._();

  final ValueNotifier<List<ReservationRecord>> reservations =
      ValueNotifier<List<ReservationRecord>>([]);

  void add(ReservationRecord reservation) {
    reservations.value = [
      reservation,
      ...reservations.value,
    ];
  }

  void removeAt(int index) {
    final list = List<ReservationRecord>.from(reservations.value);
    list.removeAt(index);
    reservations.value = list;
  }

  void clear() {
    reservations.value = [];
  }
}
