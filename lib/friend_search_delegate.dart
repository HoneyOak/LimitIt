import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final myUid = FirebaseAuth.instance.currentUser!.uid;

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThan: '${query}z')
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final results = snapshot.data!.docs
            .where((doc) => doc.id != myUid)
            .toList();

        if (results.isEmpty) {
          return const Center(child: Text("No users found."));
        }

        return FutureBuilder<Map<String, dynamic>>(
          future: _getFriendshipData(myUid),
          builder: (context, friendshipSnapshot) {
            if (!friendshipSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final friendData = friendshipSnapshot.data!;

            return ListView(
              children: results.map((doc) {
                final uid = doc.id;
                final username = doc['username'];
                final email = doc['email'];

                String status;
                if (friendData['friends'].contains(uid)) {
                  status = 'Friend';
                } else if (friendData['outgoing'].contains(uid)) {
                  status = 'Requested';
                } else {
                  status = 'Add';
                }

                return ListTile(
                  title: Text(username),
                  subtitle: Text(email),
                  trailing: _buildStatusButton(
                    status,
                    myUid,
                    uid,
                    username,
                    context,
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  Future<Map<String, Set<String>>> _getFriendshipData(String myUid) async {
    final firestore = FirebaseFirestore.instance;

    final friendsSnapshot = await firestore
        .collection('users')
        .doc(myUid)
        .collection('friends')
        .get();

    final outgoingSnapshot = await firestore
        .collection('users')
        .doc(myUid)
        .collection('friend_requests_outgoing')
        .get();

    return {
      'friends': friendsSnapshot.docs.map((doc) => doc.id).toSet(),
      'outgoing': outgoingSnapshot.docs.map((doc) => doc.id).toSet(),
    };
  }

  Widget _buildStatusButton(
    String status,
    String myUid,
    String targetUid,
    String username,
    BuildContext context,
  ) {
    if (status == 'Friend') {
      return const Text('Friend', style: TextStyle(color: Colors.green));
    } else if (status == 'Requested') {
      return const Text('Requested', style: TextStyle(color: Colors.orange));
    } else {
      return ElevatedButton(
        style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.onPrimary)),
        onPressed: () async {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(myUid)
              .collection('friend_requests_outgoing')
              .doc(targetUid)
              .set({'timestamp': FieldValue.serverTimestamp()});

          await FirebaseFirestore.instance
              .collection('users')
              .doc(targetUid)
              .collection('friend_requests_incoming')
              .doc(myUid)
              .set({'timestamp': FieldValue.serverTimestamp()});

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Friend request sent to $username')),
          );

          // Refresh the delegate UI by triggering search again
          query = username;
          showResults(context);
        },
        child: const Text('Add'),
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Text("Search usernames to add friends"),
    );
  }
}
