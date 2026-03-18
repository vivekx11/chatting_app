class MessageModel {
  final String sender;
  final String role;
  final String message;
  final String time;
  final bool isSelf;

  MessageModel({
    required this.sender,
    required this.role,
    required this.message,
    required this.time,
    this.isSelf = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json, String myUsername) {
    return MessageModel(
      sender: json['sender'] as String,
      role: json['role'] as String,
      message: json['message'] as String,
      time: json['time'] as String,
      isSelf: json['sender'] == myUsername,
    );
  }

  bool get isAdmin => role == 'admin';
}
//msg
