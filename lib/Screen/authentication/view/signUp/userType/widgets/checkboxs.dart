import 'package:flutter/material.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../models/user_type_model.dart';
import '../../I_RegistrationForm/IndividualRegistration.dart';
import '../../companyRegistrationPage/companyRegistration.dart';

class CheckBoxes extends StatefulWidget {
  const CheckBoxes({super.key});

  @override
  State<CheckBoxes> createState() => _CheckBoxesState();
}

class _CheckBoxesState extends State<CheckBoxes> {
  final UserTypeModel userTypeModel = UserTypeModel(isIndividual: false, isCompany: false);

  void _navigateToRegistrationForm(BuildContext context, bool isIndividual) {
    if (isIndividual) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => I_RegistrationForm()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => C_RegistrationForm()),
      );
    }
  }

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
              Container(
                decoration: BoxDecoration(
                  color: userTypeModel.isIndividual ? Colors.white : Colors.transparent,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      userTypeModel.isIndividual = true;
                      userTypeModel.isCompany = false;
                    });
                    _navigateToRegistrationForm(context, true);
                  },
                  child: const Text(
                    'Individual',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white, // Customize the color as needed
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: userTypeModel.isCompany ? Colors.white : Colors.transparent,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      userTypeModel.isCompany = true;
                      userTypeModel.isIndividual = false;
                    });
                    _navigateToRegistrationForm(context, false);
                  },
                  child: const Text(
                    'Company',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white, // Customize the color as needed
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4 * TSizes.spaceBtwInputFields),
        ],
      ),
    );
  }
}
