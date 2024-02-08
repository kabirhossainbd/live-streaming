import 'package:get/get.dart';
import 'package:live_streaming/model/repo/splash_repo.dart';

class SplashController extends GetxController implements GetxService {
  final SplashRepo splashRepo;
  SplashController({required this.splashRepo});

  Future<bool> initSharedData() {
    return splashRepo.initSharedData();
  }
  Future<bool> removeSharedData() {
    return splashRepo.removeSharedData();
  }
}
