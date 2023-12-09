import 'package:flutter/material.dart';
import '../data/dummy_items.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Grocery"),
      ),
      body:ListView.builder(
          itemCount: groceryItems.length,
          itemBuilder: (ctx, index){
            return ListTile(
              title: Text(
                groceryItems[index].name,
              ),
              subtitle: Text(
                  groceryItems[index].category.name,
              ),
              leading: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: groceryItems[index].category.color,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onTap: (){},
              trailing: Text(
                '${groceryItems[index].quantity}',
                style: const TextStyle(fontSize: 20),
              ),
            );
          }
      ),
    );
  }
}
