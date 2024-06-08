import 'package:flutter/material.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../models/user_type_model.dart';
import 'next_button.dart';

class CheckBoxes extends StatefulWidget {
  const CheckBoxes({super.key});

  @override
  State<CheckBoxes> createState() => _CheckBoxesState();
}

class _CheckBoxesState extends State<CheckBoxes> {
  final UserTypeModel userTypeModel = UserTypeModel(isIndividual: false, isCompany: false);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                value: userTypeModel.isIndividual,
                onChanged: (bool? value) {
                  setState(() {
                    userTypeModel.isIndividual = value!;
                    userTypeModel.isCompany = !userTypeModel.isIndividual;
                  });
                },
              ),
              const SizedBox(width: 10),
              const Text('individual'),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: userTypeModel.isCompany,
                onChanged: (bool? value) {
                  setState(() {
                    userTypeModel.isCompany = value!;
                    userTypeModel.isIndividual = !userTypeModel.isCompany;
                  });
                },
              ),
              const SizedBox(width: 10),
              const Text('company'),
            ],
          ),
          const SizedBox(height: 4 * TSizes.spaceBtwInputFields),
          NextIcon(
            userTypeModel: userTypeModel,
          ),
        ],
      ),
    );
  }
}
