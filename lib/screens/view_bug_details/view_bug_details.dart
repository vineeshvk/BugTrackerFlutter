import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../graphql/mutations.dart';

class ViewBugDetailsScreen extends StatefulWidget {
  final String title;
  final String description;
  final String status;
  final String id;
  final String assignedTo;
  final String uid;
  @required
  ViewBugDetailsScreen(
      {this.title,
      this.description,
      this.status,
      this.id,
      this.assignedTo,
      this.uid});

  @override
  ViewBugDetailsScreenState createState() {
    return new ViewBugDetailsScreenState(status: status);
  }
}

class ViewBugDetailsScreenState extends State<ViewBugDetailsScreen> {
  String status;
  ViewBugDetailsScreenState({this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View Bug',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        brightness: Brightness.light,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        padding: EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              titleTextWidget(),
              Container(margin: EdgeInsets.only(top: 20)),
              Container(
                  height: 150,
                  child: SingleChildScrollView(child: descriptionTextWidget())),
              Container(margin: EdgeInsets.only(top: 20)),
              assignedToTextWidget(),
              Container(margin: EdgeInsets.only(top: 30)),
              statusWidget(),
              Container(margin: EdgeInsets.only(top: 40)),
              updateStatusButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget titleTextWidget() {
    return Text(
      widget.title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget descriptionTextWidget() {
    return Text(
      widget.description,
      style: TextStyle(fontSize: 20),
    );
  }

  Widget assignedToTextWidget() {
    return Padding(
        padding: EdgeInsets.fromLTRB(.3, 0, 3, 0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Assigned To',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Text(
                widget.assignedTo,
                style: TextStyle(fontSize: 15),
              )
            ]));
  }

  Widget statusWidget() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Status',
            style: TextStyle(fontSize: 17, color: Colors.black54),
          ),
          DropdownButton(
            value: status,
            onChanged: (String value) {
              setState(() {
                status = value;
              });
            },
            items: <DropdownMenuItem<String>>[
              DropdownMenuItem(child: Text('unresolved'), value: 'unresolved'),
              DropdownMenuItem(child: Text('resolved'), value: 'resolved'),
              DropdownMenuItem(child: Text('closed'), value: 'closed')
            ],
            hint: Text('users'),
          )
        ]);
  }

  Widget updateStatusButton() {
    return Mutation(changeStatus,
        builder: (runMutation, {loading, error, data}) {
      return MaterialButton(
        minWidth: 400,
        height: 45,
        color: Colors.pinkAccent,
        child: Text('Update Status', style: TextStyle(fontSize: 18)),
        textColor: Colors.white,
        onPressed: () {
          if (status != null) {
            runMutation(
                {'userId': widget.uid, 'bugId': widget.id, 'status': status});
          }
        },
      );
    }, onCompleted: (Map<String, dynamic> data) {
      if (data['changeStatus'] == true) {
        Navigator.pop(context);
      }
    });
  }
}
