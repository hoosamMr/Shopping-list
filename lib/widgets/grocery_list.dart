import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _grosreryItems = [];
  void _addItem() async{
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
    if(newItem == null)return;
    setState(()=>_grosreryItems.add(newItem));
  }

  void _removeItem(GroceryItem item){
    setState(() {
      _grosreryItems.remove(item);
    });
  }
  @override
  Widget build(BuildContext context) {
    Widget content =const  Center(child: Text('No itrms added yet!.'),);
    if(_grosreryItems.isNotEmpty){
      content = ListView.builder(
        itemCount: _grosreryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction){
            _removeItem(_grosreryItems[index]);
          },
          key: ValueKey(_grosreryItems[index].id),
          child: ListTile(
            title: Text(_grosreryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _grosreryItems[index].category.color,
            ),
            trailing: Text('${_grosreryItems[index].quantity}'),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Groceries',
        ),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: content,
    );
  }
}
