import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutor_app/components/profile_component.dart';
import 'package:uuid/uuid.dart';
import 'package:tutor_app/styles/colors.dart';

import '../../consts.dart';
import '../../util/constants.dart';
import '../home/homepage.dart';

class StudentProfile extends StatefulWidget {
  final String student_id;

  //final String image;
  StudentProfile({super.key, required this.student_id});

  String? user_id = FirebaseAuth.instance.currentUser?.uid;

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  bool isEditing = false;
  TextEditingController descriptionController = TextEditingController();
  final db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> _loadUser() async {
    return (await db.collection("students").doc(widget.student_id).get())
        .data();
  }

  Future<String?> _loadImage(String imageName) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final downloadRef = storageRef.child(imageName);
      final url = await downloadRef.getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> editDescription() async {
    final docRef = db.collection("students").doc(widget.student_id);
    await docRef.update({"description": descriptionController.text});
    setState(() {
      isEditing = false;
    });
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
          widget.user_id == widget.student_id
              ? IconButton(
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
                                db.collection("students").doc(widget.user_id).delete();
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
                )
              : Container(),
        ],
      ),
      body: FutureBuilder(
        future: _loadUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic>? userData = snapshot.data;
            if (userData != null) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      FutureBuilder(
                        future: _loadImage(userData["profileUrl"]),
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

                      widget.user_id == widget.student_id
                          ? ElevatedButton(
                              onPressed: () {
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
                                    String downloadUrl = await snapshot.ref.getDownloadURL();
                                    final db = FirebaseFirestore.instance;
                                    final userDoc = db.collection("students").doc(widget.student_id);
                                    userDoc.update({
                                      "profileUrl": "${uniqueFileName}${file.name}",
                                    });
                                    setState(() {});
                                  }
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
                              info: userData["firstname"],
                            ),
                            ProfileComponent(
                              icon_: Icon(Icons.person_rounded, size: 40.w, color: AppColors.primarySage),
                              label: "Last Name",
                              info: userData["lastname"],
                            ),
                            ProfileComponent(
                              icon_: Icon(Icons.email_rounded, size: 40.w, color: AppColors.primarySage),
                              label: "Email",
                              info: userData["email"],
                            ),
                            ProfileComponent(
                              icon_: Icon(Icons.person_rounded, size: 40.w, color: AppColors.primarySage),
                              label: "Gender",
                              info: userData["gender"],
                            ),
                            ProfileComponent(
                              icon_: Icon(Icons.school_rounded, size: 40.w, color: AppColors.primarySage),
                              label: "HS Grad Year",
                              info: userData["hsGradYear"],
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Learning Experience:",
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
                                          userData["description"],
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
                                widget.user_id == widget.student_id
                                    ? IconButton(
                                        onPressed: () {
                                          if (isEditing) {
                                            editDescription();
                                          } else {
                                            setState(() {
                                              isEditing = true;
                                              descriptionController.text = userData["description"];
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
