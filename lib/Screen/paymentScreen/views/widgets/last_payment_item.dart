import 'package:flutter/material.dart';
import 'package:goma/Screen/api_path.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../../utils/helpers/helper_functions.dart';
import '../../../../utils/theme/widget_themes/text_theme.dart';

class LastPaymentItems extends StatefulWidget {

  const LastPaymentItems({super.key});

  @override
  _LastPaymentItemsState createState() => _LastPaymentItemsState();
}

class _LastPaymentItemsState extends State<LastPaymentItems> {

  bool isLoading = true;
  bool hasError = false;
  String _ownerId='';
  String _userToken='';
  String title='';
  String date='';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    fetchPaymentHistory();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _ownerId= prefs.getString('OwnerId') ?? '';
      _userToken= prefs.getString('accessToken')?? '';
    });
  }

  Future<void> fetchPaymentHistory() async {
    final url = '$AuthenticationUrl/documents/owner/$_ownerId';
    
    try {
      final response = await http.get(Uri.parse(url), headers: {"Authorization":"JWT $_userToken"});
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          title = data['document_type'];
          date = data['renewal_date'];
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var tTextTheme = THelperFunctions.isDarkMode(context)
        ? TTextTheme.darkTextTheme
        : TTextTheme.lightTextTheme;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 20.0,
        color: Colors.blue,
        child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? const Center(child: Text('Error loading your payment history'))
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(title, style: tTextTheme.titleLarge,),
                        Text('description', style: tTextTheme.bodySmall,),
                      ],
                    ),
                    Text(date, style: tTextTheme.headlineLarge,)
                  ],
              )
      ),
    );
  }
}