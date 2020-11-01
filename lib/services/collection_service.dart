import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:gms_user/models/collection.dart';
import 'package:http/http.dart' as http;

class CollectionService {
  Future<List<Collection>> getCollections() async {
    List<Collection> collections = [];

    GetStorage box = GetStorage();
    print("${box.read("ward_id")}");
    final response = await http.post(
        "https://xtoinfinity.tech/GCUdupi/user/gms_php/getCollections.php",
        body: {"ward_id": box.read('ward_id')});
    final jsonResponse = json.decode(response.body);
    final allData = jsonResponse['data'];
    allData.map((e) => collections.add(Collection.fromJson(e))).toList();
    return collections.reversed.toList();
  }
}
