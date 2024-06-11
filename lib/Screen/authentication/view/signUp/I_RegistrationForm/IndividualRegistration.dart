import 'package:flutter/material.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../../utils/theme/theme.dart';
import 'widgets/inputForm.dart';

class I_RegistrationForm extends StatelessWidget {
  const I_RegistrationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold( body: SafeArea(

      child:  InputForm(),
    ));
  }
}
