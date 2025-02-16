
import 'package:wedlock_admin/Utils/string_const.dart';

class User {
  static List<Map<String, dynamic>> userList = [
    {'fullname':'nency'},
    {'fullname':'nency'}
     ];

  List<Map<String, dynamic>> filteredUserList = [];
  static List<Map<String, dynamic>> favUserList = [];

  void addUser(
      {required firstname,
      required phone,
      required email,
      required dob,
      required gender,
      required lastname,
      required city,
      required hobbies,
        required age
      }) {
    Map<String, dynamic> map = {};
    map[FIRSTNAME] = firstname;
    map[LASTNAME] = lastname;
    map[PHONE] = phone;
    map[EMAIL] = email;
    map[DOB] = dob;
    map[GENDER] = gender;
    map[CITY] = city;
    map[HOBBIES] = hobbies;
    map[AGE]=age;
    userList.add(map);
    print("added - $firstname");
  }


  void editUser({required int id, required Map<String, dynamic> newData}) {
    userList[id] = newData;
  }

  List<Map<String, dynamic>> getUserList() {
    print("UserLst from user page - $userList");
    return userList;
  }

  void deleteUser(id) {
    userList.removeAt(id);
  }
  
  List<Map<String, dynamic>> searchDetail({required String searchData}) {
    filteredUserList = userList.where((element) {
      return element[FIRSTNAME]
          .toString()
          .toLowerCase()
          .contains(searchData.toLowerCase()) ||
          element[LASTNAME]
              .toString()
              .toLowerCase()
              .contains(searchData.toLowerCase()) ||
          element[EMAIL]
              .toString()
              .toLowerCase()
              .contains(searchData.toLowerCase()) ||
          element[CITY]
              .toString()
              .toLowerCase()
              .contains(searchData.toLowerCase());
    }).toList();

    return filteredUserList;
  }
  void favUser({
    required int id,
    required String firstname,
    required String phone,
    required String email,
    required String dob,
    required String gender,
    required String lastname,
    required String city,
    required String hobbies,
  }) {
    Map<String, dynamic> map = {
      ID: id,
      FIRSTNAME: firstname,
      LASTNAME: lastname,
      PHONE: phone,
      EMAIL: email,
      DOB: dob,
      GENDER: gender,
      CITY: city,
      HOBBIES: hobbies,
    };

    if (!favUserList.any((user) => user[id] == id)) {
      favUserList.add(map);
      print("Added to favorites: $firstname");
    } else {
      print("User already in favorites.");
    }
  }

  void favDeleteUser(int id) {
    favUserList.removeWhere((user) => user[id] == id);
    print("Removed user with ID: $id from favorites.");
  }

}
