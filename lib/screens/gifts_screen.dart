import 'package:GIFTR/data/gift.dart';
import 'package:GIFTR/data/giftr_exception.dart';
import 'package:GIFTR/data/http_helper.dart';
import 'package:GIFTR/data/person.dart';
import 'package:flutter/material.dart';
import 'package:GIFTR/shared/screen_type.dart';
import 'package:intl/intl.dart';

class GiftsScreen extends StatefulWidget {
  const GiftsScreen({
    Key? key,
    required this.person,
    required this.manageExceptions,
  }) : super(key: key);

  static const routeName = '/gifts';

  final Function manageExceptions;
  final Person person;

  @override
  State<GiftsScreen> createState() => _GiftsScreenState();
}

class _GiftsScreenState extends State<GiftsScreen> {
  List<Gift> gifts = List.empty();

  @override
  void initState() {
    super.initState();
    _grabGiftList();
  }

  void _grabGiftList() async {
    try {
      HttpHelper networkCall = HttpHelper();
      var result = await networkCall.grabGifts(widget.person.id);
      setState(() {
        gifts = result;
      });
    } catch (e) {
      widget.manageExceptions(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            //back to the people page using the function from main.dart
            Navigator.pop(context);
          },
        ),
        title: Text('Ideas - ${widget.person.name}'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              //logout and return to login screen
              widget.manageExceptions(GiftrException.INVALID_TOKEN);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: gifts.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(gifts[index].name),
              subtitle: Text(
                  '${gifts[index].store.name} - ${NumberFormat.simpleCurrency(locale: 'en_CA', decimalDigits: 2).format(gifts[index].price)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      _wantToDeleteGift(gifts[index]);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _navigateToAddNewGift();
        },
      ),
    );
  }

  void _navigateToAddNewGift() {
    print("want to add new gift");
  }

  void _wantToDeleteGift(Gift gift) {
    print('delete ${gift.name}');
    //remove from gifts with setState

    showDialog(
        context: context,
        builder: (_) => _buildConfirmationDialogForDeletion(gift),
        barrierDismissible: true);
  }

  void _executeDeletion(Gift toDelete) async {
    try {
      var networkCall = HttpHelper();
      var result = await networkCall.deleteGift(widget.person.id, toDelete);

      if (result.id == toDelete.id) {
        setState(() {
          gifts = gifts.where((gift) => gift.id != result.id).toList();
        });
      }
    } catch (e) {
      widget.manageExceptions(e);
    }
  }

  AlertDialog _buildConfirmationDialogForDeletion(Gift gift) {
    return AlertDialog(
      title: Text('Confirmation'),
      content: Text('Are you sure?'),
      actions: [
        ElevatedButton(
          child: Text('Yes'),
          onPressed: () {
            Navigator.pop(context);
            _executeDeletion(gift);
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
