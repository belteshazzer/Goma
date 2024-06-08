import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../utils/helpers/helper_functions.dart';
import '../../../../utils/theme/widget_themes/text_theme.dart';

class LastPaymentItem extends StatefulWidget {
  final String userId;

  const LastPaymentItem({super.key, required this.userId});

  @override
  _LastPaymentItemState createState() => _LastPaymentItemState();
}

class _LastPaymentItemState extends State<LastPaymentItem> {
  late String title;
  late String date;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchLastPayment();
  }

  Future<void> fetchLastPayment() async {
    final url = 'https://g-notify-user-auth-eb39843fac64.herokuapp.com/user/${widget.userId}/last-payment';
    
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          title = data['title'];
          date = data['date'];
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
                ? const Center(child: Text('Error loading payment data'))
                : ListTile(
                    title: Text(title, style: tTextTheme.titleMedium),
                    subtitle: Text(
                      date,
                      style: tTextTheme.bodySmall,
                    ),
                    onTap: () {},
                  ),
      ),
    );
  }
}
