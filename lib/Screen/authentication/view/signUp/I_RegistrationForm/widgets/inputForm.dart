import 'package:flutter/material.dart';
import 'package:goma/Screen/authentication/view/signUp/I_RegistrationForm/widgets/create_account_btn.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../../../utils/theme/widget_themes/text_field_theme.dart';
import '../../../../../../utils/theme/widget_themes/text_theme.dart';
import '../../userType/widgets/already_have_account.dart';
import 'email_field_widget.dart';
import 'textFieldWidget.dart';
import 'phone_number_widget.dart';
import 'package:phone_form_field/phone_form_field.dart';

class InputForm extends StatelessWidget {
  const InputForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const InputFields();
  }
}

class InputFields extends StatefulWidget {
  const InputFields({super.key});

  @override
  State<InputFields> createState() => _InputFieldsState();
}

class _InputFieldsState extends State<InputFields> {
  final formKey = GlobalKey<FormState>();
  Color btnbackgroundColor = Colors.grey.shade300;
  Color btnTextColor = Colors.black26;
  bool btnVisible = false;

  final List<TextEditingController> _controllers = List.generate(5, (_) => TextEditingController());
  final PhoneController _phoneNumberController = PhoneController();

  final List<String> _labelTexts = [
    TTexts.firstName,
    TTexts.middleName,
    TTexts.lastName,
    TTexts.address,
    TTexts.email
  ];

  final List<String> _addressOptions = [
    'Yeka', 'Bole', 'Kolfe', 'Kirkos', 'Nifas Silk-Lafto', 'Akaky Kaliti', 'Addis Ketema', 'Lideta', 'Gullele', 'Arada', 
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
    return SingleChildScrollView(
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
                      'Create New Account',
                      style: THelperFunctions.isDarkMode(context)
                          ? TTextTheme.darkTextTheme.headlineMedium
                          : TTextTheme.lightTextTheme.headlineMedium,
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    for (int i = 0; i < _controllers.length-1; i++)
                      TextFieldWidget(
                        controller: _controllers[i],
                        labelText: _labelTexts[i],
                        dropdownItems: i == 3 ? _addressOptions : null,
                      ),
          
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    PhoneNumberField(phoneNumberController: _phoneNumberController),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    EmailField(emailControler: _controllers[4]),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    CreateBtn(
                      controllers: _controllers,
                      phoneNumberNotifier: _phoneNumberController,
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
    );
  }
}
