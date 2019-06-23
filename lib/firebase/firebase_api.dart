import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireBaseAPI {
  static Stream<QuerySnapshot> categoryStream =
      Firestore.instance.collection('categories').snapshots();

  static CollectionReference reference =
      Firestore.instance.collection('categories');

  static addCategory(
      String name, String url, String token, String method, String icon) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.add({
        "name": name,
        "url": url,
        "method": method,
        "token": token,
        "icon": icon
      });
    });
  }

  static removeCategory(String id) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.document(id).delete().catchError((error) {
        print(error);
      });
    });
  }

  static updateCategory(String id, String newName, String newUrl,
      String newToken, String newMethod, String newIcon) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.document(id).updateData({
        "name": newName,
        "url": newUrl,
        "token": newToken,
        "method": newMethod,
        "icon": newIcon
      }).catchError((error) {
        print(error);
      });
    });
  }
}
