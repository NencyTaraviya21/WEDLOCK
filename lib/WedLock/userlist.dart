import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedlock_admin/Utils/string_const.dart';
import 'package:wedlock_admin/WedLock/crud.dart';
import 'dart:ui';

import 'package:wedlock_admin/WedLock/dashboard_matrimony.dart';

class Userlist extends StatefulWidget {
  const Userlist({super.key});

  @override
  State<Userlist> createState() => _UserlistState();
}

class _UserlistState extends State<Userlist> {
  // void _edituser(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => BackdropFilter(
  //       filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
  //       child: AlertDialog(
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //         content: Column(
  //           children: [
  //             TextFormField(
  //               decoration: InputDecoration(labelText: "Enter Name"),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text("Cancel"),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //              users.editUser(id: 0, newData: newData)
  //               Navigator.pop(context);
  //             },
  //             child: Text("Save"),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  void initState() {
    super.initState();
    setState(() {
      usersList = List.from(User.userList);
      print(usersList);
      usersList.forEach((user) {
        user['isFavorite'] = user['isFavorite'] ?? false;
      });
      // Initialize favoriteUsers with IDs of users who are already favorites
      Set<int> favoriteUsers = usersList
          .where((user) => user['isFavorite'] == true)
          .map((user) => user['id'] as int? ?? usersList.indexOf(user)) // Explicitly cast to int?
          .where((id) => id != null) // Filter out any null values from the cast
          .cast<int>() // Cast the remaining values to int
          .toSet();
    });
  }

  bool isFav = false;

  void searchUsers(String value) async {
    var results = await users.searchDetail(searchData: value);
    setState(() {
      usersList = results;
    });
  }

  User users = User();
  List<Map<String, dynamic>> usersList = [];
  List<Map<String, dynamic>> filteredUserList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Change your color here
        ),
        title: Text(
          'UserList',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontFamily: 'Libre',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  ),
                  onChanged: (value) {
                    searchUsers(value);
                  },
                ),
              ), // SEARCH
              Expanded(
                child: usersList.isEmpty
                    ? Center(
                        child: Text(
                          'No profile available.',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: usersList.length,
                        itemBuilder: (context, index) {
                          final user = usersList[index];
                          return Card(
                            elevation: 10,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      getText(index, Icons.person,
                                          '${user[FIRSTNAME] ?? 'N/A'} ${user[LASTNAME] ?? ''}'),
                                      getText(index, Icons.email, user[EMAIL]),
                                      getText(index, Icons.calendar_today, user[AGE]),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: TextButton(
                                          onPressed: () => _showBottomSheet(
                                              context, usersList[index], index),
                                          child: const Text('View more',
                                              style: TextStyle(
                                                  color: Colors.blue)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          toggleFavorite(user[ID]);
                                        },
                                        icon: Icon(
                                          isFav ? Icons.favorite : Icons.favorite_border,
                                          color: Colors.pink.shade700,
                                        ),
                                      ),
                                      //fav
                                      IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return CupertinoAlertDialog(
                                                    title: Text('Delete'),
                                                    content: Text(
                                                        'Are you sure you wanna delete'),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            users.deleteUser(
                                                                index);
                                                            print(
                                                                'data removed');
                                                            Navigator.pop(
                                                                context);
                                                            setState(() {});
                                                          },
                                                          child: Text('Yes')),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text('No'))
                                                    ],
                                                  );
                                                });
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.brown,
                                          )), //delete
                                    ],
                                  ),
                                ), //buttons
                              ],
                            ),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 60,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DashboardWedLock()));
                      },
                      child: Text(
                        "OK",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: BeveledRectangleBorder(),
                        backgroundColor:
                            Colors.pink.shade700, // Button background color
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity,
                            10), // Full width, increased height
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getListGridView(index, icon, text1, TEXT1) {
    return ListTile(
      title: Row(
        children: [
          Text(
            text1,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            User.userList[index][TEXT1],
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(
      BuildContext context, Map<String, dynamic>? user, int index) {
    if (user == null || user.isEmpty) {
      print("User data is null or empty.");
      return;
    }

    print("User Data: $user");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.pink.shade700,
                  child: Text(
                    (user['FIRSTNAME'] != null && user['FIRSTNAME'].isNotEmpty)
                        ? user['FIRSTNAME'][0].toUpperCase()
                        : 'U',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'User Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink.shade700,
                  ),
                ),
                Divider(color: Colors.pink.shade700, thickness: 2),
                SizedBox(height: 10),
                _buildDetailRow(Icons.person, 'Full Name',
                    '${user[FIRSTNAME] ?? 'N/A'} ${user[LASTNAME] ?? ''}'),
                _buildDetailRow(
                    Icons.phone, 'Phone Number', user[PHONE] ?? 'N/A'),
                _buildDetailRow(Icons.email, 'Email', user[EMAIL] ?? 'N/A'),
                _buildDetailRow(
                    Icons.calendar_today, 'Date of Birth', user[DOB] ?? 'N/A'),
                _buildDetailRow(Icons.male, 'Gender', user[GENDER] ?? 'N/A'),
                _buildDetailRow(Icons.location_on, 'City', user[CITY] ?? 'N/A'),
                _buildDetailRow(
                  Icons.videogame_asset,
                  'Hobbies',
                  (user[HOBBIES] is List<String>)
                      ? (user[HOBBIES] as List<String>).join(', ')
                      : (user[HOBBIES] != null
                          ? user[HOBBIES].toString()
                          : 'N/A'),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => _editUser(context, index),
                      icon: Icon(Icons.edit, color: Colors.pink.shade700),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Close',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveUser(
      int index,
      TextEditingController nameController,
      TextEditingController emailController,
      TextEditingController phoneController,
      TextEditingController dobController,
      String selectedGender,
      String selectedCity,
      List<String> selectedHobbies) {
    // Create the updated user data
    Map<String, dynamic> updatedUser = {
      FIRSTNAME: nameController.text,
      EMAIL: emailController.text,
      PHONE: phoneController.text,
      DOB: dobController.text,
      GENDER: selectedGender,
      CITY: selectedCity,
      HOBBIES: selectedHobbies,
    };

    // Update the data
    users.editUser(id: index, newData: updatedUser);

    // Update the local state
    setState(() {
      usersList = List.from(User.userList); // Create a new list reference
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User updated successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

// Helper widget for rows
  Widget _buildDetailRow(IconData? icon, String? title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.pink.shade700, size: 28),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink.shade700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  value!,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Set<int> favoriteUsers = {};


  void toggleFavorite(int userId) {
    setState(() {
      if (favoriteUsers.contains(userId)) {
        favoriteUsers.remove(userId);
        users.favDeleteUser(userId);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User removed from favorites!'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        final user = usersList.firstWhere(
              (u) => u[ID] == userId,
          orElse: () => {},
        );

        if (user != null) {
          favoriteUsers.add(userId);
          users.favUser(
            id: userId,
            firstname: user[FIRSTNAME],
            lastname: user[LASTNAME],
            phone: user[PHONE],
            email: user[EMAIL],
            dob: user[DOB],
            gender: user[GENDER],
            city: user[CITY],
            hobbies: user[HOBBIES],
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${user[FIRSTNAME]} added to favorites!'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }





//edit
  void _editUser(BuildContext context, int index) {
    final user = usersList[index];
    final _formKey = GlobalKey<FormState>();

    TextEditingController nameController =
        TextEditingController(text: '${user[FIRSTNAME]} ${user[LASTNAME]}');
    TextEditingController emailController =
        TextEditingController(text: user[EMAIL]);
    TextEditingController phoneController =
        TextEditingController(text: user[PHONE]);
    TextEditingController dobController =
        TextEditingController(text: user[DOB] ?? "");

    List<String> hobbies = [
      "Playing",
      "Singing",
      "Swimming",
      "Dancing",
      "Reading",
      "Writing"
    ];

    List<String> selectedHobbies = user[HOBBIES] is List
        ? List<String>.from(user[HOBBIES])
        : (user[HOBBIES] != null ? [user[HOBBIES].toString()] : []);

    String selectedGender = user[GENDER] ?? null;
    String selectedCity = user[CITY] ?? "Select City";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Edit User",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 15),
                      getTextFormField(
                          textcontroller: nameController,
                          hinttext: "Enter Name",
                          icon: Icons.person,
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            if (value.length < 2) {
                              return 'Name must be at least 2 characters';
                            }
                            return null;
                          }),
                      SizedBox(height: 15),
                      getTextFormField(
                          textcontroller: emailController,
                          hinttext: "Enter Email",
                          icon: Icons.email,
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          }),
                      SizedBox(height: 15),
                      getTextFormField(
                          textcontroller: phoneController,
                          hinttext: "Enter Phone Number",
                          icon: Icons.phone,
                          key_type: TextInputType.phone,
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a phone number';
                            }
                            if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                              return 'Please enter a valid 10-digit phone number';
                            }
                            return null;
                          }),
                      SizedBox(height: 15),
                      _buildCheckboxList(
                          "Hobbies", hobbies, selectedHobbies, setState),
                      SizedBox(height: 10),
                      _buildGenderSelector(selectedGender, (value) {
                        setState(() {
                          selectedGender = value.toString();
                        });
                      }),
                      SizedBox(height: 10),
                      _buildCityDropdown(selectedCity, (value) {
                        setState(() {
                          selectedCity = value.toString();
                        });
                      }),
                      SizedBox(height: 10),
                      _buildDatePicker(context, dobController, setState),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () => Navigator.pop(context),
                            child: Text("Reset"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate() &&
                                  selectedGender != null &&
                                  selectedCity != "Select City" &&
                                  selectedHobbies.isNotEmpty) {
                                _saveUser(
                                    index,
                                    nameController,
                                    emailController,
                                    phoneController,
                                    dobController,
                                    selectedGender,
                                    selectedCity,
                                    selectedHobbies);
                                Navigator.pop(context);
                                setState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('User updated successfully!'),
                                      duration: Duration(seconds: 2)),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Please fill all required fields correctly'),
                                      duration: Duration(seconds: 2)),
                                );
                              }
                            },
                            child: Text("Save"),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGenderSelector(
      String selectedGender, Function(String) onChanged) {
    return Row(
      children: [
        Radio(
          value: "Male",
          groupValue: selectedGender,
          onChanged: (value) => onChanged(value.toString()),
        ),
        Text("Male"),
        Radio(
          value: "Female",
          groupValue: selectedGender,
          onChanged: (value) => onChanged(value.toString()),
        ),
        Text("Female"),
      ],
    );
  }

  Widget _buildCheckboxList(
      String title,
      List<String> items,
      List<String> selectedItems,
      Function setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.pink.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Wrap(
            spacing: 20,
            runSpacing: 10,
            children: items.map((item) {
              bool isSelected = selectedItems.contains(item);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedItems.remove(item);
                    } else {
                      selectedItems.add(item);
                    }
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: isSelected,
                      activeColor: Colors.pink.shade700,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            if (!selectedItems.contains(item)) {
                              selectedItems.add(item);
                            }
                          } else {
                            selectedItems.remove(item);
                          }
                        });
                      },
                    ),
                    Text(item),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget getTextFormField({
    TextEditingController? textcontroller,
    String? hinttext,
    icon,
    TextInputType? key_type,
    String? Function(String?)? validation,
  }) {
    return TextFormField(
      keyboardType: key_type,
      validator: validation,
      controller: textcontroller,
      decoration: InputDecoration(
        hintText: hinttext,
        prefixIcon: Icon(icon),
        labelStyle: TextStyle(
          color: Colors.pink.shade700,
        ),
        hintStyle: TextStyle(color: Colors.pink.shade700),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.pink.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context,
      TextEditingController controller, StateSetter setState) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: "Select DOB",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.calendar_today),

      ),

      readOnly: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a date of birth';
        }
        return null;
      },
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime(2007),
          firstDate: DateTime(1991),
          lastDate: DateTime(2007),
        );
        if (pickedDate != null) {
          setState(() {
            controller.text =
                "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
          });
        }
      },
    );
  }

  Widget _buildCityDropdown(String selectedCity, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedCity,
      decoration: InputDecoration(
        labelText: "Select City",
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value == "Select City") {
          return 'Please select a city';
        }
        return null;
      },
      items: [
        "Select City",
        "Jamnagar",
        "Rajkot",
        "Ahmedabad",
        "Baroda",
        "Surat",
        "Vapi"
      ]
          .map((city) => DropdownMenuItem(value: city, child: Text(city)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.red.shade900),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget getText(index, icon, dynamic TEXT1) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey.shade700,
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          // Check if TEXT1 is a String (formatted full name) or a field key
          TEXT1 is String ? TEXT1 : User.userList[index][TEXT1] ?? '',
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}
