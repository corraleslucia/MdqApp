import 'package:flutter/material.dart';
import 'package:mdq/models/category.dart';
import 'package:mdq/models/detailElement.dart';
import 'package:mdq/pages/root_page.dart';
import 'package:mdq/services/authentication.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class DetailPage extends StatefulWidget {
  DetailPage(
      {Key key, this.auth, this.userId, this.onSignedOut, this.detail, this.category, this.dataList, this.icon})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  final DetailElement detail;
  final List dataList;
  final Category category;
  final IconData icon; // icono de la categoria para q se mantenga si vuelve atras.

  @override
  State<StatefulWidget> createState() => new _DetailPage();
}

class _DetailPage extends State<DetailPage> {

  GoogleMapController mapController;
  Set<Marker> markers = Set();

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;

      markers.add(
        Marker(
            markerId: MarkerId(widget.detail.name),
            position: LatLng(widget.detail.latitude, widget.detail.longitude),
            infoWindow: InfoWindow(
                title: widget.detail.name,
                snippet: 'Go Here'
            )
        )
      );

    });
  }


  @override
  Widget build(BuildContext context) {
    String name = widget.detail.name != null ? widget.detail.name : "Sin nombre";
    String street = widget.detail.street != null ? widget.detail.street : "Sin calle";
    int streetNumber = widget.detail.streetNumber != null ? widget.detail.streetNumber : 0;
    double latitude = widget.detail.latitude != null ? widget.detail.latitude : -38.0;
    double longitude = widget.detail.longitude != null ? widget.detail.longitude : -57.5;
    String phoneNumber = widget.detail.phoneNumber != null ? widget.detail.phoneNumber : "Sin telefono";
    String mail = widget.detail.mail != null ? widget.detail.mail : "Sin correo electrónico";

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Detalles"),
        backgroundColor: Colors.deepOrange,
        actions: <Widget>[
          new FlatButton(
              child: new Text('Logout',
                  style: new TextStyle(
                      fontSize: 17.0,
                      color: Colors.white)),
                  onPressed: _signOut
          ),
        ],
        leading: IconButton(icon:Icon(Icons.arrow_back),
          onPressed:() => Navigator.of(context).pushReplacement(RootPage.route("expanded", widget.category, widget.dataList, 0, widget.icon))
        )
      ),
      body: new Container(
        color: Colors.deepOrange.withOpacity(0.2),
        padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
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
                    child: new Text( name,
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
                    child: new Text( street + streetNumber.toString(),
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
                    child: new Text( phoneNumber.toString(),
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
                    child: new Text( mail,
                      style: new TextStyle( color: Colors.black,fontWeight: FontWeight.w600,fontSize: 16.0,),
                    ),
                  ),
                ),
              ],
            ),
        new Expanded(
          child: GoogleMap(
              onMapCreated: onMapCreated,
              initialCameraPosition: CameraPosition(target: LatLng(latitude, longitude),
                                                    zoom: 16.0,/* bearing: 192.8334901395799,tilt: 59.440717697143555,*/
              ),
              mapType: MapType.normal,
              markers: markers,
            ),



        ),
          ],
        ),
      ),
    );
  }


  // Metodos para sesion y logout.

  bool _isEmailVerified = false;

  @override
  void initState() {

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
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }
}







