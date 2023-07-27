import 'dart:convert';

class ConversationModel {
  final String identifier;
  final String user1Id;
  final String user2Id;
  ConversationModel({
    required this.identifier,
    required this.user1Id,
    required this.user2Id,
  });

  ConversationModel copyWith({
    String? identifier,
    String? user1Id,
    String? user2Id,
  }) {
    return ConversationModel(
      identifier: identifier ?? this.identifier,
      user1Id: user1Id ?? this.user1Id,
      user2Id: user2Id ?? this.user2Id,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'identifier': identifier});
    result.addAll({'user1Id': user1Id});
    result.addAll({'user2Id': user2Id});

    return result;
  }

  factory ConversationModel.fromMap(Map<String, dynamic> map) {
    return ConversationModel(
      identifier: map['identifier'] ?? '',
      user1Id: map['user1Id'] ?? '',
      user2Id: map['user2Id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ConversationModel.fromJson(String source) =>
      ConversationModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ConversationModel(identifier: $identifier, user1Id: $user1Id, user2Id: $user2Id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConversationModel &&
        other.identifier == identifier &&
        other.user1Id == user1Id &&
        other.user2Id == user2Id;
  }

  @override
  int get hashCode => identifier.hashCode ^ user1Id.hashCode ^ user2Id.hashCode;
}
