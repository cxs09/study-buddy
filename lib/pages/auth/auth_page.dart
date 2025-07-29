import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutor_app/pages/auth/util/auth_util.dart';
import 'package:tutor_app/pages/auth/forgot_password.dart';
import 'package:tutor_app/pages/dashboard/dashboard_route.dart';
import 'package:tutor_app/styles/colors.dart';
import '../../consts.dart';
import '../../util/util.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _loginError = false;
  final db = FirebaseFirestore.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void onSignIn() {
    signIn(_emailController.text, _passwordController.text).then((value) async {
      if (value != null) {
        String id = value.user!.uid;
        DocumentSnapshot user_doc = await db.collection("users").doc(id).get();
        if (user_doc.exists) {
          String role = user_doc["role"];

          if (role == "student") {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => DashboardRoute(isTutor: false),
              ),
              (route) => false,
            );
          } else {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => DashboardRoute(isTutor: true),
              ),
              (route) => false,
            );
          }
        }
      } else {
        setState(() {
          _loginError = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primarySage,
        elevation: 0,
        title: Text(
          "Login",
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: appBar.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Login to Your Account",
                  style: TextStyle(
                    fontSize: largeTitle.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 60.h),
                TextField(
                  controller: _emailController,
                  style: TextStyle(fontSize: 44.sp),
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(
                      fontSize: textSize.sp,
                      color: AppColors.darkSage,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: AppColors.primarySage),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: AppColors.primarySage),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: AppColors.darkSage, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 32.h),
                TextField(
                  obscureText: true,
                  controller: _passwordController,
                  style: TextStyle(fontSize: 44.sp),
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(
                      fontSize: textSize.sp,
                      color: AppColors.darkSage,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: AppColors.primarySage),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: AppColors.primarySage),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: AppColors.darkSage, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                if (_loginError)
                  Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: Text(
                      "Wrong username or password",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: textSize.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: 40.h),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primarySage.withOpacity(0.15),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: onSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primarySage,
                      foregroundColor: AppColors.textLight,
                      padding: EdgeInsets.symmetric(vertical: 28.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: buttonText.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primarySage.withOpacity(0.15),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ForgotPassword()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primarySage,
                      foregroundColor: AppColors.textLight,
                      padding: EdgeInsets.symmetric(vertical: 28.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(
                        fontSize: buttonText.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
