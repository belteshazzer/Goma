import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../utils/constants/text_strings.dart';

class EmailField extends StatefulWidget {
  const EmailField({required this.emailControler, super.key});

  final TextEditingController emailControler;

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  Color emailBorderColor = Colors.grey.shade300;

  String? validateEmail(String? value) {
    const pattern = r"^(?:[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-]+)$";
    final regex = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return 'Enter a valid email address';
    } else if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[0-9@a-zA-Z.]")),
      ],
      autocorrect: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.emailControler,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: const Icon(Icons.close, color: Colors.grey, size: 18),
          onPressed: () => widget.emailControler.clear(),
        ),
        labelText: TTexts.email,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0), // Less curved border
          borderSide: BorderSide(color: emailBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0), // Less curved border
          borderSide: BorderSide(color: emailBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0), // Less curved border
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      validator: validateEmail,
      onChanged: (value) {
        setState(() {
          if (validateEmail(value) == null) {
            emailBorderColor = const Color(0xFFE91e63);
          } else {
            emailBorderColor = Colors.grey.shade300;
          }
        });
      },
    );
  }
}
