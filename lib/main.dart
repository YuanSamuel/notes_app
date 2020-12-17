import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _notesController = new TextEditingController();

  void _incrementCounter() {
    FirebaseFirestore.instance
        .collection('notes')
        .doc(DateTime.now().toString())
        .set({'content': _notesController.text});
    _notesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _notesController,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('notes').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot != null) {
                List<DocumentSnapshot> docs = snapshot.data.docs;
                List<Widget> widgets = [];
                for (int i = 0; i < docs.length; i++) {
                  widgets.add(
                    GestureDetector(
                      child: Container(
                        child: Text(docs[i].data()['content']),
                      ),
                      onDoubleTap: () {
                        docs[i].reference.delete();
                      },
                    ),
                  );
                }
                return Column(
                  children: widgets,
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
