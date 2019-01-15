import 'package:flutter/material.dart';
import '../../view_bug_details/view_bug_details.dart';

class ListBugItem extends StatelessWidget {
  String id, title, description, status;
  String assignId;
  String assignEmail;
  final String uid;

  ListBugItem({Map<String, dynamic> data, this.uid}) {
    id = data['id'];
    title = data['title'];
    description = data['description'];
    status = data['status'];
    assignId = data['assignedTo']['id'];
    assignEmail = data['assignedTo']['email'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewBugDetailsScreen(
                        id: id,
                        title: title,
                        description: description,
                        status: status,
                        assignedTo: assignEmail,
                        uid: uid,
                      )));
        },
        child: Card(
          elevation: 3,
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(margin: EdgeInsets.only(top: 5)),
                Text(description),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
