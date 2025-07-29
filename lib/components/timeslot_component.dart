import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../consts.dart';

class TimeslotComponent extends StatelessWidget {
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final bool canDelete;
  final VoidCallback onPressed;
  const TimeslotComponent({super.key, required this.dayOfWeek, required this.startTime, required this.endTime, required this.canDelete, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          dayOfWeek,
          style: TextStyle(fontSize: textSize.sp),
        ),
        Spacer(),
        Text(
          "$startTime - $endTime",
          style: TextStyle(fontSize: textSize.sp),
        ),

        canDelete ? IconButton(onPressed: onPressed, icon: Icon(Icons.delete)) : Container()
      ],
    );
  }
}
