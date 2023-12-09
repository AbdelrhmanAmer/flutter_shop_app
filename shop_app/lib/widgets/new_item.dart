import 'package:flutter/material.dart';
import '../models/category.dart';
import '../data/categories.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  String _enteredName = "";
  int _enteredQuantity = 0;
  Category _selectedCategory = categories[Categories.fruit]!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
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
                validator: (String? value){
                  if(
                  value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50
                  ){
                    return 'Must be between 1 and 50 characters';
                  }
                  return null;
                },
                onSaved: (newValue){
                  _enteredName = newValue!;
                },
              ),
              const SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration:  InputDecoration(
                        labelText: 'Quantity',
                        labelStyle: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                      initialValue: '1',
                      validator: (String? value){
                        if( value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0
                        ){
                          return 'Must be positive value..!';
                        }
                        return null;
                      },
                      onSaved: (newValue){
                        _enteredQuantity = int.parse(newValue!);
                      },
                    ),
                  ),
                  const SizedBox(width: 30,),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                        items:[
                          for(final category in categories.entries)
                            DropdownMenuItem(
                              value: category.value,
                              child: Row(
                                children: [
                                  Container(
                                    height: 16,
                                    width: 16,
                                    color: category.value.color,
                                  ),
                                  const SizedBox(width: 6,),
                                  Text(category.value.name),
                                ],
                              ),
                            ) 
                        ],
                        onChanged: (Category? value){
                          setState(() {
                            _selectedCategory = value!;
                          });
                        }
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: (){
                        _formKey.currentState!.reset();
                      },
                      child: const Text("Reset")
                  ),
                  const SizedBox(width: 20,),
                  ElevatedButton(
                      onPressed: (){
                        if(_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          print(_enteredName);
                          print(_enteredQuantity);
                          print(_selectedCategory.name);
                        }
                      },
                      child: const Text("Add Item")
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
