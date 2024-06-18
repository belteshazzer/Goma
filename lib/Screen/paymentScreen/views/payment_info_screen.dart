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
import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:shimmer/shimmer.dart';

class PaymentInformationScreen extends StatefulWidget {
  const PaymentInformationScreen(
      {super.key,
      required this.vehicle,
      this.docType,
      required this.userToken});
  final Vehicle vehicle;
  final String? docType;
  final String userToken;

  @override
  _PaymentInformationScreenState createState() => _PaymentInformationScreenState();
}

class _PaymentInformationScreenState extends State<PaymentInformationScreen> {
  Future<Document?>? _documentFuture;
  double amount = 0.0;

  @override
  void initState() {
    super.initState();
    _documentFuture = DocumentFetcher.fetchDocument(widget.vehicle.chassisNumber, widget.docType!, widget.userToken);
    _documentFuture!.then((document) {
      if (document != null) {
        setState(() {
          amount = document.fee;
        });
      }
    });
  }

  Future<void> verifyPayment(String txRef) async {
    try {
      Map<String, dynamic> verificationResult =
          await Chapa.getInstance.verifyPayment(
        txRef: txRef,
      );

      // Process the verification result
      if (verificationResult['status'] == 'success') {
        print('Payment verification successful: $verificationResult');
      } else {
        print('Payment verification failed: $verificationResult');
      }
    } catch (e) {
      print('Exception during payment verification: $e');
    }
  }

  Future<void> startPayment() async {
    try {
      String txRef = TxRefRandomGenerator.generate(prefix: 'goma');
      String? paymentUrl = await Chapa.getInstance.startPayment(
        context: context,
        onInAppPaymentSuccess: (successMsg) async {
          // Handle success events
          await verifyPayment(txRef);

          print("docType: ${widget.docType}");

          if (widget.docType == 'EDVLCA') {
            // Update the payment status of the document
            final url = Uri.parse(
                "$AuthenticationUrl/documents/renew_road_authority/${widget.vehicle.chassisNumber}/");
            final body = json.encode({'transaction_code': txRef});

            final http.Response response = await http.put(url,
                headers: {
                  "Authorization": "JWT ${widget.userToken}",
                  "Content-Type": "application/json"
                },
                body: body);
            if (response.statusCode == 200) {
              print('EDVLCA Payment status updated successfully');
            } else {
              print('EDVLCA Failed to update payment status');
            }
          } else if (widget.docType == 'Insurance') {
            final url = Uri.parse(
                "$AuthenticationUrl/documents/renew_insurance/${widget.vehicle.chassisNumber}/");

            final body = json.encode({'transaction_code': txRef});

            final http.Response response = await http.put(url,
                headers: {
                  "Authorization": "JWT ${widget.userToken}",
                  "Content-Type": "application/json"
                },
                body: body);
            print("response: ${response.body} ${response.statusCode}");

            if (response.statusCode == 200) {
              print('Insurance Payment status updated successfully');
            } else {
              print('Insurance Failed to update payment status');
            }
          } else if (widget.docType == 'Road Fund') {
            final url = Uri.parse(
                "$AuthenticationUrl/documents/renew_road_fund/${widget.vehicle.chassisNumber}/");
            final body = json.encode({'transaction_code': txRef});

            final http.Response response = await http.put(url,
                headers: {
                  "Authorization": "JWT ${widget.userToken}",
                  "Content-Type": "application/json"
                },
                body: body);
            if (response.statusCode == 200) {
              print('Road Fund Payment status updated successfully');
            } else {
              print('Road Fund Failed to update payment status');
            }
          }
          print('Payment successful: $successMsg');
        },
        onInAppPaymentError: (errorMsg) {
          // Handle error
          print('Payment error: $errorMsg');
        },
        amount: amount.toString(),
        currency: 'ETB',
        txRef: txRef,
      );

      if (paymentUrl != null) {
        // You can open the paymentUrl in a WebView or an external browser
        print('Payment URL: $paymentUrl');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = THelperFunctions.isDarkMode(context)
        ? TTextTheme.darkTextTheme
        : TTextTheme.lightTextTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.docType!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Payment Information', style: textTheme.titleMedium),
              const Text(
                  'Your Road authority payment information is given below, please review it and click on "Pay With Chapa" to continue the transaction'),
              PaymentDetailBox(
                chassisNumber: widget.vehicle.chassisNumber,
                docType: widget.docType,
              ),
              ElevatedButton(
                  onPressed: startPayment, child: const Text('Pay With Chapa')),
              TextButton(
                  onPressed: () {
                    THelperFunctions.navigateToScreen(
                        context,
                        VehicleSelection(
                          docType: widget.docType!,
                        ));
                  },
                  child: const Text('Cancel'))
            ]),
      ),
    );
  }
}

class PaymentDetailBox extends StatefulWidget {
  const PaymentDetailBox(
      {super.key, required this.chassisNumber, required this.docType});

  final String chassisNumber;
  final String? docType;

  @override
  State<PaymentDetailBox> createState() => _PaymentDetailBoxState();
}

class _PaymentDetailBoxState extends State<PaymentDetailBox> {
  String? _userId = '';
  String? _userToken = '';
  Map<String, dynamic>? user;
  Future<Document?>? _documentFuture;

  Future<void> _getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('ownerId');
    _userToken = prefs.getString('accessToken');

    final url = Uri.parse("$AuthenticationUrl/users/in/create/$_userId/");
    final http.Response response =
        await http.get(url, headers: {"Authorization": "JWT $_userToken"});

    print("response ${response.body} ${response.statusCode}");
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        user = responseData;
        _documentFuture = DocumentFetcher.fetchDocument(widget.chassisNumber, widget.docType!, _userToken!);
      });
    } else {
      // Handle the case when the status code is not 200
      print("request failed");
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    Color textColor =
        THelperFunctions.isDarkMode(context) ? TColors.white : TColors.dark;
    return FutureBuilder<Document?>(
        future: _documentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerEffect();
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching document'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No document found'));
          } else {
            Document document = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Table(
                  border: TableBorder.all(color: Colors.transparent),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Full Name',
                                style: TextStyle(color: textColor)),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                '${user?['first_name']} ${user?['middle_name']}',
                                style: TextStyle(color: textColor)),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('plate Number',
                                style: TextStyle(color: textColor)),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(document.plateNumber,
                                style: TextStyle(color: textColor)),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                          
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Document type',
                                style: TextStyle(color: textColor)),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.docType!,
                                style: TextStyle(color: textColor)),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Deadline',
                                style: TextStyle(color: textColor)),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(document.expiryDate,
                                style: TextStyle(color: textColor)),
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
                            child: Text('\$${document.fee.toStringAsFixed(2)}',
                                style: TextStyle(color: textColor)),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Payment Status',
                                style: TextStyle(color: textColor)),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('undetermined',
                                style: TextStyle(color: textColor)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          }
        });
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Table(
        border: TableBorder.all(color: Colors.transparent),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 100,
                    height: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 100,
                    height: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 100,
                    height: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 100,
                    height: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          // Add more rows as necessary
        ],
      ),
    );
  }
}

class DocumentFetcher {
  static Future<Document?> fetchDocument(String chassisNumber, String docType, String userToken) async {
    String apiUrl = '';
    if (docType == 'EDVLCA') {
      apiUrl = '$AuthenticationUrl/documents/renew_road_authority/$chassisNumber/';
    } else if (docType == 'Insurance') {
      apiUrl = '$AuthenticationUrl/documents/renew_insurance/$chassisNumber/';
    } else if (docType == 'Road Fund') {
      apiUrl = '$AuthenticationUrl/documents/renew_road_fund/$chassisNumber/';
    }

    try {
      final http.Response response = await http.get(Uri.parse(apiUrl),
          headers: {"Authorization": "JWT $userToken"});

      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);
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


