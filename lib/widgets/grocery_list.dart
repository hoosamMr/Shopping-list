import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
   List<GroceryItem> _grosreryItems = [];
   var _isLoading = true;
   String? _error;
  @override
  void initState() {
    super.initState();
    _loadItem();
  }

  void _loadItem() async {
    final url = Uri.https(
      'flutter-perp-d8ae6-default-rtdb.firebaseio.com',
      'shopping-list.json',
    );
    final response = await http.get(url);
    if(response.statusCode >= 400){
      setState(() {
        _error = 'Faild to fetch data, please try again later.';
      });
    }
    final Map<String, dynamic> listData =
        json.decode(response.body);
    final List<GroceryItem> loadedItems = [];
    for (final item in listData.entries) {
      final category = categories.entries.firstWhere(
          (catItem) => catItem.value.title == item.value['category']).value;
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
       _grosreryItems = loadedItems;
       _isLoading = false;
    });
   
  }

  void _addItem() async {
    final newAitem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
   if(newAitem == null)return;
   setState(() {
     _grosreryItems.add(newAitem);
   });
  }

  void _removeItem(GroceryItem item) async{
    final index = _grosreryItems.indexOf(item);
     setState(() {
      _grosreryItems.remove(item);
    });
     final url = Uri.https(
      'flutter-perp-d8ae6-default-rtdb.firebaseio.com',
      'shopping-list/${item.id}.json',
    );
    final response = await http.delete(url);
    if(response.statusCode>= 400){
       setState(() {
      _grosreryItems.insert(index,item);
    });
    }
   
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No itrms added yet!.'),
    );
    if(_isLoading){
      content = const Center(child: CircularProgressIndicator(),);
    }
    if (_grosreryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _grosreryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
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
    if(_error != null){
      content =  Center(
      child: Text(_error!));
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
