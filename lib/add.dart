import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fyahcorn/changeNotifierProvider.dart';
import 'package:provider/provider.dart';
import 'Theme/colors.dart';
import 'list.dart';
import 'dbhelper.dart';
import 'model.dart';
import 'model.dart';
import 'package:provider/provider.dart';


class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyDialog= GlobalKey<FormState>();

  String _catagory = "";
  String item1 = "";
   double price = 0;
   int quantity =0;
  double itemcost =0;
  int activeCategory = 0;
  late String newCatagory;

  late DatabaseHandler handler;
  late Future<List<catagory>> _catagories;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {

      setState(() {
        _catagories = getList();
      });


    });
  }


  Future<List<catagory>> getList() async {
    return await handler.catagories();

  }

  Future<void> _onRefresh() async {
    setState(() {
      _catagories = getList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[


                Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => Form(
                          key: _formKeyDialog,
                          child: AlertDialog(
                            title: const Text('Add New Catagory'),
                            content: const Text('Write the name of your new catagory'),
                            actions: <Widget>[
                              TextFormField(

                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                  onChanged: (value) {
                                      setState(() {
                                     newCatagory = value;
                                    });
                                  },
                                decoration: const InputDecoration(
                                  hintText: 'Catagory Name',


                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (_formKeyDialog.currentState!.validate()) {
                                    handler.insertcatagory(catagory(
                                        id: Random().nextInt(1000),
                                        catagory1: newCatagory));
                                    _onRefresh();
                                    Navigator.pop(context, 'OK');
                                  }
                                 },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        ),
                      );

                    },
                    child: const Text(
                      'Add Catagory',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FutureBuilder<List<catagory>>(
                    future: _catagories,
                    builder: (BuildContext context, AsyncSnapshot<List<catagory>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return new Center(
                          child: new CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return new Text('Error: ${snapshot.error}');
                      } else {
                        final items = snapshot.data ?? <catagory>[];
                        print (items.toString());
                        return    SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: RefreshIndicator(
                            onRefresh: _onRefresh,
                            child: Row(
                                children: List.generate(items.length, (index) {
                                  return
                                    GestureDetector(
                                      onLongPress: (){
                                        handler.deletetcatagory(items[index].id);
                                        setState(() {
                                          items.remove(items[index]);
                                        });
                                      },
                                      onTap: () {
                                        setState(() {
                                          activeCategory = index;
                                          print(items[index].catagory1);
                                          _catagory = items[index].catagory1;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 5,
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            left: 5,
                                          ),
                                          width: 150,
                                          height: 70,
                                          decoration: BoxDecoration(
                                              color: grey,
                                              border: Border.all(
                                                  width: 2,
                                                  color: activeCategory == index
                                                      ? green
                                                      : Colors.white30),
                                              borderRadius: BorderRadius.circular(30),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: grey.withOpacity(0.01),
                                                  spreadRadius: 10,
                                                  blurRadius: 3,
                                                  // changes position of shadow
                                                ),
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25, right: 25, top: 20, bottom: 20),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [

                                                Text(
                                                 items[index].catagory1,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                })),
                          ),
                        );



                    }
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),

                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Item Name',
                  ),
                  onChanged: (value) {
                    setState(() {
                      item1 = value;
                    });
                  },
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some value';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Price',
                  ),
                  onChanged: (value) {
                    setState(() {
                      price = double.parse(value);
                      itemcost = price*quantity;
                    });
                  },keyboardType: TextInputType.number,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some value';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Quantity',
                  ),
                  onChanged: (value) {
                    setState(() {
                      quantity = int.parse(value);
                      itemcost = price*quantity;

                    });
                  },keyboardType: TextInputType.number,
                ),
                SizedBox(height: 30,),

                Text("Total Cost of the item is K$itemcost",
                    style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold),

                ),
                SizedBox(height: 30,),

                Consumer<ProviderBudget>(
                  builder: (context, provider, child) {


                    return ElevatedButton(
                      onPressed: () async {

                        if (_formKey.currentState!.validate()) {
                          await DatabaseHandler()
                              .insertitem(item(
                              itemcost: itemcost,
                              unitPrice: price,
                              quantity: quantity,
                              item_: item1,
                              catagory1: _catagory.isEmpty
                                  ? "Utilities"
                                  : _catagory,
                              id: Random().nextInt(1000))
                          )
                              .whenComplete(() {

                            final snackBar = SnackBar(
                              content: const Text('New Item Added'),
                              backgroundColor: (Colors.black12),
                              action: SnackBarAction(
                                label: 'dismiss',
                                onPressed: () {},
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar);
                            Navigator.pop(
                                context

                            );
                            provider.wasNewItemAdded(true);
                          }
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Processing Data')),
                          );
                        }
                      },
                      child: const Text(
                        'Add Item',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    );

                  }
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
