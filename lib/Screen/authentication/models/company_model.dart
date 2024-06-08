
class CompanyModel {
  String username;
  String company_name;
  Contact contact;

  CompanyModel({
    required this.username,
    required this.company_name,
    required this.contact,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'company_name': company_name,
      'contact': contact.toJson(),
    };
  }
}

class Contact {
  String phone_number;
  String city;

  Contact({this.phone_number='', this.city = ''});

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phone_number,
      'city': city,
    };
  }
}
