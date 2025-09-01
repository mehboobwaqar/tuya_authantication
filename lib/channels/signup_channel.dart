import 'package:flutter/services.dart';


const platform = MethodChannel("com.iot.basic.channel");

  Future<String> getVerificationCode(Map<String, dynamic> data) async {
    try {
      final result = await platform.invokeMethod('getVerificationCode', data);
      return result.toString();
    } on PlatformException catch (e) {
      return "Error: ${e.message}";
    } catch (e) {
      return "Unexpected error: $e";
    }
  }


  Future<String> signupWithVerificationCode(
      Map<String, dynamic> data) async {
    try {
      final result =
          await platform.invokeMethod('signupWithVerificationCode', data);
      return result.toString();
    } on PlatformException catch (e) {
      return "Error: ${e.message}";
    } catch (e) {
      return "Unexpected error: $e";
    }
  }

