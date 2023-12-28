import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String from;
  final String to;
  final String content;
  final Timestamp timestamp;

  Message({
    required this.from,
    required this.to,
    required this.content,
    required this.timestamp,
  });
}
