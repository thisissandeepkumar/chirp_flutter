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
  });

  factory Message.fromJSON(Map<String, dynamic> data) {
    return Message(
      chatroomId: data["chatroomId"],
      senderId: data["senderId"],
      type: MessageType.text,
      createdAt: DateTime.parse(data["createdAt"]),
      textContent: data["textContent"],
      id: data["_id"],
    );
  }

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
