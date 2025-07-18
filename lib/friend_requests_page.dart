import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendRequestsPage extends StatelessWidget {
  const FriendRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final incomingRequestsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('friend_requests_incoming');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend Requests'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: incomingRequestsRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final requests = snapshot.data!.docs;

          if (requests.isEmpty) {
            return const Center(child: Text("No incoming friend requests."));
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final requesterId = requests[index].id;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(requesterId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const ListTile(
                      title: Text("Loading..."),
                    );
                  }

                  final requester = userSnapshot.data!;
                  final username = requester['username'] ?? 'Unknown';
                  final email = requester['email'] ?? '';

                  return ListTile(
                    title: Text(username),
                    subtitle: Text(email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          tooltip: 'Accept',
                          onPressed: () async {
                            final userRef = FirebaseFirestore.instance.collection('users');

                            // Add each other as friends
                            await userRef.doc(uid).collection('friends').doc(requesterId).set({
                              'timestamp': FieldValue.serverTimestamp(),
                            });

                            await userRef.doc(requesterId).collection('friends').doc(uid).set({
                              'timestamp': FieldValue.serverTimestamp(),
                            });

                            // Remove the request
                            await userRef.doc(uid)
                                .collection('friend_requests_incoming')
                                .doc(requesterId)
                                .delete();

                            await userRef.doc(requesterId)
                                .collection('friend_requests_outgoing')
                                .doc(uid)
                                .delete();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          tooltip: 'Reject',
                          onPressed: () async {
                            final userRef = FirebaseFirestore.instance.collection('users');

                            await userRef.doc(uid)
                                .collection('friend_requests_incoming')
                                .doc(requesterId)
                                .delete();

                            await userRef.doc(requesterId)
                                .collection('friend_requests_outgoing')
                                .doc(uid)
                                .delete();
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
