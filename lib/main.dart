import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BoardApp(),
    );
  }
}

class BoardApp extends StatefulWidget {
  const BoardApp({Key? key}) : super(key: key);

  @override
  _BoardAppState createState() => _BoardAppState();
}

class _BoardAppState extends State<BoardApp> {
  
  late TextEditingController inputNameController;
  late TextEditingController inputTitleController;
  late TextEditingController inputDescriptionController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inputNameController = TextEditingController();
    inputTitleController = TextEditingController();
    inputDescriptionController = TextEditingController();
  }

  var fireStoreDb = FirebaseFirestore.instance.collection("board").snapshots();

  _showDialog(BuildContext context) async {
        await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            contentPadding: EdgeInsets.all(10),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Please fill out the form"),
                Expanded(
                  child: TextField(
                    controller: inputNameController,
                    autocorrect: true,
                    autofocus: true,
                    decoration: InputDecoration(labelText: "Your Name*"),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: inputTitleController,
                    autocorrect: true,
                    autofocus: true,
                    decoration: InputDecoration(labelText: "Title*"),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: inputDescriptionController,
                    autocorrect: true,
                    autofocus: true,
                    decoration: InputDecoration(labelText: "Description*"),
                  ),
                ),
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Board App",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStoreDb,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, int index) {
                return Text(snapshot.data!.docs[index]["description"]);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          _showDialog(context);
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.black,
      ),
    );
  }
}
