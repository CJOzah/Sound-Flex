// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../datasource/repository/api_status.dart';
import '../utils/strings.dart';

class AuthProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  Future<void> clearData() async {}

  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }

  Future<Map<String, dynamic>> postRequest(var sendOtp, String urlName) async {
    Future<Map<String, dynamic>> result;

    debugPrint('payload $sendOtp urlName $urlName');
    setLoading(true);
    notifyListeners();

    try {
      Response response = await post(
        Uri.parse(urlName),
        body: json.encode(sendOtp),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': (authUser.data == null)
          //     ? ''
          //     : 'Bearer ${authUser.data!.accessToken}',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setLoading(false);
        notifyListeners();
        final Map<String, dynamic> responseData = json.decode(response.body);
        String splitRequest = urlName.split('/').last;
        debugPrint('urlName $urlName ${urlName.split('/').last}');
        debugPrint(
            "payload response ${response.body} status Code: ${response.statusCode}");
        switch (splitRequest) {
          case 'login':
            return result =
                success(true, 'Login Successful', data: responseData);
          default:
            debugPrint("Success: ${json.decode(response.body)}");
            return result = success(true, responseData["message"],
                data: responseData["message"]);
        }
      }

      if (response.statusCode == null) {
        setLoading(false);
        notifyListeners();
        return result = failure(false, 'connection timed out');
      }

      if (response.statusCode == 404) {
        setLoading(false);
        notifyListeners();
        return result = failure(
          false,
          INVALID_PHONE_NUMBER,
        );
      }
      if (response.statusCode == 400 || response.statusCode == 401) {
        String splitRequest = urlName.split('/').last;
      }
      if (response.statusCode == 503) {
        setLoading(false);
        notifyListeners();
        return result = failure(
          false,
          'Unable to handle request,try again',
        );
      } else {
        debugPrint("Error Code: ${response.statusCode} ${response.body}");

        setLoading(false);
        notifyListeners();
        return result = failure(false, response.body);
      }
    } on HttpException {
      result = failure(false, 'Internet Connection error');
    } catch (e) {
      setLoading(false);
      debugPrint('this is exception $e');
      result = failure(false, 'Unknown error');

      notifyListeners();
    }

    return result;
  }

  static onError(error) {
    debugPrint('the error is ${error.detail}');
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}
