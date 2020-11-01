import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gms_user/models/ward.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_utils/google_maps_utils.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<bool> userSignIn(String phoneNumber) async {
    phoneNumber = phoneNumber.substring(3);
    final response = await http.post(
      "https://xtoinfinity.tech/GCUdupi/user/gms_php/signIn.php",
      body: {
        "phone": phoneNumber,
      },
    );

    print(response.body);
    if (response.body == 'no') {
      return false;
    } else {
      final jsonResponse = json.decode(response.body);
      GetStorage box = GetStorage();
      box.write("user_id", jsonResponse['user_id']);
      box.write("ward_id", jsonResponse['ward_id']);
      box.write("phone", jsonResponse['phone']);
      box.write("latitude", jsonResponse['latitude']);
      box.write("longitude", jsonResponse['longitude']);
      box.write("user_name", jsonResponse['user_name']);
      box.write("house_name", jsonResponse['house_name']);
      final fbm = FirebaseMessaging();
      fbm.requestNotificationPermissions();
      fbm.subscribeToTopic('${box.read("ward_id")}');
      return true;
    }
  }

  Future<String> userRegister(String userName, String lat, String lon,
      String houseName, String phone) async {
    String tempPhone = phone.substring(3);

    List<Ward> wards = [];
    String wardId = "";

    final wardResponse = await http
        .get("https://xtoinfinity.tech/GCUdupi/user/gms_php/getWards.php");
    final jsonResponse = json.decode(wardResponse.body);
    final allData = jsonResponse['data'];

    allData.map((e) => wards.add(Ward.fromJson(e))).toList();
    String result = checkUserWard(double.parse(lat), double.parse(lon), wards);

    if (result == "") {
      Get.rawSnackbar(message: "No ward found with these coordinates");
      return "no ward";
    } else {
      wardId = result;
    }

    final response = await http.post(
        "https://xtoinfinity.tech/GCUdupi/user/gms_php/signUp.php",
        body: {
          "phone": tempPhone,
          "wardId": wardId,
          "latitude": lat,
          "longitude": lon,
          "userName": userName,
          "houseName": houseName,
        });

    if (response.body == "yes") {
      if (await userSignIn(phone)) {
        return "yes";
      } else {
        return "no";
      }
    } else {
      return "no";
    }
  }

  String checkUserWard(double lat, double lon, List<Ward> wards) {
    String wardId = "";
    wards.map((ward) {
      List<Point> pointPolygon = ward.latitude.map((lat) {
        return Point(double.parse(lat),
            double.parse(ward.longitude[ward.latitude.indexOf(lat)]));
      }).toList();
      if (PolyUtils.containsLocationPoly(Point(lat, lon), pointPolygon)) {
        wardId = ward.wardId;
      }
    }).toList();
    return wardId;
  }
}
