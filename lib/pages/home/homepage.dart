import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutor_app/pages/auth/auth_page.dart';
import 'package:tutor_app/pages/auth/tutor_signup_page.dart';
import 'package:tutor_app/pages/auth/student_signup_page.dart';
import 'package:tutor_app/styles/colors.dart';
import '../../util/util.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Welcome Section
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Welcome to StudyBuddy",
                          style: TextStyle(
                            fontSize: 80.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 45.h),
                        Text(
                          "Connect and Learn with Other Students",
                          style: TextStyle(
                            fontSize: 54.sp,
                            color: AppColors.darkSage,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 100.h),
                  
                  // Action Buttons
                  Center(
                    child: Container(
                      width: 800.w,
                      child: Column(
                        children: [
                          _buildActionButton(
                            context,
                            "Login",
                            Icons.login_rounded,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            ),
                          ),
                          SizedBox(height: 40.h),
                          _buildActionButton(
                            context,
                            "Become a Tutor",
                            Icons.school_rounded,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TutorSignup()),
                            ),
                          ),
                          SizedBox(height: 40.h),
                          _buildActionButton(
                            context,
                            "Join as Student",
                            Icons.person_add_rounded,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => StudentSignup()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primarySage.withOpacity(0.15),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primarySage,
          foregroundColor: AppColors.textLight,
          padding: EdgeInsets.symmetric(vertical: 36.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60.w),
            SizedBox(width: 24.w),
            Text(
              text,
              style: TextStyle(
                fontSize: 52.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
