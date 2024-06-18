class Document {
  final String chassisnumber;
  final String platenumber;
  final String expiryDate;
  final double fee;

  Document({
    required this.chassisnumber,
    required this.platenumber,
    required this.expiryDate,
    required this.fee,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      chassisnumber: json['chassis_number'],
      platenumber: json['plate_number'],
      expiryDate: json['expiry_date'
      ],
      fee: json['fee'],
    );
  }
}