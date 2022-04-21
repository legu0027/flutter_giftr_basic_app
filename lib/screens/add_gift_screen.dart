import 'dart:ffi';

import 'package:GIFTR/data/gift.dart';
import 'package:GIFTR/data/http_helper.dart';
import 'package:GIFTR/data/person.dart';
import 'package:flutter/material.dart';

class AddGiftScreen extends StatefulWidget {
  const AddGiftScreen(
      {Key? key, required this.person, required this.manageExceptions})
      : super(key: key);
  static const routeName = '/gifts/add';
  final Function manageExceptions;
  final Person person;

  @override
  State<AddGiftScreen> createState() => _AddGiftScreenState();
}

class _AddGiftScreenState extends State<AddGiftScreen> {
  final nameController = TextEditingController();
  final storeController = TextEditingController();
  final priceController = TextEditingController();
  //create global ref key for the form
  final _formKey = GlobalKey<FormState>();
  Gift gift = Gift.create();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            //back to the people page using the function from main.dart
            _backToGifts();
          },
        ),
        title: Text('Add Gift - ${widget.person.name}'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildName(),
                  SizedBox(height: 16),
                  _buildStore(),
                  SizedBox(height: 16),
                  _buildPrice(),
                  SizedBox(height: 16),
                  ElevatedButton(
                    child: Text('Save'),
                    onPressed: () {
                      //use the API to save the new gift for the person
                      //after confirming the save then
                      //go to the gifts screen
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _saveGift();
                      } else {
                        return;
                      }
                    },
                  ),
                ],
              )),
        ),
      ),
    );
  }

  InputDecoration _styleField(String label, String hint) {
    return InputDecoration(
      labelText: label, // label
      labelStyle: TextStyle(color: Colors.black87),
      hintText: hint, //placeholder
      hintStyle: TextStyle(color: Colors.black54),
      border: OutlineInputBorder(),
    );
  }

  TextFormField _buildName() {
    return TextFormField(
      decoration: _styleField('Idea Name', 'gift idea'),
      controller: nameController,
      obscureText: false,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.lightBlue, fontSize: 20),
      validator: (String? value) {
        print('called validator in email');
        if (value == null || value.isEmpty) {
          return 'Please enter something';
          //becomes the new errorText value
        }
        return null; //means all is good
      },
      onSaved: (String? value) {
        //save the email value in the state variable
        setState(() {
          gift.name = value!;
        });
      },
    );
  }

  TextFormField _buildStore() {
    return TextFormField(
      decoration: _styleField('Store URL', 'Store URL'),
      controller: storeController,
      obscureText: false,
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.lightBlue, fontSize: 20),
      validator: (String? value) {
        print('called validator in store url');
        if (value == null || value.isEmpty) {
          return 'Please enter something';
          //becomes the new errorText value
        }
        return null; //means all is good
      },
      onSaved: (String? value) {
        //save the email value in the state variable
        setState(() {
          gift.store.name = value!;
        });
      },
    );
  }

  TextFormField _buildPrice() {
    return TextFormField(
      decoration: _styleField('Price', 'Approximate gift price'),
      controller: priceController,
      obscureText: false,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.lightBlue, fontSize: 20),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a price';
          //becomes the new errorText value
        }
        return null; //means all is good
      },
      onSaved: (String? value) {
        //save the email value in the state variable
        setState(() {
          if (value != null) {
            gift.price = double.parse(value);
          }
        });
      },
    );
  }

  void _saveGift() async {
    print('wanna to save gift ${gift.name}');
    try {
      var networkCall = HttpHelper();
      var result = await networkCall.saveGift(widget.person.id, gift);
      _backToGifts(result);
    } catch (e) {
      widget.manageExceptions(e);
    }
  }

  void _backToGifts([Gift? newGift]) {
    Navigator.pop(context, newGift);
  }
}
