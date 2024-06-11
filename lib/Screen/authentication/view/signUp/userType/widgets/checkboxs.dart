import 'package:flutter/material.dart';
import 'package:goma/Screen/authentication/view/signUp/I_RegistrationForm/IndividualRegistration.dart';
import 'package:goma/Screen/authentication/view/signUp/companyRegistrationPage/companyRegistration.dart';
import 'package:goma/Screen/start_pages/views/landing_page/widgets/login_btn_widget.dart';

class SelectUserType extends StatefulWidget {
  const SelectUserType({super.key});

  @override
  State<SelectUserType> createState() => _SelectUserTypeState();
}

class _SelectUserTypeState extends State<SelectUserType> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0), // Adds padding around the Column
      child: Column(
        children: [
          DarkBgButtonWidget(
            text: 'Individual',
            screen: I_RegistrationForm(),
          ),
          SizedBox(height: 16.0), // Adds space between the buttons
          DarkBgButtonWidget(
            text: 'Company',
            screen: C_RegistrationForm(),
          ),
        ],
      ),
    );
  }
}
