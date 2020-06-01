import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:pushupstats/database.dart';
import 'login_page.dart';
import 'sign_in.dart';

final databaseReference = Firestore.instance;

class FirstScreen extends StatefulWidget {
  FirstScreen({Key key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

@override
class _FirstScreenState extends State<FirstScreen> {
  int amount;

  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PushupStats'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Amount of pushups',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              onSubmitted: (String value) async {
                if (value.length != 0) {
                  await DatabaseService(uid: uid)
                      .addPushup(int.parse(value), DateTime.now());
                }
              },
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
            ),
          ],
        ),
      ),
    );
  }
}
