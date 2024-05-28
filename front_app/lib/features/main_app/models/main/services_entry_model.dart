import 'services_model.dart';

class ServiceEntries {
  final List<Service> _serviceEntries = [
    const Service(
      providerName: 'John Doe',
      title: 'Spa for dogs and cats',
      description:
          'Provides a relaxing and pampering spa experience for dogs and cats.',
      image: 'https://source.unsplash.com/random/200x128',
      category: ServiceCategory.animalCare,
      price: 49.99,
      rating: 9.12,
      paymentType: PaymentType.perJobCompletion,
      location: 'Venice, Italy',
      duration: 60,
    ),
    const Service(
      providerName: 'Jane Doe',
      title: 'Japanese tutoring',
      description:
          'Learn the basics of Japanese conversation and communication.',
      image: 'https://source.unsplash.com/random/200x128',
      category: ServiceCategory.privateTuition,
      price: 22.99,
      rating: 8.91,
      paymentType: PaymentType.perHour,
      location: 'Tokyo, Japan',
      duration: 60,
    ),
    const Service(
      providerName: 'Jim Doe',
      title: 'Trimming your lawn',
      description:
          'Cutting your lawn is a great way to get rid of the weeds and keep your lawn looking fresh.',
      image: 'https://source.unsplash.com/random/200x128',
      category: ServiceCategory.gardening,
      price: 12.59,
      rating: 8.4,
      paymentType: PaymentType.perHour,
      location: 'Hedland, Sweden',
      duration: 30,
    ),
    const Service(
      providerName: 'Jill Doe',
      title: 'Plumbing',
      description:
          'We are a plumbing service that will help you to fix any plumbing issues.',
      image: 'https://source.unsplash.com/random/200x128',
      category: ServiceCategory.housework,
      price: 149.99,
      rating: 7.9,
      paymentType: PaymentType.perJobCompletion,
      location: 'New York, USA',
      duration: 60,
    ),
    const Service(
      providerName: 'Jimmy Doe',
      title: 'Flutter development',
      description: 'We develop your flutter application as a challenge',
      image: 'https://source.unsplash.com/random/200x128',
      category: ServiceCategory.computers,
      price: 99.00,
      rating: 7.8,
      paymentType: PaymentType.perJobCompletion,
      location: 'Paris, France',
      duration: 60,
    ),
  ];

  List<Service> get serviceEntries => _serviceEntries;
}
