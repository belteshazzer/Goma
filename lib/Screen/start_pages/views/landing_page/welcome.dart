import 'package:flutter/material.dart';
import 'package:goma/utils/constants/text_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/theme/theme.dart';
import '../../../../utils/theme/widget_themes/text_theme.dart';
import '../../../authentication/view/signUp/userType/user_type.dart';
import 'widgets/transition_btn_widget.dart';
import 'widgets/login_btn_widget.dart';
import 'widgets/logo_widget.dart';

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
          final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
          final textTheme = isDarkMode ? TTextTheme.darkTextTheme : TTextTheme.lightTextTheme;

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
                  const TransitionButton(destination: ChooseUserType(), label: 'create account'),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  const LogInBtnWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
