import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutor_app/pages/dashboard/open_courses.dart';
import 'package:tutor_app/pages/dashboard/dashboard_home.dart';
import 'package:tutor_app/pages/dashboard/unconfirmed_courses.dart';
import 'package:tutor_app/styles/colors.dart';

import '../../consts.dart';
import '../course/new_course.dart';
import '../home/homepage.dart';
import '../profile/tutor_profile.dart';
import '../profile/student_profile.dart';

class DashboardRoute extends StatefulWidget {
  final bool isTutor;
  const DashboardRoute({super.key, required this.isTutor});

  @override
  State<DashboardRoute> createState() => _DashboardRouteState();
}

class _DashboardRouteState extends State<DashboardRoute> {
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  int selectedIndex = 0;
  static List<Widget>? widgetOptions;

  void onItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  
  @override
  void initState() {
    super.initState();
    widgetOptions = [
      TutorDashboard(isTutor: widget.isTutor),
      UnconfirmedCoursesTutor(isTutor: widget.isTutor,),
      OpenCourses(isTutor: widget.isTutor,)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primarySage,
        elevation: 0,
        title: Text(
          "Dashboard",
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: appBar.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: Icon(
              Icons.refresh_rounded,
              size: 50.w,
              color: AppColors.textLight,
            ),
          ),
          IconButton(
            onPressed: () {
              if (widget.isTutor) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        TutorProfile(
                          tutor_id: userId!,
                        )));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => StudentProfile(
                      student_id: userId!,
                    )));
              }
            },
            icon: Icon(
              Icons.account_circle_rounded,
              size: 70.w,
              color: AppColors.textLight,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Homepage()));
            },
            child: Text(
              "Logout",
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: buttonText.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      
      body: widgetOptions!.elementAt(selectedIndex),

      floatingActionButton: widget.isTutor ? null : FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NewCourse()));
        },
        backgroundColor: AppColors.primarySage,
        child: Icon(
          Icons.add_rounded,
          size: 50.w,
          color: AppColors.textLight,
        ),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.primarySage.withOpacity(0.15),
              blurRadius: 12,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primarySage,
          unselectedItemColor: AppColors.darkSage,
          selectedLabelStyle: TextStyle(
            fontSize: textSize.sp,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: textSize.sp,
            fontWeight: FontWeight.w500,
          ),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded, size: 60.w),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pending_actions_rounded, size: 60.w),
              label: "Unconfirmed",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_rounded, size: 60.w),
              label: "Open",
            ),
          ],
          currentIndex: selectedIndex,
          onTap: onItemTap,
        ),
      ),
    );
  }
}
