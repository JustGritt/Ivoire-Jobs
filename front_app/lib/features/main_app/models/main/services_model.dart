enum ServiceCategory {
  homeHelp,
  gardening,
  housework,
  childCare,
  computers,
  animalCare,
  privateTuition,
  relocationAssistance,
  other,
}

extension ServiceCategoryExtension on ServiceCategory {
  String get label {
    switch (this) {
      case ServiceCategory.homeHelp:
        return 'Home Help';
      case ServiceCategory.gardening:
        return 'Gardening';
      case ServiceCategory.housework:
        return 'Housework';
      case ServiceCategory.childCare:
        return 'Child Care';
      case ServiceCategory.computers:
        return 'Computers';
      case ServiceCategory.animalCare:
        return 'Animal Care';
      case ServiceCategory.privateTuition:
        return 'Private Tuition';
      case ServiceCategory.relocationAssistance:
        return 'Relocation Assistance';
      case ServiceCategory.other:
        return 'Other';
      default:
        return '';
    }
  }
}

enum PaymentType {
  perHour,
  perJobCompletion,
}

class Service {
  final String providerName;
  final String title;
  final String description;
  final String image;
  final ServiceCategory category;
  final double price;
  final double rating;
  final PaymentType paymentType;
  final String location;
  final int duration;

  const Service({
    required this.providerName,
    required this.title,
    required this.description,
    required this.image,
    required this.category,
    required this.price,
    required this.rating,
    required this.paymentType,
    required this.location,
    required this.duration,
  });
}

