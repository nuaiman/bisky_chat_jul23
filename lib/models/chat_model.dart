import 'dart:convert';

class ChatModel {
  final String identifier;
  final String senderId;
  final String message;
  final String fileUrl;
  final DateTime date;

  ChatModel({
    required this.identifier,
    required this.senderId,
    required this.message,
    required this.fileUrl,
    required this.date,
  });

  ChatModel copyWith({
    String? identifier,
    String? senderId,
    String? message,
    String? fileUrl,
    DateTime? date,
  }) {
    return ChatModel(
      identifier: identifier ?? this.identifier,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      fileUrl: fileUrl ?? this.fileUrl,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'identifier': identifier});
    result.addAll({'senderId': senderId});
    result.addAll({'message': message});
    result.addAll({'fileUrl': fileUrl});
    result.addAll({'date': date.millisecondsSinceEpoch});

    return result;
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      identifier: map['identifier'] ?? '',
      senderId: map['senderId'] ?? '',
      message: map['message'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChatModel(identifier: $identifier, senderId: $senderId, message: $message, fileUrl: $fileUrl, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatModel &&
        other.identifier == identifier &&
        other.senderId == senderId &&
        other.message == message &&
        other.fileUrl == fileUrl &&
        other.date == date;
  }

  @override
  int get hashCode {
    return identifier.hashCode ^
        senderId.hashCode ^
        message.hashCode ^
        fileUrl.hashCode ^
        date.hashCode;
  }
}
