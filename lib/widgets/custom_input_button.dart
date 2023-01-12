import 'package:flutter/material.dart';

class CustomInputButton extends StatefulWidget {
  String title;
  Color? buttonColor;
  Color? textColor;

  CustomInputButton(this.title, this.buttonColor, this.textColor, {Key? key})
      : super(key: key);

  @override
  State<CustomInputButton> createState() => _CustomInputButtonState();
}

class _CustomInputButtonState extends State<CustomInputButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: widget.buttonColor,
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      onPressed: () {},
      child: Text(
        widget.title,
        style: TextStyle(color: widget.textColor ?? Colors.white),
      ),
    );
  }
}
