import 'package:flutter/material.dart';
import 'package:mdq/models/category.dart';
import 'package:mdq/pages/root_page.dart';
import 'package:mdq/services/authentication.dart';
import 'package:mdq/widgets/SliverAppbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';


class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.onSignedOut, this.categories})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  final List<Category> categories;

  @override
  State<StatefulWidget> createState() => new _HomePageState(this.categories);

}

class _HomePageState extends State<HomePage> {
  _HomePageState(this.categories);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Map data;
  List dataList;
  Category category;

  List<Category> categories;


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
    return new Scaffold(
        body: CustomScrollView(
        slivers: <Widget>[
        SliverAppBarCustom(
          background_image: 'assets/mdpAppbar2.jpg',
          pinned: true,
          snap: false,
          floating: false,
          actions: <Widget>[
            new Container(
                child: OutlineButton(
                  child: new Text('Logout',
                      style:
                          new TextStyle(fontSize: 17.0, color: Colors.white)),
                  onPressed: _signOut,
                  borderSide: BorderSide(
                      color: Colors.black, width: .5, style: BorderStyle.solid),
                ),
                margin: EdgeInsets.fromLTRB(0, 10, 10, 10)),
          ],
        ),
//        SliverFixedExtentList(
//          itemExtent: 70,
//          delegate: SliverChildBuilderDelegate(
//            (BuildContext context, int i) {
//              return _buildRow(categories[i].name, i);
//            },
//            childCount: categories.length,
//          ),
//        ),
           SliverFixedExtentList(
            itemExtent: 70,
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int i) {
                return _buildRow(categories[i].name, i);
              },
              childCount: categories.length,
            ),
          ),
      ],
    ));
  }

  Future<List> getRubro(int index) async {
    //var response;
    var body;
    switch (categories[index].name) {
      case "Hoteles":
        body = json.encode({
          "Token": categories[index].token,
          "PagNumero": "",
          "RegsXPag": "",
          "LatCentro": "-38.0003561526665",
          "LongCentro": "-57.5495535981007",
          "DistCentro": "10000",
          "IdCategoria": "",
          "IdZona": "",
          "IdServicioAlojamiento": "",
          "Nombre": ""
        });
        break;

      case "Inmobiliarias":
        body = json.encode({
          "Token": categories[index].token,
          "PagNumero": "",
          "RegsXPag": "",
          "LatCentro": "-38.0003561526665",
          "LongCentro": "-57.5495535981007",
          "DistCentro": "10000",
          "IdZonaOperacion": "",
          "SoloConAlquilerTuristico": "false",
          "Nombre": ""
        });
        break;

      case "Agencias":
        body = json.encode({
          "Token": categories[index].token,
          "PagNumero": "",
          "RegsXPag": "",
          "LatCentro": "-38.0003561526665",
          "LongCentro": "-57.5495535981007",
          "DistCentro": "10000",
          "IdCategoria": "",
          "IdTipoOperacion": "",
          "Nombre": ""
        });
        break;

      case "Transportes":
        body = json.encode({
          "Token": categories[index].token,
          "PagNumero": "",
          "RegsXPag": "",
          "LatCentro": "-38.0003561526665",
          "LongCentro": "-57.5495535981007",
          "DistCentro": "10000",
          "IdTipoMedio": "",
          "IdDestino": "",
          "Nombre": ""
        });
        break;

      case "Salones":
        body = json.encode({
          "Token": categories[index].token,
          "PagNumero": "",
          "RegsXPag": "",
          "LatCentro": "-38.0003561526665",
          "LongCentro": "-57.5495535981007",
          "DistCentro": "10000",
          "Capacidad": "",
          "Nombre": ""
        });
        break;

      case "Playas":
        body = json.encode({
          "Token": categories[index].token,
          "PagNumero": "",
          "RegsXPag": "",
          "LatCentro": "-38.0003561526665",
          "LongCentro": "-57.5495535981007",
          "DistCentro": "10000",
          "IdZona": "",
          "IdAccesibilidad": "",
          "Nombre": ""
        });
        break;

      case "Eventos":
        body = json.encode({
          "Token" : categories[index].token,
          "PagNumero":"",
          "RegsXPag" :"",
          "IdCategoria" :"",
          "IdSubCategoria" :"",
          "FechaDesde" :"20190622",
          "FechaHasta" :"20190822",
          "Nombre":""
        });
        break;
      case "Gastronomia":
        body = json.encode({
          "Token": categories[index].token,
          "PagNumero":"",
          "RegsXPag" :"",
          "LatCentro" :"-38.0003561526665",
          "LongCentro" : "-57.5495535981007",
          "DistCentro" : "10000",
          "IdTipoComercio" :"209",
          "IdZona": "",
          "IdTipoCocina": "",
          "IdAccesibilidad" :"",
          "OpcionesParaCeliacos" :"false",
          "Nombre":""
        });
        break;
    }

    var response = await http.post(Uri.encodeFull(categories[index].url),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: body);

//    var data = json.decode(response.body);
//    dataList = data[categories[index].name];
//    return dataList;
    var data = json.decode(response.body);
    if((categories[index].name).compareTo("Gastronomia")==0){
      dataList = data[categories[index].name + "s"];
      return dataList;
    }
    dataList = data[categories[index].name];
    return dataList;
  }


  Widget _buildRow(String t, int i) {
    return Card(
        color: Colors.white,
        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
        elevation: 10,
        child: Container(
          height: 100.0,
          child: InkWell(
            splashColor: Colors.deepOrange,
            onTap: () async {
              this.category = categories[i];
              await this.getRubro(i);
              Navigator.of(context).pushReplacement(RootPage.route("expanded", categories[i], dataList, null, categories[i].icono));
            },
            child: ListTile(
              title: Text(t,
                  style: TextStyle(
                    fontSize: 20,
                  )),
              trailing: Icon(categories[i].icono),
              contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            ),
          ),
        ));
  }
}
