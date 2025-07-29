import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutor_app/components/profile_component.dart';
import 'package:tutor_app/pages/awards/award_page.dart';
import 'package:tutor_app/pages/profile/timeslot.dart';
import 'package:uuid/uuid.dart';
import '../../components/timeslot_component.dart';
import '../../consts.dart';
import '../../util/constants.dart';
import '../../util/util.dart';
import '../home/homepage.dart';
import '../../styles/colors.dart';

class TutorProfile extends StatefulWidget {
  final String tutor_id;

  //final String image;
  TutorProfile({super.key, required this.tutor_id});

  String? user_id = FirebaseAuth.instance.currentUser?.uid;
  final WidgetStateProperty<Icon?> thumbIcon =
      WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return const Icon(Icons.check);
        }
        return const Icon(Icons.close);
      });

  @override
  State<TutorProfile> createState() => _TutorProfileState();
}

class _TutorProfileState extends State<TutorProfile> {
  bool isEditing = false;
  bool isAvailable = false;

  TextEditingController descriptionController = TextEditingController();
  final db = FirebaseFirestore.instance;



  Future<Map<String, dynamic>?> _loadUser() async {
    updateSeason();
    return (await db.collection("tutors").doc(widget.tutor_id).get()).data();
  }


  Future<void> editDescription() async {
    final docRef = db.collection("tutors").doc(widget.tutor_id);
    await docRef.update({"description": descriptionController.text});
    setState(() {
      isEditing = false;
    });
  }

  void uploadProfile() {
    final ImagePicker _picker = ImagePicker();
    _picker.pickImage(source: ImageSource.gallery).then((XFile? file) async {
      if (file != null) {
        Uint8List imageData = await XFile(file.path).readAsBytes();
        var uuid = Uuid();
        String uniqueFileName = uuid.v4();
        final storageRef = FirebaseStorage.instance.ref();
        final uploadRef = storageRef.child("${uniqueFileName}${file.name}");
        UploadTask uploadTask = uploadRef.putData(imageData);
        TaskSnapshot snapshot = await uploadTask;
        await snapshot.ref.getDownloadURL();
        final db = FirebaseFirestore.instance;
        final userDoc = db.collection("tutors").doc(widget.tutor_id);
        userDoc.update({"profileUrl": "${uniqueFileName}${file.name}"});
        setState(() {});
      }
    });
  }

  void uploadResume() {
    final ImagePicker _picker = ImagePicker();
    _picker.pickImage(source: ImageSource.gallery).then((XFile? file) async {
      if (file != null) {
        Uint8List imageData = await XFile(file.path).readAsBytes();
        final storageRef = FirebaseStorage.instance.ref();
        final uploadRef = storageRef.child(file.name);
        UploadTask uploadTask = uploadRef.putData(imageData);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        final db = FirebaseFirestore.instance;
        final userDoc = db.collection("tutors").doc(widget.tutor_id);
        userDoc.update({"resumeUrl": file.name});
        setState(() {});
      }
    });
  }

  void uploadImage(bool isProfile) {
    final ImagePicker _picker = ImagePicker();
    _picker.pickImage(source: ImageSource.gallery).then((XFile? file) async {
      if (file != null) {
        Uint8List imageData = await XFile(file.path).readAsBytes();
        var uuid = Uuid();
        String uniqueFileName = uuid.v4();
        final storageRef = FirebaseStorage.instance.ref();
        final uploadRef = storageRef.child("${uniqueFileName}${file.name}");
        UploadTask uploadTask = uploadRef.putData(imageData);
        TaskSnapshot snapshot = await uploadTask;
        await snapshot.ref.getDownloadURL();
        final db = FirebaseFirestore.instance;
        final userDoc = db.collection("tutors").doc(widget.tutor_id);
        String url = isProfile ? "profileUrl" : "resumeUrl";
        userDoc.update({url: "${uniqueFileName}${file.name}"});
        setState(() {});
      }
    });
  }

  void toggleIsAvailable(bool value) async {
    final docRef = db.collection("tutors").doc(widget.tutor_id);
    await docRef.update({"isAvailable": !isAvailable});
    setState(() {
      isAvailable = !isAvailable;
    });
  }

  Future<void> editSkills(List<String> currentSkills) async {
    TextEditingController _otherSkillController = TextEditingController();

    final List<String> _checkedSkills = currentSkills;
    bool isOtherChecked = false;

    await showDialog(

        context: context,
        builder: (context){
          return StatefulBuilder(
              builder: (context, setState){
                return AlertDialog(
                  title: Text("Edit Skills"),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          children: skills.map((item) {
                            return CheckboxListTile(
                              title: Text(item),
                              value: _checkedSkills.contains(item),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _checkedSkills.add(item);
                                  } else {
                                    _checkedSkills.remove(item);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        CheckboxListTile(
                          title: Text("Other"),
                          value: isOtherChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isOtherChecked = value!;
                            });
                          },
                        ),

                        isOtherChecked ?
                        TextFormField(
                          controller: _otherSkillController,
                          decoration: InputDecoration(
                              labelText: "other skill", border: OutlineInputBorder()),
                        ) : Container(),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          if (isOtherChecked && _otherSkillController.text != "") {
                            _checkedSkills.add(_otherSkillController.text);
                          }
                          FirebaseFirestore db = FirebaseFirestore.instance;
                          DocumentReference docRef = db.collection("tutors").doc(widget.tutor_id);
                          await docRef.update({
                            "skills": _checkedSkills
                          });
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
    );
    setState(() {
    });
  }

  Future<void> updateSeason() async {
    final db = FirebaseFirestore.instance;
    final doc = db.collection("tutors").doc(widget.tutor_id);
    final docData = (await doc.get()).data();
    if (docData != null && docData["season"] != getCurrentSeason()) {
      doc.update({
        "season": getCurrentSeason(),
        "seasonHours": 0,
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
          "Profile",
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: appBar.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          widget.user_id == widget.tutor_id ? IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      "Delete Account",
                      style: TextStyle(
                        fontSize: titleSize.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    content: Text(
                      "Are you sure you want to delete your account?",
                      style: TextStyle(
                        fontSize: textSize.sp,
                        color: AppColors.textDark,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: buttonText.sp,
                            color: AppColors.primarySage,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          FirebaseAuth.instance.currentUser?.delete();
                          db.collection("tutors").doc(widget.tutor_id).delete();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Homepage()),
                          );
                        },
                        child: Text(
                          "Delete Account",
                          style: TextStyle(
                            fontSize: buttonText.sp,
                            color: AppColors.primarySage,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(
              Icons.delete_rounded,
              size: 40.w,
              color: AppColors.textLight,
            ),
          ) : Container()
        ],
      ),
      body: FutureBuilder(
        future: _loadUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic>? userData = snapshot.data;
            if (userData != null) {
              isAvailable = userData["isAvailable"] ?? false;

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      FutureBuilder(
                        future: loadImage(userData["profileUrl"] ?? ""),
                        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data != null) {
                              return CircleAvatar(
                                radius: 150.sp,
                                backgroundImage: NetworkImage(snapshot.data!),
                              );
                            } else {
                              return Text(
                                "Error",
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
                      SizedBox(height: 24.h),

                      widget.user_id == widget.tutor_id
                          ? ElevatedButton(
                              onPressed: () {
                                uploadImage(true);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primarySage,
                                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              child: Text(
                                "Upload Profile Picture",
                                style: TextStyle(
                                  fontSize: buttonText.sp,
                                  color: AppColors.textLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : Container(),

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
                            ProfileComponent(
                              icon_: Icon(Icons.person_rounded, size: 40.w, color: AppColors.primarySage),
                              label: "First Name",
                              info: userData["firstname"] ?? "Not provided",
                            ),
                            ProfileComponent(
                              icon_: Icon(Icons.person_rounded, size: 40.w, color: AppColors.primarySage),
                              label: "Last Name",
                              info: userData["lastname"] ?? "Not provided",
                            ),
                            ProfileComponent(
                              icon_: Icon(Icons.email_rounded, size: 40.w, color: AppColors.primarySage),
                              label: "Email",
                              info: userData["email"] ?? "Not provided",
                            ),
                            ProfileComponent(
                              icon_: Icon(Icons.person_rounded, size: 40.w, color: AppColors.primarySage),
                              label: "Gender",
                              info: userData["gender"] ?? "Not provided",
                            ),
                            ProfileComponent(
                              icon_: Icon(Icons.access_time_rounded, size: 40.w, color: AppColors.primarySage),
                              label: "Total Hours",
                              info: (userData["totalHours"] ?? 0).toString(),
                            ),
                          ],
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
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Experience:",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: titleSize.sp,
                                color: AppColors.textDark,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: !isEditing
                                      ? Text(
                                          userData["description"] ?? "No description provided",
                                          style: TextStyle(
                                            fontSize: textSize.sp,
                                            color: AppColors.textDark,
                                          ),
                                        )
                                      : TextField(
                                          controller: descriptionController,
                                          maxLines: null,
                                          style: TextStyle(
                                            fontSize: textSize.sp,
                                            color: AppColors.textDark,
                                          ),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(16.r),
                                            ),
                                          ),
                                        ),
                                ),
                                widget.user_id == widget.tutor_id
                                    ? IconButton(
                                        onPressed: () {
                                          if (isEditing) {
                                            editDescription();
                                          } else {
                                            setState(() {
                                              isEditing = true;
                                              descriptionController.text = userData["description"] ?? "";
                                            });
                                          }
                                        },
                                        icon: Icon(
                                          isEditing ? Icons.check_rounded : Icons.edit_rounded,
                                          size: 40.w,
                                          color: AppColors.primarySage,
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ],
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
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Currently Teaching:",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: titleSize.sp,
                                color: AppColors.textDark,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: List<String>.from(userData["skills"] ?? [])
                                        .map(
                                          (e) => Text(
                                            e,
                                            style: TextStyle(
                                              fontSize: textSize.sp,
                                              color: AppColors.textDark,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                                widget.user_id == widget.tutor_id
                                    ? IconButton(
                                        onPressed: () {
                                          editSkills(List<String>.from(userData["skills"] ?? []));
                                        },
                                        icon: Icon(
                                          Icons.edit_rounded,
                                          size: 40.w,
                                          color: AppColors.primarySage,
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 32.h),

                      widget.user_id == widget.tutor_id
                          ? Container(
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Accepting Students",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: titleSize.sp,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  SizedBox(width: 32.w),
                                  Switch(
                                    thumbIcon: widget.thumbIcon,
                                    value: isAvailable,
                                    onChanged: toggleIsAvailable,
                                    activeTrackColor: AppColors.lightSage,
                                    activeColor: AppColors.primarySage,
                                  ),
                                ],
                              ),
                            )
                          : Container(),

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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Available Times:",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: titleSize.sp,
                                color: AppColors.textDark,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            FutureBuilder(
                              future: loadTimeslots(widget.tutor_id),
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
                                        canDelete: false,
                                        onPressed: () {},
                                      );
                                    },
                                  );
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

                      widget.user_id == widget.tutor_id
                          ? ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                        builder: (context) => Timeslot(tutorId: widget.tutor_id),
                                      ),
                                    )
                                    .then((_) {
                                  setState(() {});
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primarySage,
                                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              child: Text(
                                "Edit Time Slot",
                                style: TextStyle(
                                  fontSize: buttonText.sp,
                                  color: AppColors.textLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : Container(),

                      SizedBox(height: 32.h),

                      widget.user_id == widget.tutor_id
                          ? ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AwardPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primarySage,
                                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              child: Text(
                                "My Volunteer Hours",
                                style: TextStyle(
                                  fontSize: buttonText.sp,
                                  color: AppColors.textLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
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
    );
  }
}
