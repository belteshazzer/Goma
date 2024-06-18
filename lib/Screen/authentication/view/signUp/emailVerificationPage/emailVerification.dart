import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../../utils/theme/theme.dart';
import '../../../../../utils/theme/widget_themes/text_theme.dart';
import '../../../../start_pages/views/landing_page/widgets/logo_widget.dart';
import 'widgets/pinputs.dart';

class EmailVerificationScreen extends StatelessWidget {

  final String email;
  const EmailVerificationScreen({required this.email, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'verify your email',
      theme: THelperFunctions.isDarkMode(context)? TAppTheme.darkTheme: TAppTheme.lightTheme,
      home: Scaffold(
        body:FractionallySizedBox(
          widthFactor: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LogoWidget(),
              const SizedBox(height: 20,),
              Text('Verification', style: THelperFunctions.isDarkMode(context)? TTextTheme.darkTextTheme.headlineMedium:TTextTheme.lightTextTheme.headlineMedium,),
              const SizedBox(height: 20,),
              Text('please enter the code sent to your email', style: THelperFunctions.isDarkMode(context)? TTextTheme.darkTextTheme.bodySmall:TTextTheme.lightTextTheme.bodySmall,),
              const SizedBox(height: 20,),
              Pinputs(username:email),
              const SizedBox(height: 30,),
              TextButton(onPressed: (){}, child: const Text('Didn\'t recieve code?',style: TextStyle(color: TColors.white, fontFamily: 'Poppins', fontWeight: FontWeight.bold,))),
              TextButton(onPressed: (){}, child: const Text('Resend',style: TextStyle(color: TColors.white, fontFamily: 'Poppins', fontWeight: FontWeight.bold,))),
            ],
          )
        ) ,
      ),
    );
  }
}
