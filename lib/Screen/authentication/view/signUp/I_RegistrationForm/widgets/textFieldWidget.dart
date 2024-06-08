import 'package:flutter/material.dart';
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
    return Theme(data: Theme.of(context).copyWith(
      inputDecorationTheme: THelperFunctions.isDarkMode(context)? TTextFormFieldTheme.darkInputDecorationTheme:TTextFormFieldTheme.lightInputDecorationTheme,
    ), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: labelText,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close,color: Colors.grey,size: 18,),
                  onPressed: () => controller.clear(),
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
      ),
    );
  }
}
