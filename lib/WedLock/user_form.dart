import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wedlock_admin/Utils/string_const.dart';
import 'package:wedlock_admin/WedLock/data_added_successfully.dart';
import 'package:wedlock_admin/WedLock/crud.dart';
import 'package:wedlock_admin/WedLock/database/my_database.dart';

class UserForm extends StatefulWidget {
  UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final MyDatabase myDatabase = MyDatabase();
  User users = User();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirm_password = TextEditingController();
  TextEditingController dateController = TextEditingController();
  final ValueNotifier<int?> ageNotifier = ValueNotifier<int?>(null);

  final List<String> userList = [];

  void showEditDialog(int index) {
    email.text = userList[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Item'),
          content: TextField(
            controller: email,
            decoration: InputDecoration(hintText: 'Enter email'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                (index, email.text);
                Navigator.pop(context);
              },
              child: Text('Edit'),
            ),
          ],
        );
      },
    );
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedGender = '';
  String? selectedCity = 'Select City';
  DateTime? date = DateTime.now();
  List<String> hobbies = [];
  int? age;

  final List<String> cities = [
    'Select City',
    'Jamnagar',
    'Rajkot',
    'Baroda',
    'Surat',
    'Vapi'
  ];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              width: size.width,
              height: size.height * 0.3,
              child: Image.asset(
                'assets/images/hands.webp',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    getTextFormField(
                      textcontroller: firstname,
                      hinttext: 'First Name',
                      labeltext: 'First Name',
                      key_type: TextInputType.name,
                      formaters: FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z]')),
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Firstname';
                        }
                        if (!RegExp(r'^[A-Za-z]+$').hasMatch(value)) {
                          return 'Please enter a valid username (letters only)';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),

                    getTextFormField(
                      textcontroller: lastname,
                      hinttext: 'Last Name',
                      labeltext: 'Last Name',
                      key_type: TextInputType.name,
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Lastname';
                        }
                        if (!RegExp(r'^[A-Za-z]+$').hasMatch(value)) {
                          return 'Please enter a valid username (letters only)';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),

                    getTextFormField(
                      textcontroller: phone,
                      hinttext: 'Mobile number',
                      labeltext: 'Mobile number',
                      key_type: TextInputType.number,
                      formaters:  FilteringTextInputFormatter.digitsOnly,
                      validation: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !RegExp(r'^\d{10}$').hasMatch(value)) {
                          return 'Please enter a valid 10-digit phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),

                    getTextFormField(
                      textcontroller: email, // textcontroller
                      hinttext: 'Email', // hinttext
                      labeltext: 'Email', // labeltext
                      key_type: TextInputType
                          .emailAddress, // optional named parameter
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),

                    getTextFormField(
                      textcontroller: password,
                      hinttext: 'Password',
                      labeltext: 'Password',
                      obscureText: true,
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (!RegExp(
                                r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$')
                            .hasMatch(value)) {
                          return 'Password must be at least 8 characters with letters, numbers, and special characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),

                    getTextFormField(
                      textcontroller: confirm_password,
                      hinttext: 'Confirm Password',
                      labeltext: 'Confirm Password',
                      obscureText: true,
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != password.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    FormField(
                      builder: (FormFieldState state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InputDecorator(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFBfae3f1),
                                labelText: 'Hobbies',

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(width: 1.5),
                                ),
                                errorText: state.errorText,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: CheckboxListTile(
                                          title: Text('Playing',
                                              style: TextStyle(
                                                fontSize: 17,
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                          value: hobbies.contains('Playing'),
                                          onChanged: (value) {
                                            setState(() {
                                              if (value == true) {
                                                hobbies.add('Playing');
                                              } else {
                                                hobbies.remove('Playing');
                                              }
                                            });
                                          },
                                          controlAffinity: ListTileControlAffinity
                                              .leading,
                                          contentPadding: EdgeInsets
                                              .zero,
                                        ),
                                      ),
                                      Expanded(
                                        child: CheckboxListTile(
                                          title: Text('Singing',
                                              style: TextStyle(fontSize: 17),
                                            overflow: TextOverflow.ellipsis,),
                                          value: hobbies.contains('Singing'),
                                          onChanged: (value) {
                                            setState(() {
                                              if (value == true) {
                                                hobbies.add('Singing');
                                              } else {
                                                hobbies.remove('Singing');
                                              }
                                            });
                                          },
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                      Expanded(
                                        child: CheckboxListTile(
                                          title: Text('Swimming',
                                              style: TextStyle(fontSize: 17),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          value: hobbies.contains('Swimming'),
                                          onChanged: (value) {
                                            setState(() {
                                              if (value == true) {
                                                hobbies.add('Swimming');
                                              } else {
                                                hobbies.remove('Swimming');
                                              }
                                            });
                                          },
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CheckboxListTile(
                                          title: Text('Dancing',
                                              style: TextStyle(fontSize: 17),
                                            overflow: TextOverflow.ellipsis,),
                                          value: hobbies.contains('Dancing'),
                                          onChanged: (value) {
                                            setState(() {
                                              if (value == true) {
                                                hobbies.add('Dancing');
                                              } else {
                                                hobbies.remove('Dancing');
                                              }
                                            });
                                          },
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                      Expanded(
                                        child: CheckboxListTile(
                                          title: Text('Reading',
                                              style: TextStyle(fontSize: 17),
                                            overflow: TextOverflow.ellipsis,),
                                          value: hobbies.contains('Reading'),
                                          onChanged: (value) {
                                            setState(() {
                                              if (value == true) {
                                                hobbies.add('Reading');
                                              } else {
                                                hobbies.remove('Reading');
                                              }
                                            });
                                          },
                                          controlAffinity:
                                          ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                      Expanded(
                                        child: CheckboxListTile(
                                          title: Text('Writing',
                                              style: TextStyle(fontSize: 17),
                                            overflow: TextOverflow.ellipsis,),
                                          value: hobbies
                                              .contains('Plubic speaking'),
                                          onChanged: (value) {
                                            setState(() {
                                              if (value == true) {
                                                hobbies.add('Plubic speaking');
                                              } else {
                                                hobbies
                                                    .remove('Plubic speaking');
                                              }
                                            });
                                          },
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                      validator: (value) {
                        if (hobbies.isEmpty) {
                          return 'Please select at least one hobby';
                        }
                        return null;
                      },
                    ), //hobbies

                    Row(
                      children: [
                        Text(
                          'Gender',
                          style: TextStyle(color: Colors.pink.shade700),
                        ),
                        SizedBox(
                          width: 22,
                        ),
                        Radio(
                          value: 'Male',
                          groupValue: selectedGender,
                          onChanged: (String? value) {
                            setState(() {
                              selectedGender = value!;
                            });
                          },
                          activeColor: Colors.pink.shade700,
                        ),
                        Text('Male',
                            style: TextStyle(color: Colors.pink.shade700)),
                        Radio(
                          value: 'Female',
                          groupValue: selectedGender,
                          onChanged: (String? value) {
                            setState(() {
                              selectedGender = value!;
                            });
                          },
                          activeColor: Colors.pink.shade700,
                        ),
                        Text('Female',
                            style: TextStyle(color: Colors.pink.shade700)),
                      ],
                    ), //gender
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text('Select city',
                            style: TextStyle(color: Colors.pink.shade700)),
                        SizedBox(width: 10), // Add spacing
                        Expanded(
                          child: DropdownButtonFormField(
                            value: selectedCity,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.pink.shade700),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.pink.shade700, width: 1.0),
                              ),
                            ),
                            items: cities
                                .map((String city) => DropdownMenuItem<String>(
                                      value: city,
                                      child: Text(city),
                                    ))
                                .toList(),
                            onChanged: (String? value) {
                              setState(() {
                                selectedCity = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ), //cities
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          'Select DOB',
                          style: TextStyle(color: Colors.pink.shade700),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: dateController,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: 'dd/mm/yyyy',
                              hintStyle: TextStyle(color: Colors.pink.shade700),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.pink.shade700),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.pink.shade700, width: 1.0),
                              ),
                              suffixIcon: IconButton(
                                color: Colors.pink.shade700,
                                onPressed: () async {
                                  DateTime? date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1991),
                                    lastDate: DateTime(2007),
                                  );
                                  if (date != null) {
                                    dateController.text =
                                    "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";

                                    int calculatedAge = DateTime.now().year - date.year;
                                    if (DateTime.now().month < date.month ||
                                        (DateTime.now().month == date.month &&
                                            DateTime.now().day < date.day)) {
                                      calculatedAge--;
                                    }

                                    ageNotifier.value = calculatedAge; // Update ValueNotifier
                                  }
                                },
                                icon: Icon(Icons.date_range),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ValueListenableBuilder<int?>(
                          valueListenable: ageNotifier,
                          builder: (context, age, child) {
                            return age != null
                                ? Text(
                              "Age: $age years",
                              style: TextStyle(fontSize: 15, color: Colors.pink.shade700),
                            )
                                : SizedBox();
                          },
                        ),
                        SizedBox(width: 10),
                        if (age != null)
                          Text(
                            "Age: $age years",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.pink.shade700,
                            ),
                          ),
                      ],
                    ), //DOB
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                // users.addUser(
                                //     firstname: firstname.text,
                                //     phone: phone.text,
                                //     email: email.text,
                                //     dob: dateController.text,
                                //     gender: selectedGender,
                                //     lastname: lastname.text,
                                //     city: selectedCity,
                                //     hobbies: hobbies.join(','),
                                //     age: age
                                // );
                                Map<String, dynamic> userData = {
                                  NAME: '${firstname.text} ${lastname.text}',
                                  PHONE: phone.text,
                                  EMAIL: email.text,
                                  DOB: dateController.text,
                                  GENDER: selectedGender,
                                  CITY: selectedCity,
                                  DB_HOBBIES: hobbies.join(','),
                                  AGE: ageNotifier.value ?? 0,
                                  IS_FAV: 0,
                                };
                                await myDatabase.addUser(userData);
                                print('added: ${firstname.text}');
                                print(AGE);
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DataAddedSuccessfully()));
                                });
                              };
                          },
                          child: Text('Save'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor:
                                Colors.pink.shade700, // Button background color
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                email.clear();
                                dateController.clear();
                                firstname.clear();
                                lastname.clear();
                                password.clear();
                                confirm_password.clear();
                                phone.clear();
                                cities.clear();
                                selectedGender = null;
                              });
                            },
                            child: Text('Reset'),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: Colors
                                  .pink.shade700, // Button background color
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                            )),
                      ],
                    ) //save reset
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTextFormField(
      {TextEditingController? textcontroller,
      String? hinttext,
      labeltext,
      TextInputType? key_type,
        bool obscureText = false,
      String? Function(String?)? validation,
      TextInputFormatter? formaters}) {
    return TextFormField(
      keyboardType: key_type,
      inputFormatters: formaters != null ? [formaters] : null,
      validator: validation,
      controller: textcontroller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hinttext,
        labelText: labeltext,
        labelStyle: TextStyle(
          color: Colors.pink.shade700,
        ),
        hintStyle: TextStyle(color: Colors.pink.shade700),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.pink.shade700,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.pink.shade700,
            width: 1.0, // Dark border when focused
          ),
        ),
      ),
    );
  }
}


