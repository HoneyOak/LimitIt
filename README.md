# Limit It

**Limit It** is a collaborative app designed to help you curb phone addiction by enabling your friends to monitor your screen time and support you. The app tracks your screen usage and lets your friends see how long you've been active, send "boos" for motivation, and hold you accountable.

## Features

- Track your total screen time for the day.
- View friends' screen time and whether they are currently active.
- Send and receive friend requests.
- Accept or reject incoming friend requests.
- Receive support (or boos!) from your friends.
- Display online/offline status and last seen time.
- Persist background tracking via foreground service and battery optimization handling.

## Screens

- **Home Page**: Displays your screen time and your friends' progress towards their goals.
- **Friend Requests Page**: See incoming requests and approve or reject them.
- **Friend Search**: Search and send friend requests by username.
- **Settings Page**: Customize your preferences and goals.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/limit-it.git
   cd limit-it
Install dependencies:


flutter pub get
Add your Firebase configuration files:

google-services.json for Android

GoogleService-Info.plist for iOS (if applicable)

Create a .env file:

ini
Copy
Edit
HERE_API_KEY=your_here_api_key
GRAPHISTRY_PASSWORD=your_graphistry_password
Run the app:

bash
Copy
Edit
flutter run
Dependencies
firebase_auth

cloud_firestore

flutter_foreground_task

shared_preferences

permission_handler

flutter_local_notifications

Firebase Structure
users (collection)

uid (document)

username

email

online

lastSeen

goal

totalScreenTimeToday

friends (subcollection)

friendUid (document) with timestamp

friend_requests_incoming (subcollection)

requesterUid (document)

friend_requests_outgoing (subcollection)

targetUid (document)

Notes
The app uses a foreground service to run persistently in the background.

Battery optimization must be disabled manually by the user for accurate tracking.

Android 14+ requires additional permissions for foreground services (FOREGROUND_SERVICE_REMOTE_MESSAGING).

License
MIT License. See LICENSE for details.

Copy
Edit
