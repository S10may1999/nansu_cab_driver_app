import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationSystem {
  FirebaseMessaging firebaseCloudMessaging = FirebaseMessaging.instance;

  Future<String?> generateDeviceRegisterationToken() async {
    String? deviceRecognitionToken = await firebaseCloudMessaging.getToken();
    DatabaseReference referenceOnlineDriver = FirebaseDatabase.instance
        .ref()
        .child("driver")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("deviceToken");
    referenceOnlineDriver.set(deviceRecognitionToken);
    firebaseCloudMessaging.subscribeToTopic("driver");
    firebaseCloudMessaging.subscribeToTopic("users");
  }

  startListeningForNewNotification() async {
    //1. when the app is terminated
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? messageRemote) {
      if (messageRemote != null) {
        String tripID = messageRemote.data["tripID"];
      }
    });

    //2. when app is opened and received the push notification

    FirebaseMessaging.onMessage.listen((RemoteMessage? messageRemote) {
      if (messageRemote != null) {
        String tripID = messageRemote.data["tripID"];
      }
    });

    //3. when app is minimized and running in the background

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? messageRemote) {
      if (messageRemote != null) {
        String tripID = messageRemote.data["tripID"];
      }
    });
  }
}
