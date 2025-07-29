import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutor_app/components/course_view.dart';
import 'package:tutor_app/consts.dart';
import 'package:tutor_app/data/course.dart';
import 'package:tutor_app/pages/course/course_page.dart';
import 'package:tutor_app/pages/course/new_course.dart';
import 'package:tutor_app/pages/profile/tutor_profile.dart';
import 'package:tutor_app/pages/dashboard/dashboard_home.dart';
import 'package:tutor_app/pages/dashboard/open_courses.dart';
import 'package:tutor_app/styles/colors.dart';

class UnconfirmedCoursesTutor extends StatelessWidget {
  final bool isTutor;
  UnconfirmedCoursesTutor({super.key, required this.isTutor});

  final String? user_id = FirebaseAuth.instance.currentUser?.uid;
  final List<Course> courses = <Course>[];

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>?>
      _loadCourses() async {
    final db = FirebaseFirestore.instance;
    String userType = isTutor ? "tutor" : "student";
    return (await db
            .collection("classes")
            .where(userType, isEqualTo: user_id)
            .where("confirmed", isEqualTo: false)
            .where("tutor", isNotEqualTo: '')
            .get())
        .docs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadCourses(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          courses.clear();
          snapshot.data.forEach((element) {
            courses.add(Course(
                element.id,
                element.data()["title"],
                element.data()["time"],
                element.data()["subject"],
                element.data()["tutor"],
                element.data()["student"],
                element.data()["minutes"],
                ""
            ));
          });
          if(courses.isEmpty){
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
                    "No unconfirmed courses",
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
          return ListView.builder(
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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CoursePage(
                                  course_id: courses[index].id,
                                  confirmed: false,
                                )));
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
