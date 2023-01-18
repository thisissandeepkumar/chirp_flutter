enum MessageType {
  text,
}

class Message {
  String? id;
  String chatroomId;
  String senderId;
  MessageType type;
  String? textContent;
  DateTime? createdAt;

  Message({
    this.id,
    required this.chatroomId,
    required this.senderId,
    required this.type,
    this.textContent,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Message.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        chatroomId = json['chatroomId'],
        senderId = json['senderId'],
        type = MessageType.values[json['type']],
        textContent = json['textContent'],
        createdAt = DateTime.parse(json['createdAt']);

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> json = {
      'chatroomId': chatroomId,
      'senderId': senderId,
      'type': type.index,
      'textContent': textContent,
    };
    if (id != null) {
      json['_id'] = id;
    }
    if (createdAt != null) {
      json['createdAt'] = createdAt!.toIso8601String();
    }
    return json;
  }
}
