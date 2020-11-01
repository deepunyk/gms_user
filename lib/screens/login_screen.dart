import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gms_user/screens/home_screen.dart';
import 'package:gms_user/screens/otp_screen.dart';
import 'package:gms_user/screens/register_screen.dart';
import 'package:gms_user/services/auth_service.dart';
import 'package:gms_user/widgets/custom_auth_button.dart';
import 'package:gms_user/widgets/custom_loading_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoad = false;

  Future<void> loginPhone() async {
    Get.focusScope.unfocus();
    if (controller.text.length == 10) {
      isLoad = true;
      setState(() {});
      String phoneNumber = "+91" + controller.text;

      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 15),
          verificationCompleted: (AuthCredential authCredential) {
            print("Your account is successfully verified");
          },
          verificationFailed: (FirebaseAuthException authException) {
            print("${authException.code} ${authException.message}");
            isLoad = false;
            setState(() {});
            _scaffoldKey.currentState.showSnackBar(
                new SnackBar(content: new Text("Oops! Something went wrong")));
          },
          codeSent: (String verId, [int forceCodeResent]) {
            print("code send");
            isLoad = false;
            setState(() {});
            //Get.to(OTPScreen(), arguments: [verId, phoneNumber]);
          },
          codeAutoRetrievalTimeout: (String verId) {
            isLoad = false;
            setState(() {});
            print("TIMEOUT");
          },
        );
      } catch (e) {
        print(e.toString());
      }
    } else {
      isLoad = false;
      setState(() {});
      Get.rawSnackbar(message: "Invalid phone number");
    }
  }

  testLoginPhone() async {
    String phone = "+91" + controller.text;
    AuthService authService = AuthService();
    final response = await authService.userSignIn(phone);
    response
        ? Get.offAll(HomeScreen())
        : Get.offAll(RegisterScreen(), arguments: phone);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      body: isLoad
          ? CustomLoading()
          : Container(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.08),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "GMS Udupi",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Phone Number",
                        hintText: "Enter your phone number here",
                      ),
                      onSubmitted: (val) {
                        testLoginPhone();
                      },
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                  CustomAuthButton(
                    onTap: () {
                      testLoginPhone();
                    },
                    title: "Login",
                  ),
                ],
              ),
            ),
    );
  }
}
