import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// the unique ID of the application
const String _applicationId = "my_application_id";

// the storage key for the token
const String _storageKeyMobileToken = "token";
// the storage key for current user

const String currentUserKey="currentUser";

// the URL of the Web Server
const String _urlBase = "http://10.0.2.2:3000";

// the URI to the Web Server Web API
const String _serverApi = "/api/";

// the mobile device unique identity
String _deviceIdentity = "";

final DeviceInfoPlugin _deviceInfoPlugin = new DeviceInfoPlugin();

Future<String> _getDeviceIdentity() async {
  if (_deviceIdentity == '') {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo info = await _deviceInfoPlugin.androidInfo;
        _deviceIdentity = "${info.device}-${info.id}";
      } else if (Platform.isIOS) {
        IosDeviceInfo info = await _deviceInfoPlugin.iosInfo;
        _deviceIdentity = "${info.model}-${info.identifierForVendor}";
      }
    } on PlatformException {
      _deviceIdentity = "unknown";
    }
  }

  return _deviceIdentity;
}

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Future<String> getSharedPref(String key) async {
  final SharedPreferences prefs = await _prefs;

  return prefs.getString(key) ?? '';
}

Future<bool> saveSharedPref(String value,String key) async {
  final SharedPreferences prefs = await _prefs;

  return prefs.setString(key, value);
}

Future<bool> authenticate(String name,String password) async {

  var response= await ajaxPost("auth",
         {
         "name":name,
         "password":password
         });

     if (response['body'].containsKey('token')) {
        await saveSharedPref(response['body']['token'],_storageKeyMobileToken);
      var loggedInUser=await ajaxGet("users/me");
      //TODO: Check for error
        await  saveSharedPref(json.encode(loggedInUser['data']),currentUserKey);
        return true;
     }else{
       return false;
     }
      
}
Future<bool> register(String name,String password,String fcmToken,String longtitude,String latitude) async {

  var response= await ajaxPost("users",
          {
         "name":name,
         "password":password,
         "fcmToken":fcmToken,
         "longtitude":longtitude,
         "latitude":latitude
         });

     if (response['headers'].containsKey('x-auth-token')) {
        await saveSharedPref(response['headers']['x-auth-token'],_storageKeyMobileToken);
        return true;
     }else{
       return false;
     }
      
}

Future<Map<String,dynamic>> ajaxGet(String serviceName) async {
  Map<String,dynamic> responseBody=new Map<String,dynamic>();
  try {
    var response = await http.get(_urlBase + '$_serverApi$serviceName',
        headers: {
          'x-device-id': await _getDeviceIdentity(),
          'x-auth-token': await getSharedPref(_storageKeyMobileToken),
          'x-app-id': _applicationId
        });

    if (response.statusCode == 200) {
      responseBody['data'] = json.decode(response.body);
    }
  } catch (e) {
    // An error was received
    throw new Exception("AJAX ERROR");
  }
  return responseBody;
}

Future<Map> ajaxPost(String serviceName, Map data) async {
  var res = new Map<String,dynamic>();
  try {
    var response = await http.post(_urlBase + '$_serverApi$serviceName',
        body: json.encode(data),
        headers: {
          'x-device-id': await _getDeviceIdentity(),
          'x-auth-token': await getSharedPref(_storageKeyMobileToken),
          'x-app-id': _applicationId,
          'Content-Type': 'application/json; charset=utf-8'
        });
    if (response.statusCode == 200) {
      res['body'] = json.decode(response.body);
      res['headers']=response.headers;
    }
  } catch (e) {
    // An error was received
    throw new Exception("Ajax error");
  }
    return res;
}