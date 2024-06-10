import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl for date formatting
import 'package:goma/Screen/vehicle/widgets/vehicle_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants/colors.dart';
import '../api_path.dart';
import 'vehicle_model.dart'; // Make sure this is the correct path
import 'package:http/http.dart' as http;
import 'dart:convert';

class VehicleDetail extends StatefulWidget {
  final Vehicle vehicle;

  const VehicleDetail({Key? key, required this.vehicle}) : super(key: key);

  @override
  State<VehicleDetail> createState() => _VehicleDetailState();
}

class _VehicleDetailState extends State<VehicleDetail> {
  String _userToken = "";
  List<Map<String, dynamic>> documents = [];

  @override
  void initState() {
    super.initState();
    loadDocs();
  }

  Future<void> loadDocs() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    _userToken = pref.getString('accessToken') ?? '';

    final uri = Uri.parse("$AuthenticationUrl/documents/vehicle/${widget.vehicle.id}/");

    try {
      final response = await http.get(uri, headers: {"Authorization": "JWT $_userToken"});

      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        if (response.body.isNotEmpty) {
          final List<dynamic> jsonBody = json.decode(response.body);
          print('JSON Body: $jsonBody');
          setState(() {
            documents = List<Map<String, dynamic>>.from(jsonBody);
          });
        } else {
          print('No documents found');
        }
      } else {
        print('Failed to load documents. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching documents: $error');
    }
  }

  String calculateDaysLeft(String expiryDate) {
    DateTime now = DateTime.now();
    DateTime expiry = DateTime.parse(expiryDate);
    Duration difference = expiry.difference(now);

    if (difference.isNegative) {
      return 'Expired';
    } else {
      return '${difference.inDays} days left';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    bool isDarkMode = theme.brightness == Brightness.dark;
    const Color primaryColor = TColors.primary;
    final Color darkColor = isDarkMode ? TColors.primary.withOpacity(.3) : const Color.fromARGB(255, 253, 253, 253);
    final Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Details',),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Vehicle Details Card
                VehicleDetailsCard(vehicle: widget.vehicle, darkColor: darkColor, textColor: textColor),
                const SizedBox(height: 20.0),
                // Documents to Renew Card
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  color: darkColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Documents to Renew',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 20.0),
                        // Add your table for documents to renew here
                        _buildRenewalDocumentTable(textColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRenewalDocumentTable(Color textColor) {
    return Table(
      border: TableBorder.all(color: Colors.transparent), // Remove table outline
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: const BoxDecoration( // Set background color for table header
            color: Colors.blue, // Change this color to your desired background color
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Document',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Deadline',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Status',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
        for (var doc in documents)
          TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(doc['document_type'], style: TextStyle(color: textColor)),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(doc['expiry_date'], style: TextStyle(color: textColor)),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(calculateDaysLeft(doc['expiry_date']), style: TextStyle(color: textColor)),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
