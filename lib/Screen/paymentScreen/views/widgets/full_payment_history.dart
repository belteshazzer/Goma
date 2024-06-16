import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import '../../../api_path.dart';

class FullPaymentHistoryPage extends StatefulWidget {
  @override
  _FullPaymentHistoryPageState createState() => _FullPaymentHistoryPageState();
}

class _FullPaymentHistoryPageState extends State<FullPaymentHistoryPage> {
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
      fetchFullPaymentHistory();
    });
  }

  Future<void> fetchFullPaymentHistory() async {
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
      print('Failed to load full payment history');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Full Payment History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _isLoading ? _buildShimmerEffect() : _buildFullPaymentHistoryList(isDarkMode),
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
              side: BorderSide(color: Colors.grey),
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

  Widget _buildFullPaymentHistoryList(bool isDarkMode) {
    return _paymentHistory.isEmpty
        ? Center(child: Text('No full payment history found'))
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
                ),
              );
            },
          );
  }
}

class LastPaymentHistory {
  final String documentType;
  final String renewalDate;

  LastPaymentHistory({required this.documentType, required this.renewalDate});

  factory LastPaymentHistory.fromJson(Map<String, dynamic> json) {
    return LastPaymentHistory(
      documentType: json['document_type'] as String,
      renewalDate: json['renewal_date'] as String,
    );
  }
}
