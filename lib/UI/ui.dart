import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

class CustomCard extends StatelessWidget {
  final int index;
  final QuerySnapshot? snapshot;

  const CustomCard({Key? key, required this.index, this.snapshot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    
    var formatted = DateFormat("EEE, MMM d, yyyy, h:mm a");
    var dateTime = snapshot!.docs[index]["dateTime"];
    var formattedDate = formatted.format(dateTime);

    return Column(
      children: <Widget>[
        Container(
          height: 200,
          child: Card(
            elevation: 10,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Text(
                      snapshot!.docs[index]["title"].toString()[0],
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: Text(snapshot!.docs[index]["name"] +
                      ": " +
                      snapshot!.docs[index]["title"]),
                  subtitle: Text(snapshot!.docs[index]["description"]),
                ),
                SizedBox(
                  height: 10,
                ),
                // Text((formattedDate == null)?"":formattedDate.toString()),
                Text(formattedDate),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
// Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: <Widget>[
//           Text("Title: " + snapshot!.docs[index]["title"]),
//           SizedBox(
//             height: 10,
//           ),
//           Text("Name: " + snapshot!.docs[index]["name"]),
//           SizedBox(
//             height: 10,
//           ),
//           Text("Description: " + snapshot!.docs[index]["description"]),
//         ]);