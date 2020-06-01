import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:pushupstats/database.dart';
import 'package:intl/intl.dart';
import 'sign_in.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

final databaseReference = Firestore.instance;

class FirstScreen extends StatefulWidget {
  FirstScreen({Key key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

@override
class _FirstScreenState extends State<FirstScreen> {
  int amount;
  String _date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String _formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String _time = DateFormat('hh:mm').format(DateTime.now());

  TextEditingController _controller = TextEditingController();

  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(tabs: [
              Tab(
                icon: Icon(Icons.ac_unit),
              ),
              Tab(
                icon: Icon(Icons.directions_railway),
              ),
            ]),
            title: const Text('PushupStats'),
          ),
          body: TabBarView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Amount of pushups',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 4.0,
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            theme: DatePickerTheme(
                              containerHeight: 210.0,
                            ),
                            showTitleActions: true,
                            minTime: DateTime(2000, 1, 1),
                            maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                          print('confirm $date');
                          _formattedDate =
                              '${DateFormat("dd").format(date)}-${DateFormat("MM").format(date)}-${DateFormat("yyyy").format(date)}';
                          _date =
                              '${DateFormat("yyyy").format(date)}-${DateFormat("MM").format(date)}-${DateFormat("dddd").format(date)}';
                          setState(() {});
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.date_range,
                                        size: 18.0,
                                        color: Colors.blue[700],
                                      ),
                                      Text(
                                        " $_formattedDate",
                                        style: TextStyle(
                                            color: Colors.blue[700],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Text(
                              "Change",
                              style: TextStyle(
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ],
                        ),
                      ),
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 4.0,
                      onPressed: () {
                        DatePicker.showTimePicker(context,
                            showSecondsColumn: false,
                            theme: DatePickerTheme(
                              containerHeight: 210.0,
                            ),
                            showTitleActions: true, onConfirm: (time) {
                          print('confirm $time');
                          _time = '${time.hour}:${time.minute}';
                          setState(() {});
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.access_time,
                                        size: 18.0,
                                        color: Colors.blue[700],
                                      ),
                                      Text(
                                        " $_time",
                                        style: TextStyle(
                                            color: Colors.blue[700],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Text(
                              "Change",
                              style: TextStyle(
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ],
                        ),
                      ),
                      color: Colors.white,
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Amount of pushups',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _controller,
                      onSubmitted: (String value) async {
                        if (value.length != 0) {
                          await DatabaseService(uid: uid).addPushup(
                              int.parse(value),
                              DateTime.parse('${_date}T$_time:00Z'));

                          _controller.clear();
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
              Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Pushup list',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: PushupList(),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class PushupList extends StatelessWidget {
  const PushupList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DatabaseService(uid: uid).getPushups(),
        builder: (context, AsyncSnapshot snapshot) {
          var list = [];
          if (snapshot.hasData) {
            List<DocumentSnapshot> values = snapshot.data.documents;
            values.forEach((pushup) => list.add(pushup));

            return new ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  DateTime date = list[index]["date"].toDate();
                  String amount = list[index]["amount"].toString();
                  String formattedDate =
                      DateFormat("dd-MM-yyyy hh:mm").format(date);
                  return PushupCard(
                      documentID: list[index].documentID,
                      amount: amount,
                      formattedDate: formattedDate);
                });
          }

          return CircularProgressIndicator();
        });
  }
}

class PushupCard extends StatelessWidget {
  const PushupCard({
    Key key,
    @required this.documentID,
    @required this.amount,
    @required this.formattedDate,
  }) : super(key: key);

  final String documentID;
  final String amount;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
          onTap: () => _showDialog(context, documentID),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text("Amount: " + amount.toString()),
                subtitle: Text("Date: " + formattedDate),
              )
            ],
          )),
    );
  }

  Future<void> _showDialog(context, String documentID) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do you want to delete this pushup record?'),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  DatabaseService(uid: uid).deletePushup(documentID);
                  Navigator.pop(context);
                })
          ],
        );
      },
    );
  }
}
