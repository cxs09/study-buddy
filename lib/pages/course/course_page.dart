import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutor_app/components/profile_component.dart';
import 'package:tutor_app/pages/profile/tutor_profile.dart';
import 'package:tutor_app/pages/profile/student_profile.dart';
import 'package:tutor_app/styles/colors.dart';

import '../../consts.dart';
import '../../util/constants.dart';
import '../../util/util.dart';

class CoursePage extends StatefulWidget {
  final String course_id;
  final bool confirmed;
  CoursePage({super.key, required this.course_id, required this.confirmed});


  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  String? user_id = FirebaseAuth.instance.currentUser?.uid;

  Future<Map<String, dynamic>?> _loadCourse() async {
    final db = FirebaseFirestore.instance;
    return (await db.collection("classes").doc(widget.course_id).get()).data();
  }

  Future<Map<String, dynamic>?> _loadTutorName(String id) async {
    final db = FirebaseFirestore.instance;
    if (id.isEmpty) {
      return null;
    }
    return (await db.collection("tutors").doc(id).get()).data();
  }

  Future<Map<String, dynamic>?> _loadStudentName(String id) async {
    final db = FirebaseFirestore.instance;
    return (await db.collection("students").doc(id).get()).data();
  }

  void confirmClass() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference docRef = db.collection("classes").doc(widget.course_id);
    docRef.update({"confirmed": true});
    setState(() {});
  }

  Future<void> requestTeach() async {
    final db = FirebaseFirestore.instance;
    final tutorDoc = await db.collection("tutors").doc(user_id).get();
    final tutorName =
        "${tutorDoc.get("firstname")} ${tutorDoc.get("lastname")}";
    final requests = FirebaseFirestore.instance.collection("requests");
    final querySnapshot = await requests
        .where("course", isEqualTo: widget.course_id)
        .where("tutor", isEqualTo: user_id)
        .get();
    if (querySnapshot.docs.isEmpty) {
      final request = <String, dynamic>{
        "tutor": user_id,
        "tutorName": tutorName,
        "course": widget.course_id
      };
      db.collection("requests").add(request);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Request sent",
            style: TextStyle(fontSize: textSize.sp),
          ),
          backgroundColor: AppColors.primarySage,
        ),
      );
    }
  }

  Future<void> handleTutorRequest(
      bool accept, String tutorId, String requestId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    if (accept) {
      DocumentReference docRef = db.collection("classes").doc(widget.course_id);
      await docRef.update({"tutor": tutorId, "confirmed": true});
      deleteRequests();
    } else {
      final docRef = db.collection("requests").doc(requestId);
      docRef.delete();
    }
    setState(() {});
  }

  Future<void> deleteRequests() async {
    final requests = FirebaseFirestore.instance.collection("requests");
    final querySnapshot =
        await requests.where("course", isEqualTo: widget.course_id).get();
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>?>
      _loadRequests() async {
    final db = FirebaseFirestore.instance;
    return (await db
            .collection("requests")
            .where("course", isEqualTo: widget.course_id)
            .get())
        .docs;
  }

  Future<void> recordHours() async {
    TextEditingController hoursController = TextEditingController();
    await showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Record Hours"),
            content: TextField(
              controller: hoursController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    FirebaseFirestore db = FirebaseFirestore.instance;
                    DocumentReference docRef = db.collection("classes").doc(widget.course_id);
                    DocumentSnapshot course = await docRef.get();
                    if (course.exists) {
                      Map<String, dynamic> data = course.data() as Map<String, dynamic>;
                      await docRef.update({
                        "sessions": FieldValue.increment(-1),
                        "totalHours": FieldValue.increment(
                            double.parse(hoursController.text))
                      });
                      DocumentReference userRef = db.collection("tutors").doc(
                          user_id);
                      await userRef.update({
                        "totalHours": FieldValue.increment(
                            double.parse(hoursController.text)),
                        "seasonHours": FieldValue.increment(
                            double.parse(hoursController.text))
                      });
                    }
                    setState(() {
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text("Update")
              )
            ],
          );
        }
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primarySage,
        elevation: 0,
        title: Text(
          "Course Information",
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: appBar.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _loadCourse(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic>? courseData = snapshot.data;
              if (courseData != null) {
                return Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Course Title Section
                      Container(
                        width: double.infinity,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              courseData["title"],
                              style: TextStyle(
                                fontSize: largeTitle.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDark,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.book_rounded,
                                  size: 52.w,
                                  color: AppColors.primarySage,
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  courseData["subject"],
                                  style: TextStyle(
                                    fontSize: titleSize.sp,
                                    color: AppColors.darkSage,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Course Details Section
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileComponent(
                              icon_: Icon(
                                Icons.schedule_rounded,
                                size: 40.w,
                                color: AppColors.primarySage,
                              ),
                              label: "Time",
                              info: courseData["time"],
                            ),
                            SizedBox(height: 16.h),
                            ProfileComponent(
                              icon_: Icon(
                                Icons.schedule_rounded,
                                size: 40.w,
                                color: AppColors.primarySage,
                              ),
                              label: "Duration",
                              info: "${courseData["minutes"].toString()} minutes",
                            ),
                            SizedBox(height: 16.h),
                            ProfileComponent(
                              icon_: Icon(
                                Icons.school_rounded,
                                size: 40.w,
                                color: AppColors.primarySage,
                              ),
                              label: "Sessions",
                              info: "${courseData["sessions"]?.toString() ?? "1"} sessions",
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Participants Section
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder(
                              future: _loadTutorName(courseData["tutor"]),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  Map<String, dynamic>? userData = snapshot.data;
                                  String tutorName = userData == null
                                      ? "none"
                                      : "${userData["firstname"]} ${userData["lastname"]}";
                                  return ProfileComponent(
                                    onclick: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => TutorProfile(
                                          tutor_id: courseData["tutor"],
                                        ),
                                      ));
                                    },
                                    icon_: Icon(
                                      Icons.person_rounded,
                                      size: 40.w,
                                      color: AppColors.primarySage,
                                    ),
                                    label: "Tutor",
                                    info: tutorName,
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                            SizedBox(height: 16.h),
                            FutureBuilder(
                              future: _loadStudentName(courseData["student"]),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  Map<String, dynamic>? userData = snapshot.data;
                                  if (userData != null) {
                                    return ProfileComponent(
                                      onclick: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => StudentProfile(
                                            student_id: courseData["student"],
                                          ),
                                        ));
                                      },
                                      icon_: Icon(
                                        Icons.school_rounded,
                                        size: 40.w,
                                        color: AppColors.primarySage,
                                      ),
                                      label: "Student",
                                      info: "${userData["firstname"]} ${userData["lastname"]}",
                                    );
                                  } else {
                                    return Text(
                                      "Error loading data",
                                      style: TextStyle(
                                        fontSize: textSize.sp,
                                        color: AppColors.textDark,
                                      ),
                                    );
                                  }
                                } else {
                                  return CircularProgressIndicator(
                                    color: AppColors.primarySage,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Hours Section
                      if (courseData["confirmed"])
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProfileComponent(
                                icon_: Icon(
                                  Icons.hourglass_top_rounded,
                                  size: 40.w,
                                  color: AppColors.primarySage,
                                ),
                                label: "Total Hours",
                                info: courseData["totalHours"].toString(),
                              ),
                              if (user_id == courseData["tutor"] && courseData["sessions"] != null && courseData["sessions"] >= 1)
                                Column(
                                  children: [
                                    SizedBox(height: 24.h,),
                                    ElevatedButton(
                                      onPressed: recordHours,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primarySage,
                                        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16.r),
                                        ),
                                      ),
                                      child: Text(
                                        "Record Hours",
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

                      SizedBox(height: 24.h),

                      // Action Buttons Section
                      if (!courseData["confirmed"] && user_id == courseData["tutor"])
                        Center(
                          child: ElevatedButton(
                            onPressed: confirmClass,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primarySage,
                              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: Text(
                              "Confirm Course",
                              style: TextStyle(
                                fontSize: buttonText.sp,
                                color: AppColors.textLight,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                      if (courseData["tutor"] == "" && courseData["student"] != user_id)
                        Center(
                          child: ElevatedButton(
                            onPressed: requestTeach,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primarySage,
                              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: Text(
                              "Request to Teach",
                              style: TextStyle(
                                fontSize: buttonText.sp,
                                color: AppColors.textLight,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                      if (courseData["tutor"] == "" && courseData["student"] == user_id) ...[
                        SizedBox(height: 24.h),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tutor Requests",
                                style: TextStyle(
                                  fontSize: titleSize.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textDark,
                                ),
                              ),
                              SizedBox(height: 24.h),
                              FutureBuilder(
                                future: _loadRequests(),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    List requests = snapshot.data;
                                    if (requests.isEmpty) {
                                      return Text(
                                        "No Requests",
                                        style: TextStyle(
                                          fontSize: textSize.sp,
                                          color: AppColors.textDark,
                                        ),
                                      );
                                    }
                                    return ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: requests.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          leading: IconButton(
                                            icon: Icon(
                                              Icons.close_rounded,
                                              color: Colors.red,
                                              size: 40.w,
                                            ),
                                            onPressed: () {
                                              handleTutorRequest(
                                                false,
                                                requests[index].data()["tutor"],
                                                requests[index].id,
                                              );
                                            },
                                          ),
                                          title: Text(
                                            requests[index].data()["tutorName"],
                                            style: TextStyle(
                                              fontSize: textSize.sp,
                                              color: AppColors.textDark,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          trailing: IconButton(
                                            icon: Icon(
                                              Icons.check_rounded,
                                              color: AppColors.primarySage,
                                              size: 40.w,
                                            ),
                                            onPressed: () {
                                              handleTutorRequest(
                                                true,
                                                requests[index].data()["tutor"],
                                                requests[index].id,
                                              );
                                            },
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => TutorProfile(
                                                  tutor_id: requests[index].data()["tutor"],
                                                ),
                                              ),
                                            );
                                          },
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
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              } else {
                return Text(
                  "Error loading data",
                  style: TextStyle(
                    fontSize: textSize.sp,
                    color: AppColors.textDark,
                  ),
                );
              }
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
    );
  }
}
