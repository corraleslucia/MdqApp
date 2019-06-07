import 'package:flutter/material.dart';
import 'package:mdq/models/category.dart';
import 'package:mdq/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mdq/widgets/SliverAppbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class CategoryExpanded extends StatefulWidget {
  CategoryExpanded({Key key, this.auth, this.userId, this.onSignedOut, this.category, this.hotelsData})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  final Category category;
  List hotelsData;

  @override
  State<StatefulWidget> createState() => new _CategoryExpandedState();

  static Route<dynamic> route(Category cat, List categories, BaseAuth auth) {
    return MaterialPageRoute(
      builder: (context) => CategoryExpanded(auth: auth,category: cat, hotelsData: categories),
    );
  }
}

class _CategoryExpandedState extends State<CategoryExpanded> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _textEditingController = TextEditingController();

//  Map data;
//  List hotelsData;

//  List<Category> categories;
  bool _isEmailVerified = false;
  List<ListTile> elements = new List();
  @override
  void initState() {
    super.initState();
//    this.hotelsData = new List();
//    this.getCateogorias();

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
    return new Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBarCustom(
              background_image: 'assets/mdpAppbar2.jpg',
              pinned: true,
              snap: false,
              floating: false,
//              tittle: "Mdq App",
              actions: <Widget>[
                new Container(
                    child: OutlineButton(
                      child: new Text(
                          'Logout',
                          style: new TextStyle(
                              fontSize: 17.0,
                              color: Colors.white
                          )
                      ),
                      onPressed: _signOut,
                      borderSide: BorderSide(color: Colors.black, width: .5, style: BorderStyle.solid),
                    ),
                    margin: EdgeInsets.fromLTRB(0,10 , 10, 10)
                ),
              ],
            ),
            SliverFixedExtentList(
              itemExtent: 70,
              delegate: SliverChildBuilderDelegate((BuildContext context, int i){

                  return _buildRow(widget.hotelsData[i]["Nombre"]);

              },
                childCount:widget.hotelsData == null
                    ? 0
                    : widget.hotelsData.length,


              ),
            ),
          ],
        )
    );
  }



  Widget _buildRow(String t){
    return Card(
        color: Colors.white,
        margin: EdgeInsets.fromLTRB(20,10,20,0),
        elevation: 10,
        child: Container(
          height: 100.0,
          child: InkWell(
            splashColor: Colors.deepOrange,
            onTap: () =>
            {
            },
            child: ListTile(
              title: Text(
                  t,
                  style: TextStyle(
                    fontSize: 14,
                  )),
              trailing: Icon(Icons.hotel),
              contentPadding: EdgeInsets.fromLTRB(20,0,20,0),
            ),
          ),
        )
    );

  }

//  var body = json.encode({
//    "Token": "12345678901234567890123456789012",
//    "PagNumero": "",
//    "RegsXPag": "",
//    "LatCentro": "-38.0003561526665",
//    "LongCentro": "-57.5495535981007",
//    "DistCentro": "10000",
//    "IdCategoria": "",
//    "IdZona": "",
//    "IdServicioAlojamiento": "",
//    "Nombre": ""
//  });
//
//  Future<String> getCateogorias() async {
//
//    // crear el body que iria segun la peticion q desee buscar
//
//    var response = await http.post(widget.category.url,
//        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
//        body: body);
//
//    var data = json.decode(response.body);
//    hotelsData = data[widget.category.name]; // guardo toda la data de "Hoteles"
//  }

}