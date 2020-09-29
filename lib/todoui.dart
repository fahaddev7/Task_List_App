import 'package:flutter/material.dart';
import 'package:todo_list/dbhelper.dart';

class Todoui extends StatefulWidget {
  @override
  _TodouiState createState() => _TodouiState();
}

class _TodouiState extends State<Todoui> {
  final dbhelper = Databasehelper.instance;

  final texteditingcontroller = TextEditingController();
  bool validated = true;
  String errtext = "";
  String textedited = "";
  var myitems = List();
  List<Widget> children = new List<Widget>();

  void addtodo() async {
    Map<String, dynamic> row = {Databasehelper.columnName: textedited};
    final id = await dbhelper.insert(row);
    print(id);
    Navigator.pop(context);
    setState(() {
      validated = true;
      errtext = "";
    });
  }

  Future<bool> query() async {
    myitems = [];
    children = [];
    var allrows = await dbhelper.queryall();
    allrows.forEach((row) {
      myitems.add(row.toString());
      children.add(Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 5.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: ListTile(
            title: Text(
              row['todo'],
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: "Raleway",
              ),
            ),
            onLongPress: () {
              dbhelper.deletedata(row['id']);
              setState(() {});
            },
          ),
        ),
      ));
    });
    return Future.value(true);
  }

  void showalertdialog() {
    texteditingcontroller.text = "";
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setstate) {
            return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                title: Text("Add Task"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: texteditingcontroller,
                      autofocus: true,
                      onChanged: (_val) {
                        textedited = _val;
                      },
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Raleway",
                      ),
                      decoration: InputDecoration(
                        errorText: validated ? null : errtext,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: RaisedButton(
                        onPressed: () {
                          if (texteditingcontroller.text.isEmpty) {
                            setState(() {
                              errtext = "Can't be Empty";
                              validated = false;
                            });
                          } else if (texteditingcontroller.text.length > 12) {
                            setState(() {
                              errtext = "Too many characters";
                              validated = false;
                            });
                          } else {
                            addtodo();
                          }
                        },
                        child: Text("ADD"),
                        color: Colors.purple,
                      ),
                    )
                  ],
                ));
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snap) {
        if (snap.hasData == null) {
          return Center(
            child: Text("No Data"),
          );
        } else {
          if (myitems.length == 0) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text("My Tasks"),
                centerTitle: true,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: showalertdialog,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.purple,
              ),
              body: Center(
                child: Text("No Tasks Available"),
              ),
            );
          } else {
            return Scaffold(
                appBar: AppBar(
                  title: Text("My Tasks"),
                  centerTitle: true,
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: showalertdialog,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.purple,
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: children,
                  ),
                ));
          }
        }
      },
      future: query(),
    );
  }
}
