import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutor_app/pages/auth/auth_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutor_app/styles/colors.dart';

import '../../consts.dart';

class StudentSignup extends StatefulWidget {

  StudentSignup({super.key});

  @override
  State<StudentSignup> createState() => _StudentSignupState();
}

class _StudentSignupState extends State<StudentSignup> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  final _firstnameController = TextEditingController();

  final _lastnameController = TextEditingController();

  final _hsGradYearController = TextEditingController();

  final _parentNameController = TextEditingController();

  final _parentPhoneController = TextEditingController();

  final _locationController = TextEditingController();

  final _wechatController = TextEditingController();

  final _discordController = TextEditingController();

  String? _gender;

  String? _medium;

  Future<bool> createNewUser(String email, String password) async {
    try {
      final credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primarySage,
        elevation: 0,
        title: Text(
          "Register as Student",
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: appBar.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primarySage.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(32.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Personal Information",
                          style: TextStyle(
                            fontSize: titleSize.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        TextFormField(
                          validator: (String? name) {
                            if (name == null || name.isEmpty) {
                              return "Please enter your first name";
                            }
                            return null;
                          },
                          controller: _firstnameController,
                          style: TextStyle(
                            fontSize: textSize.sp,
                            color: AppColors.textDark,
                          ),
                          decoration: InputDecoration(
                            labelText: "First name",
                            labelStyle: TextStyle(
                              fontSize: textSize.sp,
                              color: AppColors.textDark.withOpacity(0.7),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: AppColors.backgroundLight,
                            contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                          ),
                        ),
                        SizedBox(height: 32.h),
                        TextFormField(
                          validator: (String? name) {
                            if (name == null || name.isEmpty) {
                              return "Please enter your last name";
                            }
                            return null;
                          },
                          controller: _lastnameController,
                          style: TextStyle(
                            fontSize: textSize.sp,
                            color: AppColors.textDark,
                          ),
                          decoration: InputDecoration(
                            labelText: "Last name",
                            labelStyle: TextStyle(
                              fontSize: textSize.sp,
                              color: AppColors.textDark.withOpacity(0.7),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: AppColors.backgroundLight,
                            contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                          ),
                        ),
                        SizedBox(height: 32.h),
                        DropdownButtonFormField(
                          value: _gender,
                          style: TextStyle(
                            fontSize: textSize.sp,
                            color: AppColors.textDark,
                          ),
                          decoration: InputDecoration(
                            labelText: "Gender",
                            labelStyle: TextStyle(
                              fontSize: textSize.sp,
                              color: AppColors.textDark.withOpacity(0.7),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: AppColors.backgroundLight,
                            contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                          ),
                          items: <String>["male", "female", "other", "Prefer not to say"].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: textSize.sp,
                                  color: AppColors.textDark,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _gender = newValue;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Please select your gender";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 48.h),
                        Text(
                          "Account Information",
                          style: TextStyle(
                            fontSize: titleSize.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        TextFormField(
                          validator: (String? email) {
                            if (email == null || email.isEmpty) {
                              return "Please enter your email";
                            }
                            return null;
                          },
                          controller: _emailController,
                          style: TextStyle(
                            fontSize: textSize.sp,
                            color: AppColors.textDark,
                          ),
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(
                              fontSize: textSize.sp,
                              color: AppColors.textDark.withOpacity(0.7),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: AppColors.backgroundLight,
                            contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                          ),
                        ),
                        SizedBox(height: 32.h),
                        TextFormField(
                          obscureText: true,
                          validator: (String? password) {
                            if (password == null || password.length < 8) {
                              return "Please enter a password with at least 8 characters";
                            }
                            return null;
                          },
                          controller: _passwordController,
                          style: TextStyle(
                            fontSize: textSize.sp,
                            color: AppColors.textDark,
                          ),
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                              fontSize: textSize.sp,
                              color: AppColors.textDark.withOpacity(0.7),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: AppColors.backgroundLight,
                            contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                          ),
                        ),
                        SizedBox(height: 32.h),
                        TextFormField(
                          obscureText: true,
                          validator: (String? password) {
                            if (password != _passwordController.text) {
                              return "Password does not match";
                            }
                            return null;
                          },
                          controller: _confirmPasswordController,
                          style: TextStyle(
                            fontSize: textSize.sp,
                            color: AppColors.textDark,
                          ),
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            labelStyle: TextStyle(
                              fontSize: textSize.sp,
                              color: AppColors.textDark.withOpacity(0.7),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: AppColors.backgroundLight,
                            contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                          ),
                        ),
                        SizedBox(height: 48.h),
                        Text(
                          "Academic Information",
                          style: TextStyle(
                            fontSize: titleSize.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: _hsGradYearController,
                          style: TextStyle(
                            fontSize: textSize.sp,
                            color: AppColors.textDark,
                          ),
                          decoration: InputDecoration(
                            labelText: "High School Graduation Year",
                            labelStyle: TextStyle(
                              fontSize: textSize.sp,
                              color: AppColors.textDark.withOpacity(0.7),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: AppColors.backgroundLight,
                            contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Container(
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          try {
                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                            )
                                .then((value) {
                              final db = FirebaseFirestore.instance;
                              final student = <String, dynamic>{
                                "firstname": _firstnameController.text,
                                "lastname": _lastnameController.text,
                                "email": _emailController.text,
                                "gender": _gender,
                                "hsGradYear": _hsGradYearController.text,
                                "profileUrl": "profile_pic_placeholder.webp",
                                "description": "",
                              };
                              db.collection("students").doc(value.user?.uid).set(student);
                              final user = <String, dynamic>{
                                "role": "student",
                              };
                              db.collection("users").doc(value.user?.uid).set(user);
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => Login()));
                            });
                          } catch (e) {
                            print(e);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primarySage,
                        padding: EdgeInsets.symmetric(vertical: 28.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 44.sp,
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
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
}
