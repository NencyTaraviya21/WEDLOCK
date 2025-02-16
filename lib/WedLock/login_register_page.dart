import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:wedlock_admin/WedLock/dashboard_matrimony.dart';
import 'package:wedlock_admin/WedLock/global.dart';


class WedLockLoginRegister extends StatefulWidget {
  WedLockLoginRegister({super.key});

  @override
  State<WedLockLoginRegister> createState() => _FormLoginRegistrationState();
}

class _FormLoginRegistrationState extends State<WedLockLoginRegister> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();



  bool isRegister = false;
  String username = 'Username';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text(
            'WedLock',
            style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontFamily: 'Libre',
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.pink.shade700,
        ),
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink.shade100, Colors.pink.shade300],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              // the SingleChildScrollView wraps the entire form to prevent it from being cut off or inaccessible when the keyboard appears or the screen size is small
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24.0, horizontal: 16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isRegister ? 'Signup' : 'Login',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink.shade700,
                            ),
                          ),
                          SizedBox(height: 20),
                          getTextFormField(
                              userName, 'Enter username', 'Username',
                              validation: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a username';
                            }
                            if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
                              return 'Please enter a valid username';
                            }
                            return null;
                          }, onChanged: (value) {
                            setState(() {
                              globalUserName = value;
                            });
                          }),
                          SizedBox(height: 15),
                          getTextFormField(
                            email,
                            'Enter email',
                            'Email',
                            validation: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an email';
                              }
                              if (!RegExp(
                                      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                  .hasMatch(value)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          if (isRegister) ...[
                            //The ... spreads the list of widgets into the Column's children only if the condition isRegister is true
                            SizedBox(height: 15),
                            getTextFormField(
                              phone,
                              'Enter phone number',
                              'Phone Number',
                              validation: (value) {
                                if (value!.isEmpty ||
                                    !RegExp(r'^\d{10}$').hasMatch(value)) {
                                  return 'Please enter a valid phone number';
                                }
                                return null;
                              },
                            ),
                          ],
                          SizedBox(height: 15),
                          getTextFormField(
                            password,
                            'Enter password',
                            'Password',
                            validation: (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r'[a-zA-Z0-9](?=.*?[!@#\$&*~])')
                                      .hasMatch(value)) {
                                return 'Please enter a valid password';
                              }
                              return null;
                            },
                          ),
                          if (isRegister) ...[
                            SizedBox(height: 15),
                            getTextFormField(
                              confirmPassword,
                              'Confirm password',
                              'Confirm Password',
                              validation: (value) {
                                if (value!.isEmpty || value != password.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                          ],
                          SizedBox(height: 20),
                          ElevatedButton(
                              child: Text(
                                isRegister ? 'Signup' : 'Login',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink.shade700,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DashboardWedLock()));
                                  };
                              },),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isRegister
                                    ? 'Already have an account? '
                                    : "Don't have an account? ",
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isRegister = !isRegister;
                                  });
                                },
                                child: Text(
                                  isRegister ? 'Login' : 'Signup',
                                  style: TextStyle(
                                    color: Colors.pink.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget getTextFormField(
    TextEditingController textController,
    String hintText,
    String labelText, {
    validation,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      validator: validation,
      controller: textController,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.pink.shade700),
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.pink.shade700),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pink.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pink.shade700, width: 1),
        ),
      ),
    );
  }
}
