import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gms_core/services/auth_service.dart';
import 'package:gms_user/screens/home_screen.dart';
import 'package:gms_user/screens/location_picker_screen.dart';
import 'package:gms_user/widgets/custom_auth_button.dart';
import 'package:gms_user/widgets/custom_loading_button.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String latitude = "0", longitude = "0";
  String phone = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController houseController = TextEditingController();
  bool isLoad = false;

  addUser() async {
    if (latitude == "0" ||
        longitude == "0" ||
        nameController.text.length < 3 ||
        houseController.text.length < 3) {
      Get.rawSnackbar(message: 'Please enter all the details');
    } else {
      isLoad = true;
      setState(() {});
      AuthService authService = AuthService();
      final response = await authService.userRegister(nameController.text,
          latitude, longitude, houseController.text, phone);
      isLoad = false;
      setState(() {});
      if (response == "yes") {
        Get.offAll(HomeScreen());
      } else if (response == "no") {
        Get.rawSnackbar(message: "Oops! Something went wrong");
      }
    }
  }

  updateLocation(String lat, String lon) {
    latitude = lat;
    longitude = lon;
    setState(() {});
  }

  Widget locationWidget(String label, IconData icon, int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Get.focusScope.unfocus();
              Get.to(LocationPickerScreen(), arguments: updateLocation);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: [
                  Icon(icon),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    latitude == "0"
                        ? label
                        : "${latitude.substring(0, 9)} ${longitude.substring(0, 9)}",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    phone = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: isLoad
          ? CustomLoading()
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.08,
                    ),
                    Text(
                      "Enter your details to continue",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.04,
                    ),
                    Container(
                      child: TextField(
                        decoration: InputDecoration(labelText: "Full Name"),
                        textCapitalization: TextCapitalization.words,
                        controller: nameController,
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    Container(
                      child: TextField(
                        decoration:
                            InputDecoration(labelText: "Flat/House Name"),
                        controller: houseController,
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    Text(
                      "Add Location",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    locationWidget("Add Location", Icons.location_pin, 1),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    CustomAuthButton(
                      title: "Continue",
                      onTap: () {
                        Get.focusScope.unfocus();

                        addUser();
                      },
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
