import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:goma/utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/theme/theme.dart';
import '../../../../utils/theme/widget_themes/text_theme.dart';
import '../../../api_path.dart';
import '../../../authentication/view/login/login.dart';
import '../../../authentication/view/signUp/userType/user_type.dart';
import 'widgets/login_btn_widget.dart';
import 'widgets/transition_btn_widget.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Goma Notify',
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: Builder(
        builder: (context) {
          final isDarkMode =
              MediaQuery.of(context).platformBrightness == Brightness.dark;
          final textTheme =
              isDarkMode ? TTextTheme.darkTextTheme : TTextTheme.lightTextTheme;

          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Text('G-Notify', style: textTheme.headlineLarge),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  const Text(
                    'Goma Notify System revolutionizes Ethiopia\'s automotive sector by simplifying vehicle service renewals.',
                    style: TextStyle(fontSize: 14.4),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  const TransitionButton(
                      destination: ChooseUserType(), label: 'create account'),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  const DarkBgButtonWidget(
                    text: "Login",
                    screen: LoginScreen(),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  const Divider(),
                  Container(
                      decoration: const BoxDecoration(
                          border: Border.fromBorderSide(
                              BorderSide(color: TColors.info)),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VerifyScreen()));
                          },
                          child: const Text('Guest mode',
                              style: TextStyle(
                                color: TColors.info,
                              ))))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  List<Map<String, String>> _documents = [];

  Future<void> verifyVehicle(String uniqueId) async {
    setState(() {
      _isLoading = true;
      _documents = [];
    });

    String apiUrl = '$AuthenticationUrl/guests/$uniqueId/';
    int retryCount = 0;

    while (retryCount < 3) {
      try {
        final http.Response response = await http.get(Uri.parse(apiUrl));
        print("response ${response.body} status ${response.statusCode}");

        if (response.statusCode == 200) {
          List<dynamic> responseData = json.decode(response.body);
          if (responseData.isEmpty) {
            _showNoDocumentFoundDialog();
            return;
          }
          for (var document in responseData) {
            _documents.add({
              'document_type': document['document_type'],
              'renewal_status': document['renewal_status'].toString(),
              'expiry_date': document['expiry_date'],
            });
          }
          break;
        } else {
          setState(() {
            _documents.add({'error': 'Could not fetch document status.'});
          });
          break;
        }
      } catch (error) {
        retryCount++;
        if (retryCount >= 3) {
          setState(() {
            _documents.add({'error': 'Network error. Please try again later.'});
          });
          break;
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showNoDocumentFoundDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Document Found'),
          content: const Text('No documents were found for the provided unique ID.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = TTextTheme.lightTextTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Vehicle', style: textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              maxLength: 8,
              decoration: const InputDecoration(
                labelText: 'Enter Unique ID',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.length == 8) {
                  verifyVehicle(value);
                }
              },
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : _buildDocumentStatus(),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentStatus() {
    if (_documents.isEmpty) {
      return const Text(
        'Enter a valid unique ID to verify vehicle documents.',
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      );
    }

    return Column(
      children: _documents.map((doc) {
        if (doc.containsKey('error')) {
          return Text(
            doc['error']!,
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          );
        }

        bool isVerified = doc['renewal_status'] == 'true';
        return Card(
          color: isVerified ? Colors.green : Colors.red,
          child: ListTile(
            title: Text(
              doc['document_type']!,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              'Expiry Date: ${doc['expiry_date']}',
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: Icon(
              isVerified ? Icons.check_circle : Icons.error,
              color: Colors.white,
            ),
          ),
        );
      }).toList(),
    );
  }
}
