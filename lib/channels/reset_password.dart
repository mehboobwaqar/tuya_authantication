
import 'package:flutter/services.dart';
import 'package:iot_basic/channels/signup_channel.dart';

Future<String> resetPasswordEmail(Map<String, dynamic> data) async {

  try{
    final result = await platform.invokeMethod('resetPasswordEmail', data);
    return result.toString();
  } on PlatformException catch (e) {
    return "Error: ${e.message}";
  }

}