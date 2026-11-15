import 'package:supabase_flutter/supabase_flutter.dart';

import 'reservation_store.dart';

/// Owner-only, verified-phone booking request intake.
/// A successful insert means "sent for management review", never confirmed.
class RvOnlineBookingService {
  RvOnlineBookingService._();

  static const _url = String.fromEnvironment('SUPABASE_URL');
  static const _key = String.fromEnvironment('SUPABASE_ANON_KEY');
  static bool get configured => _url.isNotEmpty && _key.isNotEmpty;

  static SupabaseClient get _db {
    if (!configured) throw StateError('RV_ONLINE_NOT_CONFIGURED');
    return Supabase.instance.client;
  }

  static String normalizePhone(String phone) {
    var s = phone.trim().replaceAll(RegExp(r'[^0-9+]'), '');
    if (s.startsWith('00')) s = '+${s.substring(2)}';
    if (s.startsWith('09')) s = '+98${s.substring(1)}';
    if (s.startsWith('98') && !s.startsWith('+')) s = '+$s';
    return s;
  }

  static bool get isVerified {
    if (!configured) return false;
    final auth = _db.auth;
    final phone = normalizePhone(auth.currentUser?.phone ?? '');
    return auth.currentSession != null &&
        RegExp(r'^\\+[0-9]{7,15}$').hasMatch(phone);
  }

  static String _date(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  static String _clock(int hour, int minute) =>
      '${hour.toString().padLeft(2, '0')}:'
      '${minute.toString().padLeft(2, '0')}:00';

  static Future<String> submit(
    ReservationRecord request, {
    required DateTime date,
    required int hour,
    required int minute,
  }) async {
    if (!isVerified) throw StateError('RV_PHONE_VERIFICATION_REQUIRED');

    final user = _db.auth.currentUser!;
    final verifiedPhone = normalizePhone(user.phone ?? '');
    if (normalizePhone(request.phone) != verifiedPhone) {
      throw StateError('RV_PHONE_DOES_NOT_MATCH_VERIFIED_ACCOUNT');
    }
    if (hour < 7 || hour > 23 || minute < 0 || minute > 59) {
      throw const FormatException('رزرو از ۷ صبح تا ۱۲ شب انجام می‌شود.');
    }
    if (request.guests < 1 || request.guests > 30) {
      throw const FormatException('تعداد مهمان باید بین ۱ تا ۳۰ نفر باشد.');
    }
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final today = DateTime.now();
    if (normalizedDate.isBefore(DateTime(today.year, today.month, today.day)) ||
        normalizedDate.isAfter(today.add(const Duration(days: 365)))) {
      throw const FormatException('تاریخ انتخاب‌شده معتبر نیست.');
    }
    if (request.customerName.trim().length < 3 ||
        request.customerName.trim().length > 120 ||
        request.note.length > 1000) {
      throw const FormatException('نام یا توضیحات درخواست معتبر نیست.');
    }

    final created = await _db.from('rv_reservation_requests').insert({
      'requester_id': user.id,
      'salon_name': request.salonName,
      'customer_name': request.customerName.trim(),
      'phone': verifiedPhone,
      'reservation_date': _date(date),
      'reservation_time': _clock(hour, minute),
      'guest_count': request.guests,
      'design': request.design,
      'cake': request.cake,
      'music': request.music,
      'note': request.note,
    }).select('id').single();
    return created['id'] as String;
  }

  static Future<List<RvOnlineReservationStatus>> myRequests() async {
    if (!isVerified) return const [];
    final rows = await _db.from('rv_reservation_requests')
        .select('id,salon_name,reservation_date,reservation_time,'
            'guest_count,status,created_at,management_note')
        .order('created_at', ascending: false).limit(50);
    return [
      for (final row in rows)
        RvOnlineReservationStatus(
          id: row['id'].toString(),
          salon: row['salon_name'].toString(),
          date: row['reservation_date'].toString(),
          time: row['reservation_time'].toString(),
          guests: row['guest_count'] as int,
          status: row['status'].toString(),
          managementNote: row['management_note']?.toString(),
        ),
    ];
  }
}

class RvOnlineReservationStatus {
  const RvOnlineReservationStatus({
    required this.id,
    required this.salon,
    required this.date,
    required this.time,
    required this.guests,
    required this.status,
    this.managementNote,
  });
  final String id, salon, date, time, status;
  final int guests;
  final String? managementNote;

  String get statusFa => switch (status) {
    'confirmed' => 'تأییدشده توسط مدیریت',
    'declined' => 'عدم تأیید مدیریت',
    'cancelled' => 'لغوشده',
    _ => 'در انتظار بررسی مدیریت',
  };
}
