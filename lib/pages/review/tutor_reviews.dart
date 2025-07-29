import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tutor_app/components/review_view.dart';
import 'package:tutor_app/data/review.dart';

class TutorReviews extends StatelessWidget {
  final String tutorId;
  TutorReviews({super.key, required this.tutorId});

  final db = FirebaseFirestore.instance;

  final List<Review> reviews = <Review>[];

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>?>
  _loadReviews() async {
    final db = FirebaseFirestore.instance;
    return (await db
        .collection("reviews")
        .where("tutorId", isEqualTo: tutorId)
        .get())
        .docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Tutor Reviews",
          style: TextStyle(color: Colors.white),
        ),
      ),

        body: Column(
          children: [
            FutureBuilder(
              future: _loadReviews(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  reviews.clear();
                  snapshot.data.forEach((element) {
                    reviews.add(Review(
                        element.id,
                        element.data()["tutorId"],
                        element.data()["studentId"],
                        element.data()["rating"],
                        element.data()["title"],
                        element.data()["comment"]));
                  });
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: ReviewView(
                          title: reviews[index].title,
                          studentId: reviews[index].studentId,
                          rating: reviews[index].rating,
                          comment: reviews[index].comments,
                        ),
                      );
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
    );
  }
}
