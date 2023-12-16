
import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() {
    return _NewItem();
  }
}

class _NewItem extends State<NewItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                  hintText: 'name',
                ),
                validator: (value) {
                  return 'Demo...';
                },
              ) //instead of TextField widget
              //,const Divider() //SizedBox(height: 6,child: Placeholder(color: Colors.white,),)
              ,
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                 Expanded(child:  TextFormField(
                    decoration: const InputDecoration(
                        //alignLabelWithHint: true,
                        label: Text('Quantity')),
                    initialValue: '1',
                    keyboardType: TextInputType.number,
                  ),),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      hint: const Text('color'),
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(category.value.title),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {},
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
