import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  void _addItem() {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => NewItem()));
  }
 
  @override
  Widget build(BuildContext context) {
    
    return  Scaffold(
            appBar: AppBar(
              title: const Text("Your Groceries"),
              actions: [
                IconButton(
                    onPressed: () => _addItem(), icon: const Icon(Icons.add))
              ],
            ),
            body: ListView.builder(
      itemCount: groceryItems.length,
      itemBuilder: (ctx, index){
        final item = groceryItems[index];
        return ListTile(  
        title: Text(item.name),
        leading: Container(
          width: 24,
          height: 24,
          color: item.category.color,
        ),
        trailing:Text(item.quantity.toString()) ,
      );
      }    
    ),
          );
    //My solution:::
    // return ListView.builder(
    //   itemCount: groceryItems.length,
    //   itemBuilder: (context, index) {
    //     final item = groceryItems[index];
    //     return Padding(
    //       padding: const EdgeInsets.all(20.0),
    //       child: Row(
    //         children: [
    //           Container(
    //             width: 24,
    //             height: 24,
    //             decoration: BoxDecoration(
    //               color: item.category.color,
    //               shape: BoxShape.circle
    //             ),
    //             //color: item.category.color,
    //           ),
    //           const SizedBox(width: 20),
    //           Expanded(child: Text(item.name)),
    //           //const SizedBox(width: 10),
    //           Text('${item.quantity}'),
    //         ],
    //       ),
    //     );
    //   },
    // );
  }
}
