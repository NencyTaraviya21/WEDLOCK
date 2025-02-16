import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedlock_admin/Utils/string_const.dart';
import 'package:wedlock_admin/WedLock/dashboard_matrimony.dart';
import 'package:wedlock_admin/WedLock/crud.dart';

class FavroiteUser extends StatefulWidget {
  const FavroiteUser({super.key});

  @override
  State<FavroiteUser> createState() => _UserlistState();
}

class _UserlistState extends State<FavroiteUser> {

  void initState() {
    super.initState();
    setState(() {
      favUserList = User.favUserList;
      print(' fav : $favUserList');
    });
  }

  void searchUsers(String value) async {
    var results = await users.searchDetail(searchData: value);
    setState(() {
      favUserList = results; // Ensure usersList updates correctly
    });
  }
  bool isFav = true;
  User users = User();
  List<Map<String, dynamic>> favUserList = [];
  List<Map<String, dynamic>> filteredUserList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Change your color here
        ),
        title: Text(
          'Favorite',
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
              Padding( //search
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
              ),
              Expanded(
                child: favUserList.isEmpty
                    ? Center(
                        child: Text(
                          'No profile available.',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: favUserList.length,
                        itemBuilder: (context, index) {
                          final user = favUserList[index];
                          return Card(
                            elevation: 10,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getText(index, Icons.person, Colors.blue,
                                      'Firstname', FIRSTNAME),
                                  // getText(index, 'Lastname', LASTNAME),
                                  getText(index, Icons.email, Colors.red,
                                      'Email', EMAIL),
                                  getText(
                                      index,
                                      Icons.phone,
                                      Colors.grey.shade700,
                                      'Mobile number',
                                      PHONE),
                                  getText(index, Icons.date_range,
                                      Colors.black26, 'DOB', DOB.toString()),
                                  getText(index, Icons.person, Colors.red,
                                      'Gender', GENDER),
                                  getText(index, Icons.location_city,
                                      Colors.pink, 'City', CITY),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if(index<favUserList.length)
                                            users.favDeleteUser(index);
                                            Navigator.pop;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'User removed from favorites!'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          isFav ? Icons.favorite : Icons.favorite_border, // Toggle icon
                                          color: Colors.pink.shade700,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
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

  Widget getText(index, icon, color, text1, TEXT1) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          text1,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 10,
        ),
        Text(":"),
        SizedBox(
          width: 10,
        ),
        Text(
          User.userList[index][TEXT1] ?? '',
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }
// leading: CircleAvatar(
//   child: Text(index.toString()),
// ),
// trailing: Row(
//   mainAxisSize: MainAxisSize.min,
//   children: [
//     IconButton(
//       onPressed: () {
//         showDialog(
//             context: context,
//             builder: (context) {
//               return CupertinoAlertDialog(
//                 title: Text('Delete'),
//                 content: Text('Are you sure you wanna delete'),
//                 actions: [
//                   TextButton(
//                       onPressed: () {
//
//                         print('data removed');
//                         Navigator.pop(context);
//                         setState(() {});
//                       },
//                       child: Text('Yes')),
//                   TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text('No'))
//                 ],
//               );
//             });
//       },
//       icon: Icon(Icons.delete),
//     ),
//   ],
// ),
}
