import 'package:flutter/material.dart';
import 'package:shop_app/widgets/new_item.dart';
import '../models/grocery_item.dart';

class GroceryList extends StatefulWidget {
  GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  @override
  Widget build(BuildContext context) {
    Widget emptyItemsContent = const Center(child: Text("No items added yet."));
    Widget slideRightBackground(){
      return Container(
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
    }
    onDismissed(int index){
      setState(() {
        _groceryItems.removeAt(index);
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Grocery"),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.of(context).push<GroceryItem>(
                MaterialPageRoute(builder: (ctx)=>const NewItem())
              ).then((value){
                if(value == null) return ;
                setState(() {
                  _groceryItems.add(value);
                });
              });
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body:_groceryItems.isEmpty
          ? emptyItemsContent
          : ListView.builder(
          itemCount: _groceryItems.length,
          itemBuilder: (ctx, index){
            return Dismissible(
              key: ValueKey(_groceryItems[index].id),
              onDismissed: (_)=>onDismissed(index),
              direction: DismissDirection.startToEnd,
              background: slideRightBackground(),
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
      ),
    );
  }
}
