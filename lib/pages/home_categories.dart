import 'package:flutter/material.dart';
import 'package:mdq/models/category.dart';
import 'package:mdq/pages/root_page.dart';
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

//  static Route<dynamic> route(Key key, BaseAuth auth, String userId, VoidCallback onSignedOut) {
//    return MaterialPageRoute(
//      builder: (context) => HomePage(key: key, auth: auth, onSignedOut: onSignedOut, userId: userId),
//    );
//  }

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
    categories.add(new Category("Hoteles", "http://turismomardelplata.gov.ar/WS20/TurismoWS.svc/Hotel/Buscar", "12345678901234567890123456789012", "POST", Icons.hotel));
    categories.add(new Category("Gastronomia", "", "", "", Icons.restaurant));
    categories.add(new Category("Museos", "", "", "", Icons.account_balance));
    categories.add(new Category("Playas", "", "", "", Icons.beach_access));
    categories.add(new Category("Transportes", "", "", "", Icons.directions_bus));
    categories.add(new Category("Lugares", "", "", "", Icons.place));
    categories.add(new Category("Inmobiliarias", "", "", "", Icons.home));
    categories.add(new Category("Eventos", "", "", "", Icons.event));
    categories.add(new Category("Congresos", "", "", "", Icons.business));
    categories.add(new Category("Agencias de viajes", "", "", "", Icons.airplanemode_active));
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
                return _buildRow(categories[i].name, i);
              },
              childCount: categories.length,

              ),
            ),
          ],
        )
    );
  }
  var body = json.encode({
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

  Future<String> getCateogorias() async {

    // crear el body que iria segun la peticion q desee buscar

    var response = await http.post(this.category.url,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: body);

    var data = json.decode(response.body);
    dataList = data[this.category.name]; // guardo toda la data de "Hoteles"
  }



  Widget _buildRow(String t, int i){
       return Card(
        color: Colors.white,
        margin: EdgeInsets.fromLTRB(20,10,20,0),
        elevation: 10,
        child: Container(
          height: 100.0,
          child: InkWell(
            splashColor: Colors.deepOrange,
            onTap: () async {
              this.category = categories[i];
              await this.getCateogorias();
              //await Navigator.of(context).pushReplacement(CategoryExpanded.route(widget.key, widget.auth,widget.userId, widget.onSignedOut, categories[i], dataList));
              Navigator.of(context).pushReplacement(RootPage.route("expanded", categories[i], dataList));

              // CONFLICTO MERGE: Ya no es necesario rootear a categoryExpanded. ruteo a rootPage y esa devuelve una categoryExpanded.
              //await Navigator.of(context).pushReplacement(CategoryExpanded.route(categories[i], dataList, this.widget.auth, this.widget.onSignedOut, this.widget.userId));

            },
            child: ListTile(
              title: Text(
                  t,
                  style: TextStyle(
                      fontSize: 20,
                  )),
              trailing: Icon(categories[i].icono),
              contentPadding: EdgeInsets.fromLTRB(20,0,20,0),
            ),
          ),
        )
      );



          
  }

}