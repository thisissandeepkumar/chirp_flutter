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
    this.createdAt,
  });

  factory Message.fromJSON(Map<String, dynamic> data) {
    return Message(
      chatroomId: data["chatroomId"],
      senderId: data["senderId"],
      type: MessageType.text,
      createdAt: DateTime.parse(data["createdAt"].toString()),
      textContent: data["textContent"],
      id: data["_id"],
    );
  }

  Map<String, dynamic> toJSON() {
    late String type;
    switch (this.type) {
      case MessageType.text:
        type = "text";
        break;
    }
    Map<String, dynamic> json = {
      'chatroomId': chatroomId,
      'senderId': senderId,
      'type': type,
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
