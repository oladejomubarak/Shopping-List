import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/widgets/all_groceries.dart';
import 'package:shopping_list/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItmes = [];
  var _isLoading = true;
  String? _error;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'flutter-shopping-list-46f68-default-rtdb.firebaseio.com',
        'shopping-list.json');
    final response = await http.get(url);
    print(response.body);
    if (response.statusCode >= 400) {
      setState(() {
        _error = "Failed to get data.";
      });
    }

    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
              (catItem) => catItem.value.title == item.value['category'])
          .value;
      loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }

    setState(() {
      _groceryItmes = loadedItems;
      _isLoading = false;
    });
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => NewItem(),
      ),
    );
    //  _loadItems();
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItmes.add(newItem);
    });
  }

  void _removeItem(GroceryItem groceryItem) {
    final url = Uri.https(
        'flutter-shopping-list-46f68-default-rtdb.firebaseio.com',
        'shopping-list/${groceryItem.id}.json');
    final itemIndex = _groceryItmes.indexOf(groceryItem);
    setState(() {
      _groceryItmes.remove(groceryItem);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
      content: const Text("Expense deleted successfully!"),
      action: SnackBarAction(
        label: "undo",
        backgroundColor: Colors.green,
        onPressed: () {
          setState(() {
            _groceryItmes.insert(itemIndex, groceryItem);
          });
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text(
          "No Item Available, start adding them by tapping the add icon above!"),
    );
    if (_isLoading) {
      mainContent = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_groceryItmes.isNotEmpty) {
      mainContent = AllGroceries(
        groceryItmes: _groceryItmes,
        onRemoveItem: _removeItem,
      );
    }
    if (_error != null) {
      mainContent = Center(
        child: Text(_error!),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Groceries"),
          actions: [
            IconButton(onPressed: () => _addItem(), icon: const Icon(Icons.add))
          ],
        ),
        body: mainContent);
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
