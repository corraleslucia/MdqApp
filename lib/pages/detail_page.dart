import 'package:flutter/material.dart';
import 'package:mdq/services/authentication.dart';

class DetailPage extends StatelessWidget {
  DetailPage(
      {Key key, this.auth, this.userId, this.onSignedOut, this.name, this.street, this.streetNumber,
        this.latitude, this.longitude, this.phoneNumber, this.mail})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  final String name;
  final String street;
  final int streetNumber;
  final double latitude;
  final double longitude;
  final String phoneNumber;
  final String mail;


  static Route<dynamic> route(String name, String street, int sNumber,
      double lat, double lon, String pNumber, String mail,
      BaseAuth auth, VoidCallback onSignedOut, String userId) {

    return MaterialPageRoute(
      builder: (context) =>
          DetailPage(
            auth: auth,
            onSignedOut: onSignedOut,
            userId: userId,
            name: name,
            street: street,
            streetNumber: sNumber,
            latitude: lat,
            longitude: lon,
            phoneNumber: pNumber,
            mail: mail,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Detalles"),
        backgroundColor: Colors.deepOrange,
      ),
      body: new Container(
        child: new Column(

          children: <Widget>[
            Row(
              children: <Widget>[
                new Container(
                  child: new Icon(
                    Icons.label_important,
                    color: Colors.deepOrange,
                    size: 40.0,

                  ),
                ),

                new Container(
                  child: Text("Nombre:", textAlign: TextAlign.center,),
                ),

                new Expanded(
                  child: new Container(
                    padding: new EdgeInsets.only(left: 8.0),
                    child: new Text( this.name,
                          style: new TextStyle( color: Colors.black,fontWeight: FontWeight.w600,fontSize: 16.0,),
                          ),
                    ),
                  ),
              ],
            ),

            Row(
              children: <Widget>[
                new Container(
                  child: new Icon(
                    Icons.map,
                    color: Colors.deepOrange,
                    size: 40.0,

                    ),
                ),

                new Container(
                  child: Text("Dirección:", textAlign: TextAlign.center,),
                ),

                new Expanded(
                  child: new Container(
                    padding: new EdgeInsets.only(left: 8.0),
                    child: new Text( this.street + this.streetNumber.toString(),
                      style: new TextStyle( color: Colors.black,fontWeight: FontWeight.w600,fontSize: 16.0,),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                new Container(
                  child: new Icon(
                    Icons.phone,
                    color: Colors.deepOrange,
                    size: 40.0,

                  ),
                ),

                new Container(
                  child: Text("Telefono: :", textAlign: TextAlign.center,),
                ),

                new Expanded(
                  child: new Container(
                    padding: new EdgeInsets.only(left: 8.0),
                    child: new Text( this.phoneNumber.toString(),
                      style: new TextStyle( color: Colors.black,fontWeight: FontWeight.w600,fontSize: 16.0,),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              children: <Widget>[
                new Container(
                  child: new Icon(
                    Icons.mail,
                    color: Colors.deepOrange,
                    size: 40.0,

                  ),
                ),

                new Container(
                  child: Text("Mail:", textAlign: TextAlign.center,),
                ),

                new Expanded(
                  child: new Container(
                    padding: new EdgeInsets.only(left: 8.0),
                    child: new Text( this.mail,
                      style: new TextStyle( color: Colors.black,fontWeight: FontWeight.w600,fontSize: 16.0,),
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  bool _isEmailVerified = false;

  @override
  void initState() {

    _checkEmailVerification();
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await this.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resentVerifyEmail() {
    this.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      //context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verifique su cuenta"),
          content: new Text("Por favor verifica tu cuenta en el link enviado al email"),
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
      //context: context,
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
    this.dispose();
  }

  _signOut() async {
    try {
      await this.auth.signOut();
      this.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

}






