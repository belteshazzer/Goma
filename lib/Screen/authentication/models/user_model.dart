
class UserModel {
  String username;
  String first_name;
  String middle_name;
  String last_name;
  Contact contact;

  UserModel({
    required this.username,
    required this.first_name,
    required this.middle_name,
    required this.last_name,
    required this.contact,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'first_name': first_name,
      'middle_name': middle_name,
      'last_name': last_name,
      'contact': contact.toJson(),
    };
  }
}

class Contact {
  String? phone_number;
  String city;

  Contact({this.phone_number, this.city = ''});

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phone_number,
      'city': city,
    };
  }
}
