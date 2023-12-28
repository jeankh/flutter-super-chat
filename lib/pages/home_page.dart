import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:superchat/pages/account_page.dart';
import 'package:superchat/pages/chat_page.dart';
import 'package:superchat/pages/sign_in_page.dart';
import 'package:superchat/util/constants.dart';
import 'package:superchat/widgets/stream_listener.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamListener<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      listener: (user) {
        if (user == null) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const SignInPage()),
              (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(kAppTitle),
          backgroundColor: theme.colorScheme.primary,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
            ),
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountPage()),
                );
              },
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _collectionRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var userData =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  return ListTile(
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          child: Text(userData['displayName'][0]),
                        ),
                        userData['profileImageUrl'] != null
                            ? CircleAvatar(
                                backgroundImage:
                                    NetworkImage(userData['profileImageUrl']),
                                backgroundColor: Colors.transparent,
                              )
                            : SizedBox(),
                      ],
                    ),
                    contentPadding:
                        userData['id'] == FirebaseAuth.instance.currentUser?.uid
                            ? const EdgeInsets.only(left: 72.0)
                            : null,
                    title: Text(
                      userData['displayName'] ?? 'No username',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      userData['bin'] ?? 'No bio',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                              userId: userData['id'],
                              displayName: userData['displayName']),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
