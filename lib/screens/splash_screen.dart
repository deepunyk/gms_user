import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gms_user/screens/home_screen.dart';
import 'package:gms_user/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool check = false;

  checkLogin() {
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(onMessage: (msg) {
      print(msg);
      return;
    }, onLaunch: (msg) {
      print(msg);
      return;
    }, onResume: (msg) {
      print(msg);
      return;
    });
    fbm.subscribeToTopic('alerts');
    GetStorage box = GetStorage();
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (box.hasData("user_id")) {
        fbm.subscribeToTopic('${box.read("ward_id")}');
        Get.offAll(HomeScreen());
      } else {
        Get.offAll(LoginScreen());
      }
    });
  }

  _showDialog() {
    Get.dialog(AlertDialog(
      title: Text("No internet connection"),
      content: Text("Please switch on your internet connection to proceed."),
      actions: [
        FlatButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: Text("Quit")),
        FlatButton(
            onPressed: () {
              Get.close(1);

              Future.delayed(const Duration(milliseconds: 1000), () {
                checkConnection();
              });
            },
            child: Text("Okay")),
      ],
    ));
  }

  checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      checkLogin();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      checkLogin();
    } else {
      _showDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!check) {
      check = true;
      checkConnection();
    }
    return Scaffold(
      body: Container(
        color: Get.theme.primaryColor.withOpacity(0.05),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  width: 125,
                  height: 125,
                  child: ClipOval(
                    child: Image.asset(
                      "assets/images/logo.png",
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AutoSizeText(
                    "GMS Udupi",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpinKitChasingDots(
                    color: Get.theme.primaryColor,
                    size: 30,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Please wait"),
                  SizedBox(
                    height: Get.height * 0.08,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
