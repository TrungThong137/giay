import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../widget.dart';

class WarningDialog extends StatelessWidget {
  const WarningDialog({
    Key? key,
    this.content,
    this.image,
    this.title,
    this.leftButtonName,
    this.color,
    this.colorNameLeft,
    this.rightButtonName,
    this.onTapLeft,
    this.onTapRight,
    this.isForm = false,
    this.controller,
    this.isWaning=false,
  }) : super(key: key);
  final String? content;
  final String? title;
  final String? leftButtonName;
  final String? rightButtonName;
  final String? image;
  final Color? color;
  final Color? colorNameLeft;
  final Function()? onTapLeft;
  final Function()? onTapRight;
  final bool isForm;
  final TextEditingController? controller;
  final bool isWaning;

  dynamic dialogContent(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (image != null)
              isWaning ? SvgPicture.asset(
                image ?? '',
                color: Colors.orangeAccent,
                width: 100,
                height: 100,
              )
              :CircleAvatar(
                backgroundColor: Colors.white,
                radius: 35,
                child: SvgPicture.asset(
                  image ?? '',
                ),
              ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Text(
                title?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            if (content != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  content ?? '',
                  style: const TextStyle(
                    fontSize: 15, 
                  ),
                ),
              ),
            const SizedBox(height: 10),
            SizedBox(height: content != null ? 10 : 30),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 10),
                    child: AppOutlineButton(
                      content: leftButtonName,
                      onTap: onTapLeft,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 15),
                    child: AppButton(
                      enableButton: true,
                      content: rightButtonName,
                      onTap: onTapRight,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
