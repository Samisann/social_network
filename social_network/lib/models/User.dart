import 'Hobby.dart';

class User {
  String email;
  String nom;
  String prenom;
  String telephone;
  String password;
  List<Hobby> hobbies;

  User({
    this.email = '',
    this.nom = '',
    this.prenom = '',
    this.telephone = '',
    this.password = '',
    this.hobbies = const [],
  });
}
