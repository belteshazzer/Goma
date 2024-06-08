import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../../utils/theme/theme.dart';
import '../../../../../utils/theme/widget_themes/elevated_button_theme.dart';
import '../../../../../utils/theme/widget_themes/text_theme.dart';
import '../../../../start_pages/views/landing_page/widgets/logo_widget.dart';
import '../../../controllers/SignUpController/setPasswordController.dart';
import '../../login/login.dart';

class PasswordScreen extends StatelessWidget {
  final String username;
  const PasswordScreen({required this.username, super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<_PasswordAppState> passwordAppKey = GlobalKey();

    return MaterialApp(
      title: 'Set Your Password',
      theme: THelperFunctions.isDarkMode(context) ? TAppTheme.darkTheme : TAppTheme.lightTheme,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const LogoWidget(),
                const SizedBox(height: 20),
                Text(
                  'Password',
                  style: THelperFunctions.isDarkMode(context)
                      ? TTextTheme.darkTextTheme.headlineMedium
                      : TTextTheme.lightTextTheme.headlineMedium,
                ),
                const SizedBox(height: 5),
                Text(
                  'Create your own password to continue',
                  style: THelperFunctions.isDarkMode(context)
                      ? TTextTheme.darkTextTheme.bodySmall
                      : TTextTheme.lightTextTheme.bodySmall,
                ),
                const SizedBox(height: 20),
                PasswordApp(username:username, key: passwordAppKey),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordApp extends StatefulWidget {
  final String username;
  const PasswordApp({required this.username, super.key});

  @override
  State<PasswordApp> createState() => _PasswordAppState();
}

class _PasswordAppState extends State<PasswordApp> {
  late TextEditingController _passwordController1;
  late TextEditingController _passwordController2;

  @override
  void initState() {
    super.initState();
    _passwordController1 = TextEditingController();
    _passwordController2 = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController1.dispose();
    _passwordController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 400,
              child: FancyPasswordField(
                controller: _passwordController1,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 400,
              child: FancyPasswordField(
                controller: _passwordController2,
                validator: (value) {
                  if (_passwordController1.text==_passwordController2.text){
                    return null;
                  }
                  return 'Passwords do not match';
                },
              ),
            ),
            const SizedBox(height: 20),
            Theme(data: Theme.of(context).copyWith(
              elevatedButtonTheme: THelperFunctions.isDarkMode(context)? TElevatedButtonTheme.darkElevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
            ), child: ElevatedButton(
                onPressed: _submitPassword,
                child: const Text('Finish'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitPassword() async {
    String password1 = _passwordController1.text;
    String password2 = _passwordController2.text;
    
    if (password1 == password2) {
      SubmitPassword.submitPassword(widget.username, password1);
      if(SubmitPassword.passwordAccepted){
        THelperFunctions.navigateToScreen(context, const LoginScreen());
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(SubmitPassword.errorMsg??'')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('password doesn\'t match')));
    }
  }
}
