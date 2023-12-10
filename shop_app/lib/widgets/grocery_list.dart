import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shop_app/data/categories.dart';
import 'package:shop_app/widgets/new_item.dart';
import '../models/category.dart';
import '../models/grocery_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList>
{
  List<GroceryItem> _groceryItems = [];
  bool isLoading = true;
  String? _error;

  void _loadData() async{
    final Uri url = Uri.https(
        'qflutter-shop-3438e-default-rtdb.firebaseio.com',
        'shopping-list.json');
    final http.Response response = await http.get(url);
    if(response.statusCode >= 400){
      setState(() {
        _error = 'Failed to fetch data. Please try again later. ';
      });
    }

    final Map<String, dynamic> loadedData = json.decode(response.body);
    // temp list
    final List<GroceryItem> tempList = [];

    for(var map in loadedData.entries){
      final Category category =
          categories
              .entries
              .firstWhere(
                  (element)=> element.value.name == map.value['category']
          ).value;
      tempList.add(
        GroceryItem(
            id: map.key,
            name: map.value['name'],
            quantity: map.value['quantity'],
            category: category
        ),
      );
      setState(() {
        _groceryItems = tempList;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    Widget emptyPage = const Center(child: Text("No items added yet."));
    Widget loadingPage = const Center(child: CircularProgressIndicator(),);
    Widget errorPage = Center(child: Text(_error!,),);
    Widget slideRightBackground = Container(
      color: Colors.red[400],
      padding: const EdgeInsets.all(16),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.delete, size: 25,),
          SizedBox(width: 15,),
          Text(
            "Delete",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    ) ;
    void onDismissed(int index){ setState(() => _groceryItems.removeAt(index)); }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Grocery"),
        actions: [
          IconButton(
            onPressed: ()=>_addItem(),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: _error != null
          ? errorPage   : isLoading
          ? loadingPage : _groceryItems.isEmpty
          ? emptyPage   : ListView.builder(
          itemCount: _groceryItems.length,
          itemBuilder: (ctx, index){
            return Dismissible(
              key: ValueKey(_groceryItems[index].id),
              onDismissed: (_)=>onDismissed(index),
              direction: DismissDirection.startToEnd,
              background: slideRightBackground,
              child: ListTile(
                title: Text(
                  _groceryItems[index].name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  _groceryItems[index].category.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiaryContainer.withOpacity(.5),
                    fontSize: 14,
                  ),
                ),
                leading: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: _groceryItems[index].category.color,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onTap: (){},
                trailing: Text(
                  '${_groceryItems[index].quantity}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    fontSize: 18,
                  ),
                ),
              ),
            );
          }
      )
    );
  }

  _addItem()async{
    final GroceryItem? newItem = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (ctx)=>const NewItem())
    );
    if(newItem == null){return;}

    setState(() => _groceryItems.add(newItem));
  }
}
