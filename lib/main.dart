import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timeitapp/firebase_options.dart';
import 'dart:math';
import 'package:qr_flutter/qr_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String prueba = 'prueba';
  bool atWork = false;
  final db = FirebaseFirestore.instance;
  final userPath =
      '/Company/kGCOpHgRyiIYLr4Fwuys/User/82Pn54ECfpMJov5SPDLn6JW4JMg1';
  Future<void> updateAtWork() async {
    await db.doc(userPath).update({
      'atWork': atWork,
    });
    setState(() {
      atWork = !atWork;
    });
  }

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  void checkForNewSharedLists() {
    // do request here

    setState(() {
      prueba = getRandomString(5);
      print(prueba);
      // change state according to result of request
    });
  }

  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        Duration(seconds: 2), (Timer t) => checkForNewSharedLists());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: StreamBuilder(
          stream: db
              .doc(
                  '/Company/kGCOpHgRyiIYLr4Fwuys/User/82Pn54ECfpMJov5SPDLn6JW4JMg1')
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return ErrorWidget(snapshot.error.toString());
            }
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            final doc = snapshot.data!;

            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "QR para escanear",
                  style: const TextStyle(fontSize: 32),
                ),
                QrImage(
                  data: prueba,
                  version: QrVersions.auto,
                  size: 200.0,
                ),

                // ElevatedButton.icon(
                //   onPressed: () {
                //     print(getRandomString(5));
                //     updateAtWork();
                //   },
                //   icon: Icon(Icons.start),
                //   label: Text("Start"),
                // ),
                // doc['atWork'] ? Text('true') : Text('false')
              ],
            );
          },
        )),
      ),
    );
  }
}
