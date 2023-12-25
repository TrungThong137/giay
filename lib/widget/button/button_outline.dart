import 'package:flutter/material.dart';

class AppOutlineButton extends StatelessWidget {
  const AppOutlineButton({
    super.key,
    this.color,
    this.onTap,
    this.content,
    this.colorContent, 
    this.width,
  });
  final Color? color;
  final Function()? onTap;
  final String? content;
  final Color? colorContent;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap!(),
      child: Container(
        width: width?? MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(
            color: color ?? Colors.black,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Text(
          content??'',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: colorContent ?? Colors.black,
            fontWeight: FontWeight.bold,
          ) 
        ),
      ),
    );
  }
}
