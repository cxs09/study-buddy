import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutor_app/styles/colors.dart';

import '../consts.dart';

class ProfileComponent extends StatelessWidget {
  final Widget icon_;
  final String label;
  final String info;
  final VoidCallback? onclick;

  const ProfileComponent({
    super.key,
    required this.icon_,
    required this.label,
    required this.info,
    this.onclick,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: onclick != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onclick,
        child: Container(
          decoration: BoxDecoration(
            color: onclick != null ? AppColors.primarySage.withOpacity(0.05) : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
            border: onclick != null ? Border.all(
              color: AppColors.primarySage.withOpacity(0.3),
              width: 2,
            ) : null,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              icon_,
              SizedBox(width: 35.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: textSize.sp,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      info,
                      style: TextStyle(
                        fontSize: textSize.sp,
                        color: AppColors.darkSage,
                      ),
                    ),
                  ],
                ),
              ),
              if (onclick != null && (label == "Tutor" || label == "Student")) ...[
                SizedBox(width: 8.w),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 40.w,
                  color: AppColors.primarySage,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
