import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference usersCollection =
      Firestore.instance.collection('users');

  Future addPushup(int amount, DateTime date) async {
    return await usersCollection
        .document(uid)
        .collection("pushups")
        .add({'amount': amount, 'date': date});
  }
}
