import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  // Rapid Host Endpoint
  static String host = dotenv.get("API_HOST");

  // Server Secrate Token
  static String googleApiMaps = dotenv.get("GOOGLE_API_MAPS");
  static String stripePublicKey = dotenv.get("STRIPE_PUBLIC_KEY");
  static String currency = "XOF";
}
