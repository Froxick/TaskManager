import 'package:frontend/features/user/api/user_api.dart';
import 'package:frontend/features/user/model/user_model.dart';
import 'package:frontend/shared/store/jwt_store.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final JwtStore _jwtStore;
  final UserApi _userApi = UserApi();

  UserController(this._jwtStore);

  var user = Rxn<UserModel>();
  var loading = true.obs;

  Future<void> getProfile() async {
    try {
      loading.value = true;
      final result = await _userApi.getUser();
      user.value = result;
    } catch (e) {
      print(e);
    } finally {
      loading.value = false;
    }
  }

  Future<void> logoutUser() async {
    await _userApi.logout();
    await _jwtStore.clearTokens();
    user.value = null;
  }
}
