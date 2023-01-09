import 'package:comms_flutter/models/account.dart';

class Chatroom {
  String id;
  List<Account> participants;
  bool isGroup;
  String? title;
  String? description;
  String? image;
  DateTime created;
  DateTime updatedAt;

  Chatroom({
    required this.id,
    required this.participants,
    required this.isGroup,
    this.title,
    this.description,
    this.image,
    required this.created,
    required this.updatedAt,
  });

  factory Chatroom.fromJson(Map<String, dynamic> json) {
    return Chatroom(
      id: json['id'],
      participants: (json['participants'] as List)
          .map((e) => Account.fromJson(e))
          .toList(),
      isGroup: json['isGroup'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      created: DateTime.parse(json['created']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participants': participants.map((e) => e.toJson()).toList(),
      'isGroup': isGroup,
      'title': title,
      'description': description,
      'image': image,
      'created': created.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
