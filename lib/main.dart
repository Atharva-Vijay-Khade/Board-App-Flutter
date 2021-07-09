import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'UI/ui.dart';

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

  // _showDialogIncomplete(BuildContext context) async {
  //   await showDialog(
  //       context: context,
  //       builder: (BuildContext context) => AlertDialog(
  //             contentPadding: EdgeInsets.all(10),
  //             content: Center(
  //               child: Text("Fields can't be empty"),
  //             ),
  //           ));
  // }

  _showDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      inputTitleController.clear();
                      inputDescriptionController.clear();
                      inputNameController.clear();
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      if (inputTitleController.text.isNotEmpty &&
                          inputDescriptionController.text.isNotEmpty &&
                          inputNameController.text.isNotEmpty) {
                        FirebaseFirestore.instance.collection("board").add({
                          "name": inputNameController.text,
                          "title": inputTitleController.text,
                          "description": inputDescriptionController.text,
                          "dateTime":DateTime.now(),
                        }).then((value) {
                          print(value.id);
                        }).catchError((error) {
                          print(error);
                        });

                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //   content: Text("Data Added Successfully"),
                        // ));

                        inputTitleController.clear();
                        inputDescriptionController.clear();
                        inputNameController.clear();

                        Navigator.pop(context);
                      } else {
                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        // content: Text("Data is incomplete"),
                        // ));
                        // Container(
                        //   width:100,
                        //   height:100,
                        //   child: Center(
                        //     child: _showDialogIncomplete(context),
                        //   ),
                        // );
                      }
                    },
                    child: Text("Save"),
                  ),
                ],
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
                return CustomCard(index: index,snapshot: snapshot.data);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog(context);
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.black,
      ),
    );
  }
}
