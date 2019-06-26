
class DetailElement {

  String name;
  String street;
  int streetNumber;
  double latitude;
  double longitude;
  String phoneNumber;
  String mail;

  DetailElement({this.name, this.street, this.streetNumber, this.latitude,
                 this.longitude, this.phoneNumber, this.mail});


  @override
  String toString() {
    return 'DetailElement{name: $name, street: $street, streetNumber: $streetNumber, longitude: $longitude, phoneNumber: $phoneNumber, mail: $mail}';
  }


}