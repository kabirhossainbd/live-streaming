import 'package:get/get.dart';
import 'package:live_streaming/controller/signal_controller.dart';
import 'package:live_streaming/model/repo/auth_repo.dart';
import 'package:live_streaming/model/response/body/response_model.dart';
import 'package:live_streaming/src/utils/constants/m_helper.dart';

class AuthController extends GetxController  implements GetxService {
  final AuthRepo authRepo;
  final SignalRController signalController;
  AuthController({required this.authRepo, required this.signalController});

  Future<ResponseModel> login(String studentId, String name) async {
    showLoading();
    update();
    Response response = await authRepo.login(studentId: studentId, name: name);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      Map map = response.body;
      String token = map["access_token"];
      authRepo.saveUserToken(token);
      // saveUserId(map["user"]['id']);
      // saveUserName(map["user"]['id']);
      responseModel = ResponseModel(true, response.body["message"].toString());
      update();
    } else {
      responseModel = ResponseModel(false, response.body["message"].toString());
    }
    hideLoading();
    update();
    return responseModel;
  }

  int getUserId() {
    return authRepo.getUserId();
  }

  void saveUserId(int id) {
    authRepo.saveUserId(id);
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }


  void saveUserName(String name) {
    authRepo.saveFullName(name);
  }
  String getName() {
    return authRepo.getFullName();
  }
}
