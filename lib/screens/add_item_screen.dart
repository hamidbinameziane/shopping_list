import 'package:flutter/material.dart';
import 'package:shopping_list/data/predefined_items_manager.dart';
import 'package:shopping_list/models/shopping_item.dart';

class AddItemScreen extends StatefulWidget {
  final Function(ShoppingItem) onItemSelected;

  const AddItemScreen({super.key, required this.onItemSelected});

  @override
  AddItemScreenState createState() => AddItemScreenState();
}

class AddItemScreenState extends State<AddItemScreen> {
  final PredefinedItemsManager _itemsManager = PredefinedItemsManager();
  final TextEditingController _textController = TextEditingController();
  List<ShoppingItem> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    await _itemsManager.loadItems();
    setState(() {
      _filteredItems = _itemsManager.items;
    });
  }

  void _filterItems(String query) {
    List<ShoppingItem> allItems = _itemsManager.items;
    if (query.isEmpty) {
      setState(() {
        _filteredItems = allItems;
      });
    } else {
      setState(() {
        _filteredItems = allItems
            .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  Future<void> _addNewItem() async {
    if (_textController.text.isNotEmpty) {
      final newItem = ShoppingItem(name: _textController.text);
      await _itemsManager.addItem(newItem);
      widget.onItemSelected(newItem);
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _removeItem(ShoppingItem item) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: const Text('هل أنت متأكد أنك تريد حذف هذا العنصر من القائمة المحفوظة؟'),
          actions: <Widget>[
            TextButton(
              child: const Text('إلغاء'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('حذف'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _itemsManager.removeItem(item);
      _filterItems(_textController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة عنصر'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textController,
              onChanged: _filterItems,
              decoration: InputDecoration(
                labelText: 'ابحث أو أضف عنصرًا جديدًا',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addNewItem,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return ListTile(
                  title: Text(
                    item.name,
                    style: const TextStyle(fontSize: 28.0),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _removeItem(item);
                    },
                  ),
                  onTap: () {
                    widget.onItemSelected(item);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
