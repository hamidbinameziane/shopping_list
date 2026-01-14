import 'package:flutter/material.dart';
import 'package:shopping_list/models/shopping_item.dart';
import 'package:shopping_list/screens/add_item_screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ShoppingListScreenState createState() => ShoppingListScreenState();
}

class ShoppingListScreenState extends State<ShoppingListScreen> {
  List<ShoppingItem> _shoppingList = [];
  final Map<String, TextEditingController> _quantityControllers = {};
  final Map<String, FocusNode> _quantityFocusNodes = {};

  @override
  void initState() {
    super.initState();
    _loadShoppingList();
  }

  @override
  void dispose() {
    for (var controller in _quantityControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _quantityFocusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _loadShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    final String? shoppingListString = prefs.getString('shoppingList');
    if (shoppingListString != null) {
      final List<dynamic> shoppingListJson = jsonDecode(shoppingListString);
      setState(() {
        _shoppingList = shoppingListJson.map((json) {
          final item = ShoppingItem.fromMap(json);
          _quantityControllers[item.id] = TextEditingController(text: item.quantity.toString());
          _quantityFocusNodes[item.id] = FocusNode();
          return item;
        }).toList();
      });
    }
  }

  Future<void> _saveShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    final String shoppingListString = jsonEncode(_shoppingList.map((item) => item.toMap()).toList());
    await prefs.setString('shoppingList', shoppingListString);
  }

  void _addItem(ShoppingItem item) {
    setState(() {
      _shoppingList.insert(0, item);
      _quantityControllers[item.id] = TextEditingController(text: item.quantity.toString());
      _quantityFocusNodes[item.id] = FocusNode();
    });
    _saveShoppingList();
  }

  void _removeItem(ShoppingItem item) {
    _quantityControllers[item.id]?.dispose();
    _quantityControllers.remove(item.id);
    _quantityFocusNodes[item.id]?.dispose();
    _quantityFocusNodes.remove(item.id);

    setState(() {
      _shoppingList.removeWhere((element) => element.id == item.id);
    });
    _saveShoppingList();
  }

  void _incrementQuantity(int index) {
    setState(() {
      final item = _shoppingList[index];
      item.quantity++;
      _quantityControllers[item.id]?.text = item.quantity.toString();
    });
    _saveShoppingList();
  }

  void _decrementQuantity(int index) {
    setState(() {
      final item = _shoppingList[index];
      if (item.quantity > 1) {
        item.quantity--;
        _quantityControllers[item.id]?.text = item.quantity.toString();
      }
    });
    _saveShoppingList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة التسوق'),
      ),
      body: _shoppingList.isEmpty
          ? const Center(
              child: Text('قائمة التسوق فارغة'),
            )
          : ReorderableListView.builder(
              itemCount: _shoppingList.length,
              itemBuilder: (context, index) {
                final item = _shoppingList[index];
                return Dismissible(
                  key: ValueKey(item.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _removeItem(item);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${item.name} تم حذفه')),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      item.name,
                      style: const TextStyle(fontSize: 22.4),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            _decrementQuantity(index);
                          },
                        ),
                        SizedBox(
                          width: 70, // Adjust width as needed
                          child: TextField(
                            controller: _quantityControllers[item.id],
                            focusNode: _quantityFocusNodes[item.id],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 23.52),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                            onChanged: (value) {
                              int? newQuantity = int.tryParse(value);
                              if (newQuantity != null && newQuantity >= 0) {
                                item.quantity = newQuantity;
                                _saveShoppingList();
                              }
                            },
                            onSubmitted: (value) {
                              _quantityFocusNodes[item.id]?.unfocus();
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            _incrementQuantity(index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final ShoppingItem reorderedItem = _shoppingList.removeAt(oldIndex);
                  _shoppingList.insert(newIndex, reorderedItem);

                  // No need to manage controllers/focus nodes here as they are tied to item IDs
                });
                _saveShoppingList();
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddItemScreen(
                onItemSelected: (item) {
                  _addItem(item);
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
