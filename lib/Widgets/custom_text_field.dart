import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final FormFieldValidator<String>? validator;
  final String name;
  final String? initialValue;
  CustomTextField({
    super.key, required this.label, required this.validator, required this.name,   this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffF5F5F5),
      child: FormBuilderTextField(
        decoration: InputDecoration(
            fillColor: Colors.green,
            filled: true,
            border:InputBorder.none,
            hintText: label
        ),
        validator: validator,
        initialValue: initialValue,
        name:name ,
      ),
    );
  }
}
