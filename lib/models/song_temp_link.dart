// To parse this JSON data, do
//
//     final songTempLink = songTempLinkFromJson(jsonString);

import 'dart:convert';

SongTempLink songTempLinkFromJson(String str) => SongTempLink.fromJson(json.decode(str));

String songTempLinkToJson(SongTempLink data) => json.encode(data.toJson());

class SongTempLink {
    SongTempLink({
        this.metadata,
        this.link,
    });

    Metadata? metadata;
    String? link;

    factory SongTempLink.fromJson(Map<String, dynamic> json) => SongTempLink(
        metadata: Metadata.fromJson(json["metadata"]),
        link: json["link"],
    );

    Map<String, dynamic> toJson() => {
        "metadata": metadata!.toJson(),
        "link": link,
    };
}

class Metadata {
    Metadata({
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

    factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
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
