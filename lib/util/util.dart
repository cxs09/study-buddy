import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>?>
loadTimeslots(String tutorId) async {
  final db = FirebaseFirestore.instance;
  return (await db
      .collection("timeslots")
      .where("tutorId", isEqualTo: tutorId)
      .get())
      .docs;
}

Future<void> deleteItem(String collection, String Id) async {
  final db = FirebaseFirestore.instance;
  final docRef = db.collection(collection).doc(Id);
  await docRef.delete();
}

Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>?>
loadCourses(bool isTutor, String user_id) async {
  final db = FirebaseFirestore.instance;
  final userType = isTutor ? "tutor" : "student";
  return (await db
      .collection("classes")
      .where(userType, isEqualTo: user_id)
      .where("confirmed", isEqualTo: true)
      .get())
      .docs;
}

Future<String?> loadImageUrl(String? imageName) async {
  try {
    if (imageName == null || imageName.isEmpty) {
      return null;
    }
    final storageRef = FirebaseStorage.instance.ref();
    final downloadRef = storageRef.child(imageName);
    final url = await downloadRef.getDownloadURL();
    return url;
  } catch (e) {
    print('Error loading image URL: $e');
    return null;
  }
}

Future<String?> loadImage(String imageName) async {
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

String getCurrentSeason() {
  DateTime now = DateTime.now();
  int month = now.month;
  int year = now.year;
  if (month >= 6 && month <= 11) {
    return "$year second";
  } else if (month == 12){
    return "${year+1} first";
  } else {
    return "$year first";
  }
}

List<String> getTwoSeasons() {
  DateTime now = DateTime.now();
  int year = now.year;
  String currentSeason = getCurrentSeason();
  if (currentSeason.endsWith("first")) {
    return [
      "${year-1} second",
      currentSeason
    ];
  } else {
    return [
      currentSeason,
      "$year first"
    ];
  }
}
