import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giay/widget/widget.dart';

Future<bool> showExitPopup(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (_) {
        return WarningDialog(
          image: 'assets/Warning.svg',
          title: 'Thoát ứng dụng',
          content: 'Bạn muốn thoát ứng dụng không?',
          leftButtonName: 'Hủy',
          color: Colors.grey,
          colorNameLeft: Colors.black,
          rightButtonName: 'Xác nhận',
          isWaning: true,
          onTapLeft: () {
            Navigator.pop(context);
          },
          onTapRight: () {
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else if (Platform.isIOS) {
              exit(0);
            }
          },
        );
      },
    )??false;
  }