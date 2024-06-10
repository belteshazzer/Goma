import 'package:flutter/material.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';

class AddVehicleHeader extends StatelessWidget {
  const AddVehicleHeader({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          
          height: 150,
          
          child: const Text(
            'G-NOTIFY',
            style: TextStyle(
              fontSize: TSizes.xl,
              fontWeight: FontWeight.bold,
              fontFamily: 'YourFontFamily',
            ),
          ),
          ),
        
        Text(
          TTexts.addVehicleTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
          height: TSizes.sm,
        ),
        Text(
          TTexts.addVehicleSubTitle,
          style: Theme.of(context).textTheme.bodyMedium,
        )
      ],
    );
  }
}
