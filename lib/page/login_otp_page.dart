import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taro_talk/app_config.dart';

class LoginOTPPage extends StatefulWidget {
  static final route = "/login/otp";

  @override
  _LoginOTPPageState createState() => _LoginOTPPageState();
}

class _LoginOTPPageState extends State<LoginOTPPage> {
  final _getOTPForm = GlobalKey<FormState>();
  final _verifyForm = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _otpController = TextEditingController();
  final _mobileNode = FocusNode();
  final _otpNode = FocusNode();

  String _verificationId;
  bool _isMobileLoading = false;
  bool _isVerifyLoading = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.primaryColor,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 120,
                ),
                Image.asset(
                  AppConfig.logoIcon,
                  height: 200,
                ),
                SizedBox(
                  height: 16,
                ),
                _isMobileLoading
                    ? SizedBox(
                        height: 56,
                        width: 56,
                        child: CircularProgressIndicator(),
                      )
                    : Form(
                        key: _getOTPForm,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "เบอร์โทรศัพท์",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: _mobileController,
                              focusNode: _mobileNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: "กรอกเบอร์โทรศัพท์",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                fillColor: Colors.white.withAlpha(120),
                              ),
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                              validator: (text) {
                                if (text.isEmpty) {
                                  return "กรุณากรอกเบอร์โทรศัพท์";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            RaisedButton(
                              onPressed: () async {
                                if (_getOTPForm.currentState.validate()) {
                                  _requestOTP();
                                }
                              },
                              color: Colors.black.withAlpha(7),
                              child: Text(
                                "ส่ง OTP",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                SizedBox(
                  height: 24,
                ),
                _isVerifyLoading
                    ? SizedBox(
                        height: 56,
                        width: 56,
                        child: CircularProgressIndicator(),
                      )
                    : Form(
                        key: _verifyForm,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "ยืนยัน OTP",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: _otpController,
                              focusNode: _otpNode,
                              autofocus: false,
                              decoration: InputDecoration(
                                hintText: "กรอก OTP ที่ได้จาก SMS",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                fillColor: Colors.white.withAlpha(120),
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            RaisedButton(
                              onPressed: () async {
                                if (_verifyForm.currentState.validate()) {
                                  _verifyOTP();
                                }
                              },
                              color: Colors.black.withAlpha(7),
                              child: Text(
                                "ส่ง OTP",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _requestOTP() async {
    setState(() {
      _isMobileLoading = true;
    });
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: "+66" + _mobileController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int resendToken) {
          setState(() {
            _verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print("Request OTP error ${e.toString()}");
    } finally {
      setState(() {
        _isMobileLoading = false;
      });
    }
  }

  _verifyOTP() async {
    setState(() {
      _isVerifyLoading = true;
    });
    try {
      final user = await auth.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: _otpController.text,
        ),
      );
      print("Verity OTP success : ${user.toString()}");
    } catch (e) {
      print("Verify OTP error ${e.toString()}");
    } finally {
      setState(() {
        _isVerifyLoading = false;
      });
    }
  }
}
