import 'package:flutter/material.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../../utils/theme/widget_themes/text_field_theme.dart';
import '../../../../../utils/theme/widget_themes/text_theme.dart';
import '../I_RegistrationForm/widgets/email_field_widget.dart';
import '../I_RegistrationForm/widgets/textFieldWidget.dart';
import '../I_RegistrationForm/widgets/phone_number_widget.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../userType/widgets/already_have_account.dart';
import 'widgets/create_btn.dart';

class C_RegistrationForm extends StatelessWidget {
  const C_RegistrationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'create company acoount',
      home: InputFields(),
    );
  }
}

class InputFields extends StatefulWidget {
  const InputFields({super.key});

  @override
  State<InputFields> createState() => _InputFieldsState();
}

class _InputFieldsState extends State<InputFields> {
  final formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = List.generate(3, (_) => TextEditingController());
  final PhoneController _phoneNumberController = PhoneController();

  final List<String> _labelTexts = [
    'Company Name',
    'Address',
    'E-mail',
  ];

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: formKey,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: THelperFunctions.isDarkMode(context)
                        ? TTextFormFieldTheme.darkInputDecorationTheme
                        : TTextFormFieldTheme.lightInputDecorationTheme,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'create new account',
                        style: THelperFunctions.isDarkMode(context)
                            ? TTextTheme.darkTextTheme.headlineMedium
                            : TTextTheme.lightTextTheme.headlineMedium,
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      for (int i = 0; i < _controllers.length - 1; i++)
                        TextFieldWidget(
                          controller: _controllers[i],
                          labelText: _labelTexts[i],
                        ),
                      PhoneNumberField(phoneNumberController: _phoneNumberController),
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      EmailField(emailControler: _controllers[2]),
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      CreateBtn(
                        controllers: _controllers,
                        phoneNumberController: _phoneNumberController,
                        formKey: formKey,
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      const HaveAccount(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
