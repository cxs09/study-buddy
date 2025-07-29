import 'package:cloud_firestore/cloud_firestore.dart';

class Course{
  String id;
  String title;
  String time;
  String subject;
  String tutor;
  String student;
  int minutes;
  String hours;
  Course(this.id, this.title, this.time, this.subject, this.tutor, this.student, this.minutes, this.hours);
}