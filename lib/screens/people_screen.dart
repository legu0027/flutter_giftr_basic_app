import 'package:GIFTR/data/giftr_exception.dart';
import 'package:GIFTR/data/http_helper.dart';
import 'package:GIFTR/data/person.dart';
import 'package:GIFTR/screens/add_person_screen.dart';
import 'package:flutter/material.dart';
import 'package:GIFTR/shared/screen_type.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({Key? key}) : super(key: key);

  static const routeName = '/people';

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
        title: Text('Giftr - People'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logout();
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
                    print('view gift ideas for person $index');
                    print('go to the gifts_screen');
                    // widget.goGifts(people[index]['id'], people[index]['name']);
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("people dispose");
    people = List.empty();
  }

  void _peopleList() async {
    HttpHelper helper = HttpHelper();
    try {
      var people = await helper.grabPeopleList();
      _showPeople(people);
    } catch (e) {
      String message = (e as GiftrException?)?.message ?? e.toString();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _showPeople(List<Person> list) async {
    // await Future<int>.delayed(
    //   Duration(seconds: 2),
    //   () => 12,
    // );

    setState(() => people = list);
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

  void _logout() {
    Navigator.pop(context);
  }
}
