// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:tutor_app/pages/course_page.dart';
// import 'package:tutor_app/pages/dashboard.dart';
// import 'package:tutor_app/pages/tutor_list.dart';
//
// class ReviewPage extends StatefulWidget {
//   final String studentId;
//   final String tutorId;
//
//   ReviewPage({super.key, required this.studentId, required this.tutorId});
//
//   @override
//   State<ReviewPage> createState() => _ReviewPageState();
// }
//
// class _ReviewPageState extends State<ReviewPage> {
//   final TextEditingController _titleController = TextEditingController();
//
//   final TextEditingController _commentController = TextEditingController();
//
//   int? _rating;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Review",
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.blue,
//       ),
//
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextField(
//                 controller: _titleController,
//                 decoration: InputDecoration(
//                     labelText: "title", border: OutlineInputBorder()),
//               ),
//               SizedBox(height: 30,),
//
//               DropdownButtonFormField(
//                 value: _rating,
//                 decoration: InputDecoration(
//                     labelText: "rating", border: OutlineInputBorder()),
//                 items: <int>[1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value){
//                   return DropdownMenuItem<int>(value: value, child: Text(value.toString()),);
//                 }).toList(),
//                 onChanged: (int? newValue){
//                   setState(() {
//                     _rating = newValue;
//                   });
//                 },
//                 validator: (int? value){
//                   if (value == null) {
//                     return "Please give a rating";
//                   }
//                   return null;
//                 },
//               ),
//
//               SizedBox(height: 30,),
//               TextField(
//                 controller: _commentController,
//                 decoration: InputDecoration(
//                     labelText: "comments", border: OutlineInputBorder()),
//               ),
//               SizedBox(height: 30,),
//               ElevatedButton(onPressed: (){
//                 final db = FirebaseFirestore.instance;
//                 Map<String, dynamic> review_info = {
//                   "title": _titleController.text,
//                   "rating": _rating,
//                   "comment": _commentController.text,
//                   "tutorId": widget.tutorId,
//                   "studentId": widget.studentId,
//                 };
//                 db.collection("reviews").add(review_info).then((_) {
//                   Navigator.of(context).push(MaterialPageRoute(
//                       builder: (context) => Dashboard()));
//                   // Navigate to home page
//                 });
//               }, child: Text("Submit"))
//             ],
//           ),
//         ),
//       ),
//
//     );
//   }
// }
