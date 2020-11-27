import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:second_test/app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  //24769a33-7dc4-41f7-9e46-07ee01cc2f40
  //1a817192-b9c4-4249-a875-79bf34846915
  OneSignal.shared.init('1a817192-b9c4-4249-a875-79bf34846915', iOSSettings: null);
  OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
  await Firebase.initializeApp();
  runApp(App());
}
