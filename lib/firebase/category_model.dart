import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String name;
  final String url;
  final String token;
  final String method;
  final String icon;
  final DocumentReference reference;

  Category.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        name = map['name'],
        assert(map['url'] != null),
        url = map['url'],
        assert(map['token'] != null),
        token = map['token'],
        assert(map['method'] != null),
        method = map['method'],
        assert(map['icon'] != null),
        icon = map['icon'];



  Category.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);


  @override
  String toString() => name;
}