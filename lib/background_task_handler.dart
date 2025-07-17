import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:limit_it/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This function will be called when the background task starts.
@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MyTaskHandler extends TaskHandler {
  bool _initialized = false;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    if (!_initialized) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _initialized = true;
    }
  }

  @override
  @override
  @override
  void onRepeatEvent(DateTime timestamp) async {
    print("repeat event ran");

    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');
    if (uid == null) {
      print("UID is null, aborting background write.");
      return;
    }

    final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
    final today = DateTime.now();
    final todayString = "${today.year}-${today.month}-${today.day}";
    final lastResetDate = prefs.getString('lastResetDate');

    if (lastResetDate != todayString) {
      print("Resetting totalScreenTimeToday for $todayString");
      await userDoc.set({
        'totalScreenTimeToday': 0,
        'online': true,
        'lastSeen': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      await prefs.setString('lastResetDate', todayString);
    } else {
      final snapshot = await userDoc.get();
      final currentTime =
          (snapshot.data()?['totalScreenTimeToday'] ?? 0) as int;

      print(
        "Updating screen time. Current: $currentTime, New: ${currentTime + 1}",
      );

      await userDoc.set({
        'totalScreenTimeToday': currentTime + 1,
        'online': true,
        'lastSeen': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');
    if (uid != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'online': false,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  void onReceiveData(Object data) {}
  @override
  void onNotificationButtonPressed(String id) {}
  @override
  void onNotificationPressed() {}
  @override
  void onNotificationDismissed() {}
}
