import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mdq/models/category.dart';

class FireBaseAPI {
  static List<Category> categories;

  static Stream<QuerySnapshot> categoryStream =
      Firestore.instance.collection('categories').snapshots();

  static CollectionReference reference =
      Firestore.instance.collection('categories');

  static final myIcons = <String, IconData>{
    'hotel': Icons.hotel,
    'restaurant': Icons.restaurant,
    'museo': Icons.account_balance,
    'playa': Icons.beach_access,
    'transporte': Icons.directions_bus,
    'lugar': Icons.place,
    'inmobiliaria': Icons.home,
    'evento': Icons.event,
    'congreso': Icons.business,
    'agencia': Icons.airplanemode_active
  };

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

  static List<Category> getCategoriesList() {
    if (categories != null) {
      return categories;
    } else {
      FireBaseAPI.categoryStream.listen((data) => categories = [
            (new Category(
                data.documents[0]['name'],
                data.documents[0]['url'],
                data.documents[0]['token'],
                data.documents[0]['method'],
                myIcons[data.documents[0]['icon']])),
            (new Category(
                data.documents[1]['name'],
                data.documents[1]['url'],
                data.documents[1]['token'],
                data.documents[1]['method'],
                myIcons[data.documents[1]['icon']])),
            (new Category(
                data.documents[2]['name'],
                data.documents[2]['url'],
                data.documents[2]['token'],
                data.documents[2]['method'],
                myIcons[data.documents[2]['icon']])),
            (new Category(
                data.documents[3]['name'],
                data.documents[3]['url'],
                data.documents[3]['token'],
                data.documents[3]['method'],
                myIcons[data.documents[3]['icon']])),
            (new Category(
                data.documents[4]['name'],
                data.documents[4]['url'],
                data.documents[4]['token'],
                data.documents[4]['method'],
                myIcons[data.documents[4]['icon']])),
            (new Category(
                data.documents[5]['name'],
                data.documents[5]['url'],
                data.documents[5]['token'],
                data.documents[5]['method'],
                myIcons[data.documents[5]['icon']])),
            (new Category(
                data.documents[6]['name'],
                data.documents[6]['url'],
                data.documents[6]['token'],
                data.documents[6]['method'],
                myIcons[data.documents[6]['icon']])),
            (new Category(
                data.documents[7]['name'],
                data.documents[7]['url'],
                data.documents[7]['token'],
                data.documents[7]['method'],
                myIcons[data.documents[7]['icon']])),
            (new Category(
                data.documents[8]['name'],
                data.documents[8]['url'],
                data.documents[8]['token'],
                data.documents[8]['method'],
                myIcons[data.documents[8]['icon']]))
          ]);

      return categories;
    }
  }
}
