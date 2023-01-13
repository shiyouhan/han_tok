// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:han_tok/app/data/base_style.dart';

class SelectText extends StatelessWidget {
  const SelectText({
    Key? key,
    this.isSelect = true,
    this.title,
  }) : super(key: key);

  final bool isSelect;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      color: Colors.black.withOpacity(0),
      child: Text(
        title ?? '??',
        textAlign: TextAlign.center,
        style: isSelect
            ? TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                inherit: true,
              )
            : TextStyle(
                color: Color.fromRGBO(0xff, 0xff, 0xff, .66),
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                inherit: true,
              ),
      ),
    );
  }
}
