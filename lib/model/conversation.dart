import 'package:superchat/model/message.dart';

class Conversation {
  final String id;
  List<Message> messages = [];

  Conversation({required this.id});
}
