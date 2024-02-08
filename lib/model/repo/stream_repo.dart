
import 'package:get/get.dart';

import '../../src/data/datasource/remote/http_client.dart';

class StreamRepo extends GetxController  implements GetxService{
  final ApiClient apiClient;
  StreamRepo({required this.apiClient});

}