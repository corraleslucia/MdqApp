import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String name;
  final DocumentReference reference;

  Category.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        name = map['name'];

  Category.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => name;
}