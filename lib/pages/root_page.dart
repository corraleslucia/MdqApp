import 'package:flutter/material.dart';
import 'package:mdq/models/category.dart';
import 'package:mdq/models/detailElement.dart';
import 'package:mdq/pages/detail_page.dart';
import 'package:mdq/pages/login_signup_page.dart';
import 'package:mdq/services/authentication.dart';
import 'package:mdq/pages/home_categories.dart';
import 'package:mdq/pages/home_admin.dart';
import 'category_expanded.dart';
import 'package:mdq/firebase/firebase_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RootPage extends StatefulWidget {

  RootPage({this.auth, this.page, this.category, this.elements, this.indexToDetailPage, this.iconoCategoria});

  final BaseAuth auth; // sesion
  final String page; // pagina de redireccion
  final Category category; // categoria para lista detalle - expanded
  final List elements; // lista para lista detalle - expanded
  final int indexToDetailPage; // indice del item seleccionado para mostrar detalles
  final IconData iconoCategoria;
  final List<Category> categories = FireBaseAPI.getCategoriesList();

  @override
  State<StatefulWidget> createState() => new _RootPageState();

  static Route<dynamic> route(String pageTo, Category cat, List elem,
      int index, IconData icono) {
    return MaterialPageRoute(
      builder: (context) =>
          RootPage(auth: new Auth(),
              page: pageTo,
              category: cat,
              elements: elem,
              indexToDetailPage: index,
              iconoCategoria: icono
          ),

    );
  }
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
//  Stream<QuerySnapshot> categoryStream ;


  @override
  void initState() {
    super.initState();
    print(widget.page);
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
        user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void _onLoggedIn() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
      Navigator.of(context).pushReplacement(
          RootPage.route("home", null, null, null, null));
    });
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  DetailElement getElementDetails(String name, int index) {

    DetailElement returnValue = new DetailElement();
    print(widget.elements[index]);
    print(widget.elements[index]["Nombre"]);
    switch (name){
      case "Hoteles":
      case "Inmobiliarias":
      case "Agencias":
      case "Transportes":
      case "Salones":
      case "Playas":
      case "Gastronomia":
        returnValue.name = widget.elements[index]["Nombre"];
        returnValue.street = widget.elements[index]["CalleRuta"];
        returnValue.streetNumber = int.parse(widget.elements[index]["AlturaKM"]);
        returnValue.latitude =  double.parse(widget.elements[index]["Latitud"]);
        returnValue.longitude = double.parse(widget.elements[index]["Longitud"]);
        returnValue.phoneNumber = widget.elements[index]["Telefono1"];
        returnValue.phoneNumber = widget.elements[index]["Telefono1"];
        returnValue.mail = widget.elements[index]["Email"];
        break;

      case "Eventos":
//        returnValue.name = widget.elements[index]["Nombre"];
//        returnValue.street = widget.elements[index]["CalleRuta"];
//        returnValue.streetNumber = int.parse(widget.elements[index]["AlturaKM"]);
//        returnValue.latitude =  double.parse(widget.elements[index]["Latitud"]);
//        returnValue.longitude = double.parse(widget.elements[index]["Longitud"]);
//        returnValue.phoneNumber = widget.elements[index]["Telefono1"];
//        returnValue.phoneNumber = widget.elements[index]["Telefono1"];
//        returnValue.mail = widget.elements[index]["Email"];
//        break;
    }
    return returnValue;
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginSignUpPage(
          auth: widget.auth,
          onSignedIn: _onLoggedIn,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId == "J52c3lPyAvZSASo80BzEoJBwJ3J3") {
          return new HomePageAdmin(
            userId: _userId,
            auth: widget.auth,
            onSignedOut: _onSignedOut,
          );
        }
        else if (_userId.length > 0 && _userId != null) {
          switch (widget.page) {
            case "home":
              return new HomePage(
                userId: _userId,
                auth: widget.auth,
                onSignedOut: _onSignedOut,
                categories: widget.categories,
              );
              break;
            case "expanded":

              return CategoryExpanded(
                  userId: _userId,
                  auth: widget.auth,
                  onSignedOut: _onSignedOut,
                  category: widget.category,
                  hotelsData: widget.elements,
                  icon: widget.iconoCategoria,
              );
            case "detail":
              DetailElement de = getElementDetails(widget.category.name, widget.indexToDetailPage);
              print(de.toString());
              return DetailPage(
                userId: _userId,
                auth: widget.auth,
                onSignedOut: _onSignedOut,
                detail: de,
                category: widget.category,
                dataList: widget.elements,
                icon: widget.iconoCategoria,
              );
              break;
            default:
              return new HomePage(
                userId: _userId,
                auth: widget.auth,
                onSignedOut: _onSignedOut,
              );
          }
        } else
          return _buildWaitingScreen();
        break;
      default:
        return _buildWaitingScreen();
    }
  }
}