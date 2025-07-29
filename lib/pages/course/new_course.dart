import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutor_app/pages/course/tutor_list.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutor_app/styles/colors.dart';

import '../../consts.dart';

class NewCourse extends StatefulWidget {
  NewCourse({super.key});

  @override
  State<NewCourse> createState() => _NewCourseState();
}

class _NewCourseState extends State<NewCourse> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _sessionsController = TextEditingController(text: "1");

  String? user_id = FirebaseAuth.instance.currentUser?.uid;
  String? dayOfWeek;
  String downloadUrl = "";
  String? _subject;
  int _duration = 60;
  int _sessions = 1;

  List<String> subjects = [
    'ESL',
    'Regular Homework Tutoring',
    'Regular Math Homework',
    'Programming',
    'Drawing',
    'Spanish',
    'Chinese',
    'AMC 8',
    'AMC 10',
    'AMC 12',
    'Speech & Debate',
    'Science Olympiad',
    'Robotics',
    'Sports',
    'Crochet',
    'Basketball',
    'Soccer',
    'Writing',
    'Piano',
    'Chess',
    'Music Theory'
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _sessionsController.text = "1";
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteTextColor: AppColors.textDark,
              dayPeriodTextColor: AppColors.textDark,
              dayPeriodColor: AppColors.primarySage.withOpacity(0.2),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              dayPeriodBorderSide: BorderSide(
                color: AppColors.primarySage,
                width: 2,
              ),
              dialHandColor: AppColors.primarySage,
              dialBackgroundColor: AppColors.primarySage.withOpacity(0.1),
              dialTextColor: AppColors.textDark,
              entryModeIconColor: AppColors.primarySage,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textDark,
                textStyle: TextStyle(
                  fontSize: textSize.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  Map<String, dynamic> generateClassInfo() {
    return {
      "title": _titleController.text,
      "time": "${dayOfWeek}s, ${_timeController.text}",
      "subject": _subject,
      "minutes": _duration,
      "sessions": int.tryParse(_sessionsController.text) ?? 1,
    };
  }

  void postClass() {
    final db = FirebaseFirestore.instance;
    final course = <String, dynamic>{
      "title": _titleController.text,
      "time": "${dayOfWeek}s, ${_timeController.text}",
      "subject": _subject,
      "student": user_id,
      "tutor": "",
      "confirmed": false,
      "minutes": _duration,
      "sessions": int.tryParse(_sessionsController.text) ?? 1,
      "totalHours": 0,
    };
    db.collection("classes").add(course);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primarySage,
        elevation: 0,
        title: Text(
          "New Course",
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: appBar.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primarySage.withOpacity(0.15),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (String? title) {
                            if (title == null || title.isEmpty) {
                              return "Please enter a course title";
                            }
                            return null;
                          },
                          controller: _titleController,
                          maxLength: 40,
                          style: TextStyle(
                            fontSize: textSize.sp,
                            color: AppColors.textDark,
                          ),
                          decoration: InputDecoration(
                            labelText: "Course Title",
                            labelStyle: TextStyle(
                              fontSize: textSize.sp,
                              color: AppColors.textDark,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        DropdownButtonFormField(
                          value: _subject,
                          decoration: InputDecoration(
                            labelText: "Subject",
                            labelStyle: TextStyle(
                              fontSize: textSize.sp,
                              color: AppColors.textDark,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage,
                                width: 2,
                              ),
                            ),
                          ),
                          items: subjects.map<DropdownMenuItem<String>>((String value) {
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
                              _subject = newValue;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Please select a subject";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24.h),
                        DropdownButtonFormField<String>(
                          validator: (String? day) {
                            if (day == null || day.isEmpty) {
                              return "Please select a day of the week";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Day of Week",
                            labelStyle: TextStyle(
                              fontSize: textSize.sp,
                              color: AppColors.textDark,
                            ),
                            suffixIcon: Icon(
                              Icons.calendar_view_day_rounded,
                              color: AppColors.primarySage,
                              size: 40.w,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage,
                                width: 2,
                              ),
                            ),
                          ),
                          value: dayOfWeek,
                          items: [
                            "Monday",
                            "Tuesday",
                            "Wednesday",
                            "Thursday",
                            "Friday",
                            "Saturday",
                            "Sunday"
                          ].map((day) => DropdownMenuItem<String>(
                            value: day,
                            child: Text(
                              day,
                              style: TextStyle(
                                fontSize: textSize.sp,
                                color: AppColors.textDark,
                              ),
                            ),
                          )).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              dayOfWeek = newValue;
                            });
                          },
                        ),
                        SizedBox(height: 24.h),
                        TextFormField(
                          validator: (String? time) {
                            if (time == null || time.isEmpty) {
                              return "Please select a time";
                            }
                            return null;
                          },
                          controller: _timeController,
                          style: TextStyle(
                            fontSize: textSize.sp,
                            color: AppColors.textDark,
                          ),
                          decoration: InputDecoration(
                            labelText: "Select Time",
                            labelStyle: TextStyle(
                              fontSize: textSize.sp,
                              color: AppColors.textDark,
                            ),
                            suffixIcon: Icon(
                              Icons.access_time_rounded,
                              color: AppColors.primarySage,
                              size: 40.w,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage,
                                width: 2,
                              ),
                            ),
                          ),
                          readOnly: true,
                          onTap: () => selectTime(context),
                        ),
                        SizedBox(height: 24.h),
                        DropdownButtonFormField(
                          value: _duration.toString(),
                          decoration: InputDecoration(
                            labelText: "Class Duration (minutes)",
                            labelStyle: TextStyle(
                              fontSize: textSize.sp,
                              color: AppColors.textDark,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage,
                                width: 2,
                              ),
                            ),
                          ),
                          items: [60, 45, 30].map((int value) {
                            return DropdownMenuItem<String>(
                              value: value.toString(),
                              child: Text(
                                value.toString(),
                                style: TextStyle(
                                  fontSize: textSize.sp,
                                  color: AppColors.textDark,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _duration = int.parse(newValue!);
                            });
                          },
                        ),
                        SizedBox(height: 24.h),
                        TextFormField(
                          validator: (String? sessions) {
                            if (sessions == null || sessions.isEmpty) {
                              return "Please enter number of sessions";
                            }
                            int? sessionsInt = int.tryParse(sessions);
                            if (sessionsInt == null || sessionsInt < 1) {
                              return "Please enter a valid number (1 or more)";
                            }
                            return null;
                          },
                          controller: _sessionsController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          style: TextStyle(
                            fontSize: textSize.sp,
                            color: AppColors.textDark,
                          ),
                          decoration: InputDecoration(
                            labelText: "Number of Class Sessions",
                            labelStyle: TextStyle(
                              fontSize: textSize.sp,
                              color: AppColors.textDark,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: AppColors.primarySage,
                                width: 2,
                              ),
                            ),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              _sessions = int.tryParse(value) ?? 1;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Map<String, dynamic> classInfo = generateClassInfo();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TutorList(
                                classinfo: classInfo,
                              ),
                            ));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primarySage,
                          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Text(
                          "Find Tutor",
                          style: TextStyle(
                            fontSize: buttonText.sp,
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 24.w),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            postClass();
                            Navigator.of(context).pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primarySage,
                          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Text(
                          "Post Class",
                          style: TextStyle(
                            fontSize: buttonText.sp,
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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
