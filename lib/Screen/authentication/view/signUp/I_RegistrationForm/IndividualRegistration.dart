import 'package:flutter/material.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../../utils/theme/theme.dart';
import 'widgets/inputForm.dart';

class I_RegistrationForm extends StatelessWidget {
  const I_RegistrationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black), // Change the color of the back button and other icons
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20), // Change the color of the title text
        elevation: 0, // Remove the shadow below the app bar if desired
      ),
      body: const InputForm(),
    );
  }
}
