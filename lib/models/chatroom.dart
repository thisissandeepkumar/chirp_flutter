import 'package:comms_flutter/models/account.dart';

class Chatroom {
  String id;
  List<Account> participants;
  DateTime createdAt;
  DateTime updatedAt;
  String? title;
  bool isGroup;

  Chatroom({
    required this.id,
    required this.participants,
    required this.createdAt,
    required this.updatedAt,
    this.title,
    this.isGroup = false,
  }) {
    id = id;
    participants = participants;
    createdAt = createdAt;
    updatedAt = updatedAt;
    title = title;
    isGroup = isGroup;
  }

  factory Chatroom.fromJson(Map<String, dynamic> json) {
    return Chatroom(
      id: json['_id'],
      participants: (json['participants'] as List)
          .map((e) => Account.fromJson(e))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      title: json['title'],
      isGroup: json['isGroup'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'participants': participants.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'title': title,
      'isGroup': isGroup,
    };
  }
}
