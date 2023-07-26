import 'dart:convert';

class ConversationModel {
  final String postOwnerId;
  final String requestingUid;
  final String identifier;
  final String ownerName;
  final String ownerImageUrl;
  final String requestingUserName;
  final String requestingUserImageUrl;
  ConversationModel({
    required this.postOwnerId,
    required this.requestingUid,
    required this.identifier,
    required this.ownerName,
    required this.ownerImageUrl,
    required this.requestingUserName,
    required this.requestingUserImageUrl,
  });

  ConversationModel copyWith({
    String? postOwnerId,
    String? requestingUid,
    String? identifier,
    String? ownerName,
    String? ownerImageUrl,
    String? requestingUserName,
    String? requestingUserImageUrl,
  }) {
    return ConversationModel(
      postOwnerId: postOwnerId ?? this.postOwnerId,
      requestingUid: requestingUid ?? this.requestingUid,
      identifier: identifier ?? this.identifier,
      ownerName: ownerName ?? this.ownerName,
      ownerImageUrl: ownerImageUrl ?? this.ownerImageUrl,
      requestingUserName: requestingUserName ?? this.requestingUserName,
      requestingUserImageUrl:
          requestingUserImageUrl ?? this.requestingUserImageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'postOwnerId': postOwnerId});
    result.addAll({'requestingUid': requestingUid});
    result.addAll({'identifier': identifier});
    result.addAll({'ownerName': ownerName});
    result.addAll({'ownerImageUrl': ownerImageUrl});
    result.addAll({'requestingUserName': requestingUserName});
    result.addAll({'requestingUserImageUrl': requestingUserImageUrl});

    return result;
  }

  factory ConversationModel.fromMap(Map<String, dynamic> map) {
    return ConversationModel(
      postOwnerId: map['postOwnerId'] ?? '',
      requestingUid: map['requestingUid'] ?? '',
      identifier: map['identifier'] ?? '',
      ownerName: map['ownerName'] ?? '',
      ownerImageUrl: map['ownerImageUrl'] ?? '',
      requestingUserName: map['requestingUserName'] ?? '',
      requestingUserImageUrl: map['requestingUserImageUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ConversationModel.fromJson(String source) =>
      ConversationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ConversationModel(postOwnerId: $postOwnerId, requestingUid: $requestingUid, identifier: $identifier, ownerName: $ownerName, ownerImageUrl: $ownerImageUrl, requestingUserName: $requestingUserName, requestingUserImageUrl: $requestingUserImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConversationModel &&
        other.postOwnerId == postOwnerId &&
        other.requestingUid == requestingUid &&
        other.identifier == identifier &&
        other.ownerName == ownerName &&
        other.ownerImageUrl == ownerImageUrl &&
        other.requestingUserName == requestingUserName &&
        other.requestingUserImageUrl == requestingUserImageUrl;
  }

  @override
  int get hashCode {
    return postOwnerId.hashCode ^
        requestingUid.hashCode ^
        identifier.hashCode ^
        ownerName.hashCode ^
        ownerImageUrl.hashCode ^
        requestingUserName.hashCode ^
        requestingUserImageUrl.hashCode;
  }
}
