
import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';

class AllGroceries extends StatelessWidget{
const AllGroceries({super.key, required this.groceryItmes, required this.onRemoveItem});
final List<GroceryItem> groceryItmes;
final void Function(GroceryItem groceItem) onRemoveItem;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
          itemCount: groceryItmes.length,
          itemBuilder: (ctx, index) {
            final item = groceryItmes[index];
            return ListTile(
              title: Text(item.name),
              leading: Container(
                width: 24,
                height: 24,
                color: item.category.color,
              ),
              trailing: Text(item.quantity.toString()),
            );
          });
  }
}