import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goma/Screen/vehicle/vehicle_model.dart';
import 'package:goma/utils/constants/colors.dart';
import 'package:goma/utils/helpers/helper_functions.dart';
import 'package:goma/utils/theme/widget_themes/text_theme.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_path.dart';
import 'vehicle_selections.dart';
import 'document_model.dart';

class PaymentInformationScreen extends StatelessWidget {

  const PaymentInformationScreen({super.key, required this.vehicle, this.docType});
  final Vehicle vehicle;
  final String? docType  ;

  @override
  Widget build(BuildContext context) {
    final textTheme=THelperFunctions.isDarkMode(context)? TTextTheme.darkTextTheme : TTextTheme.lightTextTheme;
    
    return Scaffold(
      appBar: AppBar(title:  Text(docType!),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Payment Information', style: textTheme.titleMedium),
          const Text('Your Road authority payment information is given bellow, please review it and click on "Pay With" to continue the transaction'),
          PaymentDetailBox(chassisNumber: vehicle.chassisNumber),
          ElevatedButton(onPressed: () async {
              // await initiatePayment(context, vehicle.chassis_number);
            },
             child: const Text('Pay With')),
          TextButton(onPressed: (){THelperFunctions.navigateToScreen(context,  EDVLCAVehicleSelection(docType: docType!,));}, child: const Text('Cancel'))
        ]
      ),
    );
  }
}

class PaymentDetailBox extends StatefulWidget {
  const PaymentDetailBox({super.key, required this.chassisNumber});

  final String chassisNumber;
  @override
  State<PaymentDetailBox> createState() => _PaymentDetailBoxState();
}

class _PaymentDetailBoxState extends State<PaymentDetailBox> {

  String? _userId = '';
  String? _userToken ='';
  Map<String, dynamic>? user;
  late Future<Document?> _documentFuture; 

  Future<void> _getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('ownerId');
    _userToken = prefs.getString('accessToken');

    final url = Uri.parse("$AuthenticationUrl/users/in/create/$_userId/");
    final http.Response response = await http.get(url, headers: {"Authorization": "JWT $_userToken"});
    
    print("response ${response.body} ${response.statusCode}");
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        user = responseData;
    _documentFuture= fetchDocument(widget.chassisNumber);

      });
    } else {
      // Handle the case when the status code is not 200
      print("request failed");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = THelperFunctions.isDarkMode(context) ? TColors.white : TColors.dark;
    return  FutureBuilder<Document?>(
      future: _documentFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching document'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No document found'));
        } else {
          Document document = snapshot.data!;
          return Table(
            border: TableBorder.all(color: Colors.transparent), 
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
       
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Full Name', style: TextStyle(color: textColor)),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${user?['first_name']} ${user?['middle_name']}', style: TextStyle(color: textColor)),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('plate Number', style: TextStyle(color: textColor)),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(document.plateNumber, style: TextStyle(color: textColor)),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Document type', style: TextStyle(color: textColor)),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('EDVLCA payment', style: TextStyle(color: textColor)),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Deadline', style: TextStyle(color: textColor)),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(document.expiryDate, style: TextStyle(color: textColor)),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Amount', style: TextStyle(color: textColor)),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(document.fee.toString(), style: TextStyle(color: textColor)),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Payment Status', style: TextStyle(color: textColor)),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('undetermined', style: TextStyle(color: textColor)),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      }
    );
  }

   Future<Document?> fetchDocument(String chassisNumber) async {        
    String apiUrl = '$AuthenticationUrl/documents/renew_road_fund/$chassisNumber/';
    print("CHASSIS ${chassisNumber}");

    try {
      final http.Response response = await http.get(Uri.parse(apiUrl),headers: {"Authorization":"JWT $_userToken"});
      print(_userToken);

      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);
        print(response.body);
        return Document.fromJson(body);
      } else if (response.statusCode == 400) {
        Map<String, dynamic> body = json.decode(response.body);
        print('Error: ${body['Message']}');
        return null;
      } else {
        print('Failed to load document. Status Code: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error fetching document: $error');
      return null;
    }
  }
}