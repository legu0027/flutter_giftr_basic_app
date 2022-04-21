import 'package:GIFTR/data/giftr_exception.dart';
import 'package:GIFTR/data/http_helper.dart';
import 'package:GIFTR/data/person.dart';
import 'package:GIFTR/screens/login_screen.dart';
import 'package:GIFTR/screens/people_screen.dart';
import 'package:flutter/material.dart';
import 'package:GIFTR/shared/screen_type.dart';
import 'package:intl/intl.dart';

class AddPersonScreen extends StatefulWidget {
  const AddPersonScreen({Key? key, required this.person}) : super(key: key);

  final Person person;
  static String routeName = '/addPerson';

  @override
  State<AddPersonScreen> createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  final nameController = TextEditingController();
  final dobController = TextEditingController();

  //create global ref key for the form
  final _formKey = GlobalKey<FormState>();

  Person? person;

  @override
  void initState() {
    super.initState();

    person = widget.person;

    nameController.text = person?.name ?? '';
    if (person?.dob != null) {
      dobController.text = DateFormat.yMMMd().format(person!.dob);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: (person?.name.isEmpty ?? true)
            ? Text('Add Person')
            : Text('Edit ${person!.name}'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              _buildName(),
              SizedBox(height: 16),
              _buildDOB(),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text('Save'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _savePerson();
                      } else {
                        //form failed validation so exit
                        return;
                      }
                    },
                  ),
                  SizedBox(width: 16.0),
                  if (person?.id.isNotEmpty ?? false)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      child: Text('Delete'),
                      onPressed: () {
                        //delete the selected person
                        //needs confirmation dialog
                      },
                    ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  InputDecoration _styleField(String label, String hint, bool pickDate) {
    return InputDecoration(
      labelText: label, // label
      labelStyle: TextStyle(color: Colors.black87),
      hintText: hint, //placeholder
      hintStyle: TextStyle(color: Colors.black54),
      border: OutlineInputBorder(),
      suffixIcon: pickDate
          ? IconButton(
              icon: Icon(Icons.calendar_month),
              onPressed: () {
                _showDatePicker();
              },
            )
          : null,
    );
  }

  TextFormField _buildName() {
    return TextFormField(
      decoration: _styleField('Person Name', 'person name', false),
      controller: nameController,
      obscureText: false,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.lightBlue, fontSize: 20),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a name';
          //becomes the new errorText value
        }
        return null; //means all is good
      },
      onSaved: (String? value) {
        //save the email value in the state variable
        print("seting the name: $value");
        setState(() {
          person?.name = value!;
        });
      },
    );
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year + 1),
    ).then(
      (value) {
        setState(
          () {
            person?.dob = value!;
            dobController.text = DateFormat.yMMMd().format(value!);
          },
        );
      },
    );
  }

  TextFormField _buildDOB() {
    return TextFormField(
      decoration: _styleField('Date of Birth', 'yyyy-mm-dd', true),
      controller: dobController,
      obscureText: false,
      keyboardType: TextInputType.datetime,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.lightBlue, fontSize: 20),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a valid date';
        }
        return null;
      },
      onSaved: (String? value) {
        setState(() {
          var newDob = DateFormat.yMMMd().parse(value!);
          print("setting dob: $newDob");
          person?.dob = newDob;
        });
      },
    );
  }

  void _savePerson() async {
    if (person == null || person!.id.isEmpty) {
      var networkCall = HttpHelper();
      try {
        var result = await networkCall.savePerson(person!);
        print("person was saved: ${result.id}");
        Navigator.pop(context, result);
      } catch (e) {
        var text;
        if (e is GiftrException) {
          text = Text(e.message);
        } else {
          text = Text(e.toString());
        }
        _logout();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: text));
      }
    }
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.routeName, (route) => true);
  }
}
