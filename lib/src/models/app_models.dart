class ConsultationPlan {
  final String id;
  final String title;
  final String subtitle;
  final String price;
  final List<String> features;
  final String level;

  ConsultationPlan({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.features,
    required this.level,
  });
}

class ConsultationRequest {
  final String fullName;
  final String phone;
  final String email;
  final String company;
  final String sector;
  final String subject;
  final String details;
  final String planId;
  final String contactMethod;
  final bool agreed;

  ConsultationRequest({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.company,
    required this.sector,
    required this.subject,
    required this.details,
    required this.planId,
    required this.contactMethod,
    required this.agreed,
  });
}

class RequestStatusItem {
  final String code;
  final String title;
  final String subtitle;
  final String status;
  final int progress;

  RequestStatusItem({
    required this.code,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.progress,
  });
}

class StrategicBranch {
  final String title;
  final String description;
  final String icon;

  StrategicBranch({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class BrandAsset {
  final String title;
  final String subtitle;
  final String status;
  final String imagePath;

  BrandAsset({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.imagePath,
  });
}
