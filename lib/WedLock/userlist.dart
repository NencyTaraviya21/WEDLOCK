import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:wedlock_admin/Utils/string_const.dart';
import 'package:wedlock_admin/WedLock/crud.dart';
import 'dart:ui';

import 'package:wedlock_admin/WedLock/dashboard_matrimony.dart';
import 'package:wedlock_admin/WedLock/database/my_database.dart';

class Userlist extends StatefulWidget {
  const Userlist({super.key});

  @override
  State<Userlist> createState() => _UserlistState();
}

class _UserlistState extends State<Userlist> {
  MyDatabase myDatabase = MyDatabase();
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
    // setState(() {
    //   // usersList = List.from(myDatabase.usersList);
    //   // print(usersList);
    //   // favoriteStatus = List.generate(usersList.length, (index) => false);
    // });
    fetchUsers();
    setState(() {});
  }

  List<Map<String, dynamic>> currentUsersList = [];
  Future<void> fetchUsers() async {
    await myDatabase.fetchUsersFromTable();
    currentUsersList = myDatabase.usersList; // Initially, display all users
    setState(() {});
  }

  int _selectedItem = -1;
  void _onTap(int index) {
    setState(() {
      _selectedItem = index;
    });
  }

  void searchUsers(String value) async {
    var results = await users.searchDetail(searchData: value);
    setState(() {
      usersList = results;
    });
  }

  User users = User();
  List<Map<String, dynamic>> usersList = [];
  List<Map<String, dynamic>> filteredUserList = [];
  int isFav = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFfcf0f9),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
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
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.sort_by_alpha_sharp,
                size: 35,
              )),
        ],
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
                    suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.tune_outlined),
                        color: Colors.grey.shade600),
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
                child: currentUsersList.isEmpty
                    ? Center(
                        child: Text(
                          'No profile available.',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: currentUsersList.length,
                        itemBuilder: (context, index) {
                          final user = currentUsersList[index];
                          isFav = user[IS_FAV];
                          return Card(
                            elevation: 10,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  // child: Column(
                                  //   crossAxisAlignment:
                                  //       CrossAxisAlignment.start,
                                  //   children: [
                                  //     getText(index, Icons.person,
                                  //         '${user[FIRSTNAME] ?? 'N/A'} ${user[LASTNAME] ?? ''}'),
                                  //     getText(index, Icons.email, user[EMAIL]),
                                  //     getText(index, Icons.calendar_today,
                                  //         user[AGE]),
                                  //     Align(
                                  //       alignment: Alignment.bottomRight,
                                  //       child: TextButton(
                                  //         onPressed: () => _showBottomSheet(
                                  //             context, usersList[index], index),
                                  //         child: const Text('View more',
                                  //             style: TextStyle(
                                  //                 color: Colors.blue)),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  child: InkWell(
                                    onTap: () => _showBottomSheet(
                                        context, user, index), // Pass index
                                    borderRadius: BorderRadius.circular(15),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                Colors.pink.shade700,
                                            radius: 30,
                                            child: Text(
                                              (user[NAME] != null &&
                                                      user[NAME].isNotEmpty)
                                                  ? user[NAME][0].toUpperCase()
                                                  : 'U',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '${user[NAME] ?? 'N/A'}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SingleChildScrollView(
                                                    child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        user[EMAIL] ?? 'N/A',
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines:
                                                            1, // Ensures the text stays in one line
                                                      ),
                                                    ),
                                                    Text(
                                                        ' | '), // Keeps separator visible
                                                    Expanded(
                                                      child: Text(
                                                        '${user[AGE] ?? 'N/A'} years',
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ],
                                                ))
                                              ],
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors
                                                  .pink[50], // Background color
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  blurRadius: 5,
                                                  spreadRadius: 2,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: IconButton(
                                              icon: Icon(user[IS_FAV] == 1
                                                  ? Icons.favorite_outlined
                                                  : Icons.favorite_border),
                                              color: user[IS_FAV] == 1
                                                  ? Colors.pink[700]
                                                  : Colors.pink[500],
                                              onPressed: () {
                                                isFav = isFav == 1 ? 0 : 1;
                                                int user_id = user[USER_ID];
                                                myDatabase.favUser(
                                                    user_id, isFav);
                                                fetchUsers();
                                              },
                                            ),
                                          ), //fav
                                          SizedBox(
                                            width: 3,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
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
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.pink[200], // Background color
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink[700]!.withOpacity(0.3),
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashboardWedLock()));
                        },
                        icon: Icon(CupertinoIcons.home),
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

  void _deleteUser(int index, BuildContext context) async {
    final userToDelete = usersList[index];

    bool? confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CupertinoAlertDialog(
          title: const Text("Confirm Delete"),
          content: Text(
              "Are you sure you want to delete ${userToDelete[FIRSTNAME]} ${userToDelete[LASTNAME]}?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false), // Cancel
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // Confirm
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      usersList.removeAt(index);
      setState(() {});

      // If needed, navigate back
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  }

  void _showBottomSheet(
      BuildContext context, Map<String, dynamic>? user, int index) {
    if (user == null || user.isEmpty) {
      print("User data is null or empty.");
      return;
    }

    print("User Data: $user");
    print((user[NAME].split(" "))[0]);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.pink.shade700,
                      child: Text(
                        (user[NAME] != null && user[NAME].isNotEmpty)
                            ? (user[NAME].split(" "))[0][0].toUpperCase()
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
                      ((user[NAME].split(" "))[0] != null &&
                              (user[NAME].split(" "))[0].isNotEmpty)
                          ? (user[NAME].split(" "))[0] + "'s Details"
                          : 'User details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink.shade700,
                      ),
                    ),
                    Divider(color: Colors.pink.shade700, thickness: 2),
                    SizedBox(height: 10),
                    _buildDetailRow(
                        Icons.person, 'Full Name', '${user[NAME] ?? 'N/A'}'),
                    _buildDetailRow(
                        Icons.phone, 'Phone Number', user[PHONE] ?? 'N/A'),
                    _buildDetailRow(Icons.email, 'Email', user[EMAIL] ?? 'N/A'),
                    _buildDetailRow(Icons.cake_rounded, 'Date of Birth',
                        user[DOB] ?? 'N/A'),
                    _buildDetailRow(
                      Icons.hourglass_bottom,
                      'Age',
                      user[AGE]?.toString() ?? 'N/A',
                    ),
                    _buildDetailRow(
                        Icons.male, 'Gender', user[GENDER] ?? 'N/A'),
                    _buildDetailRow(
                        Icons.location_on, 'City', user[CITY] ?? 'N/A'),
                    _buildDetailRow(
                      Icons.videogame_asset,
                      'Hobbies',
                      (user[DB_HOBBIES] is List<String>)
                          ? (user[DB_HOBBIES] as List<String>).join(', ')
                          : (user[DB_HOBBIES] != null
                              ? user[DB_HOBBIES].toString()
                              : 'N/A'),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.pink[100], // Background color
                            borderRadius: BorderRadius.circular(
                                22), // Adjust for more/less rounding// Background color
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 5,
                                spreadRadius: 2,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () {
                              if (currentUsersList.isEmpty ||
                                  index >= currentUsersList.length) {
                                print("Error: Invalid index or empty list.");
                                return;
                              }
                              _editUser(context, index);
                            },
                            icon: Icon(Icons.edit, color: Colors.pink[700]),
                          ),
                        ),
                        SizedBox(width: 15),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.pink[100], // Background color
                            borderRadius:
                                BorderRadius.circular(22), // Background color
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 5,
                                spreadRadius: 2,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () {
                              showCupertinoDialog(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                  title: Text("Confirm Deletion"),
                                  content: Text(
                                      "Are you sure you want to delete this user?"),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: Text("Cancel"),
                                      onPressed: () => Navigator.of(context)
                                          .pop(), // Close dialog
                                    ),
                                    CupertinoDialogAction(
                                      child: Text("Delete",
                                          style: TextStyle(color: Colors.red)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Userlist()));
                                        myDatabase.deleteUser(user[USER_ID]);
                                        fetchUsers(); // Refresh list
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: Icon(Icons.delete, color: Colors.pink[500]),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.pink[700], size: 24),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        );
      },
    );
  }

  //
  // void _saveUser(
  //     int index,
  //     TextEditingController nameController,
  //     TextEditingController emailController,
  //     TextEditingController phoneController,
  //     TextEditingController dobController,
  //     String selectedGender,
  //     String selectedCity,
  //     List<String> selectedHobbies) {
  //   Map<String, dynamic> updatedUser = {
  //     FIRSTNAME: nameController.text,
  //     EMAIL: emailController.text,
  //     PHONE: phoneController.text,
  //     DOB: dobController.text,
  //     GENDER: selectedGender,
  //     CITY: selectedCity,
  //     HOBBIES: selectedHobbies,
  //   };
  //   users.editUser(id: index, newData: updatedUser);
  //   setState(() {
  //     usersList = List.from(User.userList); // Create a new list reference
  //   });
  //   Navigator.pop(context);
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('User updated successfully!'),
  //       duration: Duration(seconds: 2),
  //     ),
  //   );
  // }

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

  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> favUserList = [];

//edit
  void _editUser(BuildContext context, int index) {
    final user = currentUsersList[index];
    final _formKey = GlobalKey<FormState>();

    TextEditingController nameController =
        TextEditingController(text: user[NAME]);
    TextEditingController emailController =
        TextEditingController(text: user[EMAIL]);
    TextEditingController phoneController =
        TextEditingController(text: user[PHONE]);
    TextEditingController dobController =
        TextEditingController(text: user[DOB] ?? "");

    ValueNotifier<int?> ageNotifier =
        ValueNotifier<int?>(user[AGE] ?? null); // For age update

    List<String> hobbies = [
      "Playing",
      "Singing",
      "Swimming",
      "Dancing",
      "Reading",
      "Writing"
    ];

    List<String> selectedHobbies = user[DB_HOBBIES] is List
        ? List<String>.from(user[DB_HOBBIES])
        : (user[DB_HOBBIES] != null
            ? user[DB_HOBBIES]
                .toString()
                .split(',')
                .map((e) => e.trim())
                .toList()
            : []);

    print("Selected Hobbies during Edit: $selectedHobbies");

    String selectedGender = user[GENDER] ?? "";
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
                      _buildCityDropdown(selectedCity, (value) {
                        setState(() {
                          selectedCity = value.toString();
                        });
                      }),
                      SizedBox(height: 15),
                      _buildCheckboxList(
                          "Hobbies",
                          [
                            "Playing",
                            "Singing",
                            "Swimming",
                            "Dancing",
                            "Reading",
                            "Writing"
                          ],
                          selectedHobbies,
                          setState),
                      SizedBox(height: 15),
                      _buildGenderSelector(selectedGender, (value) {
                        setState(() {
                          selectedGender = value.toString();
                        });
                      }),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            'Select DOB',
                            style: TextStyle(color: Colors.pink.shade700),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: dobController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'dd/mm/yyyy',
                                hintStyle:
                                    TextStyle(color: Colors.pink.shade700),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.pink.shade700),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.pink.shade700, width: 1.0),
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
                                      dobController.text =
                                          "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";

                                      int calculatedAge =
                                          DateTime.now().year - date.year;
                                      if (DateTime.now().month < date.month ||
                                          (DateTime.now().month == date.month &&
                                              DateTime.now().day < date.day)) {
                                        calculatedAge--;
                                      }

                                      ageNotifier.value =
                                          calculatedAge; // Update ValueNotifier
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
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.pink.shade700),
                                    )
                                  : SizedBox();
                            },
                          ),
                        ],
                      ), //dob

                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () => Navigator.pop(context),
                            child: Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                Map<String, dynamic> updatedUser = {
                                  NAME: nameController.text.trim(),
                                  EMAIL: emailController.text.trim(),
                                  PHONE: phoneController.text.trim(),
                                  DOB: dobController.text.trim(),
                                  AGE: ageNotifier.value,
                                  GENDER: selectedGender,
                                  DB_HOBBIES: selectedHobbies.join(","),
                                };

                                await myDatabase.editUser(
                                    updatedUser, user[USER_ID]);
                                fetchUsers();

                                setState(() {
                                  currentUsersList[index] = updatedUser;
                                });
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('User updated successfully!'),
                                    duration: Duration(seconds: 2),
                                  ),
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
        Icon(
          Icons.wc_rounded,
          color: Colors.pink[700],
        ),
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

  Widget _buildCheckboxList(String title, List<String> items,
      List<String> selectedItems, Function setState) {
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
          width: double.infinity,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.pink.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Wrap(
            spacing: 20,
            runSpacing: 10,
            alignment: WrapAlignment.start,
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
                    Text(
                      item,
                      style: TextStyle(fontSize: 14),
                    ),
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
        hintStyle: TextStyle(
          color: Colors.pink.shade700,
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.pink[700],
        ),
        labelStyle: TextStyle(
          color: Colors.pink.shade700,
        ),
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
