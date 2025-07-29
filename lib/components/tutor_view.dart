import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../consts.dart';

class TutorView extends StatelessWidget {
  final String name;
  final String image;

  const TutorView({super.key, required this.name, required this.image});

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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FutureBuilder(
            future: _loadImage(image),
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  // return CircleAvatar(
                  //   backgroundImage: snapshot.data!,
                  // );
                  return CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(snapshot.data!),
                  );
                } else {
                  return Text("Error");
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          SizedBox(width: 35),
          Text(name, style: TextStyle(fontSize: textSize.sp)),

        ],
      ),
    );
  }
}
