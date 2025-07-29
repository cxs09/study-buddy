import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutor_app/components/timeslot_component.dart';
import 'package:tutor_app/util/util.dart';
import 'package:tutor_app/styles/colors.dart';

import '../../consts.dart';

class Timeslot extends StatefulWidget {
  final String tutorId;
  const Timeslot({super.key, required this.tutorId});

  @override
  State<Timeslot> createState() => _TimeslotState();
}

class _TimeslotState extends State<Timeslot> {
  String? dayOfWeek = "Monday";
  TextEditingController _timeStartController = TextEditingController();
  TextEditingController _timeEndController = TextEditingController();

  Future<void> selectTime(BuildContext context, TextEditingController timeController) async {
    final TimeOfDay? picked =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        timeController.text = picked.format(context);
      });
    }
  }

  Future<void> addTimeslot() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    if (_timeStartController.text.isNotEmpty && _timeEndController.text.isNotEmpty) {
      Map<String, dynamic> timeslot = {
        "tutorId": widget.tutorId,
        "dayOfWeek": dayOfWeek,
        "startTime": _timeStartController.text,
        "endTime": _timeEndController.text,
      };

      db.collection("timeslots").add(timeslot);
      setState(() {
        dayOfWeek = "Monday";
        _timeStartController.clear();
        _timeEndController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          "Add Time Slots",
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: appBar.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: AppColors.primarySage,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            FutureBuilder(
              future: loadTimeslots(widget.tutorId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List timeslots = snapshot.data;
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: timeslots.length,
                    itemBuilder: (context, index) {
                      return TimeslotComponent(
                        dayOfWeek: timeslots[index].data()["dayOfWeek"],
                        startTime: timeslots[index].data()["startTime"],
                        endTime: timeslots[index].data()["endTime"],
                        canDelete: true,
                        onPressed: () async {
                          await deleteItem("timeslots", timeslots[index].id);
                          setState(() {});
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
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Day of Week",
                      labelStyle: TextStyle(
                        fontSize: textSize.sp,
                        color: AppColors.darkSage,
                      ),
                      suffixIcon: Icon(
                        Icons.calendar_view_day,
                        color: AppColors.primarySage,
                        size: 40.w,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: AppColors.primarySage,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: AppColors.primarySage.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
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
                  TextField(
                    controller: _timeStartController,
                    decoration: InputDecoration(
                      labelText: "Select Start Time",
                      labelStyle: TextStyle(
                        fontSize: textSize.sp,
                        color: AppColors.darkSage,
                      ),
                      suffixIcon: Icon(
                        Icons.access_time,
                        color: AppColors.primarySage,
                        size: 40.w,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: AppColors.primarySage,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: AppColors.primarySage.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: AppColors.primarySage,
                          width: 2,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: textSize.sp,
                      color: AppColors.textDark,
                    ),
                    readOnly: true,
                    onTap: () => selectTime(context, _timeStartController),
                  ),
                  SizedBox(height: 24.h),
                  TextField(
                    controller: _timeEndController,
                    decoration: InputDecoration(
                      labelText: "Select End Time",
                      labelStyle: TextStyle(
                        fontSize: textSize.sp,
                        color: AppColors.darkSage,
                      ),
                      suffixIcon: Icon(
                        Icons.access_time,
                        color: AppColors.primarySage,
                        size: 40.w,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: AppColors.primarySage,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: AppColors.primarySage.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: AppColors.primarySage,
                          width: 2,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: textSize.sp,
                      color: AppColors.textDark,
                    ),
                    readOnly: true,
                    onTap: () => selectTime(context, _timeEndController),
                  ),
                  SizedBox(height: 32.h),
                  ElevatedButton(
                    onPressed: addTimeslot,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primarySage,
                      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Text(
                      "Add Time Slot",
                      style: TextStyle(
                        fontSize: buttonText.sp,
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
