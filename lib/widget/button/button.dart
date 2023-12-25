// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    this.enableButton = false,
    this.content,
    this.onTap,
    this.width,
    this.color,
  }) : super(key: key);
  final Function? onTap;
  final bool enableButton;
  final String? content;
  final double? width;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => enableButton ? onTap!() : null,
      child: Container(
        width: width ?? MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: enableButton? color??Colors.orangeAccent :Colors.black12,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(5, 5),
              blurRadius: 10,
            )
          ],
        ),
        child: Text(
          content??'',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: enableButton ? Colors.white : Colors.black38,
            fontWeight: FontWeight.bold
          ) 
        ),
      ),
    );
  }
}
