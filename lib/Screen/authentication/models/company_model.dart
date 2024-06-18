class Contact {
  final String phoneNumber;
  final String city;

  Contact({required this.phoneNumber, required this.city});

  Map<String, dynamic> toJson() => {
        'phone_number': phoneNumber,
        'city': city,
      };
}

class CompanyModel {
  final String username;
  final String companyName;
  final Contact contact;

  CompanyModel({
    required this.username,
    required this.companyName,
    required this.contact,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'company_name': companyName,
        'contact': contact.toJson(),
      };
}
