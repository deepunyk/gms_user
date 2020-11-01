import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ReportService {
  Future<bool> addReport() async {
    GetStorage box = GetStorage();

    final response = await http.post(
        "https://xtoinfinity.tech/GCUdupi/user/gms_php/addReport.php",
        body: {
          "user_id": box.read('user_id').toString(),
          "complaint_date": DateTime.now().toString(),
        });

    print(response.body);
    if (response.body == "yes") {
      return true;
    } else {
      return false;
    }
  }
}
