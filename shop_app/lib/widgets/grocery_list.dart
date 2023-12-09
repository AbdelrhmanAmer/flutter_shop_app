import 'package:flutter/material.dart';
import 'package:shop_app/widgets/new_item.dart';
import '../data/dummy_items.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Grocery"),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx)=>const NewItem())
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body:ListView.builder(
          itemCount: groceryItems.length,
          itemBuilder: (ctx, index){
            return ListTile(
              title: Text(
                groceryItems[index].name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                  groceryItems[index].category.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiaryContainer.withOpacity(.5),
                  fontSize: 14,
                ),
              ),
              leading: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: groceryItems[index].category.color,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onTap: (){},
              trailing: Text(
                '${groceryItems[index].quantity}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  fontSize: 18,
                ),
              ),
            );
          }
      ),
    );
  }
}
