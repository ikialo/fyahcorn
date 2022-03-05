import 'package:flutter/material.dart';
import 'package:fyahcorn/Alerts/AlertUpdate.dart';
import 'package:fyahcorn/Alerts/alertFilter.dart';
import 'package:fyahcorn/changeNotifierProvider.dart';
import 'package:provider/provider.dart';
import 'Theme/colors.dart';
import 'add.dart';
import 'dbhelper.dart';
import 'model.dart';


class ListScreen extends StatefulWidget {
  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late DatabaseHandler handler;
  late Future<List<item>> _item ;
  late Future<List<catagory>> _catagories;
  int activeCat = 0;
  String ChosenCata = " ";

  final _formKeyDialog= GlobalKey<FormState>();



  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {

      setState(() {
        _item = getItemList(ChosenCata);
        _catagories = getList();

      });


      print("this is itemlist:"+ getItemList(" ").toString());
    });
  }

  Future<List<catagory>> getList() async {
    return await handler.catagories();
  }
  Future<List<item>> getItemList(String cata ) async {
    return await handler.items(cata);
  }

  Future<void> _onRefresh() async {
    setState(() {
      _item = getItemList(ChosenCata);
    });
  }

  Widget setupAlertDialoadContainer() {

    return AlertFIlter();

  }
  Widget editItemAlert(String item, double unitprice, int quantity, int id){

    String _item = item;
    double _unitprice = unitprice;
    int _quantity = quantity;


  return SingleChildScrollView(

    child: Column(

      children: [
      SizedBox(
        width: 200,
        child: TextField(

          onChanged: (value){

            setState(() {
              _item =value;
            });
        },
          decoration: const InputDecoration(
            hintText: 'Item Name',


          ),
    ),
      ),

      SizedBox(
        width: 200,
        child: TextField(
          onChanged: (value){

            setState(() {
              _unitprice = double.parse(value);
            });
          },
          decoration: const InputDecoration(
            hintText: 'Unit Price',


          ),
          keyboardType: TextInputType.number,

        ),
      ),

      SizedBox(
        width: 200,
        child: TextField(
          onChanged: (value){

            setState(() {
              _quantity = int.parse(value);
            });
          },

          decoration: const InputDecoration(
            hintText: 'Quantity'


          ),
          keyboardType: TextInputType.number,
        ),
      ),

      SizedBox(height: 15,),
      TextButton(
        onPressed: () {

           // handler.updateItem(_item, _unitprice, _quantity, id);
            _onRefresh();
            Navigator.pop(context, 'Update');

        },
        child: const Text('Update'),
      ),
    ],),
  );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<ProviderBudget>(builder: (context, provider, child){

          ChosenCata = provider.catagoryFilter;
          if (provider.newItemAdded){
            print(provider.newItemAdded);
            _onRefresh();
            provider.wasNewItemAdded(false);
          }
          return Text(provider.catagoryFilter);
        }),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(icon:Icon(Icons.filter_alt), onPressed: (){

              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Filter By Catagory'),
                      content: setupAlertDialoadContainer(),
                      actions: [
                        TextButton(onPressed: (){
                          Navigator.pop(context);
                        }, child: Text("Cancel")),
                        Consumer<ProviderBudget>(
                          builder: (context, provider,child) {
                            return TextButton(onPressed: () {
                              ChosenCata = " ";
                              provider.CatagoryToFilterTo(ChosenCata);
                              _onRefresh();
                              Navigator.pop(context);
                            }, child: Text("Reset"));

                          }),
                        TextButton(onPressed: (){
                          _onRefresh();
                          Navigator.pop(context);
                        }
                            , child: Text("Filter")),

                      ],
                    );
                  });
            },),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<item>>(
          future: _item,
          builder: (BuildContext context, AsyncSnapshot<List<item>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return new Center(
                child: new CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return new Text('Error: ${snapshot.error}');
            } else {
              final items = snapshot.data ?? <item>[];
              return new Scrollbar(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child:
                  ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        direction: DismissDirection.startToEnd,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: const Icon(Icons.delete_forever),
                        ),
                        key: ValueKey<int>(items[index].id),
                        onDismissed: (DismissDirection direction) async {
                          await handler.deletetItem(items[index].id);
                          setState(() {
                            items.remove(items[index]);
                          });
                        },
                        child: GestureDetector(
                          onLongPress: (){
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Update Item'),
                                    content: AlertUpdate(item_: items[index].item_, id_: items[index].id,
                                      quantity_: items[index].quantity,unitprice_: items[index].unitPrice,
                                    ),
                                    actions: [
                                      TextButton(onPressed: (){
                                        Navigator.pop(context);
                                      }, child: Text("Cancel")),


                                    ],
                                  );
                                });
                          },
                          child: Card(
                              child: ListTile(
                            contentPadding: const EdgeInsets.all(8.0),
                            title: Text(items[index].item_,  style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold
                            ),),
                                subtitle: Text('Unit Cost: K'+ items[index].unitPrice.toString()+'  \nQuantity: '+items[index].quantity.toString(),
                                  style: TextStyle(
                                  fontSize: 15,
                                ),),
                                trailing: Text("K"+items[index].itemcost.toString()),
                                leading: Container(
                                    width:70,child: Text(items[index].catagory1)),

                          )),
                        ),
                      );
                    },
                  ),
                ),
              );
            }
          },
        ),
      ),
    );


  }
}
