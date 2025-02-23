import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static String get baseUrl => dotenv.env['API_BASE_URL']!;
  static String get LivekitApiUrl => dotenv.env['LIVEKIT_API_URL']!;
  static String get localDB => dotenv.env['LOCAL_DB_NAME'] ?? 'localDataStore';
  static String get livekitUrl => dotenv.env['LIVEKIT_URL']!;
}
