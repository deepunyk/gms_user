import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gms_user/services/auth_service.dart';
import 'package:gms_user/widgets/custom_loading_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String verificationId = "";
  String phoneNumber = "";
  GetStorage box = GetStorage();
  bool isLoad = false;

  Widget pincodeField(BuildContext context) {
    return PinCodeTextField(
      pinTheme: PinTheme.defaults(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          activeColor: Theme.of(context).primaryColor,
          selectedColor: Theme.of(context).primaryColor,
          inactiveColor: Colors.black12),
      appContext: context,
      length: 6,
      obscureText: false,
      autoFocus: true,
      animationType: AnimationType.fade,
      keyboardType: TextInputType.number,
      animationDuration: Duration(milliseconds: 300),
      onChanged: (val) {},
      onCompleted: (val) {
        submitOtp(val);
      },
    );
  }

  Future<void> submitOtp(String otp) async {
    isLoad = true;
    setState(() {});
    final _phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);
    FirebaseAuth.instance
        .signInWithCredential(_phoneAuthCredential)
        .then((user) async {
      AuthService authService = AuthService();
      bool response = await authService.userSignIn(phoneNumber);
      if (response) {
        isLoad = false;
        setState(() {});
        //Get.offAll(HomeScreen());
      } else {
        isLoad = false;
        setState(() {});
        //Get.to(NameScreen(), arguments: phoneNumber);
      }
    }).catchError((error) {
      print("${error.hashCode}");
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: new Text("Incorrect OTP, please try again")));
      isLoad = false;
      setState(() {});
    });
  }

  Future<void> resendOTP() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 15),
      verificationCompleted: (AuthCredential authCredential) {
        //print("Your account is successfully verified");
      },
      verificationFailed: (FirebaseAuthException authException) {
        _scaffoldKey.currentState.showSnackBar(
            new SnackBar(content: new Text("Oops! Something went wrong")));
      },
      codeSent: (String verId, [int forceCodeResent]) {
        verificationId = verId;
      },
      codeAutoRetrievalTimeout: (String verId) {
        print("TIMEOUT");
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List response = ModalRoute.of(context).settings.arguments;

    verificationId = response[0];
    phoneNumber = response[1];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: Text(
          "OTP",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: isLoad
          ? CustomLoading()
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Please enter the OTP",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: pincodeField(context),
                  ),
                  FlatButton(
                    child: Text(
                      "Resend OTP",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    onPressed: () {
                      resendOTP();
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
