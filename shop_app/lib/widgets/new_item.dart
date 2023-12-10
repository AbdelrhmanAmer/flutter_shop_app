import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/grocery_item.dart';
import '../models/category.dart';
import '../data/categories.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _enteredName = "";
  int _enteredQuantity = 0;
  Category _selectedCategory = categories[Categories.fruit]!;

  void _saveItem(){
    if(_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      final Uri url = Uri.https(
          'flutter-shop-3438e-default-rtdb.firebaseio.com',
          'shopping-list.json');

      http.post(
        url,
        headers: {
          'Content-Type': 'application/json'
        },
        body: json.encode({
          'name': _enteredName,
          'quantity': _enteredQuantity,
          'category': _selectedCategory.name
        }),
      ).then((response){
        if(response.statusCode == 200){
          final Map<String, dynamic> loadedData = json.decode(response.body);
          Navigator.of(context).pop(
              GroceryItem(
                  id: loadedData['name'],
                  name: _enteredName,
                  quantity: _enteredQuantity,
                  category: _selectedCategory
              )
          );
        }
      });
    }
  }

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
                  labelText: 'Item Name',
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
                      onPressed: _isLoading? null: ()=>_formKey.currentState!.reset(),
                      child: const Text("Reset")
                  ),
                  const SizedBox(width: 20,),
                  ElevatedButton(
                      onPressed: _isLoading ? null : _saveItem,
                      child: _isLoading
                          ? const SizedBox(width: 16, height: 16,child: CircularProgressIndicator(),)
                          : const Text("Add Item")
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
