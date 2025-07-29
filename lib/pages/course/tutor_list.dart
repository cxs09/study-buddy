import 'dart:convert';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:tutor_app/components/tutor_view.dart';
import 'package:tutor_app/consts.dart';
import 'package:tutor_app/pages/dashboard/dashboard_route.dart';
import 'package:tutor_app/data/tutor.dart';
import 'package:tutor_app/styles/colors.dart';
import 'package:tutor_app/main.dart';

class TutorList extends StatefulWidget {
  final Map<String, dynamic> classinfo;

  TutorList({super.key, required this.classinfo});

  @override
  State<TutorList> createState() => _TutorListState();
}

class _TutorListState extends State<TutorList> {
  final _openai = OpenAI.instance.build(token: OPENAI_API_KEY);
  final _searchController = TextEditingController();

  String? user_id = FirebaseAuth.instance.currentUser?.uid;

  List<Tutor> tutors = <Tutor>[];
  List<Tutor> filterTutors = <Tutor>[];

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

  Future<List<Tutor>> _loadTutors() async {
    final db = FirebaseFirestore.instance;
    final userDocs =
        (await db
                .collection("tutors")
                .where("isAvailable", isEqualTo: true)
                .get())
            .docs;

    List<Tutor> tutors = [];

    for (var user in userDocs) {
      Map data = user.data();

      // Extract skills
      List<String> tutorSkills = List<String>.from(data["skills"]);

      // Check if tutor teaches the requested subject
      if (!tutorSkills.contains(widget.classinfo["subject"])) continue;

      tutors.add(
        Tutor(
          user.id,
          data['firstname'],
          data['lastname'],
          data['profileUrl'],
          tutorSkills,
        ),
      );
    }

    // Filter tutors by name search
    filterTutors =
        tutors
            .where(
              (tutor) => "${tutor.firstName} ${tutor.lastName}"
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()),
            )
            .toList();

    return filterTutors;
  }

  //
  // Future<List<Tutor>> _loadTutors() async {
  //   final db = FirebaseFirestore.instance;
  //   final userDocs =
  //       (await db
  //               .collection("tutors")
  //               .where("isAvailable", isEqualTo: true)
  //               .get())
  //           .docs;
  //
  //   List<Tutor> tutors = [];
  //
  //   for (var user in userDocs) {
  //     Map data = user.data();
  //
  //     // Skip tutors without a resume
  //     //if (data['resumeUrl'] == 'document_placeholder.png') continue;
  //
  //     // Load resume URL
  //     String? url = await _loadImage(data['resumeUrl']);
  //     if (url == null) continue;
  //
  //     // Extract skills
  //     List<String> tutorSkills = List<String>.from(data["skills"]);
  //
  //     // Check if tutor teaches the requested subject
  //     if (!tutorSkills.contains(widget.classinfo["subject"])) continue;
  //
  //     // Fetch trustworthiness info
  //     Map<String, dynamic>? trustworthinessInfo = await getTrustworthinessInfo(
  //       url,
  //     );
  //
  //     tutors.add(
  //       Tutor(
  //         user.id,
  //         data['firstname'],
  //         data['lastname'],
  //         data['profileUrl'],
  //         tutorSkills,
  //         trustworthinessInfo?['Knowledge'] ?? "Not Provided",
  //         // trustworthinessInfo?['Trust Score']?.toString() ??
  //         //     "Awaiting Submission",
  //         // trustworthinessInfo?['Years Teaching']?.toString() ??
  //         //     "Resume Not Submitted",
  //       ),
  //     );
  //   }
  //
  //   // Filter tutors by name search
  //   filterTutors =
  //       tutors
  //           .where(
  //             (tutor) => "${tutor.firstName} ${tutor.lastName}"
  //                 .toLowerCase()
  //                 .contains(_searchController.text.toLowerCase()),
  //           )
  //           .toList();
  //
  //   return filterTutors;
  // }


  // Future<Map<String, dynamic>?> getTrustworthinessInfo(String imageUrl) async {
  //   String prompt = '''
  //   Analyze the trustworthiness of the tutor based on the resume image. Generate a JSON file that includes the following attributes:
  //
  //   Knowledge: A summary of the tutor's expertise based on their qualifications, certifications, and experience.
  //   Trust Score: A numerical score (out of 10) representing the tutor's reliability and credibility, derived from their years of teaching experience, certifications, and skills.
  //   Years Teaching: The total number of years the tutor has been teaching, as indicated in the resume.
  //   Return the JSON file. The JSON file should be in the following format:
  //   {
  //     "Knowledge": "<knowledge summary>",
  //     "Trust Score": <trust score>,
  //     "Years Teaching": <years teaching>
  //   }
  //   ''';
  //   String base64Image = await convertImageToBase64(imageUrl);
  //   print(imageUrl);
  //   final request = ChatCompleteText(
  //     messages: [
  //       {
  //         "role": "user",
  //         "content": [
  //           {"type": "text", "text": prompt},
  //           {
  //             "type": "image_url",
  //             "image_url": {"url": "data:image/png;base64,$base64Image"},
  //           },
  //         ],
  //       },
  //     ],
  //     maxToken: 1000,
  //     model: Gpt4OChatModel(),
  //     responseFormat: ResponseFormat.jsonObject,
  //   );
  //
  //   ChatCTResponse? response = await _openai.onChatCompletion(request: request);
  //   String result = response!.choices.first.message!.content.trim();
  //   // print(result);
  //   Map<String, dynamic> trustworthinessInfo = {};
  //   try {
  //     trustworthinessInfo = Map<String, dynamic>.from(json.decode(result));
  //     return trustworthinessInfo;
  //   } catch (e) {
  //     print('Error parsing JSON: $e');
  //     return null;
  //   }
  // }
  //
  //
  // Future<String> convertImageToBase64(String imageUrl) async {
  //   try {
  //     // Fetch the image from the URL
  //     final response = await http.get(Uri.parse(imageUrl));
  //
  //     // Check if the request was successful
  //     if (response.statusCode == 200) {
  //       // Convert the image bytes to Base64
  //       Uint8List bytes = response.bodyBytes;
  //       String base64String = base64Encode(bytes);
  //
  //       return base64String; // Return the Base64 string
  //     } else {
  //       throw Exception('Failed to load image');
  //     }
  //   } catch (e) {
  //     return 'Error: $e';
  //   }
  // }

  Future<void> selectTutor(String tutorId) async {
    final db = FirebaseFirestore.instance;
    final course = <String, dynamic>{
      "title": widget.classinfo["title"],
      "time": widget.classinfo["time"],
      "subject": widget.classinfo["subject"],
      "student": user_id,
      "tutor": tutorId,
      "confirmed": false,
      "minutes": widget.classinfo["minutes"],
      "sessions": widget.classinfo["sessions"],
      "totalHours": 0,
    };
    await db.collection("classes").add(course);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primarySage,
        elevation: 0,
        title: Text(
          "Find Your Tutor",
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: appBar.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: FutureBuilder(
        future: _loadTutors(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final matches = snapshot.data;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: AppColors.primarySage,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24.r),
                        bottomRight: Radius.circular(24.r),
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(
                        fontSize: textSize.sp,
                        color: AppColors.textLight,
                      ),
                      decoration: InputDecoration(
                        labelText: "Search tutors",
                        labelStyle: TextStyle(
                          fontSize: textSize.sp,
                          color: AppColors.textLight.withOpacity(0.8),
                        ),
                        hintText: "Enter tutor name",
                        hintStyle: TextStyle(
                          fontSize: textSize.sp,
                          color: AppColors.textLight.withOpacity(0.6),
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          size: 40.w,
                          color: AppColors.textLight,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.darkSage.withOpacity(0.3),
                      ),
                    ),
                  ),
                  if (filterTutors.isEmpty)
                    Padding(
                      padding: EdgeInsets.all(32.w),
                      child: Column(
                        children: [
                          Icon(
                            Icons.person_search_rounded,
                            size: 120.w,
                            color: AppColors.primarySage,
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            "No tutors found",
                            style: TextStyle(
                              fontSize: textSize.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            "Try adjusting your search",
                            style: TextStyle(
                              fontSize: textSize.sp,
                              color: AppColors.darkSage,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (filterTutors.isNotEmpty)
                    ListView.builder(
                      padding: EdgeInsets.all(24.w),
                      scrollDirection: Axis.vertical,
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filterTutors.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 24.h),
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
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.all(24.w),
                            childrenPadding: EdgeInsets.all(24.w),
                            backgroundColor: AppColors.accentMint,
                            collapsedBackgroundColor: Colors.white,
                            title: TutorView(
                              name: filterTutors[index].firstName,
                              image: filterTutors[index].profileUrl,
                            ),
                            children: [
                              Divider(color: AppColors.lightSage),
                              _buildInfoTile(
                                Icons.person_rounded,
                                "Name",
                                "${filterTutors[index].firstName} ${filterTutors[index].lastName}",
                              ),
                              _buildInfoTile(
                                Icons.school_rounded,
                                "Skills",
                                filterTutors[index].skills.join(", "),
                              ),
                              SizedBox(height: 24.h),
                              ElevatedButton(
                                onPressed: () {
                                  selectTutor(filterTutors[index].id).then((_) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => DashboardRoute(isTutor: false),
                                      ),
                                    );
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primarySage,
                                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      size: 40.w,
                                      color: AppColors.textLight,
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      "Select Tutor",
                                      style: TextStyle(
                                        fontSize: buttonText.sp,
                                        color: AppColors.textLight,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.hourglass_empty_rounded,
                    size: 120.w,
                    color: AppColors.primarySage,
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    "Loading tutors...",
                    style: TextStyle(
                      fontSize: textSize.sp,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primarySage),
                    strokeWidth: 4,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primarySage,
            size: 40.w,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: textSize.sp,
                    color: AppColors.darkSage,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: textSize.sp,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
