import 'package:flutter/services.dart';
import 'package:iot_basic/channels/signup_channel.dart';

Future<String> loginChannel(Map<String, dynamic> data) async {
  try {
    final result = await platform.invokeMethod('userLogin', data);
    return result;
  } on PlatformException catch (e) {
    return e.message ?? "Login failed";
  }
}
