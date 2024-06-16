import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:goma/Screen/api_path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class PaymentHistoryPage extends StatefulWidget {
  @override
  _PaymentHistoryPageState createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  String _ownerId = '';
  String _userToken = '';
  List<LastPaymentHistory> _paymentHistory = [];
  bool _isLoading = true;

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
    final response = await http.get(Uri.parse(url), headers: {"Authorization": "JWT $_userToken"});
    print("response: ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _paymentHistory = data.map((item) => LastPaymentHistory.fromJson(item)).toList();
        _isLoading = false;
      });
    } else {
      // Handle error
      print('Failed to load payment history');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _generateAndDownloadFile(String documentId) async {
    final url = '$AuthenticationUrl/files/gen_files/$documentId';
    final response = await http.get(Uri.parse(url), headers: {"Authorization": "JWT $_userToken"});
    final directory = await getExternalStorageDirectory();
    final savePath ='${directory!.path}/$documentId.pdf'; // Save file with .pdf extension

    if (response.statusCode == 200) {
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: directory.path,
        fileName: '$documentId.pdf', // Save file with .pdf extension
        showNotification: true,
        openFileFromNotification: true,
      );

      FlutterDownloader.registerCallback((id, status, progress) {
        if (taskId == id && status == DownloadTaskStatus.complete) {
          print('Download task is complete');
          // Handle file download completion
        }
      });
      print('File downloaded successfully');
    } else {
      // Handle error based on response status code
      if (response.statusCode == 404) {
        print('File not found');
      } else {
        print('Failed to download file');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _isLoading ? _buildShimmerEffect() : _buildPaymentHistoryList(isDarkMode),
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
            itemCount: _paymentHistory.length,
            itemBuilder: (context, index) {
              final history = _paymentHistory[index];
              return Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: isDarkMode ? Colors.white : Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(
                    history.documentType,
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  subtitle: Text(
                    'Renewal Date: ${history.renewalDate}',
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  trailing: TextButton(
                    onPressed: () {
                      _generateAndDownloadFile(history.documentId); // Pass documentId here
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
}

class LastPaymentHistory {
  final String documentId; // Assuming you have documentId in LastPaymentHistory
  final String documentType;
  final String renewalDate;

  LastPaymentHistory({required this.documentId, required this.documentType, required this.renewalDate});

  factory LastPaymentHistory.fromJson(Map<String, dynamic> json) {
    return LastPaymentHistory(
      documentId: json['id'] as String, // Adjust field name as per your JSON
      documentType: json['document_type'] as String,
      renewalDate: json['renewal_date'] as String,
    );
  }
}
