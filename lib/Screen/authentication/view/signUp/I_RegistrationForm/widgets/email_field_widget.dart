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
      const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
          r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
          r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
          r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
          r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
          r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
          r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
      final regex = RegExp(pattern);

      return value!.isEmpty || !regex.hasMatch(value)
          ? 'Enter a valid email address'
          : null;
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
          icon: const Icon(Icons.close,color: Colors.grey,size: 18,),
          onPressed: () => widget.emailControler.clear(),
        ),
        labelText: TTexts.email,
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      validator: validateEmail,
      onChanged: (value){
        setState(() {
          if(validateEmail(value) == null){
            emailBorderColor = const Color(0xFFE91e63);
          }
          else{
            emailBorderColor = Colors.grey.shade300;
          }
        });
      },
    );
  }
}
