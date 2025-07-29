import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutor_app/consts.dart';
import 'package:tutor_app/data/course.dart';
import 'package:tutor_app/styles/colors.dart';

import '../../data/award_cutoff.dart';
import '../../util/util.dart';
import 'package:collection/collection.dart';

class AwardPage extends StatefulWidget {
  AwardPage({super.key});

  @override
  State<AwardPage> createState() => _AwardPageState();
}

class _AwardPageState extends State<AwardPage> {
  String? user_id = FirebaseAuth.instance.currentUser?.uid;
  Map<String, double> courseHours = {};
  @override
  void initState() {
    super.initState();
    getCourseHours();
  }

  final List<Course> courses = <Course>[];

  Future<void> getCourseHours() async {
    final db = FirebaseFirestore.instance;
    final documents = await db.collection("seasonalHours").where("tutorId", isEqualTo: user_id).get();
    Map<String, double> groupHours = {};
    for (var doc in documents.docs) {
      String courseId = doc["courseId"];
      double hours = (doc["hours"] as num).toDouble();
      groupHours[courseId] = (groupHours[courseId]?? 0.0) + hours;
    }
    setState(() {
      courseHours = groupHours;
    });
  }

  Future<String> loadStudentName(String id) async {
    final db = FirebaseFirestore.instance;
    final doc = (await db.collection("students").doc(id).get()).data();
    if (doc != null) {
      return "${doc["firstname"]} ${doc["lastname"]}";
    }
    return "";
  }

  Future<double> getTotalSeasonalHours() async {
    final db = FirebaseFirestore.instance;
    double totalHours = 0.0;

    for (var season in getTwoSeasons()) {
      QuerySnapshot documents = await db.collection("seasonalHours")
          .where("tutorId", isEqualTo: user_id)
          .where("season", isEqualTo: season)
          .get();
      for (var doc in documents.docs) {
        var data = doc.data() as Map<String, dynamic>;
        if (data.containsKey("hours") && data["hours"] is num) {
          totalHours += data["hours"];
        }
      }
    }
    return totalHours;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primarySage,
        elevation: 0,
        title: Text(
          "My Volunteer Hours",
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: appBar.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              child: FutureBuilder(
                future: getTotalSeasonalHours(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 44.w,
                          color: AppColors.primarySage,
                        ),
                        SizedBox(width: 16.w),
                        Text(
                          "Total Hours: ${snapshot.data}",
                          style: TextStyle(
                            fontSize: titleSize.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primarySage,
                      ),
                    );
                  }
                }
              ),
            ),

            SizedBox(height: 32.h),

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
              child: FutureBuilder(
                future: loadCourses(true, user_id!),
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
                        element.data()["totalHours"].toString()
                      ));
                    });

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(AppColors.primarySage.withOpacity(0.1)),
                          dataRowColor: MaterialStateProperty.all(Colors.white),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          columns: [
                            DataColumn(
                              label: Text(
                                "Course",
                                style: TextStyle(
                                  fontSize: textSize.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Student",
                                style: TextStyle(
                                  fontSize: textSize.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Hours",
                                style: TextStyle(
                                  fontSize: textSize.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                          ],
                          rows: courses.mapIndexed((index, course) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    course.title,
                                    style: TextStyle(
                                      fontSize: textSize.sp,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  FutureBuilder(
                                    future: loadStudentName(course.student),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          snapshot.data.toString(),
                                          style: TextStyle(
                                            fontSize: textSize.sp,
                                            color: AppColors.textDark,
                                          ),
                                        );
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.primarySage,
                                          ),
                                        );
                                      }
                                    }
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    (courseHours[course.id] ?? 0).toString(),
                                    style: TextStyle(
                                      fontSize: textSize.sp,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
