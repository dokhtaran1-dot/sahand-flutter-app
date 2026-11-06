import 'package:supabase_flutter/supabase_flutter.dart';

/// Only a verified server record is proof of membership.
/// Device preferences cannot authorize membership, wallet or prizes.
class RoyalClubMember {
  const RoyalClubMember({
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.memberCode,
    this.displayName,
    this.avatarPath,
    this.createdAt,
  });

  final String userId;
  final String fullName;
  final String phone;
  final String memberCode;
  final String? displayName;
  final String? avatarPath;
  final DateTime? createdAt;

  String get membershipCode => memberCode;

  factory RoyalClubMember.fromJson(Map<String, dynamic> data) {
    return RoyalClubMember(
      userId: data['user_id'] as String,
      fullName: data['full_name'] as String,
      phone: data['phone'] as String,
      memberCode: data['member_code'] as String,
      displayName: data['display_name'] as String?,
      avatarPath: data['avatar_path'] as String?,
      createdAt: DateTime.tryParse((data['created_at'] ?? '').toString()),
    );
  }
}

class RoyalClubMemberService {
  RoyalClubMemberService._();

  static SupabaseClient get client => Supabase.instance.client;
  static User? get currentUser => client.auth.currentUser;

  static Future<RoyalClubMember?> loadCurrent() async {
    final user = currentUser;
    if (user == null) return null;
    final result = await client
        .from('royal_club_members')
        .select('user_id,full_name,phone,member_code,display_name,created_at,avatar_path')
        .eq('user_id', user.id)
        .maybeSingle();
    if (result == null) return null;
    return RoyalClubMember.fromJson(result);
  }

  static Future<RoyalClubMember> saveVerifiedMember(String fullName, {String? displayName}) async {
    final user = currentUser;
    final number = user?.phone;
    if (user == null || number == null ||
        !RegExp(r'^\+989[0-9]{9}$').hasMatch(number)) {
      throw const FormatException('شماره همراه هنوز تأیید نشده است.');
    }
    final trimmed = fullName.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (trimmed.length < 3 || trimmed.length > 120) {
      throw const FormatException('نام و نام خانوادگی باید بین ۳ تا ۱۲۰ حرف باشد.');
    }
    final alias = displayName?.trim();
    if (alias != null && alias.isNotEmpty &&
        (alias.length < 2 || alias.length > 30)) {
      throw const FormatException('نام نمایشی باید بین ۲ تا ۳۰ کاراکتر باشد.');
    }
    final saved = await client.from('royal_club_members').upsert({
      'user_id': user.id,
      'full_name': trimmed,
      'display_name': alias == null || alias.isEmpty ? null : alias,
      'phone': number,
      'accepted_terms_at': DateTime.now().toUtc().toIso8601String(),
    }, onConflict: 'user_id').select(
      'user_id,full_name,phone,member_code,display_name,created_at,avatar_path',
    ).single();
    return RoyalClubMember.fromJson(saved);
  }

  static String normalizeIranMobile(String raw) {
    const persian = '۰۱۲۳۴۵۶۷۸۹';
    const arabic = '٠١٢٣٤٥٦٧٨٩';
    var converted = '';
    for (final c in raw.trim().split('')) {
      final p = persian.indexOf(c);
      final a = arabic.indexOf(c);
      converted += p >= 0 ? p.toString() : (a >= 0 ? a.toString() : c);
    }
    var normalized = converted.replaceAll(RegExp(r'[\s\-()]'), '');
    if (normalized.startsWith('0098')) normalized = '+98'+normalized.substring(4);
    if (normalized.startsWith('09')) normalized = '+98'+normalized.substring(1);
    if (normalized.startsWith('989')) normalized = '+'+normalized;
    return normalized;
  }

  static bool validIranMobile(String value) =>
      RegExp(r'^\+989[0-9]{9}$').hasMatch(normalizeIranMobile(value));

  static Future<void> signOut() async => client.auth.signOut();
}
