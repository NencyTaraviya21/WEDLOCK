import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wedlock_admin/WedLock/login_register_page.dart';

class PlayScreenWedLock extends StatefulWidget {
  const PlayScreenWedLock({super.key});

  @override
  State<PlayScreenWedLock> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreenWedLock> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => WedLockLoginRegister()));
    });
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "WedLock",
                    style: TextStyle(
                      fontFamily: 'Libre',
                      fontSize: size.width * 0.09, // Responsive font size
                      fontWeight: FontWeight.bold, // Bold text
                      color: Colors.pink.shade600, // Text color
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 3,
                          color: Colors.pink.shade600.withOpacity(0.5),),
                      ],
                    ),
                  ),

                  Icon(Icons.lock,color: Colors.yellowAccent.shade700,size: 50,
                  ),
                  SizedBox(width: 10),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "Your journey to happiness begins here!",
                style: TextStyle(
                  fontFamily: 'Lexend_Giga',
                  fontSize: size.width * 0.03, // Smaller responsive font size
                  fontWeight: FontWeight.w500, // Medium font weight
                  color: Colors.pink.shade600, // Subtle text color
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 2,
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
