// To parse this JSON data, do
//
//     final songList = songListFromJson(jsonString);

import 'dart:convert';

SongList songListFromJson(String str) => SongList.fromJson(json.decode(str));

String songListToJson(SongList data) => json.encode(data.toJson());

class SongList {
    SongList({
        this.entries,
        this.cursor,
        this.hasMore,
    });

    List<SongInfo>? entries;
    String? cursor;
    bool? hasMore;

    factory SongList.fromJson(Map<String, dynamic> json) => SongList(
        entries: List<SongInfo>.from(json["entries"].map((x) => SongInfo.fromJson(x))),
        cursor: json["cursor"],
        hasMore: json["has_more"],
    );

    Map<String, dynamic> toJson() => {
        "entries": List<dynamic>.from(entries!.map((x) => x.toJson())),
        "cursor": cursor,
        "has_more": hasMore,
    };
}

class SongInfo {
    SongInfo({
        this.tag,
        this.name,
        this.pathLower,
        this.pathDisplay,
        this.id,
        this.clientModified,
        this.serverModified,
        this.rev,
        this.size,
        this.isDownloadable,
        this.contentHash,
    });

    String? tag;
    String? name;
    String? pathLower;
    String? pathDisplay;
    String? id;
    DateTime? clientModified;
    DateTime? serverModified;
    String? rev;
    int? size;
    bool? isDownloadable;
    String? contentHash;

    factory SongInfo.fromJson(Map<String, dynamic> json) => SongInfo(
        tag: json[".tag"],
        name: json["name"],
        pathLower: json["path_lower"],
        pathDisplay: json["path_display"],
        id: json["id"],
        clientModified: DateTime.parse(json["client_modified"]),
        serverModified: DateTime.parse(json["server_modified"]),
        rev: json["rev"],
        size: json["size"],
        isDownloadable: json["is_downloadable"],
        contentHash: json["content_hash"],
    );

    Map<String, dynamic> toJson() => {
        ".tag": tag,
        "name": name,
        "path_lower": pathLower,
        "path_display": pathDisplay,
        "id": id,
        "client_modified": clientModified!.toIso8601String(),
        "server_modified": serverModified!.toIso8601String(),
        "rev": rev,
        "size": size,
        "is_downloadable": isDownloadable,
        "content_hash": contentHash,
    };
}
