import 'package:flutter/services.dart';

class Channels {

  static const platform = MethodChannel("com.iot.basic.channel");

  static Future<void> getVerifactionCode(Map<String, dynamic> data) async{

    try{
      final result = await platform.invokeMethod('getVerificationCode', data);
      print(result);
    } on PlatformException catch(e){
      print({"error": "Failed to get data from native code: '${e.message}'."});
    }
  }
  static Future<void> signupWithVerificationCode(Map<String, dynamic> data) async {

    try {
      final result = await platform.invokeMethod('signupWithVerificationCode', data);
      print(result);
    } on PlatformException catch (e) {
      print({"error": "Failed to get data from native code: '${e.message}'."});
    }
  }
}