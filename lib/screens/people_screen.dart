import 'package:GIFTR/data/http_helper.dart';
import 'package:GIFTR/data/person.dart';
import 'package:flutter/material.dart';
import 'package:GIFTR/shared/screen_type.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PeopleScreen extends StatefulWidget {
  PeopleScreen(
      {Key? key,
      required this.logout,
      required this.goGifts,
      required this.goEdit})
      : super(key: key);

  Function(int, String) goGifts;
  Function(int, String, DateTime) goEdit;
  Function logout;

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  List<Person> people = List.of({
    Person('11', 'Bobby Singer', DateTime(1947, 5, 4)),
    Person('13', 'Crowley', DateTime(1661, 12, 4)),
    Person('12', 'Sam Winchester', DateTime(1983, 5, 2)),
    Person('10', 'Dean Winchester', DateTime(1979, 1, 24)),
  });
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
              //logout and return to login screen
              widget.logout();
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
                    print('edit person $index');
                    print('go to the add_person_screen');
                    print(people[index].dob);
                    // widget.goEdit(people[index].id,
                    //     people[index].name,
                    //     people[index].dob);
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
          //go to the add gift page
          DateTime now = DateTime.now();
          widget.goEdit(0, '', now);
        },
      ),
    );
  }

  void _peopleList() async {
    SharedPreferences prefsIntance = await SharedPreferences.getInstance();
    String? token = prefsIntance.getString('token');

    //If token null, user is not logged
    if (token == null) {
      widget.logout();
      return;
    }

    HttpHelper helper = HttpHelper();
    var result = await helper.grabPeopleList(token);

    if (result.containsKey('Errors')) {
      //some error has ocurred

      String message = '';

      message = result['errors'][0]['title'];

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    //All good, show people list
    _showPeople(Person.toList(result['data']));
  }

  void _showPeople(List<Person> list) async {
    await Future<int>.delayed(
      Duration(seconds: 2),
      () => 12,
    );

    setState(() => people = list);
  }
}
