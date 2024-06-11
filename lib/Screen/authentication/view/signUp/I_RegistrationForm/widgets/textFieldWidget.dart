import 'package:flutter/material.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../../../utils/theme/widget_themes/text_field_theme.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: THelperFunctions.isDarkMode(context)
            ? TTextFormFieldTheme.darkInputDecorationTheme
            : TTextFormFieldTheme.lightInputDecorationTheme,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0), // Adjust the value to make it less curved
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0), // Adjust the value to make it less curved
                borderSide: const BorderSide(color: TColors.grey), // Customize the border color
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0), // Adjust the value to make it less curved
                borderSide: const BorderSide(color: TColors.light), // Customize the border color when focused
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
        ],
      ),);
  }}