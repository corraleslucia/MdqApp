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
      this.url,
      this.token,
      this.method,
      this.icon,
      this.docId})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  final String name;
  final String url;
  final String token;
  final String method;
  final String icon;
  final String docId;

  @override
  State<StatefulWidget> createState() => new _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  bool _isEmailVerified = false;
  final _formAddCategoryKey = GlobalKey<FormState>();
  String _name;
  String _url;
  String _token;
  String _method;
  String _icon;

  String validateName(String value) {
    if (value.isEmpty) {
      return "Please Enter Category name.";
    } else {
      return null;
    }
  }

  String validateUrl(String value) {
    if (value.isEmpty) {
      return "Please Enter Url.";
    } else {
      return null;
    }
  }

  String validateToken(String value) {
    if (value.isEmpty) {
      return "Please Enter Token.";
    } else {
      return null;
    }
  }

  String validateMethod(String value) {
    if (value.isEmpty) {
      return "Please Enter Method name.";
    } else {
      return null;
    }
  }

  String validateIcon(String value) {
    if (value.isEmpty) {
      return "Please Enter Icon name.";
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
//    _checkEmailVerification();
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
                  FireBaseAPI.updateCategory(
                      widget.docId, _name, _url, _token, _method, _icon);
                } else {
                  FireBaseAPI.addCategory(_name, _url, _token, _method, _icon);
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

//      body: Container(
//        margin: EdgeInsets.all(16.0),
//        child: Form(
//          key: _formAddCategoryKey,
//          child: TextFormField(
//            decoration: InputDecoration(
//              labelText: 'Category name',
//              border: OutlineInputBorder(),
//              prefixIcon: Icon(Icons.star),
//            ),
//            keyboardType: TextInputType.text,
//            initialValue: widget.name != null && widget.name.isNotEmpty
//                ? widget.name
//                : "",
//            validator: (value) {
//              return validateName(value);
//            },
//            onSaved: (value) => setState(() =>_name = value),
//          ),
//
//        ),
//      ),

      body: Container(
        margin: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formAddCategoryKey,
            child: Column(
              children: <Widget>[
                TextFormField(
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
                  onSaved: (value) => setState(() => _name = value),
                ),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Category url',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.web),
                  ),
                  keyboardType: TextInputType.text,
                  initialValue: widget.url != null && widget.url.isNotEmpty
                      ? widget.url
                      : "",
                  validator: (value) {
                    return validateUrl(value);
                  },
                  onSaved: (value) => setState(() => _url = value),
                ),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Category API token',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.code),
                  ),
                  keyboardType: TextInputType.text,
                  initialValue: widget.token != null && widget.token.isNotEmpty
                      ? widget.token
                      : "",
                  validator: (value) {
                    return validateToken(value);
                  },
                  onSaved: (value) => setState(() => _token = value),
                ),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Category API method',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.developer_mode),
                  ),
                  keyboardType: TextInputType.text,
                  initialValue: widget.method != null &&
                      widget.method.isNotEmpty
                      ? widget.method
                      : "",
                  validator: (value) {
                    return validateName(value);
                  },
                  onSaved: (value) => setState(() => _method = value),
                ),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Category Icon',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.image),
                  ),
                  keyboardType: TextInputType.text,
                  initialValue: widget.icon != null && widget.icon.isNotEmpty
                      ? widget.icon
                      : "",
                  validator: (value) {
                    return validateName(value);
                  },
                  onSaved: (value) => setState(() => _icon = value),
                ),

              ],
            ),
          ),
        ),
      ),

    );
  }
}
