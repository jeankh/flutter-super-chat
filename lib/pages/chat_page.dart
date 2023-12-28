import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  final String? userId;
  final String? displayName;

  const ChatPage({this.userId, this.displayName, Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final CollectionReference _messagesCollection =
      FirebaseFirestore.instance.collection('messages');
  late Stream<List<QueryDocumentSnapshot>> _messagesStream;

  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _messagesStream = getMessagesStream();
  }

  Stream<List<QueryDocumentSnapshot>> getMessagesStream() {
    return _messagesCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  void _sendMessage() {
    String messageText = _textEditingController.text.trim();
    User? user = FirebaseAuth.instance.currentUser;
    if (messageText.isNotEmpty) {
      _messagesCollection.add({
        'from': widget.userId,
        'to': user?.uid,
        'content': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((_) {
        print('Message sent: $messageText');
        _textEditingController.clear();
      }).catchError((error) {
        print('Error sending message: $error');
        _showErrorDialog('Failed to send message. Please try again.');
      });
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.displayName ?? ""}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<QueryDocumentSnapshot>>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No messages yet.'),
                  );
                }

                return ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.all(8),
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final messageData =
                        snapshot.data![index].data() as Map<String, dynamic>;

                    final isSentByTargetUser =
                        messageData['from'] == widget.userId &&
                            messageData['to'] ==
                                FirebaseAuth.instance.currentUser?.uid;
                    final isSentToTargetUser =
                        messageData['to'] == widget.userId &&
                            messageData['from'] ==
                                FirebaseAuth.instance.currentUser?.uid;

                    if (isSentByTargetUser || isSentToTargetUser) {
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            widget.displayName?[0] ?? "",
                          ),
                          backgroundColor:
                              isSentToTargetUser ? Colors.blue : Colors.purple,
                        ),
                        contentPadding: EdgeInsets.only(
                          top: 20,
                        ),
                        shape: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),

                        title: Text(messageData['content']),

                        // Add additional ListTile elements if necessary
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    cursorColor: Color.fromARGB(255, 99, 99, 99),
                    enableSuggestions: true,
                    style: TextStyle(fontSize: 18),
                    cursorRadius: Radius.circular(16),
                    controller: _textEditingController,
                    decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        )),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _sendMessage,
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
