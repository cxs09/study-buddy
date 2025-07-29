import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../consts.dart';

class ReviewView extends StatelessWidget {
  final String title;
  final String studentId;
  final int rating;
  final String comment;
  const ReviewView(
      {super.key,
      required this.title,
      required this.studentId,
      required this.rating,
      required this.comment});

  Future<Map<String, dynamic>?> _loadUser() async {
    final db = FirebaseFirestore.instance;
    return (await db.collection("students").doc(studentId).get()).data();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
              future: _loadUser(),
              builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null) {

                    List<Widget> stars = List.generate(rating, (index)=>Icon(Icons.star, size: 18, color: Colors.yellow,));

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapshot.data!["firstname"], style: TextStyle(fontSize: textSize.sp, color: Colors.blueAccent, fontWeight: FontWeight.bold),),
                        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize.sp),),
                        Row(
                          children: stars,
                        ),
                        Text(comment, style: TextStyle(fontSize: textSize.sp),)
                      ]
                    );

                  } else {
                    return Container();
                  }
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ],
      ),
    );
  }
}
