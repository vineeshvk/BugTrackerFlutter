import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../graphql/queries.dart';
import './widgets/list_bug_item.dart';
import '../../widgets/overscrollDisableWidget.dart';
import '../add_bug_screen/add_bug_screen.dart';

class HomeScreen extends StatelessWidget {
  final String uid;
  final bool admin;

  HomeScreen({this.uid, this.admin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bugs',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        brightness: Brightness.light,
        centerTitle: true,
      ),
      body: Container(
        child: Query(
          viewBugs,
          pollInterval: 3,
          variables: {'userId': uid},
          builder: ({error, loading, data}) {
            print('home => $uid');
            if (error != null) {
              return Text(error.toString());
            }
            if (loading) {
              return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.pinkAccent)));
            }

            List bugList = data['viewBugs'];
            print(data.toString() + uid);
            print(bugList);

            return OverScrollDisable(
              child: ListView.builder(
                itemCount: bugList.length,
                itemBuilder: (context, index) => ListBugItem(
                      data: bugList[index],
                      uid: uid,
                    ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: admin
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddBugScreen(
                              uid: uid,
                            )));
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.pinkAccent,
              tooltip: 'hello',
            )
          : Container(),
    );
  }
}
