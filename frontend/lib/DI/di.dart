import 'package:frontend/shared/store/jwt_store.dart';
import 'package:get/get.dart';

class DI {
  static Future<void> init() async {
    final jwtStore = JwtStore();

    Get.put<JwtStore>(jwtStore, permanent: true);
  }
}
