import 'package:aswdc_flutter_pub/aswdc_flutter_pub.dart';
import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: DeveloperScreen(
            backgroundColor: Colors.pink.shade50,
            colorValue:Colors.pink.shade700,
            developerName: ' Nency Taraviya (23010101267)',
            mentorName: ' Prof. Mehul Bhundiya',
            exploredByName: ' ASWDC',
            isAdmissionApp: true,
            isDBUpdate: true,
            shareMessage: '',
            appTitle: 'WedLock',
            appBarColor: Colors.pink.shade700,
            appLogo: 'assets/images/applogo.png',
          ),
        ),
      ),
    );
  }
}