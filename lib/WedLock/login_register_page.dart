import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'WedLock',
          style: TextStyle(fontSize: 30, color: Colors.white, fontFamily: 'Libre', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink.shade700,
      ),
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.pink.shade100, Colors.pink.shade300], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isRegister ? 'Signup' : 'Login',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pink.shade700),
                        ),
                        SizedBox(height: 20),

                        /// Username Field (Only for Signup)
                        if (isRegister)
                          getTextFormField(userName, 'Enter username', 'Username', validation: (value) {
                            if (value!.isEmpty) return 'Please enter a username';
                            if (!RegExp(r'[A-Za-z]').hasMatch(value)) return 'Please enter a valid username';
                            return null;
                          }),

                        SizedBox(height: 15),

                        /// Email Field (Used for Login & Signup)
                        getTextFormField(email, 'Enter email', 'Email', validation: (value) {
                          if (value!.isEmpty) return 'Please enter an email';
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Enter a valid email';
                          return null;
                        }),

                        /// Phone Field (Only for Signup)
                        if (isRegister)
                          SizedBox(height: 15),
                        if (isRegister)
                          getTextFormField(phone, 'Enter phone number', 'Phone Number', validation: (value) {
                            if (value!.isEmpty || !RegExp(r'^\d{10}$').hasMatch(value)) return 'Please enter a valid phone number';
                            return null;
                          }),

                        SizedBox(height: 15),

                        /// Password Field
                        getTextFormField(password, 'Enter password', 'Password', obscureText: true, validation: (value) {
                          if (value!.isEmpty || !RegExp(r'^(?=.*[!@#\$&*~]).{6,}$').hasMatch(value)) {
                            return 'Password must be at least 6 characters & contain a special character';
                          }
                          return null;
                        }),

                        /// Confirm Password (Only for Signup)
                        if (isRegister)
                          SizedBox(height: 15),
                        if (isRegister)
                          getTextFormField(confirmPassword, 'Confirm password', 'Confirm Password', obscureText: true, validation: (value) {
                            if (value!.isEmpty || value != password.text) return 'Passwords do not match';
                            return null;
                          }),

                        SizedBox(height: 20),

                        /// Login/Signup Button
                        ElevatedButton(
                          child: Text(isRegister ? 'Signup' : 'Login', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink.shade700,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              SharedPreferences prefs = await SharedPreferences.getInstance();

                              if (isRegister) {
                                /// Signup Logic
                                await prefs.setString('email', email.text);
                                await prefs.setString('phone', phone.text);
                                await prefs.setString('username', userName.text);
                                await prefs.setString('password', password.text);

                                globalUserName = userName.text;
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration successful')));
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardWedLock()));
                              } else {
                                /// Login Logic
                                String? storedEmail = prefs.getString('email');
                                String? storedPassword = prefs.getString('password');

                                print("Stored Email: $storedEmail");
                                print("Stored Password: $storedPassword");
                                print("Entered Email: ${email.text}");
                                print("Entered Password: ${password.text}");

                                if (storedEmail != null && storedPassword != null && email.text == storedEmail && password.text == storedPassword) {
                                  globalUserName = userName.text;
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardWedLock()));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid credentials')));
                                }
                              }
                            }
                          },
                        ),

                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(isRegister ? 'Already have an account? ' : "Don't have an account? "),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isRegister = !isRegister;
                                  email.clear();
                                  phone.clear();
                                  userName.clear();
                                  password.clear();
                                  confirmPassword.clear();
                                });
                              },
                              child: Text(
                                isRegister ? 'Login' : 'Signup',
                                style: TextStyle(color: Colors.pink.shade700, fontWeight: FontWeight.bold),
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
      ),
    );
  }

  /// Reusable TextFormField Widget
  Widget getTextFormField(
      TextEditingController textController,
      String hintText,
      String labelText, {
        bool obscureText = false,
        required String? Function(String?) validation,
      }) {
    return TextFormField(
      controller: textController,
      obscureText: obscureText,
      validator: validation,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.pink.shade700),
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.pink.shade700),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.pink.shade700)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.pink.shade700, width: 1)),
      ),
    );
  }
}
