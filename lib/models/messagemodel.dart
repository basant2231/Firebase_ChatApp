class MessageModel {
  String? content;
  String? date;
  // i who am sending or the other partener
  String? senderID;

  MessageModel({
    required this.content,
    required this.date,
    required this.senderID,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'date': date,
      'senderID': senderID,
    };
  }

  static fromJson({required Map<String, dynamic> data}) {
    return MessageModel(
      content: data['content'] as String,
      date: data['date'] as String,
      senderID: data['senderID'] as String,
    );
  }
}
