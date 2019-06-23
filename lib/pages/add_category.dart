import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mdq/firebase/firebase_api.dart';
import 'package:mdq/services/authentication.dart';

class AddCategoryDialog extends StatefulWidget {
  AddCategoryDialog(
      {Key key,
        this.auth,
        this.userId,
        this.onSignedOut,
        this.name,
        this.docId})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  final String name;
  final String docId;

  @override
  State<StatefulWidget> createState() => new _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  bool _isEmailVerified = false;
  final _formAddCategoryKey = GlobalKey<FormState>();
  String _name;

  String validateName(String value) {
    if (value.isEmpty) {
      return "Please Enter Category name.";
    } else {
      return null;
    }
  }

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
          title: new Text("Verifique su cuenta"),
          content: new Text(
              "Por favor verifica tu cuenta en el link enviado al email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Reenviar link"),
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
          title: new Text("Verifique su cuenta"),
          content: new Text(
              "El link para verificar la cuenta ha sido enviado a su email"),
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
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              final form = _formAddCategoryKey.currentState;
              if (form.validate()) {
                form.save();
                if (widget.name != null && widget.name.isNotEmpty) {
                  FireBaseAPI.updateCategory(widget.docId, _name);
                } else {
                  FireBaseAPI.addCategory(_name);
                }
                Navigator.pop(context);
              }
            },
            child: Text(
              widget.name != null && widget.name.isNotEmpty ? "UPDATE" : 'SAVE',
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: Form(
          key: _formAddCategoryKey,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Category name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.star),
            ),
            keyboardType: TextInputType.text,
            initialValue: widget.name != null && widget.name.isNotEmpty
                ? widget.name
                : "",
            validator: (value) {
              return validateName(value);
            },
            onSaved: (value) => _name = value,
          ),
        ),
      ),
    );
  }
}
