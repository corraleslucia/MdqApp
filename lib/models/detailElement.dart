import 'package:flutter/material.dart';
import 'package:mdq/services/authentication.dart';

class DetailElement {

  BaseAuth auth;
  VoidCallback onSignedOut;
  String userId;
  String name;
  String street;
  int streetNumber;
  double latitude;
  double longitude;
  String phoneNumber;
  String mail;

  DetailElement(this.auth, this.onSignedOut, this.userId, this.name,
      this.street, this.streetNumber, this.latitude, this.longitude,
      this.phoneNumber, this.mail);
}