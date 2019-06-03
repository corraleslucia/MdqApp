import 'package:flutter/material.dart';
import 'package:mdq/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mdq/models/todo.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _textEditingController = TextEditingController();

  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();

    _checkEmailVerification();
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resentVerifyEmail() {
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resent link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text(
              "Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Categorias'),
        actions: <Widget>[
          new FlatButton(
              child: new Text('Logout',
                  style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: _signOut)
        ],
      ),
      body: getListView(),
    );
  }

  Widget getListView() {
    var listView = ListView.separated(
      padding: EdgeInsets.fromLTRB(30, 16, 30, 16),
        itemCount: 11,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return createCell('Gastronomía');
              break;
            case 1:
              return createCell('Hoteles');
              break;
            case 2:
              return createCell('Museos');
              break;
            case 3:
              return createCell('Playas');
              break;
            case 4:
              return createCell('Transportes');
              break;
            case 5:
              return createCell('Recreación');
              break;
            case 6:
              return createCell('Lugares');
              break;
            case 7:
              return createCell('Inmobiliarias');
              break;
            case 8:
              return createCell('Eventos');
              break;
            case 9:
              return createCell('Congresos');
              break;
            case 10:
              return createCell('Agencias de viajes');
              break;
          }
        }
    );
    return listView;
  }

  Widget createCell(String name) {
    return Material(
      color: Colors.blue,
      child: Container(
        height: 60,
        child: InkWell( //para que sea tappeable

          borderRadius: new BorderRadius.circular(10.0),
          highlightColor: Colors.blue,
          splashColor: Colors.blue,
          onTap: () {
            print(name + ' tapped');
          },

          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: (
                        TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            fontSize: 18.0,
                            color: Colors.white,
                        )
                    ),
                  ),
                ),
                Container(
                  child: Icon(Icons.arrow_right,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],

            ),
          ),
        ),
      ),
    );
  }
}