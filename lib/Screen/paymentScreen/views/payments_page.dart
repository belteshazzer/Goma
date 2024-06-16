import 'package:flutter/material.dart';
import 'package:goma/utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../../utils/theme/widget_themes/text_theme.dart';
import 'vehicle_selections.dart';
import 'widgets/Payment_list_card.dart';
import 'widgets/last_payment_item.dart';

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});
  @override
  Widget build(BuildContext context) {
  final textTheme = THelperFunctions.isDarkMode(context)? TTextTheme.darkTextTheme : TTextTheme.lightTextTheme;
  final isDarkMode = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Payments', style: textTheme.headlineSmall,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              const PaymentTypeCards(title: 'EDVLCA', description: 'A Payment Made to Ethiopian Drivers and Vehicles Licence and Control Authority for the Renewal of BOLO', vehicleSelectionPage: VehicleSelection(docType: 'EDVLCA',)),
              const PaymentTypeCards(title: 'Insurance Payment', description: 'pay here for a payment made to an insurance companies you registered for your vehicle', vehicleSelectionPage: VehicleSelection(docType: 'Insurance',)),
              const PaymentTypeCards(title: 'Road Fund', description: 'pay here for annual utilization of road for a government', vehicleSelectionPage: VehicleSelection(docType: 'Road Fund',)),
              const SizedBox(height: 50.0,),
            
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Last Payments',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Expanded(
                child: PaymentHistoryPage()
                ),
            ],
          ),
        ),
      )
    );
  }
}
