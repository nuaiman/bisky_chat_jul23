import 'dart:convert';

class ChatModel {
  final String id;
  final String identifier;
  final String senderId;
  final String message;
  final String fileUrl;
  bool isRead;
  final DateTime date;

  ChatModel({
    required this.id,
    required this.identifier,
    required this.senderId,
    required this.message,
    required this.fileUrl,
    required this.isRead,
    required this.date,
  });

  ChatModel copyWith({
    String? id,
    String? identifier,
    String? senderId,
    String? message,
    String? fileUrl,
    bool? isRead,
    DateTime? date,
  }) {
    return ChatModel(
      id: id ?? this.id,
      identifier: identifier ?? this.identifier,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      fileUrl: fileUrl ?? this.fileUrl,
      isRead: isRead ?? this.isRead,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    // result.addAll({'id': id});
    result.addAll({'identifier': identifier});
    result.addAll({'senderId': senderId});
    result.addAll({'message': message});
    result.addAll({'fileUrl': fileUrl});
    result.addAll({'isRead': isRead});
    result.addAll({'date': date.millisecondsSinceEpoch});

    return result;
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['\$id'] ?? '',
      identifier: map['identifier'] ?? '',
      senderId: map['senderId'] ?? '',
      message: map['message'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      isRead: map['isRead'] ?? false,
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChatModel(id: $id, identifier: $identifier, senderId: $senderId, message: $message, fileUrl: $fileUrl, isRead: $isRead, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatModel &&
        other.id == id &&
        other.identifier == identifier &&
        other.senderId == senderId &&
        other.message == message &&
        other.fileUrl == fileUrl &&
        other.isRead == isRead &&
        other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        identifier.hashCode ^
        senderId.hashCode ^
        message.hashCode ^
        fileUrl.hashCode ^
        isRead.hashCode ^
        date.hashCode;
  }
}
