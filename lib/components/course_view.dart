import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../consts.dart';
import '../util/util.dart';

class CourseView extends StatelessWidget {
  final String title;
  final String subject;
  //final String name;
  final String time;
  const CourseView({super.key, required this.title, required this.subject, required this.time});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: textSize.sp, fontWeight: FontWeight.bold),),
                Text(subject, style: TextStyle(fontSize: textSize.sp),)
              ],
            ),
          ),
          Text(time, style: TextStyle(fontSize: textSize.sp),)
        ],
      ),
    );
  }
}
