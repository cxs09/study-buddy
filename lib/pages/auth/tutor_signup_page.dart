import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutor_app/pages/auth/auth_page.dart';
import 'package:tutor_app/util/util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutor_app/styles/colors.dart';
import '../../consts.dart';
import '../../util/constants.dart';

class TutorSignup extends StatefulWidget {

  TutorSignup({super.key});

  @override
  State<TutorSignup> createState() => _TutorSignupState();
}

class _TutorSignupState extends State<TutorSignup> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  final _firstnameController = TextEditingController();

  final _lastnameController = TextEditingController();

  final _dateController = TextEditingController();

  final _locationController = TextEditingController();

  final _wechatController = TextEditingController();

  final _discordController = TextEditingController();

  final _referralnameController = TextEditingController();

  final _otherSkillController = TextEditingController();

  final List<String> _checkedSkills = [];

  String? _gender;

  String? _medium;

  bool isOtherChecked = false;

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
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
          "Register as Tutor",
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: largeTitle.sp,
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
                            fontSize: largeTitle.sp,
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
                        SizedBox(height: 32.h),
                        TextFormField(
                          controller: _dateController,
                          style: TextStyle(
                            fontSize: textSize.sp,
                            color: AppColors.textDark,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Birth Date',
                            labelStyle: TextStyle(
                              fontSize: textSize.sp,
                              color: AppColors.textDark.withOpacity(0.7),
                            ),
                            suffixIcon: Icon(
                              Icons.calendar_today_rounded,
                              color: AppColors.primarySage,
                              size: 50.w,
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
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a date';
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
                          "Teaching Information",
                          style: TextStyle(
                            fontSize: titleSize.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.accentMint.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: AppColors.primarySage.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          padding: EdgeInsets.all(24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Skills",
                                style: TextStyle(
                                  fontSize: titleSize.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textDark,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              SizedBox(height: 24.h),
                              Wrap(
                                spacing: 16.w,
                                runSpacing: 16.h,
                                children: skills.map((item) {
                                  return FilterChip(
                                    label: Text(
                                      item,
                                      style: TextStyle(
                                        fontSize: textSize.sp,
                                        color: _checkedSkills.contains(item) ? AppColors.textLight : AppColors.textDark,
                                      ),
                                    ),
                                    selected: _checkedSkills.contains(item),
                                    onSelected: (bool selected) {
                                      setState(() {
                                        if (selected) {
                                          _checkedSkills.add(item);
                                        } else {
                                          _checkedSkills.remove(item);
                                        }
                                      });
                                    },
                                    backgroundColor: AppColors.backgroundLight,
                                    selectedColor: AppColors.primarySage,
                                    checkmarkColor: AppColors.textLight,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.r),
                                      side: BorderSide(
                                        color: _checkedSkills.contains(item) ? AppColors.primarySage : AppColors.primarySage.withOpacity(0.3),
                                        width: 2,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 24.h),
                              Row(
                                children: [
                                  Checkbox(
                                    value: isOtherChecked,
                                    activeColor: AppColors.primarySage,
                                    checkColor: AppColors.textLight,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isOtherChecked = value!;
                                      });
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  Text(
                                    "Other",
                                    style: TextStyle(
                                      fontSize: textSize.sp,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (isOtherChecked) ...[
                          SizedBox(height: 24.h),
                          TextFormField(
                            controller: _otherSkillController,
                            style: TextStyle(
                              fontSize: textSize.sp,
                              color: AppColors.textDark,
                            ),
                            decoration: InputDecoration(
                              labelText: "Other Skill",
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
                              if (isOtherChecked && _otherSkillController.text != "") {
                                _checkedSkills.add(_otherSkillController.text);
                              }
                              final tutor = <String, dynamic>{
                                "firstname": _firstnameController.text,
                                "lastname": _lastnameController.text,
                                "email": _emailController.text,
                                "gender": _gender,
                                "birthDate": _dateController.text,
                                "isAvailable": true,
                                "resumeUrl": "document_placeholder.png",
                                "profileUrl": "profile_pic_placeholder.webp",
                                "skills": _checkedSkills,
                                "totalHours": 0,
                                "description": "",
                                "season": getCurrentSeason(),
                                "seasonHours": 0,
                              };
                              db.collection("tutors").doc(value.user?.uid).set(tutor);
                              final user = <String, dynamic>{
                                "role": "tutor",
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
                          fontSize: textSize.sp,
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
