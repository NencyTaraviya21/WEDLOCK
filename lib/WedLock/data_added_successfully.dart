import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wedlock_admin/WedLock/userlist.dart';


class DataAddedSuccessfully extends StatefulWidget {
  const DataAddedSuccessfully({super.key});

  @override
  State<DataAddedSuccessfully> createState() => _DataAddedSuccessfullyState();
}


class _DataAddedSuccessfullyState extends State<DataAddedSuccessfully> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Userlist()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Dark background color
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.pink.shade100, Colors.pink.shade300]),
            color: Colors.white70, // Darker container color
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.white70,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white70,
                size: 60,
              ),
              SizedBox(height: 20),
              Text(
                "DATA ADDED SUCCESSFULLY",
                style: TextStyle(
                  color: Colors.pink.shade700,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "Your data has been successfully stored.",
                style: TextStyle(
                  color: Colors.pink.shade700,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              // CheckboxListTile(,value: true, onChanged: (value) {
              //
              // },)
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
