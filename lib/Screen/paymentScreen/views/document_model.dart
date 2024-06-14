class Document {
  final String chassisNumber;
  final String plateNumber;
  final String expiryDate;
  final double fee;

  Document({
    required this.chassisNumber,
    required this.plateNumber,
    required this.expiryDate,
    required this.fee,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      chassisNumber: json['chassis_number'],
      plateNumber: json['plate_number'],
      expiryDate: json['expiry_date'
      ],
      fee: json['fee'],
    );
  }
}