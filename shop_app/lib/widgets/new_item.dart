import 'package:flutter/material.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                decoration:  InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
                // maxLength: 50,
                validator: (String? value){
                  if(
                  value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50
                  ){
                    return '';
                  }
                  return null;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
