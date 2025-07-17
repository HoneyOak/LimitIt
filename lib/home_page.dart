import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:limit_it/friend_requests_page.dart';
import 'package:limit_it/friend_search_delegate.dart';
import 'package:limit_it/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> userStream;

  @override
  void initState() {
    super.initState();
    userStream = FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots();
  }

  String formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return "${hours}h ${remainingMinutes}m";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LimitIt',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.secondary),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
            },
          ),
          IconButton(
            icon: Icon(Icons.mail_outline, color: Theme.of(context).colorScheme.secondary),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FriendRequestsPage()));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSearch(context: context, delegate: FriendSearchDelegate());
        },
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        child: Icon(Icons.person_add, color: Theme.of(context).colorScheme.primary),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: userStream,
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = userSnapshot.data!.data();
          final myMinutes = userData?['totalScreenTimeToday'] ?? 0;
          final myFormattedTime = formatDuration(myMinutes);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Today's Screen Time", style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  myFormattedTime,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection('friends')
                        .snapshots(),
                    builder: (context, friendsSnapshot) {
                      if (!friendsSnapshot.hasData) return const Center(child: CircularProgressIndicator());

                      final friendDocs = friendsSnapshot.data!.docs;

                      if (friendDocs.isEmpty) {
                        return const Center(child: Text("No friends added yet."));
                      }

                      return ListView.builder(
                        itemCount: friendDocs.length,
                        itemBuilder: (context, index) {
                          final friendId = friendDocs[index].id;

                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance.collection('users').doc(friendId).get(),
                            builder: (context, friendSnapshot) {
                              if (!friendSnapshot.hasData) {
                                return const ListTile(title: Text("Loading friend..."));
                              }

                              final friendData = friendSnapshot.data!.data() as Map<String, dynamic>;
                              final username = friendData['username'] ?? 'Friend';
                              final isOnline = friendData['online'] ?? false;
                              final lastSeen = friendData['lastSeen']?.toDate();
                              final minutesAgo = lastSeen != null
                                  ? DateTime.now().difference(lastSeen).inMinutes
                                  : null;

                              final screenTime = friendData['totalScreenTimeToday'] ?? 0;
                              final goal = friendData['goal'] ?? 480;
                              final progress = screenTime / goal;
                              final formattedTime = formatDuration(screenTime);

                              return Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: 24,
                                            backgroundColor: Theme.of(context).colorScheme.secondary,
                                          ),
                                          Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child: CircleAvatar(
                                              radius: 6,
                                              backgroundColor: isOnline ? Colors.green : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
                                            Text(
                                              isOnline
                                                  ? 'Active now'
                                                  : minutesAgo != null
                                                      ? 'Last seen $minutesAgo min ago'
                                                      : 'Offline',
                                              style: const TextStyle(color: Colors.grey),
                                            ),
                                            const SizedBox(height: 8),
                                            LinearProgressIndicator(
                                              value: progress.clamp(0.0, 1.0),
                                              backgroundColor: Colors.grey.shade300,
                                              color: Colors.orange,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "$formattedTime of ${formatDuration(goal)} goal",
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        children: [
                                          const Icon(Icons.image, color: Colors.purple),
                                          Text(formattedTime),
                                          const SizedBox(height: 8),
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.grey.shade800,
                                              padding: const EdgeInsets.symmetric(horizontal: 12),
                                            ),
                                            onPressed: () {},
                                            icon: const Icon(Icons.thumb_down),
                                            label: const Text('Send boo'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
