import 'package:flutter/material.dart';
import 'package:goma/Screen/add_vehicle/widgets/header.dart';
import 'package:goma/utils/helpers/helper_functions.dart';
import 'widgets/input_form.dart';

class AddVehicleScreen extends StatelessWidget {
  const AddVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
            // padding: TSpacingStyle.paddingWithAppBarHeight,
            padding:const EdgeInsets.all(40.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                /// Logo, Title, & sub-title
                AddVehicleHeader(dark: dark),

                /// Form
                InputForm(dark: dark)
              ],
            )),
      ),
    );
  }
}

