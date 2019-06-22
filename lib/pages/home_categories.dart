import 'package:flutter/material.dart';
import 'package:mdq/models/category.dart';
import 'package:mdq/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mdq/widgets/SliverAppbar.dart';
import 'package:mdq/pages/category_expanded.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

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

  Map data;
  List dataList;
  Category category;

  List<Category> categories;
  bool _isEmailVerified = false;
  List<ListTile> elements = new List();
  @override
  void initState() {
    super.initState();
    categories = new List();
    categories.add(new Category(
        "Hoteles",
        "http://turismomardelplata.gov.ar/WS20/TurismoWS.svc/Hotel/Buscar",
        "12345678901234567890123456789012",
        "POST",
        Icons.hotel));
    /*categories.add(new Category(
        "Gastronomia",
        "http://turismomardelplata.gov.ar/WS20/TurismoWS.svc/Gastronomia/Buscar",  // NO TRAE INFO
        "12345678901234567890123456789012",
        "POST",
        Icons.restaurant));
    categories.add(new Category(
        "Museos",
        "http://turismomardelplata.gov.ar/WS20/TurismoWS.svc/Museo/Buscar",  // NO TRAE INFO
        "12345678901234567890123456789012",
        "POST",
        Icons.account_balance));*/
    categories.add(new Category(
        "Playas",
        "http://turismomardelplata.gov.ar/WS20/TurismoWS.svc/Playa/Buscar",
        "12345678901234567890123456789012",
        "POST",
        Icons.beach_access));
    categories.add(new Category(
        "Transportes",
        "http://turismomardelplata.gov.ar/WS20/TurismoWS.svc/Transporte/Buscar",
        "12345678901234567890123456789012",
        "POST",
        Icons.directions_bus));
    //categories.add(new Category("Lugares", "", "", "", Icons.place));
    categories.add(new Category(
        "Inmobiliarias",
        "http://turismomardelplata.gov.ar/WS20/TurismoWS.svc/Inmobiliaria/Buscar",
        "12345678901234567890123456789012",
        "POST",
        Icons.location_city));
    categories.add(new Category(
        "Eventos",
        "http://turismomardelplata.gov.ar/WS20/TurismoWS.svc/Evento/Buscar",
        "12345678901234567890123456789012",
        "POST",
        Icons.event));
    categories.add(new Category(
        "Salones",
        "http://turismomardelplata.gov.ar/WS20/TurismoWS.svc/Congreso/Buscar",
        "12345678901234567890123456789012",
        "POST",
        Icons.business));
    categories.add(new Category(
        "Agencias",
        "http://turismomardelplata.gov.ar/WS20/TurismoWS.svc/Agencia/Buscar",
        "12345678901234567890123456789012",
        "POST",
        Icons.airplanemode_active));
    this.dataList = new List();

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
//      appBar: new AppBar(
//        title: new Text('MDQ APP'),
//        actions: <Widget>[
//          new FlatButton(
//              child: new Text('Logout',
//              style: new TextStyle(fontSize: 17.0, color: Colors.white)),
//              onPressed: _signOut)
//        ],
//      ),
//      body: getListView(),
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

  var bodyHotel = json.encode({
    "Token": "12345678901234567890123456789012",
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

  var bodyInmobiliaria = json.encode({
    "Token": "12345678901234567890123456789012",
    "PagNumero": "",
    "RegsXPag": "",
    "LatCentro": "-38.0003561526665",
    "LongCentro": "-57.5495535981007",
    "DistCentro": "10000",
    "IdZonaOperacion": "",
    "SoloConAlquilerTuristico": "false",
    "Nombre": ""
  });

  var bodyAgencia = json.encode({
    "Token": "12345678901234567890123456789012",
    "PagNumero": "",
    "RegsXPag": "",
    "LatCentro": "-38.0003561526665",
    "LongCentro": "-57.5495535981007",
    "DistCentro": "10000",
    "IdCategoria": "",
    "IdTipoOperacion": "",
    "Nombre": ""
  });

  var bodyTransporte = json.encode({
    "Token": "12345678901234567890123456789012",
    "PagNumero": "",
    "RegsXPag": "",
    "LatCentro": "-38.0003561526665",
    "LongCentro": "-57.5495535981007",
    "DistCentro": "10000",
    "IdTipoMedio": "",
    "IdDestino": "",
    "Nombre": ""
  });

  var bodyCongreso = json.encode({
    "Token": "12345678901234567890123456789012",
    "PagNumero": "",
    "RegsXPag": "",
    "LatCentro": "-38.0003561526665",
    "LongCentro": "-57.5495535981007",
    "DistCentro": "10000",
    "Capacidad": "",
    "Nombre": ""
  });

  var bodyPlaya = json.encode({
    "Token": "12345678901234567890123456789012",
    "PagNumero": "",
    "RegsXPag": "",
    "LatCentro": "-38.0003561526665",
    "LongCentro": "-57.5495535981007",
    "DistCentro": "10000",
    "IdZona": "",
    "IdAccesibilidad": "",
    "Nombre": ""
  });

  var bodyEvento = json.encode({
    "Token" : "12345678901234567890123456789012",
    "PagNumero":"",
    "RegsXPag" :"",
    "IdCategoria" :"",
    "IdSubCategoria" :"",
    "FechaDesde" :"20190622",
    "FechaHasta" :"20190822",
    "Nombre":""
  });

  Future<String> getRubro(String rubro) async {
    //var response;

    var body;

    switch (rubro) {
      case "Hoteles":
        body = bodyHotel;
        break;

      case "Inmobiliarias":
        body = bodyInmobiliaria;
        break;

      case "Agencias":
        body = bodyAgencia;
        break;

      case "Transportes":
        body = bodyTransporte;
        break;

      case "Salones":
        body = bodyCongreso;
        break;

      case "Playas":
        body = bodyPlaya;
        break;

      case "Eventos":
        body = bodyEvento;
        break;
    }

    var response = await http.post(this.category.url,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: body);

    var data = json.decode(response.body);
    dataList = data[this.category.name]; // guardo toda la data de "Hoteles"
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

              await this.getRubro(this.category.name);

              await Navigator.of(context).pushReplacement(
                  CategoryExpanded.route(
                      categories[i],
                      dataList,
                      this.widget.auth,
                      this.widget.onSignedOut,
                      this.widget.userId));
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
