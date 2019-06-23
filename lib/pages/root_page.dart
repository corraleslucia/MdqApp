import 'package:flutter/material.dart';
import 'package:mdq/models/category.dart';
import 'package:mdq/pages/detail_page.dart';
import 'package:mdq/pages/login_signup_page.dart';
import 'package:mdq/services/authentication.dart';
import 'package:mdq/pages/home_categories.dart';
import 'package:mdq/pages/home_admin.dart';

import 'category_expanded.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth, this.page, this.category, this.elements});

  final BaseAuth auth;
  final String page;
  final Category category;
  final List elements;

  @override
  State<StatefulWidget> createState() => new _RootPageState();

  static Route<dynamic> route(String pageTo, Category cat, List elem) {
    return MaterialPageRoute(
      builder: (context) => RootPage(auth: new Auth(), page: pageTo, category: cat, elements: elem),
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
    widget.auth.getCurrentUser().then((user){
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
      Navigator.of(context).pushReplacement(RootPage.route("home", null, null));
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
        if(_userId.length > 0 && _userId == "J52c3lPyAvZSASo80BzEoJBwJ3J3"){
          return new HomePageAdmin(
                userId: _userId,
                auth: widget.auth,
                onSignedOut: _onSignedOut,
              );
        }
        else if (_userId.length > 0 && _userId != null) {
          switch (widget.page){
            case "home":
              return new HomePage(
                userId: _userId,
                auth: widget.auth,
                onSignedOut: _onSignedOut,
              );
              break;
            case "expanded":
              return CategoryExpanded(
                  userId: _userId,
                  auth: widget.auth,
                  onSignedOut: _onSignedOut,
                  category: widget.category,
                  hotelsData: widget.elements
              );
            case "detail":
              return DetailPage(
                userId: _userId,
                auth: widget.auth,
                onSignedOut: _onSignedOut,
                latitude: 38,
                longitude: 38,
                mail: "hotelmalada@gmail.com",
                name: "Hotel Malada",
                phoneNumber: "+549223004466",
                street: "Av. Pedro Luro",
                streetNumber: 5669,
              );
              break;
            default:
              return new HomePage(
                userId: _userId,
                auth: widget.auth,
                onSignedOut: _onSignedOut,
              );
          }
        } else return _buildWaitingScreen();
        break;
      default:
        return _buildWaitingScreen();
    }
  }
}