import 'package:flutter/material.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../../utils/theme/widget_themes/text_theme.dart';
import 'widgets/Payment_list_card.dart';
import 'widgets/last_payment_item.dart';

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});
  @override
  Widget build(BuildContext context) {
  final textTheme = THelperFunctions.isDarkMode(context)? TTextTheme.darkTextTheme : TTextTheme.lightTextTheme;

  const String insurance='insurance payment';
  const String insuranceDesc='lorem ipsumm sit amet dolor consecutotor lorem ipsumm sit amet dolor consecutotor';

    return Scaffold(
      appBar: AppBar(
        title: Text('Payments', style: textTheme.headlineLarge,),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            const PaymentTypeCards(title:insurance , description: insuranceDesc),
            const PaymentTypeCards(title:insurance , description: insuranceDesc),
            const PaymentTypeCards(title:insurance , description: insuranceDesc),
            ClipPath(
              clipper: CurvedClipper(),
              child: Container(
                height: 40,
                color: Colors.grey[850],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Last Payments',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Expanded(
              child: ListView(
                children: const [
                  LastPaymentItem(userId: '09867nbv'),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}