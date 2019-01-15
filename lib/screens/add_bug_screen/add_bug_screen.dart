import 'package:flutter/material.dart';
import '../../mixins/validation_mixin.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../graphql/queries.dart';
import '../../graphql/mutations.dart';

class AddBugScreen extends StatefulWidget {
  final String uid;
  AddBugScreen({this.uid});

  @override
  AddBugScreenState createState() {
    return new AddBugScreenState(uid);
  }
}

class AddBugScreenState extends State<AddBugScreen> with ValidateMixing {
  final formKey = GlobalKey<FormState>();
  final String uid;

  String title = '';
  String description = '';
  String assignTo;

  AddBugScreenState(this.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Bug',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        brightness: Brightness.light,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Container(margin: EdgeInsets.only(top: 10)),
                titleTextField(),
                Container(margin: EdgeInsets.only(top: 30)),
                contentTextField(),
                Container(margin: EdgeInsets.only(top: 30)),
                assignToWidget(),
                Container(margin: EdgeInsets.only(top: 30)),
                submitButtonWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget titleTextField() {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Title',
      ),
      validator: validateTitle,
      onSaved: (String title) {
        this.title = title;
      },
    );
  }

  Widget contentTextField() {
    return TextFormField(
      decoration: InputDecoration.collapsed(hintText: 'Enter the description'),
      textAlign: TextAlign.start,
      keyboardType: TextInputType.multiline,
      maxLines: 10,
      validator: validateDescription,
      onSaved: (String description) {
        this.description = description;
      },
    );
  }

  Widget assignToWidget() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Assign to',
            style: TextStyle(fontSize: 17, color: Colors.black54),
          ),
          Query(allUsers, variables: {'userId': uid},
              builder: ({error, loading, data}) {
            if (error != null) {
              return Text(error.toString());
            }
            if (loading) {
              return Text('Loading...');
            }
            final List users =
                data['allUsers'].map((user) => user['email']).toList();

            final List<DropdownMenuItem<String>> userList = users
                .map((user) =>
                    DropdownMenuItem<String>(child: Text(user), value: user))
                .toList();

            return DropdownButton(
              value: assignTo,
              onChanged: (String value) {
                setState(() {
                  assignTo = value;
                });
              },
              items: userList,
              hint: Text('users'),
            );
          }),
        ]);
  }

  Widget submitButtonWidget() {
    return Mutation(
      addBug,
      builder: (runMutation, {data, error, loading}) {
        return MaterialButton(
          minWidth: 400,
          height: 45,
          color: Colors.pinkAccent,
          child: Text('Add', style: TextStyle(fontSize: 18)),
          textColor: Colors.white,
          splashColor: Colors.pink,
          onPressed: () {
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              if (assignTo != null) {
                runMutation({
                  'adminId': uid,
                  'assignEmail': assignTo,
                  'description': description,
                  'title': title
                });
              }
            }
          },
        );
      },
      onCompleted: (Map<String, dynamic> data) {
        bool response = data['addBug'];
        if (response == true) {
          Navigator.pop(context);
        } else {
          return Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text("Something went wrong"),
          ));
        }
      },
    );
  }
}
