import 'package:GIFTR/data/giftr_exception.dart';
import 'package:GIFTR/data/http_helper.dart';
import 'package:GIFTR/data/person.dart';
import 'package:GIFTR/screens/gifts_screen.dart';
import 'package:GIFTR/screens/login_screen.dart';
import 'package:GIFTR/screens/people_screen.dart';
import 'package:flutter/material.dart';
import 'package:GIFTR/shared/screen_type.dart';
import 'package:intl/intl.dart';

class AddPersonScreen extends StatefulWidget {
  const AddPersonScreen(
      {Key? key, required this.person, required this.manageExceptions})
      : super(key: key);

  final Person person;
  final Function manageExceptions;
  static const String routeName = '/addPerson';

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
            _backToPeople();
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
                        _wantToDeletePerson();
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
    try {
      var networkCall = HttpHelper();
      if (person == null || person!.id.isEmpty) {
        var result = await networkCall.savePerson(person!);
        _backToPeople(result);
      } else if (person!.id.isNotEmpty) {
        var result = await networkCall.updatePerson(person!);
        _backToPeople(result);
      }
    } catch (e) {
      widget.manageExceptions(e);
    }
  }

  void _backToPeople([Person? person]) {
    Navigator.pop(context, person);
  }

  void _wantToDeletePerson() {
    //1 show confirmation dialog
    showDialog(
        context: context,
        builder: (_) => _buildConfirmationDialogForDeletion(),
        barrierDismissible: true);
    //2. if yes, execute deletion
    //3. if no, do nothing
  }

  void _executeDeletion() async {
    try {
      var networkCall = HttpHelper();
      var result = await networkCall.deletePerson(person!);
      _backToPeople(result);
    } catch (e) {
      widget.manageExceptions(e);
    }
  }

  AlertDialog _buildConfirmationDialogForDeletion() {
    return AlertDialog(
      title: Text('Confirmation'),
      content: Text('Are you sure?'),
      actions: [
        ElevatedButton(
          child: Text('Yes'),
          onPressed: () {
            Navigator.pop(context);
            _executeDeletion();
          },
        ),
        ElevatedButton(
          child: Text('No'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
      elevation: 24,
    );
  }
}
