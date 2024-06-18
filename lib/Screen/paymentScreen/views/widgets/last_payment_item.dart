import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:goma/utils/constants/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_file/open_file.dart';

import '../../../api_path.dart';
import 'full_payment_history.dart'; 

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});

  @override
  _PaymentHistoryPageState createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  String _ownerId = '';
  String _userToken = '';
  List<LastPaymentHistory> _paymentHistory = [];
  bool _isLoading = true;
  double _progress = 0.0;
  File? _pdfFile;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _ownerId = prefs.getString('ownerId') ?? '';
      _userToken = prefs.getString('accessToken') ?? '';
      fetchPaymentHistory();
    });
  }

  Future<void> fetchPaymentHistory() async {
    final url = '$AuthenticationUrl/documents/owner/$_ownerId/';
    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {"Authorization": "JWT $_userToken"},
        ),
      );
      print("response: ${response.data}");
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        setState(() {
          _paymentHistory =
              data.map((item) => LastPaymentHistory.fromJson(item)).toList();
          _isLoading = false;
        });
      } else {
        // Handle error
        print('Failed to load payment history');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching payment history: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _generateAndDownloadFile(String documentId) async {
    final url = '$AuthenticationUrl/files/gen_files/$documentId/';

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {"Authorization": "JWT $_userToken"},
          responseType: ResponseType.bytes,
        ),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _progress = received / total;
            });
          }
        },
      );

      if (response.statusCode == 200) {
        final bytes = response.data;
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/goma-${documentId.substring(documentId.length - 5)}.pdf');
        await file.writeAsBytes(bytes);

        setState(() {
          _isLoading = false;
          _pdfFile = file; // Store the file for PDFView
        });

        // Open the file using open_file package
        await OpenFile.open(file.path);
      } else {
        throw 'Failed to download PDF';
      }
    } catch (e) {
      print('Error downloading PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _isLoading
            ? _buildShimmerEffect()
            : Column(
                children: [
                  Expanded(child: _buildPaymentHistoryList(isDarkMode)),
                  _buildViewMoreButton(),
                ],
              ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 3, // Number of shimmer items
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              title: Container(
                width: double.infinity,
                height: 16.0,
                color: Colors.white,
              ),
              subtitle: Container(
                width: double.infinity,
                height: 14.0,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentHistoryList(bool isDarkMode) {
    return _paymentHistory.isEmpty
        ? const Center(child: Text('No history found'))
        : ListView.builder(
            itemCount:2,
            itemBuilder: (context, index) {
              final history = _paymentHistory[index];
              return Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: isDarkMode ? Colors.white : Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(
                    history.documentType,
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  subtitle: Text(
                    'Renewal Date: ${history.renewalDate}',
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  trailing: TextButton(
                    onPressed: () {
                      _generateAndDownloadFile(
                          history.documentId); // Pass documentId here
                    },
                    child: const Text(
                      'Download',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              );
            },
          );
  }

  Widget _buildViewMoreButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FullPaymentHistoryPage()),
          );
        },
        child:  const Text('View More',style: TextStyle(color: TColors.white),),
      ),
    );
  }
}

class LastPaymentHistory {
  final String documentId; // Assuming you have documentId in LastPaymentHistory
  final String documentType;
  final String renewalDate;

  LastPaymentHistory(
      {required this.documentId,
      required this.documentType,
      required this.renewalDate});

  factory LastPaymentHistory.fromJson(Map<String, dynamic> json) {
    return LastPaymentHistory(
      documentId: json['id'] as String, // Adjust field name as per your JSON
      documentType: json['document_type'] as String,
      renewalDate: json['renewal_date'] as String,
    );
  }
}
