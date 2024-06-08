import 'package:flutter/material.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../models/user_type_model.dart';
import '../../I_RegistrationForm/IndividualRegistration.dart';
import '../../companyRegistrationPage/companyRegistration.dart';


class NextIcon extends StatelessWidget {
  final UserTypeModel userTypeModel;
  const NextIcon({super.key, required this.userTypeModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed:(){
            if (userTypeModel.isIndividual){
              THelperFunctions.navigateToScreen(context, const I_RegistrationForm());
            }
            if(userTypeModel.isCompany){
              THelperFunctions.navigateToScreen(context, const C_RegistrationForm());
            }
            else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text('Please select at least one option.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          icon:const Icon(Icons.navigate_next, color: TColors.primary, size: TSizes.iconLg,)
        ),
      ]
    );
  }
}