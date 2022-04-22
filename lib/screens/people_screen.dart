import 'package:GIFTR/data/giftr_exception.dart';
import 'package:GIFTR/data/http_helper.dart';
import 'package:GIFTR/data/person.dart';
import 'package:GIFTR/screens/add_person_screen.dart';
import 'package:GIFTR/screens/gifts_screen.dart';
import 'package:GIFTR/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({Key? key, required this.manageExceptions})
      : super(key: key);

  static const routeName = '/people';
  final Function manageExceptions;

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  List<Person> people = List.empty();
  DateTime today = DateTime.now();
  @override
  void initState() {
    super.initState();
    _peopleList();
  }

  @override
  Widget build(BuildContext context) {
    //sort the people by the month of birth

    people.sort((a, b) => a.dob.month.compareTo(b.dob.month));

    return Scaffold(
      appBar: AppBar(
        title: Text('People'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              widget.manageExceptions(GiftrException.LOGOUT);
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: people.length,
        itemBuilder: (context, index) {
          return ListTile(
            //different background colors for birthdays that are past
            tileColor: today.month > people[index].dob.month
                ? Colors.black12
                : Colors.white,
            title: Text(people[index].name),
            subtitle: Text(DateFormat.MMMd().format(people[index].dob)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.grey),
                  onPressed: () {
                    _goEdit(people[index]);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.lightbulb, color: Colors.amber),
                  onPressed: () {
                    _goToGiftList(people[index]);
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
          _goAdd();
        },
      ),
    );
  }

  void _goToGiftList(Person person) {
    var result =
        Navigator.pushNamed(context, GiftsScreen.routeName, arguments: person);
  }

  void _peopleList() async {
    HttpHelper helper = HttpHelper();
    try {
      var people = await helper.grabPeopleList();
      _showPeople(people);
    } catch (e) {
      widget.manageExceptions(e);
    }
  }

  void _showPeople(List<Person> list) async {
    setState(() {
      list.sort((a, b) => a.dob.month.compareTo(b.dob.month));
      people = list;
    });
  }

  void _goAdd() {
    var result = Navigator.pushNamed(context, AddPersonScreen.routeName,
        arguments: Person.create());

    () async {
      var didPersonAdd = await result;
      print('Person added result: $didPersonAdd');
      if (didPersonAdd != null) {
        _peopleList();
      }
    }();
  }

  void _goEdit(Person person) {
    var result = Navigator.pushNamed(context, AddPersonScreen.routeName,
        arguments: person);

    () async {
      var didPersonEdit = await result;
      print('Edited person result: $didPersonEdit');
      if (didPersonEdit != null) {
        _peopleList();
      }
    }();
  }
}
