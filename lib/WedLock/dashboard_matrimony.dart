import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedlock_admin/WedLock/about_us.dart';
import 'package:wedlock_admin/WedLock/crud.dart';
import 'package:wedlock_admin/WedLock/favroite_user.dart';
import 'package:wedlock_admin/WedLock/global.dart';
import 'package:wedlock_admin/WedLock/login_register_page.dart';
import 'package:wedlock_admin/WedLock/user_form.dart';
import 'package:wedlock_admin/WedLock/userlist.dart';
class DashboardWedLock extends StatefulWidget {
  const DashboardWedLock({super.key});

  @override
  State<DashboardWedLock> createState() => _DashboardMatrimonyState();
}

class _DashboardMatrimonyState extends State<DashboardWedLock> {
  final List<Map<String, dynamic>> listItems = [
    {'icon': Icons.add, 'text': 'Add User', 'class_name': () => UserForm()},
    {
      'icon': Icons.list_outlined,
      'text': 'User List',
      'class_name': () => Userlist()
    },
    {
      'icon': Icons.favorite,
      'text': 'Favorites',
      'class_name': () => FavUserList()
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'WedLock',
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
      drawer: Drawer(
        child: ListView(
          children: [
            Row(
            children: [
              SizedBox(width: 8),
              CircleAvatar(
                radius: 25,
                child: Icon(
                  CupertinoIcons.person_alt_circle_fill,
                  size: 50,
                  color: Colors.pink.shade700,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Miss. Nency',
                style: TextStyle(fontSize: 20, fontFamily: 'Federo'),
              ),
            ]),
            getDrawerList(
                'About us', Icons.person, Icons.keyboard_arrow_right_sharp,
                fileName: AboutUsPage()),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.pink.shade700),
              title: Text('Logout', style: TextStyle(fontSize: 18)),
              onTap: () async {
                bool confirmed = await _showLogoutDialog(context);
                if (confirmed) {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.clear(); // Clear all saved data (logout)
                  globalUserName = ''; // Reset global username

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => WedLockLoginRegister()), // Redirect to login
                        (Route<dynamic> route) => false, // Remove all previous routes
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding:
            EdgeInsets.symmetric(vertical: 20), // Reduce top and bottom space
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade100, Colors.pink.shade300],
          ),
        ),
        child: ListView.builder(
          itemCount: listItems.length,
          itemBuilder: (context, index) {
            return getListItem(
              listItems[index]['icon'],
              listItems[index]['text'],
              listItems[index]['class_name'],
            );
          },
        ),
      ),
    );
  }

  Widget getDrawerList(String title, IconData leadingIcon, IconData trailingIcon, {required Widget fileName}) {
    return ListTile(
      leading: Icon(leadingIcon, color: Colors.pink.shade700),
      title: Text(title, style: TextStyle(fontSize: 18)),
      trailing: Icon(trailingIcon, color: Colors.pink.shade700),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => fileName),
        );
      },
    );
  }

  Widget getListItem(IconData icon, String text, class_name) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => class_name()));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 10, vertical: 5), // Keeps it centered
        child: Container(
          width: MediaQuery.of(context).size.width, // Full width of screen
          height: 150,
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: ListTile(
                leading: Icon(
                  icon,
                  size: 50, // Reduce icon size
                  color: Colors.pink.shade700,
                ),
                title: Text(
                  text,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.grey), // Small arrow
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<bool> _showLogoutDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;
  }
}

