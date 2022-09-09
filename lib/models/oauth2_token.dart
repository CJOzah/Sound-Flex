// To parse this JSON data, do
//
//     final oauth2Token = oauth2TokenFromJson(jsonString);

import 'dart:convert';

Oauth2Token oauth2TokenFromJson(String str) => Oauth2Token.fromJson(json.decode(str));

String oauth2TokenToJson(Oauth2Token data) => json.encode(data.toJson());

class Oauth2Token {
    Oauth2Token({
        this.oauth2Token,
    });

    String? oauth2Token;

    factory Oauth2Token.fromJson(Map<String, dynamic> json) => Oauth2Token(
        oauth2Token: json["oauth2_token"],
    );

    Map<String, dynamic> toJson() => {
        "oauth2_token": oauth2Token,
    };
}
