// ignore_for_file: unnecessary_null_comparison, avoid_print

      
import 'dart:async';
      
import 'dart:convert';
      
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sound_flex/models/song_list.dart';
import 'package:sound_flex/models/song_temp_link.dart';
import 'package:sound_flex/models/token.dart';

import '../datasource/repository/api_status.dart';
import '../utils/strings.dart';

class AuthProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  Token? _bearer;
  Token? get bearer => _bearer;
  SongList? _songList;
  SongList? get songList => _songList;
  SongTempLink? _songTempLink;
  SongTempLink? get songTempLink => _songTempLink;

  Future<void> clearData() async {}

  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }

  Future<Map<String, dynamic>> postRequest(var payload, String urlName) async {
    Future<Map<String, dynamic>> result;

    debugPrint('payload $payload urlName $urlName');
    setLoading(true);
    notifyListeners();

    String plainCredentials = "hxwueslwhk1oxee:3pvz3p5lse4pxqf";

    // Create authorization header
    String basicAuth = 'Basic ' + base64.encode(utf8.encode(plainCredentials));
    print("basic auth: $basicAuth");

    String splitRequest = urlName.split('/').last;

    try {
      Response response = await post(
        Uri.parse(urlName),
        encoding: Encoding.getByName('utf-8'),
        body: splitRequest.contains("token") ? payload : jsonEncode(payload),
        headers: {
          "Content-Type": splitRequest.contains("token") ? "application/x-www-form-urlencoded" :"application/json",
          if(!splitRequest.contains("token")) 'Authorization':  'Bearer ${_bearer!.accessToken}',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setLoading(false);
        notifyListeners();
        final Map<String, dynamic> responseData = json.decode(response.body);
        debugPrint('urlName $urlName ${urlName.split('/').last}');
        debugPrint(
            "payload response ${response.body} status Code: ${response.statusCode}");
        switch (splitRequest) {
          case 'token':
            _bearer = tokenFromJson(response.body);
            print(bearer);
            return result =
                success(true, 'Token retrieved', data: responseData);

          case 'list_folder':
            _songList = songListFromJson(response.body);
            print(songList);
            return result =
                success(true, 'List retrieved', data: responseData);
          case 'get_temporary_link':
            _songTempLink = songTempLinkFromJson(response.body);
            print(songTempLink);
            return result =
                success(true, 'Temporary link retrieved', data: responseData);
          default:
            debugPrint("Success: ${json.decode(response.body)}");
            return result = success(true, responseData["message"],
                data: responseData["message"]);
        }
      }

      if (response.statusCode == null) {
        setLoading(false);
        debugPrint("Error Code: ${response.statusCode} ${response.body}");

        notifyListeners();
        return result = failure(false, 'connection timed out');
      }

      if (response.statusCode == 404) {
        setLoading(false);
        debugPrint("Error Code: ${response.statusCode} ${response.body}");

        notifyListeners();
        return result = failure(
          false,
          INVALID_PHONE_NUMBER,
        );
      }
      if (response.statusCode == 400 || response.statusCode == 401) {
        setLoading(false);
        debugPrint("Error Code: ${response.statusCode} ${response.body}");

        notifyListeners();
        return result = failure(false, response.body);
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
