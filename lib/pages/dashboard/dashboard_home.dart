import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutor_app/components/course_view.dart';
import 'package:tutor_app/data/course.dart';
import 'package:tutor_app/pages/course/course_page.dart';
import 'package:tutor_app/pages/course/new_course.dart';
import 'package:tutor_app/pages/profile/tutor_profile.dart';
import 'package:tutor_app/pages/dashboard/unconfirmed_courses.dart';
import 'package:tutor_app/pages/dashboard/open_courses.dart';
import 'package:tutor_app/styles/colors.dart';

import '../../../util/util.dart';
import '../../consts.dart';

class TutorDashboard extends StatefulWidget {
  final bool isTutor;

  TutorDashboard({super.key, required this.isTutor});

  @override
  State<TutorDashboard> createState() => _TutorDashboardState();
}

class _TutorDashboardState extends State<TutorDashboard> {
  String? user_id = FirebaseAuth.instance.currentUser?.uid;
  final List<Course> courses = <Course>[];

  @override
  void initState() {
    super.initState();
    if (widget.isTutor) {
      checkIncomingStudents();
    }
  }

  void checkIncomingStudents() async {
    final db = FirebaseFirestore.instance;
    final unconfirmedClasses =
        (await db
                .collection("classes")
                .where("tutor", isEqualTo: user_id)
                .where("confirmed", isEqualTo: false)
                .get())
            .docs;
    final cnt = unconfirmedClasses.length;
    if (cnt == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "You have 1 unconfirmed class",
            style: TextStyle(fontSize: textSize.sp),
          ),
          backgroundColor: AppColors.primarySage,
        ),
      );
    } else if (cnt > 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "You have ${cnt} unconfirmed classes",
            style: TextStyle(fontSize: textSize.sp),
          ),
          backgroundColor: AppColors.primarySage,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadCourses(widget.isTutor, user_id!),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          courses.clear();
          snapshot.data.forEach((element) {
            courses.add(
              Course(
                element.id,
                element.data()["title"],
                element.data()["time"],
                element.data()["subject"],
                element.data()["tutor"],
                element.data()["student"],
                element.data()["minutes"],
                "",
              ),
            );
          });
          if (courses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 100.h),
                  Icon(
                    Icons.school_rounded,
                    size: 160.w,
                    color: AppColors.primarySage,
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    "You have no current courses",
                    style: TextStyle(
                      fontSize: largeTitle.sp,
                      color: AppColors.primarySage,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            );
          }
          return Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(24.w),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 24.h),
                  child: Container(
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
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.r),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CoursePage(
                                course_id: courses[index].id,
                                confirmed: true,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                courses[index].title,
                                style: TextStyle(
                                  fontSize: titleSize.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textDark,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.subject_rounded,
                                    size: 44.w,
                                    color: AppColors.primarySage,
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    courses[index].subject,
                                    style: TextStyle(
                                      fontSize: textSize.sp,
                                      color: AppColors.darkSage,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time_rounded,
                                    size: 44.w,
                                    color: AppColors.primarySage,
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    courses[index].time,
                                    style: TextStyle(
                                      fontSize: textSize.sp,
                                      color: AppColors.darkSage,
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
              },
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primarySage,
            ),
          );
        }
      },
    );
  }
}
