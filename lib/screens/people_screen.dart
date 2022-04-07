import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Screen { LOGIN, PEOPLE, GIFTS, ADDGIFT, ADDPERSON }

class PeopleScreen extends StatefulWidget {
  PeopleScreen(
      {Key? key,
      required this.logout,
      required this.goGifts,
      required this.goEdit})
      : super(key: key);

  Function(int, String) goGifts;
  Function(int, String, DateTime) goEdit;
  Function(Enum) logout;

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  //state var list of people
  //real app will be using the API to get the data
  List<Map<String, dynamic>> people = [
    {'id': 11, 'name': 'Bobby Singer', 'dob': DateTime(1947, 5, 4)},
    {'id': 13, 'name': 'Crowley', 'dob': DateTime(1661, 12, 4)},
    {'id': 12, 'name': 'Sam Winchester', 'dob': DateTime(1983, 5, 2)},
    {'id': 10, 'name': 'Dean Winchester', 'dob': DateTime(1979, 1, 24)},
  ];
  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    //code here runs for every build
    //someObjects.sort((a, b) => a.someProperty.compareTo(b.someProperty));
    people.sort((a, b) => a['dob'].month.compareTo(b['dob'].month));
    //sort the people by the month of birth

    return Scaffold(
      appBar: AppBar(
        title: Text('Giftr - People'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              //logout and return to login screen
              widget.logout(Screen.LOGIN);
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: people.length,
        itemBuilder: (context, index) {
          return ListTile(
            //different background colors for birthdays that are past
            tileColor: today.month > people[index]['dob'].month
                ? Colors.black12
                : Colors.white,
            title: Text(people[index]['name']),
            subtitle: Text(DateFormat.MMMd().format(people[index]['dob'])),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.grey),
                  onPressed: () {
                    print('edit person $index');
                    print('go to the add_person_screen');
                    print(people[index]['dob']);
                    widget.goEdit(people[index]['id'], people[index]['name'],
                        people[index]['dob']);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.lightbulb, color: Colors.amber),
                  onPressed: () {
                    print('view gift ideas for person $index');
                    print('go to the gifts_screen');
                    widget.goGifts(people[index]['id'], people[index]['name']);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          //go to the add gift page
          DateTime now = DateTime.now();
          widget.goEdit(0, '', now);
        },
      ),
    );
  }
}
