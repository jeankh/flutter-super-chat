import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:superchat/pages/sign_in_page.dart';
import 'package:superchat/util/constants.dart';
import 'package:superchat/widgets/stream_listener.dart';

class AccountPage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('users');

  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController binController = TextEditingController();

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
          backgroundColor: Colors.blue, //theme.colorScheme.primary,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Text(
              'Your profile',
              style: theme.textTheme.headline6,
            ),
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(user?.displayName?[0] ?? ""),
                    ),
                    title: Text(user?.displayName ?? 'No username'),
                    subtitle: Text(user?.email ?? 'No email'),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 2,
              endIndent: theme.textTheme.headline6?.fontSize,
              indent: theme.textTheme.headline6?.fontSize,
              color: Colors.grey,
            ),
            Text(
              'Update Your profile',
              style: theme.textTheme.headline6,
            ),
            Expanded(
              child: Column(
                children: [
                  TextFormField(
                    controller: displayNameController,
                    decoration: InputDecoration(
                      labelText: 'New Display Name',
                    ),
                  ),
                  TextFormField(
                    controller: binController,
                    decoration: InputDecoration(
                      labelText: 'New Bio',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String newDisplayName = displayNameController.text;
                      String newBin = binController.text;
                      if (user?.uid != null) {
                        _collectionRef.doc(user?.uid).set(
                          {
                            'displayName': newDisplayName,
                            'bin': newBin,
                          },
                          SetOptions(merge: true),
                        ).then((_) {
                          print('Data updated successfully');
                        }).catchError((error) {
                          print('Error updating data: $error');
                        });
                      }
                      displayNameController.clear();
                      binController.clear();
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
