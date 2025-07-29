import 'package:flutter/material.dart';

class TutorView extends StatefulWidget {
  const TutorView({super.key});

  @override
  State<TutorView> createState() => _TutorViewState();
}

class _TutorViewState extends State<TutorView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Tutor View'),
      ),
    );
  }
} 