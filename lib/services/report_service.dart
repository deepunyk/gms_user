import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gms_user/data/custom_constants.dart';
import 'package:http/http.dart' as http;

class ReportService {
  Future<bool> addReport() async {
    GetStorage box = GetStorage();

    final response = await http.post(
        "${CustomConstants.url}gms_php/addReport.php",
        body: {
          "user_id": box.read('user_id').toString(),
          "complaint_date": DateTime.now().toString(),
        });

    print(response.body);
    if (response.body == "yes") {
      await FirebaseFirestore.instance.collection("notification").add({
        "title": "${box.read('user_name')} has reported",
        "body": "Click here to get more details",
        "to": "admin"
      });
      return true;
    } else {
      return false;
    }
  }
}
